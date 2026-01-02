import { GardensBuilder } from './Gardens';
import { GardenDetailBuilder, GardenDetailParams } from './GardenDetail';
import { CreateGardenBuilder, CreateGardenParams } from './CreateGarden';
import { CreatePlantBuilder, CreatePlantParams } from './CreatePlant';
import { connectGardenBookStore, GardenBookViewModel } from '../viewmodels/GardenBookViewModel';
import { ThemedColors, ThemedFonts, ThemedLayout } from '../constants/UIConstants';
import { ThemedText, ThemedTextVariant } from '../components/ThemedText';
import { ThemedLoadingSpinner } from '../components/ThemedLoadingSpinner';

@Entry
@ComponentV2
struct Index {
  private pathStack: NavPathStack = new NavPathStack();
  @Local store: GardenBookViewModel = connectGardenBookStore();

  aboutToAppear(): void {
    // Initialize storage when page appears
    if (this.getUIContext().getHostContext() !== undefined) {
      this.store.initializeStorage(this.getUIContext().getHostContext()!);
    }
  }

  @Builder
  private PageMap(name: string, param: Object) {
    if (name === 'GardenDetail') {
      GardenDetailBuilder(param as GardenDetailParams)
    } else if (name === 'CreateGarden') {
      CreateGardenBuilder(param as CreateGardenParams)
    } else if (name === 'CreatePlant') {
      CreatePlantBuilder(param as CreatePlantParams)
    }else {
      NavDestination() {
        Column({ space: ThemedLayout.SPACING_MD }) {
          ThemedText({
            text: 'Unknown destination',
            variant: ThemedTextVariant.TITLE,
            weight: ThemedFonts.WEIGHT_BOLD
          })

          ThemedText({
            text: name,
            variant: ThemedTextVariant.BODY
          })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(ThemedColors.BACKGROUND)
      }
      .hideTitleBar(true)
      .hideBackButton(true)
    }
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        if (this.store.isLoading) {
          // Show loading while storage initializes
          Column() {
            ThemedLoadingSpinner()
            ThemedText({
              text: 'Loading gardens...',
              variant: ThemedTextVariant.BODY
            })
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(ThemedColors.BACKGROUND)
        } else {
          GardensBuilder(
            this.store,
            (gardenId: string) => {
              this.pathStack.pushPathByName('GardenDetail', new GardenDetailParams(this.store, gardenId, () => {
                this.pathStack.pushPathByName('CreatePlant', new CreatePlantParams(this.store, gardenId, () => {
                  this.pathStack.pop();
                }));
              }));
            },
            () => {
              this.pathStack.pushPathByName('CreateGarden', new CreateGardenParams(this.store, () => {
                this.pathStack.pop();
              }));
            }
          )
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PageMap)
  }
}