import { Type } from '@kit.ArkUI';
import { GardenViewModel } from './GardenViewModel';
import { PlantViewModel } from './PlantViewModel';
import type { MediaKey } from '../utils/MediaUtils';
import {
  gardenStorage,
  GardenBookData,
  GardenData,
  PlantData
} from '../services/GardenStorageService';

function generateId(prefix: string): string {
  return `${prefix}-${Date.now()}`;
}

@ObservedV2
export class GardenBookViewModel {
  @Type(GardenViewModel)
  @Trace gardens: GardenViewModel[] = [];

  @Trace isLoading: boolean = false;
  @Trace isInitialized: boolean = false;

  @Computed
  get isEmpty(): boolean {
    return this.gardens.length === 0;
  }

  @Computed
  get gardenCount(): number {
    return this.gardens.length;
  }

  async initializeStorage(context: Context): Promise<void> {
    if (this.isInitialized) {
      return;
    }

    this.isLoading = true;

    try {
      // Initialize the storage service
      await gardenStorage.initialize(context, 'com.hmosdemos.wearable.gardenhelper');

      // Load existing data
      const data = await gardenStorage.loadGardens();
      this.gardens = this.fromStorageData(data);
      this.isInitialized = true;

      console.info(`[GardenBook] Loaded ${this.gardens.length} gardens from storage`);
    } catch (e) {
      console.error('[GardenBook] Failed to initialize storage:', e);
      // Continue with empty data if storage fails
      this.gardens = [];
      this.isInitialized = true;
    } finally {
      this.isLoading = false;
    }
  }

  private async saveToStorage(): Promise<void> {
    if (!gardenStorage.isReady()) {
      console.warn('[GardenBook] Storage not ready, skipping save');
      return;
    }

    try {
      const data = this.toStorageData();
      await gardenStorage.saveGardens(data);
    } catch (e) {
      console.error('[GardenBook] Failed to save:', e);
    }
  }

  private toStorageData(): GardenBookData {
    const gardens: GardenData[] = this.gardens.map((g): GardenData => {
      const plants: PlantData[] = g.plants.map((p): PlantData => {
        const plantData: PlantData = {
          id: p.id,
          name: p.name,
          mediaKey: p.mediaKey,
          waterEveryDays: p.waterEveryDays,
          lastWateredAt: p.lastWateredAt,
          location: p.location
        };
        return plantData;
      });

      const gardenData: GardenData = {
        id: g.id,
        name: g.name,
        mediaKey: g.mediaKey,
        plants: plants
      };
      return gardenData;
    });

    const result: GardenBookData = { gardens: gardens };
    return result;
  }

  private fromStorageData(data: GardenBookData): GardenViewModel[] {
    return data.gardens.map(gd => {
      const garden = new GardenViewModel();
      garden.id = gd.id;
      garden.name = gd.name;
      garden.mediaKey = gd.mediaKey as MediaKey;

      garden.plants = gd.plants.map(pd => {
        const plant = new PlantViewModel();
        plant.id = pd.id;
        plant.name = pd.name;
        plant.mediaKey = pd.mediaKey as MediaKey;
        plant.waterEveryDays = pd.waterEveryDays;
        plant.lastWateredAt = pd.lastWateredAt;
        plant.location = pd.location as 'indoor' | 'outdoor';
        return plant;
      });

      return garden;
    });
  }

  createGarden(name: string, mediaKey: MediaKey = 'seedling'): GardenViewModel {
    const garden = new GardenViewModel();
    garden.id = generateId('garden');
    garden.name = name.trim();
    garden.mediaKey = mediaKey;
    garden.plants = [];
    this.gardens = [...this.gardens, garden];

    // Persist change
    this.saveToStorage();

    return garden;
  }

  deleteGarden(gardenId: string): void {
    this.gardens = this.gardens.filter(g => g.id !== gardenId);

    // Persist change
    this.saveToStorage();
  }

  getGardenById(gardenId: string): GardenViewModel | undefined {
    return this.gardens.find(g => g.id === gardenId);
  }

  createPlant(gardenId: string, name: string, mediaKey: MediaKey = 'seedling'): PlantViewModel | undefined {
    return this.createPlantWithOptions(gardenId, name, mediaKey, 3);
  }

  createPlantWithOptions(
    gardenId: string,
    name: string,
    mediaKey: MediaKey,
    waterEveryDays: number
  ): PlantViewModel | undefined {
    const garden = this.getGardenById(gardenId);
    if (!garden) {
      return undefined;
    }

    const plant = new PlantViewModel();
    plant.id = generateId('plant');
    plant.name = name.trim();
    plant.mediaKey = mediaKey;
    plant.waterEveryDays = waterEveryDays;
    plant.lastWateredAt = Date.now();

    garden.addPlant(plant);

    // Persist change
    this.saveToStorage();

    return plant;
  }

  waterPlant(gardenId: string, plantId: string): void {
    const garden = this.getGardenById(gardenId);
    if (!garden) {
      return;
    }

    const plant = garden.plants.find(p => p.id === plantId);
    if (!plant) {
      return;
    }

    plant.markWatered();

    // Persist change
    this.saveToStorage();
  }

  deletePlant(gardenId: string, plantId: string): void {
    const garden = this.getGardenById(gardenId);
    if (!garden) {
      return;
    }

    garden.deletePlant(plantId);

    // Persist change
    this.saveToStorage();
  }
}

// Singleton instance for the app
let gardenBookInstance: GardenBookViewModel | undefined;

export function getGardenBookStore(): GardenBookViewModel {
  if (!gardenBookInstance) {
    gardenBookInstance = new GardenBookViewModel();
  }
  return gardenBookInstance;
}

// Keep the old function name for backwards compatibility
export function connectGardenBookStore(): GardenBookViewModel {
  return getGardenBookStore();
}
