import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';
import { ThemedButton, ThemedButtonType } from '../components/ThemedButton';
import { ThemedText, ThemedTextVariant } from '../components/ThemedText';
import { GardenBookViewModel } from '../viewmodels/GardenBookViewModel';

export class CreateGardenParams {
  store: GardenBookViewModel;
  onDone: () => void;

  constructor(store: GardenBookViewModel, onDone: () => void) {
    this.store = store;
    this.onDone = onDone;
  }
}

@Builder
export function CreateGardenBuilder(params: CreateGardenParams) {
  CreateGarden({ params: params })
}

@ComponentV2
struct CreateGarden {
  @Require @Param params: CreateGardenParams;
  @Local name: string = '';

  build() {
    NavDestination() {
      Column({ space: ThemedLayout.SPACING_MD }) {
        ThemedText({
          text: 'Create garden',
          variant: ThemedTextVariant.TITLE,
          weight: ThemedFonts.WEIGHT_BOLD
        })

        TextInput({ text: this.name, placeholder: 'Garden name' })
          .onChange((value: string) => {
            this.name = value;
          })
          .width('100%')

        ThemedButton({
          text: 'Create',
          type: ThemedButtonType.PRIMARY,
          fullWidth: true,
          disabled: this.name.trim().length === 0,
          onButtonClick: () => {
            this.params.store.createGarden(this.name);
            this.params.onDone();
          }
        })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding(ThemedLayout.PADDING_MD)
      .backgroundColor(ThemedColors.BACKGROUND)
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}
