import { ActivityRecord, ActivityStore } from '../data/ActivityStore';
import { ArcList, ArcListItem, ArcListAttribute } from '@ohos.arkui.ArcList';
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component

struct HistoryPage {
  build(){
    Column(){
      Text('Activities')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .padding({
          top:10,
          bottom:10
        })
      ArcList(){
        ForEach(ActivityStore.getRecords(), (r: ActivityRecord, idx) => {
          ArcListItem(){
            Column({space:6}){
              Text(`#${ActivityStore.getRecords().length - idx}  -  ${(r.distance/1000).toFixed(2)} km`)
                .fontSize(12)
              Text(`Avg: ${(r.avgSpeed * 3.6).toFixed(1)} km/h  |  Pts: ${(r.points.length)}`)
                .fontSize(8)
                .opacity(0.7)
              Text(`${new Date(r.startTime).toLocaleString()} - ${r.endTime ? new Date(r.endTime).toLocaleString() : ''} `)
                .fontSize(8)
                .opacity(0.7)
            }
          }
        })
      }.space(LengthMetrics.px(200))
      .margin({bottom : 60})
    }
    .padding(16)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')

  }
}