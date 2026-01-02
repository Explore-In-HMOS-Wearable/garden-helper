import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';
import { ThemedButton, ThemedButtonType } from '../components/ThemedButton';
import { ThemedText, ThemedTextColor, ThemedTextVariant } from '../components/ThemedText';
import { GardenBookViewModel } from '../viewmodels/GardenBookViewModel';
import { MediaKey, PLANT_ICON_KEYS, mediaFromKey } from '../utils/MediaUtils';
import { ArcList, ArcListItem, ArcListAttribute } from '@kit.ArkUI';

export class CreatePlantParams {
  store: GardenBookViewModel;
  gardenId: string;
  onDone: () => void;

  constructor(store: GardenBookViewModel, gardenId: string, onDone: () => void) {
    this.store = store;
    this.gardenId = gardenId;
    this.onDone = onDone;
  }
}

@Builder
export function CreatePlantBuilder(params: CreatePlantParams) {
  CreatePlant({ params: params })
}

// Water frequency options
const WATER_FREQUENCY_OPTIONS: number[] = [1, 2, 3, 5, 7, 14];

@ComponentV2
struct CreatePlant {
  @Require @Param params: CreatePlantParams;
  @Local name: string = '';
  @Local selectedIcon: MediaKey = 'seedling';
  @Local waterEveryDays: number = 3;

  build() {
    NavDestination() {
      ArcList({ initialIndex: 1 }) {
        // Title
        ArcListItem() {
          ThemedText({
            text: 'Create plant',
            variant: ThemedTextVariant.TITLE,
            weight: ThemedFonts.WEIGHT_BOLD
          })
            .padding({ top: ThemedLayout.PADDING_MD, bottom: ThemedLayout.PADDING_SM })
        }

        // Name input
        ArcListItem() {
          Column({ space: ThemedLayout.SPACING_XS }) {
            ThemedText({
              text: 'Name',
              variant: ThemedTextVariant.CAPTION,
              color: ThemedTextColor.SECONDARY
            })

            TextInput({ text: this.name, placeholder: 'Plant name' })
              .onChange((value: string) => {
                this.name = value;
              })
              .width('100%')
              .backgroundColor(ThemedColors.CARD)
              .borderRadius(ThemedLayout.RADIUS_SM)
          }
          .width('100%')
          .padding({ left: ThemedLayout.PADDING_MD, right: ThemedLayout.PADDING_MD })
        }

        // Icon picker label
        ArcListItem() {
          ThemedText({
            text: 'Choose icon',
            variant: ThemedTextVariant.CAPTION,
            color: ThemedTextColor.SECONDARY
          })
            .padding({ top: ThemedLayout.PADDING_SM })
        }

        // Icon picker grid
        ArcListItem() {
          this.IconPickerGrid()
        }

        // Water frequency label
        ArcListItem() {
          ThemedText({
            text: 'Water every',
            variant: ThemedTextVariant.CAPTION,
            color: ThemedTextColor.SECONDARY
          })
            .padding({ top: ThemedLayout.PADDING_SM })
        }

        // Water frequency picker
        ArcListItem() {
          this.WaterFrequencyPicker()
        }

        // Create button
        ArcListItem() {
          ThemedButton({
            text: 'Create',
            type: ThemedButtonType.PRIMARY,
            fullWidth: true,
            disabled: this.name.trim().length === 0,
            onButtonClick: () => {
              this.params.store.createPlantWithOptions(
                this.params.gardenId,
                this.name,
                this.selectedIcon,
                this.waterEveryDays
              );
              this.params.onDone();
            }
          })
            .margin({
              left: ThemedLayout.MARGIN_MD,
              right: ThemedLayout.MARGIN_MD,
              top: ThemedLayout.MARGIN_SM,
              bottom: ThemedLayout.MARGIN_MD
            })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ThemedColors.BACKGROUND)
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }

  @Builder
  IconPickerGrid() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
      ForEach(PLANT_ICON_KEYS, (iconKey: MediaKey) => {
        Stack() {
          Image(mediaFromKey(iconKey))
            .width(36)
            .height(36)
            .objectFit(ImageFit.Contain)
        }
        .width(48)
        .height(48)
        .borderRadius(ThemedLayout.RADIUS_SM)
        .backgroundColor(this.selectedIcon === iconKey ? ThemedColors.ACCENT_PRIMARY : ThemedColors.CARD)
        .border({
          width: this.selectedIcon === iconKey ? 2 : 1,
          color: this.selectedIcon === iconKey ? ThemedColors.ACCENT_PRIMARY : ThemedColors.BORDER
        })
        .margin(4)
        .onClick(() => {
          this.selectedIcon = iconKey;
        })
      }, (iconKey: MediaKey) => iconKey)
    }
    .width('100%')
    .padding({ left: ThemedLayout.PADDING_SM, right: ThemedLayout.PADDING_SM })
  }

  @Builder
  WaterFrequencyPicker() {
    Row({ space: ThemedLayout.SPACING_XS }) {
      ForEach(WATER_FREQUENCY_OPTIONS, (days: number) => {
        Column() {
          ThemedText({
            text: days.toString(),
            variant: ThemedTextVariant.BODY,
            weight: this.waterEveryDays === days ? ThemedFonts.WEIGHT_BOLD : ThemedFonts.WEIGHT_REGULAR
          })
          ThemedText({
            text: days === 1 ? 'day' : 'days',
            variant: ThemedTextVariant.CAPTION,
            color: ThemedTextColor.SECONDARY
          })
        }
        .width(40)
        .height(50)
        .justifyContent(FlexAlign.Center)
        .borderRadius(ThemedLayout.RADIUS_SM)
        .backgroundColor(this.waterEveryDays === days ? ThemedColors.ACCENT_PRIMARY : ThemedColors.CARD)
        .border({
          width: this.waterEveryDays === days ? 2 : 1,
          color: this.waterEveryDays === days ? ThemedColors.ACCENT_PRIMARY : ThemedColors.BORDER
        })
        .onClick(() => {
          this.waterEveryDays = days;
        })
      }, (days: number) => days.toString())
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ left: ThemedLayout.PADDING_SM, right: ThemedLayout.PADDING_SM })
  }
}
