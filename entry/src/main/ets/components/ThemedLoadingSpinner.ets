import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';

export enum ThemedLoadingSize {
  SMALL = 'small',
  STANDARD = 'standard',
  LARGE = 'large'
}

@Component
export struct ThemedLoadingSpinner {
  // Optional props
  @Prop spinnerSize: ThemedLoadingSize = ThemedLoadingSize.STANDARD;
  @Prop color: string = ThemedColors.ACCENT_PRIMARY;
  @Prop message: string = '';
  
  build() {
    Column({ space: ThemedLayout.SPACING_SM }) {
      LoadingProgress()
        .width(this.getSize())
        .height(this.getSize())
        .color(this.color)
      
      if (this.message) {
        Text(this.message)
          .fontSize(ThemedFonts.SIZE_CAPTION)
          .fontColor(ThemedColors.TEXT_SECONDARY)
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
  
  private getSize(): number {
    switch (this.spinnerSize) {
      case ThemedLoadingSize.SMALL:
        return ThemedLayout.ICON_SM;
      case ThemedLoadingSize.LARGE:
        return ThemedLayout.ICON_LG;
      default:
        return ThemedLayout.ICON_MD;
    }
  }
}
