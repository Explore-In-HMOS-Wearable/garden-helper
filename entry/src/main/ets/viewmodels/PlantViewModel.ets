import { ThemedStatusType } from '../components/ThemedStatusBadge';
import type { MediaKey } from '../utils/MediaUtils';

@ObservedV2
export class PlantViewModel {
  @Trace id: string = '';
  @Trace name: string = '';
  @Trace mediaKey: MediaKey = 'seedling';
  @Trace waterEveryDays: number = 3;
  @Trace lastWateredAt: number = 0;
  @Trace location: 'indoor' | 'outdoor' = 'indoor';

  @Computed
  get daysSinceWatered(): number {
    if (!this.lastWateredAt) {
      return Number.MAX_SAFE_INTEGER;
    } else {
      return Math.floor((Date.now() - this.lastWateredAt) / (24 * 60 * 60 * 1000));
    }
  }

  @Computed
  get daysUntilNext(): number {
    return this.waterEveryDays - this.daysSinceWatered;
  }

  @Computed
  get status(): ThemedStatusType {
    if (this.daysUntilNext < 0) {
      return ThemedStatusType.OVERDUE;
    }
    if (this.daysUntilNext === 0) {
      return ThemedStatusType.DUE_SOON;
    }
    // For 1-day plants: show healthy right after watering (daysUntilNext === waterEveryDays)
    // For others: show due soon when 1 day left
    if (this.daysUntilNext === 1 && this.waterEveryDays > 1) {
      return ThemedStatusType.DUE_SOON;
    }

    return ThemedStatusType.HEALTHY;
  }

  @Computed
  get detailText(): string {
    if (!this.lastWateredAt) {
      return 'Not watered yet';
    }
    if (this.daysUntilNext < 0) {
      return `Overdue ${Math.abs(this.daysUntilNext)}d`;
    }
    if (this.daysUntilNext === 0) {
      return 'Due today';
    }
    if (this.daysUntilNext === 1) {
      return 'Due tomorrow';
    }

    return `Next in ${this.daysUntilNext}d`;
  }

  markWatered(now: number = Date.now()): void {
    this.lastWateredAt = now;
  }
}
