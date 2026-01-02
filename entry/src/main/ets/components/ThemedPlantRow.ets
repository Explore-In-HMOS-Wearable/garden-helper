import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';
import { ThemedIcon, ThemedIconSize } from './ThemedIcon';
import { ThemedStatusBadge, ThemedStatusBadgeSize, ThemedStatusType } from './ThemedStatusBadge';
import { ThemedText, ThemedTextColor, ThemedTextVariant } from './ThemedText';
import { PlantViewModel } from '../viewmodels/PlantViewModel';

@ComponentV2
export struct ThemedPlantRow {
  @Require @Param plant: PlantViewModel;
  @Require @Param media: ResourceStr;
  @Event onWaterClick: () => void = () => {};
  @Event onDeleteClick: () => void = () => {};

  build() {
    Row({ space: ThemedLayout.SPACING_SM }) {
      // Status badge (left)
      ThemedStatusBadge({
        status: this.plant.status,
        badgeSize: ThemedStatusBadgeSize.SMALL,
        showLabel: false
      })

      // Plant icon
      ThemedIcon({
        media: this.media,
        iconSize: ThemedIconSize.SM
      })

      // Plant info
      Column({ space: ThemedLayout.SPACING_XS }) {
        ThemedText({
          text: this.plant.name,
          variant: ThemedTextVariant.BODY,
          weight: ThemedFonts.WEIGHT_BOLD
        })

        ThemedText({
          text: this.plant.detailText,
          variant: ThemedTextVariant.CAPTION,
          color: ThemedTextColor.SECONDARY
        })
      }
      .layoutWeight(1)

      // Water button (right)
      ThemedIcon({
        media: $r('app.media.water'),
        iconSize: ThemedIconSize.SM,
        onIconClick: () => {
          this.onWaterClick();
        }
      })

      // Delete button (right)
      ThemedIcon({
        media: $r('app.media.error'),
        iconSize: ThemedIconSize.XS,
        onIconClick: () => {
          this.onDeleteClick();
        }
      })
    }
    .width('100%')
    .padding(ThemedLayout.PADDING_SM)
    .backgroundColor(ThemedColors.PLANT_CARD_EMERALD)
    .borderRadius(ThemedLayout.RADIUS_SM)
    .border({ width: 1, color: ThemedColors.BORDER_LIGHT })
    .margin({ bottom: ThemedLayout.MARGIN_XS })
  }
}
