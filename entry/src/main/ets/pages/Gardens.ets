import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';
import { ThemedButton, ThemedButtonSize, ThemedButtonType } from '../components/ThemedButton';
import { ThemedStatusType } from '../components/ThemedStatusBadge';
import { ThemedGardenRow } from '../components/ThemedGardenRow';
import { ThemedText, ThemedTextColor, ThemedTextVariant } from '../components/ThemedText';
import { ArcList, ArcListItem, ArcListAttribute } from '@kit.ArkUI';
import { GardenBookViewModel } from '../viewmodels/GardenBookViewModel';
import { GardenViewModel } from '../viewmodels/GardenViewModel';

@Builder
export function GardensBuilder(
  store: GardenBookViewModel,
  onOpenGarden: (gardenId: string) => void = () => {
  },
  onCreateGarden: () => void = () => {
  },
) {
  Gardens({ store: store, onOpenGarden: onOpenGarden, onCreateGarden: onCreateGarden })
}

@ComponentV2
struct Gardens {
  @Require @Param store: GardenBookViewModel;
  @Event onOpenGarden: (gardenId: string) => void = () => {
  };
  @Event onCreateGarden: () => void = () => {
  };

  build() {
    Column() {
      ArcList({ initialIndex: 1 }) {
        ArcListItem() {
          this.HeaderCard()
        }

        ForEach(this.store.gardens, (garden: GardenViewModel) => {
          ArcListItem() {
            ThemedGardenRow({
              garden: garden,
              onRowClick: () => {
                this.onOpenGarden(garden.id);
              },
              onDeleteClick: () => {
                this.deleteGarden(garden);
              }
            })
          }
        }, (garden: GardenViewModel) => garden.id)

        ArcListItem() {
          ThemedButton({
            text: 'New garden',
            iconMedia: $r('app.media.seedling'),
            type: ThemedButtonType.PRIMARY,
            buttonSize: ThemedButtonSize.SMALL,
            fullWidth: true,
            onButtonClick: () => {
              this.onCreateGarden();
            }
          })
            .margin({
              left: ThemedLayout.MARGIN_MD,
              right: ThemedLayout.MARGIN_MD,
              bottom: ThemedLayout.MARGIN_SM
            })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ThemedColors.BACKGROUND)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ThemedColors.BACKGROUND)
  }

  private deleteGarden(garden: GardenViewModel): void {
    this.store.deleteGarden(garden.id);
  }

  @Builder
  private HeaderCard() {
    Column({ space: ThemedLayout.SPACING_XS }) {
      ThemedText({
        text: 'Gardens',
        variant: ThemedTextVariant.TITLE,
        weight: ThemedFonts.WEIGHT_BOLD
      })

      ThemedText({
        text: this.getSummaryText(),
        variant: ThemedTextVariant.CAPTION,
        color: ThemedTextColor.SECONDARY
      })
    }
    .width('100%')
    .padding({
      left: ThemedLayout.PADDING_MD,
      right: ThemedLayout.PADDING_MD,
      top: ThemedLayout.PADDING_MD,
      bottom: ThemedLayout.PADDING_SM
    })
    .margin({ bottom: ThemedLayout.MARGIN_SM })
  }

  private getSummaryText(): string {
    const total = this.store.gardens.length;
    if (total === 0) {
      return 'No gardens yet';
    }

    const overdueCount =
      this.store.gardens.filter((g: GardenViewModel) => g.overallStatus === ThemedStatusType.OVERDUE).length;
    const dueSoonCount =
      this.store.gardens.filter((g: GardenViewModel) => g.overallStatus === ThemedStatusType.DUE_SOON).length;

    if (overdueCount === 0 && dueSoonCount === 0) {
      return 'All gardens are happy';
    }

    if (overdueCount > 0 && dueSoonCount > 0) {
      return `${overdueCount} overdue · ${dueSoonCount} due`;
    }

    if (overdueCount > 0) {
      return `${overdueCount} overdue`;
    }

    return `${dueSoonCount} due`;
  }
}
