import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';
import { ThemedStatusBadge, ThemedStatusBadgeSize, ThemedStatusType } from './ThemedStatusBadge';
import { ThemedText, ThemedTextColor, ThemedTextVariant } from './ThemedText';
import { ThemedIcon, ThemedIconSize } from './ThemedIcon';
import { GardenViewModel } from '../viewmodels/GardenViewModel';

@ComponentV2
export struct ThemedGardenRow {
  @Require @Param garden: GardenViewModel;
  @Event onRowClick: () => void = () => {};
  @Event onDeleteClick: () => void = () => {};

  build() {
    Row({ space: ThemedLayout.SPACING_SM }) {
      // Status badge (left)
      ThemedStatusBadge({
        status: this.garden.overallStatus,
        badgeSize: ThemedStatusBadgeSize.SMALL,
        showLabel: false
      })

      Column({ space: ThemedLayout.SPACING_XS }) {
        ThemedText({
          text: this.garden.name,
          variant: ThemedTextVariant.BODY_LARGE,
          weight: ThemedFonts.WEIGHT_BOLD
        })

        ThemedText({
          text: this.garden.summaryText,
          variant: ThemedTextVariant.CAPTION,
          color: ThemedTextColor.SECONDARY
        })
      }
      .layoutWeight(1)
      .onClick(() => {
        this.onRowClick();
      })

      // Delete button (right)
      ThemedIcon({
        media: $r('app.media.error'),
        iconSize: ThemedIconSize.SM,
        onIconClick: () => {
          this.onDeleteClick();
        }
      })
    }
    .width('100%')
    .padding(ThemedLayout.PADDING_MD)
    .backgroundColor(ThemedColors.CARD)
    .borderRadius(ThemedLayout.RADIUS_MD)
    .border({ width: 1, color: ThemedColors.BORDER })
    .margin({ bottom: ThemedLayout.MARGIN_SM })
  }
}
