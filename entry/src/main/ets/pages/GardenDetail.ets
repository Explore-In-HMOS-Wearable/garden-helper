import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';
import { ThemedIcon, ThemedIconSize } from '../components/ThemedIcon';
import { ThemedStatusBadge, ThemedStatusBadgeSize } from '../components/ThemedStatusBadge';
import { ThemedText, ThemedTextColor, ThemedTextVariant } from '../components/ThemedText';
import { ThemedPlantRow } from '../components/ThemedPlantRow';
import { ThemedEmptyState } from '../components/ThemedEmptyState';
import { ThemedButton, ThemedButtonSize, ThemedButtonType } from '../components/ThemedButton';
import { ArcList, ArcListItem, ArcListAttribute } from '@kit.ArkUI';
import { GardenBookViewModel } from '../viewmodels/GardenBookViewModel';
import { mediaFromKey } from '../utils/MediaUtils';
import { PlantViewModel } from '../viewmodels/PlantViewModel';
import { GardenViewModel } from '../viewmodels/GardenViewModel';

export class GardenDetailParams {
  store: GardenBookViewModel;
  gardenId: string;
  onCreatePlant: () => void;

  constructor(store: GardenBookViewModel, gardenId: string, onCreatePlant: () => void) {
    this.store = store;
    this.gardenId = gardenId;
    this.onCreatePlant = onCreatePlant;
  }
}

@Builder
export function GardenDetailBuilder(params: GardenDetailParams) {
  GardenDetail({ params: params })
}

@ComponentV2
struct GardenDetail {
  @Require @Param params: GardenDetailParams;

  @Computed
  get garden(): GardenViewModel | undefined {
    return this.params.store.getGardenById(this.params.gardenId);
  }

  build() {
    NavDestination() {
      if (!this.garden) {
        ThemedEmptyState({
          media: $r('app.media.seedling'),
          title: 'Garden not found',
          message: 'This garden may have been removed.'
        })
          .backgroundColor(ThemedColors.BACKGROUND)
      } else if (this.garden!.plants.length === 0) {
        ThemedEmptyState({
          media: $r('app.media.seedling'),
          title: 'No plants yet',
          message: 'Add your first plant to get started',
          actionText: 'New plant',
          onAction: () => {
            this.params.onCreatePlant();
          }
        })
          .backgroundColor(ThemedColors.BACKGROUND)
      } else {
        Column() {
          ArcList({ initialIndex: 1 }) {
            ArcListItem() {
              this.HeaderCard(this.garden!)
            }

            ForEach(this.garden!.plants, (plant: PlantViewModel) => {
              ArcListItem() {
                ThemedPlantRow({
                  plant: plant,
                  media: mediaFromKey(plant.mediaKey),
                  onWaterClick: () => {
                    this.waterPlant(plant);
                  },
                  onDeleteClick: () => {
                    this.deletePlant(plant);
                  }
                })
              }
            }, (plant: PlantViewModel) => plant.id)

            ArcListItem() {
              ThemedButton({
                text: 'New plant',
                iconMedia: $r('app.media.seedling'),
                type: ThemedButtonType.PRIMARY,
                buttonSize: ThemedButtonSize.SMALL,
                fullWidth: true,
                onButtonClick: () => {
                  this.params.onCreatePlant();
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
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }

  private waterPlant(plant: PlantViewModel): void {
    this.params.store.waterPlant(this.params.gardenId, plant.id);
  }

  private deletePlant(plant: PlantViewModel): void {
    this.params.store.deletePlant(this.params.gardenId, plant.id);
  }

  @Builder
  private HeaderCard(garden: GardenViewModel) {
    Row({ space: ThemedLayout.SPACING_SM }) {
      ThemedIcon({
        media: mediaFromKey(garden.mediaKey),
        iconSize: ThemedIconSize.LG
      })

      Column({ space: ThemedLayout.SPACING_XS }) {
        Row({ space: ThemedLayout.SPACING_XS }) {
          ThemedText({
            text: garden.name,
            variant: ThemedTextVariant.BODY_LARGE,
            weight: ThemedFonts.WEIGHT_BOLD
          })

          ThemedStatusBadge({
            status: garden.overallStatus,
            badgeSize: ThemedStatusBadgeSize.SMALL,
            showLabel: false
          })
        }

        ThemedText({
          text: garden.summaryText,
          variant: ThemedTextVariant.CAPTION,
          color: ThemedTextColor.SECONDARY
        })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
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
}
