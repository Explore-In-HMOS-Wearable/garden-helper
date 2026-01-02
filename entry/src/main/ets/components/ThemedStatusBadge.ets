import { ThemedFonts, ThemedLayout, ThemedUIHelpers } from '../constants/UIConstants';

export enum ThemedStatusType {
  HEALTHY = 'healthy',
  DUE_SOON = 'due_soon',
  OVERDUE = 'overdue',
  JUST_WATERED = 'just_watered'
}

export enum ThemedStatusBadgeSize {
  SMALL = 'small',
  STANDARD = 'standard'
}

@Component
export struct ThemedStatusBadge {
  // Required props
  @Prop status: ThemedStatusType;
  
  // Optional props
  @Prop badgeSize: ThemedStatusBadgeSize = ThemedStatusBadgeSize.STANDARD;
  @Prop showLabel: boolean = false;
  @Prop label: string = '';
  
  build() {
    Row({ space: ThemedLayout.SPACING_XS }) {
      Circle()
        .width(this.badgeSize === ThemedStatusBadgeSize.SMALL ? ThemedLayout.SPACING_SM : ThemedLayout.STATUS_DOT_SM)
        .height(this.badgeSize === ThemedStatusBadgeSize.SMALL ? ThemedLayout.SPACING_SM : ThemedLayout.STATUS_DOT_SM)
        .fill(this.getStatusColor())
      
      if (this.showLabel && this.getLabel()) {
        Text(this.getLabel())
          .fontSize(this.badgeSize === ThemedStatusBadgeSize.SMALL ? ThemedFonts.SIZE_SMALL : ThemedFonts.SIZE_CAPTION)
          .fontColor(this.getStatusColor())
          .fontWeight(FontWeight.Medium)
      }
    }
  }
  
  private getStatusColor(): string {
    return ThemedUIHelpers.getStatusColor(this.status);
  }
  
  private getLabel(): string {
    if (this.label !== '') {
      return this.label;
    }
    
    switch (this.status) {
      case ThemedStatusType.HEALTHY:
        return 'Healthy';
      case ThemedStatusType.DUE_SOON:
        return 'Due Soon';
      case ThemedStatusType.OVERDUE:
        return 'Overdue';
      case ThemedStatusType.JUST_WATERED:
        return 'Just Watered';
      default:
        return '';
    }
  }
}
