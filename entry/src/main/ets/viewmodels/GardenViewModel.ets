import { Type } from '@kit.ArkUI';
import { ThemedStatusType } from '../components/ThemedStatusBadge';
import type { MediaKey } from '../utils/MediaUtils';
import { PlantViewModel } from './PlantViewModel';

@ObservedV2
export class GardenViewModel {
  @Trace id: string = '';
  @Trace name: string = '';
  @Trace mediaKey: MediaKey = 'seedling';

  @Type(PlantViewModel)
  @Trace plants: PlantViewModel[] = [];

  @Computed
  get overallStatus(): ThemedStatusType {
    const hasOverdue = this.plants.some(p => p.status === ThemedStatusType.OVERDUE);
    if (hasOverdue) {
      return ThemedStatusType.OVERDUE;
    }

    const hasDue = this.plants.some(p => p.status === ThemedStatusType.DUE_SOON);
    if (hasDue) {
      return ThemedStatusType.DUE_SOON;
    }

    return ThemedStatusType.HEALTHY;
  }

  @Computed
  get summaryText(): string {
    const plantCount = this.plants.length;
    const overdue = this.plants.filter(p => p.status === ThemedStatusType.OVERDUE).length;
    const due = this.plants.filter(p => p.status === ThemedStatusType.DUE_SOON).length;

    if (plantCount === 0) {
      return '0 plants';
    }
    if (overdue === 0 && due === 0) {
      return `${plantCount} plants · all set`;
    }
    if (overdue > 0 && due > 0) {
      return `${plantCount} plants · ${overdue} overdue · ${due} due`;
    }
    if (overdue > 0) {
      return `${plantCount} plants · ${overdue} overdue`;
    }

    return `${plantCount} plants · ${due} due`;
  }

  addPlant(plant: PlantViewModel): void {
    this.plants = [...this.plants, plant];
  }

  deletePlant(plantId: string): void {
    this.plants = this.plants.filter(p => p.id !== plantId);
  }
}
