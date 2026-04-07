import webview from '@ohos.web.webview';
import { ActivityStore } from '../data/ActivityStore';
import router from '@ohos.router';

@Entry
@Component

struct DashboardPage{
  private controller: webview.WebviewController = new webview.WebviewController();
  onPageEndSendData(){
    const records = ActivityStore.getRecords();
    const json = JSON.stringify(records);
    this.controller.runJavaScript(`updateRuns(${json})`);
  }
  build(){
    Column(){
      Button('Back')
        .onClick(() => {
          router.back()
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
        .width('100%')
        .layoutWeight(1)
        .onPageEnd(() =>{
          this.onPageEndSendData()
        })

    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .borderRadius('50%')
    .backgroundColor(Color.White)
    .clip(true)
  }
}