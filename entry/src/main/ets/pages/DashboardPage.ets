import webview from '@ohos.web.webview';
import { ActivityStore } from '../data/ActivityStore';

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
      Web({
        src: $rawfile('dashboard.html'),
        controller: this.controller
      }).borderRadius('50%')
        .width('100%')
        .height('100%')
        .onPageEnd(() =>{
          this.onPageEndSendData()
        })

    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}