import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';

export enum ThemedButtonType {
  PRIMARY = 'primary',
  SECONDARY = 'secondary',
  DANGER = 'danger',
  TEXT = 'text'
}

export enum ThemedButtonSize {
  SMALL = 'small',
  STANDARD = 'standard',
  LARGE = 'large'
}

@Component
export struct ThemedButton {
  // Required props
  @Prop text: string;
  onButtonClick: () => void = () => {};
  
  // Optional props with defaults
  @Prop type: ThemedButtonType = ThemedButtonType.PRIMARY;
  @Prop buttonSize: ThemedButtonSize = ThemedButtonSize.STANDARD;
  @Prop disabled: boolean = false;
  @Prop fullWidth: boolean = false;
  @Prop iconMedia: ResourceStr;
  
  build() {
    Row({ space: ThemedLayout.SPACING_XS }) {
      if (this.iconMedia) {
        Image(this.iconMedia)
          .width(this.getIconSize())
          .height(this.getIconSize())
          .objectFit(ImageFit.Contain)
      }
      
      Text(this.text)
        .fontSize(this.getFontSize())
        .fontWeight(ThemedFonts.WEIGHT_MEDIUM)
    }
    .width(this.fullWidth ? '100%' : undefined)
    .height(this.getHeight())
    .padding({ left: ThemedLayout.PADDING_MD, right: ThemedLayout.PADDING_MD })
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.getBackgroundColor())
    .borderRadius(this.getHeight() / 2)
    .opacity(this.disabled ? 0.4 : 1)
    .onClick(() => {
      if (!this.disabled) {
        this.onButtonClick();
      }
    })
  }
  
  private getBackgroundColor(): string {
    if (this.disabled) {
      return ThemedColors.BUTTON_DISABLED;
    }
    
    switch (this.type) {
      case ThemedButtonType.PRIMARY:
        return ThemedColors.BUTTON_PRIMARY;
      case ThemedButtonType.SECONDARY:
        return ThemedColors.BUTTON_SECONDARY;
      case ThemedButtonType.DANGER:
        return ThemedColors.BUTTON_DANGER;
      case ThemedButtonType.TEXT:
        return ThemedColors.TRANSPARENT;
      default:
        return ThemedColors.BUTTON_PRIMARY;
    }
  }
  
  private getHeight(): number {
    return this.buttonSize === ThemedButtonSize.SMALL ? ThemedLayout.BUTTON_HEIGHT_SM :
           this.buttonSize === ThemedButtonSize.LARGE ? ThemedLayout.BUTTON_HEIGHT_LG : ThemedLayout.BUTTON_HEIGHT_MD;
  }
  
  private getFontSize(): number {
    return this.buttonSize === ThemedButtonSize.SMALL ? ThemedFonts.SIZE_CAPTION :
           this.buttonSize === ThemedButtonSize.LARGE ? ThemedFonts.SIZE_BODY_LARGE : ThemedFonts.SIZE_BODY;
  }
  
  private getIconSize(): number {
    return this.buttonSize === ThemedButtonSize.SMALL ? ThemedLayout.ICON_XS :
           this.buttonSize === ThemedButtonSize.LARGE ? ThemedLayout.ICON_MD : ThemedLayout.ICON_SM;
  }
}