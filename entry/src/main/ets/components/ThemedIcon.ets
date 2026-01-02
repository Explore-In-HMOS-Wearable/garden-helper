import { ThemedLayout } from '../constants/UIConstants';

export enum ThemedIconSize {
  XS = 'xs',
  SM = 'sm',
  MD = 'md',
  LG = 'lg',
  XL = 'xl',
  XXL = 'xxl'
}

@Component
export struct ThemedIcon {
  @Prop media: ResourceStr;
  
  // Optional props
  @Prop iconSize: ThemedIconSize = ThemedIconSize.MD;
  @Prop color: string = '';
  onIconClick: () => void = () => {};
  
  build() {
    Stack() {
      Image(this.media)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    }
    .width(this.getSize())
    .height(this.getSize())
    .alignContent(Alignment.Center)
    .onClick(() => {
      if (this.onIconClick.toString() !== '() => {}') {
        this.onIconClick();
      }
    })
  }
  
  private getSize(): number {
    switch (this.iconSize) {
      case ThemedIconSize.XS:
        return ThemedLayout.ICON_XS;
      case ThemedIconSize.SM:
        return ThemedLayout.ICON_SM;
      case ThemedIconSize.MD:
        return ThemedLayout.ICON_MD;
      case ThemedIconSize.LG:
        return ThemedLayout.ICON_LG;
      case ThemedIconSize.XL:
        return ThemedLayout.ICON_XL;
      case ThemedIconSize.XXL:
        return ThemedLayout.ICON_XXL;
      default:
        return ThemedLayout.ICON_MD;
    }
  }
}
