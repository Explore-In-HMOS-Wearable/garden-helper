import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';
import { ThemedButton, ThemedButtonType } from './ThemedButton';

@Component
export struct ThemedEmptyState {
  // Required props
  @Prop media: ResourceStr;
  @Prop title: string = 'No plants yet';
  @Prop message: string = 'Add your first plant to get started';
  @Prop actionText: string = '';
  onAction: () => void = () => {};
  
  build() {
    Column({ space: ThemedLayout.SPACING_MD }) {
        Image(this.media)
          .width(ThemedLayout.ICON_XL)
          .height(ThemedLayout.ICON_XL)
          .objectFit(ImageFit.Contain)
      
      Text(this.title)
        .fontSize(ThemedFonts.SIZE_BODY_LARGE)
        .fontWeight(FontWeight.Bold)
        .fontColor(ThemedColors.TEXT_PRIMARY)
        .textAlign(TextAlign.Center)
      
      Text(this.message)
        .fontSize(ThemedFonts.SIZE_CAPTION)
        .fontColor(ThemedColors.TEXT_SECONDARY)
        .textAlign(TextAlign.Center)
        .maxLines(3)
      
      if (this.actionText && this.onAction) {
        ThemedButton({
          text: this.actionText,
          onButtonClick: this.onAction,
          type: ThemedButtonType.PRIMARY
        })
          .margin({ top: ThemedLayout.MARGIN_SM })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(ThemedLayout.PADDING_XL)
  }
}
