import { ThemedColors, ThemedFonts } from '../constants/UIConstants';

export enum ThemedTextVariant {
  HERO = 'hero',
  TITLE_LARGE = 'title_large',
  TITLE = 'title',
  BODY_LARGE = 'body_large',
  BODY = 'body',
  CAPTION = 'caption',
  SMALL = 'small'
}

export enum ThemedTextColor {
  PRIMARY = 'primary',
  SECONDARY = 'secondary',
  TERTIARY = 'tertiary',
  DISABLED = 'disabled',
  SUCCESS = 'success',
  WARNING = 'warning',
  ERROR = 'error',
  INFO = 'info'
}

@Component
export struct ThemedText {
  // Required props
  @Prop text: string;
  
  // Optional props with defaults
  @Prop variant: ThemedTextVariant = ThemedTextVariant.BODY;
  @Prop color: ThemedTextColor = ThemedTextColor.PRIMARY;
  @Prop weight: FontWeight = FontWeight.Normal;
  @Prop textAlign: TextAlign = TextAlign.Start;
  @Prop maxLines: number = 0;
  @Prop ellipsis: boolean = false;
  
  build() {
    Text(this.text)
      .fontSize(this.getFontSize())
      .fontWeight(this.weight)
      .fontColor(this.getColor())
      .textAlign(this.textAlign)
      .lineHeight(this.getFontSize() * 1.3)
      .maxLines(this.maxLines > 0 ? this.maxLines : undefined)
      .textOverflow(this.ellipsis ? { overflow: TextOverflow.Ellipsis } : undefined)
  }
  
  private getFontSize(): number {
    switch (this.variant) {
      case ThemedTextVariant.HERO:
        return ThemedFonts.SIZE_HERO;
      case ThemedTextVariant.TITLE_LARGE:
        return ThemedFonts.SIZE_TITLE_LARGE;
      case ThemedTextVariant.TITLE:
        return ThemedFonts.SIZE_TITLE;
      case ThemedTextVariant.BODY_LARGE:
        return ThemedFonts.SIZE_BODY_LARGE;
      case ThemedTextVariant.BODY:
        return ThemedFonts.SIZE_BODY;
      case ThemedTextVariant.CAPTION:
        return ThemedFonts.SIZE_CAPTION;
      case ThemedTextVariant.SMALL:
        return ThemedFonts.SIZE_SMALL;
      default:
        return ThemedFonts.SIZE_BODY;
    }
  }
  
  private getColor(): string {
    switch (this.color) {
      case ThemedTextColor.PRIMARY:
        return ThemedColors.TEXT_PRIMARY;
      case ThemedTextColor.SECONDARY:
        return ThemedColors.TEXT_SECONDARY;
      case ThemedTextColor.TERTIARY:
        return ThemedColors.TEXT_TERTIARY;
      case ThemedTextColor.DISABLED:
        return ThemedColors.TEXT_DISABLED;
      case ThemedTextColor.SUCCESS:
        return ThemedColors.SUCCESS;
      case ThemedTextColor.WARNING:
        return ThemedColors.WARNING;
      case ThemedTextColor.ERROR:
        return ThemedColors.ERROR;
      case ThemedTextColor.INFO:
        return ThemedColors.INFO;
      default:
        return ThemedColors.TEXT_PRIMARY;
    }
  }
}
