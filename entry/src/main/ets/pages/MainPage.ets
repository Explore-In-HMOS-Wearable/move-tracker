import router from '@ohos.router';
import { BackgroundTaskService } from '../services/BackgroundTaskService';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct MainPage {
  @State isTracking: boolean = false;
  private context: common.Context = AppStorage.get('context')!;

  build() {
    Column({ space: 16 }) {
      Text('Move Tracker App')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .padding({ top: 12 })
      Text(this.isTracking ? 'Tracking is ON' : 'Tracking is OFF')
        .fontSize(13)
        .opacity(0.8)
      Button(this.isTracking ? 'Stop Tracking' : 'Start Tracking')
        .onClick(async () => {
          if (this.isTracking) {
            await BackgroundTaskService.stop(this.context);
            this.isTracking = false;
          } else {
            await BackgroundTaskService.start(this.context);
            this.isTracking = true;
          }
        })
        .fontSize(14)
        .borderRadius(12)
        .padding(8)
        .backgroundColor('#ff353535')
        .width('76%')
        .height(32)
      Row({space:12}){
        Button('History')
          .onClick(() => {
            router.pushUrl(
              {url: 'pages/HistoryPage'}
            )
          })
          .fontSize(11)
          .borderRadius(12)
          .backgroundColor('#ff353535')
          .padding(8)
          .width('35%')
          .height(32)
        Button('Dashboard')
          .onClick(() => {
            router.pushUrl(
              {url: 'pages/DashboardPage'}
            )
          })
          .width('35%')
          .height(32)
          .fontSize(10)
          .borderRadius(12)
          .padding(8)
          .backgroundColor('#ff353535')
      }
    }
    .padding(16)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }}