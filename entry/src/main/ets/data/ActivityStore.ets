export interface ActivityPoint {
  lat: number;
  lon: number;
  speed: number;
  time: number;
}
export interface ActivityRecord{
  id: string;
  startTime: number;
  endTime?: number;
  distance: number;
  avgSpeed: number;
  points: ActivityPoint[];
}
export class ActivityStore{
  private static activities: ActivityRecord[] = [];

  static startNewActivity():
    ActivityRecord{
    const rec: ActivityRecord = {
      id: Date.now().toString(),
      startTime: Date.now(),
      distance: 0,
      avgSpeed: 0,
      points: []
    };
    return rec;
  }
  static addRecord(record: ActivityRecord){
    ActivityStore.activities.unshift(record)
  }
  static getRecords(): ActivityRecord[]{
    return ActivityStore.activities;
  }
  static latest(): ActivityRecord | null {
    return ActivityStore.activities.length > 0 ? ActivityStore.activities[0] : null;
  }
  static deleteRecord(id: string): void {
    ActivityStore.activities = ActivityStore.activities.filter(r => r.id !== id);
  }

}