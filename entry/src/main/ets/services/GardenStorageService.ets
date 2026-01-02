import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

export interface PlantData {
  id: string;
  name: string;
  mediaKey: string;
  waterEveryDays: number;
  lastWateredAt: number;
  location: string;
}

export interface GardenData {
  id: string;
  name: string;
  mediaKey: string;
  plants: PlantData[];
}

export interface GardenBookData {
  gardens: GardenData[];
}

// Storage keys
const STORE_ID = 'GardenHelperStore';
const GARDENS_KEY = 'all_gardens';


// Singleton service for garden data persistence
export class GardenStorageService {
  private static instance: GardenStorageService | undefined;
  private kvManager: distributedKVStore.KVManager | undefined;
  private kvStore: distributedKVStore.SingleKVStore | undefined;
  private isInitialized: boolean = false;
  private initPromise: Promise<void> | undefined;

  private constructor() {}

  static getInstance(): GardenStorageService {
    if (!GardenStorageService.instance) {
      GardenStorageService.instance = new GardenStorageService();
    }
    return GardenStorageService.instance;
  }

  async initialize(context: Context, bundleName: string): Promise<void> {
    if (this.isInitialized) {
      return;
    }

    // Prevent concurrent initialization
    if (this.initPromise) {
      await this.initPromise;
    }

    this.initPromise = this.doInitialize(context, bundleName);
    await this.initPromise;
  }

  private async doInitialize(context: Context, bundleName: string): Promise<void> {
    try {
      // Create KV Manager
      const config: distributedKVStore.KVManagerConfig = {
        context: context,
        bundleName: bundleName
      };

      this.kvManager = distributedKVStore.createKVManager(config);
      console.info('[GardenStorage] KVManager created');

      // Get KV Store
      const options: distributedKVStore.Options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: false,
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        securityLevel: distributedKVStore.SecurityLevel.S3
      };

      this.kvStore = await new Promise<distributedKVStore.SingleKVStore>((resolve, reject) => {
        this.kvManager!.getKVStore<distributedKVStore.SingleKVStore>(
          STORE_ID,
          options,
          (err, store) => {
            if (err) {
              console.error(`[GardenStorage] Failed to get KVStore: ${err.message}`);
              reject(err);
              return;
            }
            resolve(store);
          }
        );
      });

      this.isInitialized = true;
      console.info('[GardenStorage] KVStore initialized successfully');

    } catch (e) {
      const error = e as BusinessError;
      console.error(`[GardenStorage] Initialization failed: ${error.code} - ${error.message}`);
      this.initPromise = undefined;
      throw new Error(`Initialization failed: ${error.code} - ${error.message}`);
    }
  }

  isReady(): boolean {
    return this.isInitialized && this.kvStore !== undefined;
  }

  async saveGardens(data: GardenBookData): Promise<void> {
    if (!this.isReady()) {
      console.error('[GardenStorage] Service not initialized');
      throw new Error('GardenStorageService not initialized');
    }

    try {
      const json = JSON.stringify(data);
      await this.kvStore!.put(GARDENS_KEY, json);
      console.info(`[GardenStorage] Saved ${data.gardens.length} gardens`);
    } catch (e) {
      const error = e as BusinessError;
      console.error(`[GardenStorage] Save failed: ${error.code} - ${error.message}`);
      throw new Error(`Save failed: ${error.code} - ${error.message}`);
    }
  }

  async loadGardens(): Promise<GardenBookData> {
    if (!this.isReady()) {
      console.error('[GardenStorage] Service not initialized');
      throw new Error('GardenStorageService not initialized');
    }

    try {
      const json = await this.kvStore!.get(GARDENS_KEY) as string;

      if (!json || json === '') {
        console.info('[GardenStorage] No data found, returning empty');
        return { gardens: [] };
      }

      const data = JSON.parse(json) as GardenBookData;
      console.info(`[GardenStorage] Loaded ${data.gardens.length} gardens`);
      return data;

    } catch (e) {
      const error = e as BusinessError;
      // Key not found is expected on first run
      if (error.code === 15100004) {
        console.info('[GardenStorage] No existing data, returning empty');
        return { gardens: [] };
      }
      console.error(`[GardenStorage] Load failed: ${error.code} - ${error.message}`);
      throw new Error(`Load failed: ${error.code} - ${error.message}`);
    }
  }

  async clearAll(): Promise<void> {
    if (!this.isReady()) {
      throw new Error('GardenStorageService not initialized');
    }

    try {
      await this.kvStore!.delete(GARDENS_KEY);
      console.info('[GardenStorage] All data cleared');
    } catch (e) {
      const error = e as BusinessError;
      // Ignore "key not found" error
      if (error.code !== 15100004) {
        console.error(`[GardenStorage] Clear failed: ${error.code} - ${error.message}`);
        throw new Error(`Clear failed: ${error.code} - ${error.message}`);
      }
    }
  }

  async close(bundleName: string): Promise<void> {
    if (!this.kvManager) {
      return;
    }

    try {
      await new Promise<void>((resolve, reject) => {
        this.kvManager!.closeKVStore(bundleName, STORE_ID, (err) => {
          if (err) {
            reject(err);
            return;
          }
          resolve();
        });
      });

      this.kvStore = undefined;
      this.isInitialized = false;
      this.initPromise = undefined;
      console.info('[GardenStorage] KVStore closed');

    } catch (e) {
      const error = e as BusinessError;
      console.error(`[GardenStorage] Close failed: ${error.code} - ${error.message}`);
    }
  }
}

// Export singleton instance for convenience
export const gardenStorage = GardenStorageService.getInstance();
