import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager';
import common from '@ohos.app.ability.common';
import { WantAgent } from '@kit.AbilityKit';
import { startTracking, stopTracking } from './LocationService';

export class BackgroundTaskService {
  private static isRunning: boolean = false;

  static async start(context: common.Context) {
    if (BackgroundTaskService.isRunning) {
      return;
    }
    try {
      let wantAgentObj: WantAgent = AppStorage.get('WantAgentObj')!;
      await backgroundTaskManager.startBackgroundRunning(context,
        backgroundTaskManager.BackgroundMode.LOCATION, wantAgentObj)
      BackgroundTaskService.isRunning = true;
      await startTracking(5000);
    } catch (err) {
      console.error(err.message)
    }
  }

  static async stop(context: common.Context) {
    if (!BackgroundTaskService.isRunning) {
      return;
    }
    try {
      await backgroundTaskManager.stopBackgroundRunning(context);
      BackgroundTaskService.isRunning = false;
      await stopTracking();
    } catch (err) {
      console.error(err)
    }
  }

  static isActive(): boolean {
    return BackgroundTaskService.isRunning;
  }
}