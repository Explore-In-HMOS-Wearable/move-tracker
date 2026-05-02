import webview from '@ohos.web.webview';
import { ActivityStore } from '../data/ActivityStore';

@Builder
export function DashboardPageBuilder() {
  DashboardPage()
}

@Entry
@Component
struct DashboardPage {
  @Consume('pathStack') pathStack: NavPathStack = new NavPathStack()
  private controller: webview.WebviewController = new webview.WebviewController();

  onPageEndSendData() {
    const records = ActivityStore.getRecords();
    const json = JSON.stringify(records);
    this.controller.runJavaScript(`updateRuns(${json})`);
  }

  build() {
    NavDestination() {
      Column() {
        Button('Back')
          .onClick(() => {
            this.pathStack.pop()
          })
          .width('45%')
          .height(32)
          .backgroundColor('#ff353535')
          .borderRadius(16)
          .margin({ top: 10, bottom: 5 })

        Web({
          src: $rawfile('dashboard.html'),
          controller: this.controller
        })
          .geolocationAccess(true)
          .fileAccess(false)
          .width('100%')
          .layoutWeight(1)
          .onPageEnd(() => {
            this.onPageEndSendData()
          })
          .onControllerAttached(() => {
            this.controller.registerJavaScriptProxy(
              {
                deleteActivity: (id: string) => {
                  AlertDialog.show({
                    title: 'Delete Activity',
                    message: 'Are you sure you want to delete this activity?',
                    primaryButton: {
                      value: 'No',
                      action: () => {
                      }
                    },
                    secondaryButton: {
                      value: 'Yes',
                      fontColor: Color.Red,
                      action: () => {
                        ActivityStore.deleteRecord(id);
                        this.onPageEndSendData();
                      }
                    }
                  })
                }
              },
              'jsBridge',
              ['deleteActivity']
            );
          })

      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
      .borderRadius('50%')
      .backgroundColor(Color.White)
      .clip(true)
    }
    .hideBackButton(true)
  }
}