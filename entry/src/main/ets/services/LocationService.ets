import { geoLocationManager } from '@kit.LocationKit';
import { ActivityRecord, ActivityPoint, ActivityStore } from '../data/ActivityStore';

let currentActivity: ActivityRecord | null = null;
let subscribed = false;

function toRad(deg: number) {
  return deg * Math.PI / 180;
}

function haversine(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371000;
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a = Math.sin(dLat / 2)**2 + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2)**2;
  return 2 * R * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

export async function startTracking(intervalMs: number = 5000) {
  if (currentActivity) {
    return;
  }
  currentActivity = ActivityStore.startNewActivity();
  let request: geoLocationManager.ContinuousLocationRequest =
    { 'interval': 1, 'locationScenario': geoLocationManager.UserActivityScenario.NAVIGATION };
  let locationCallback = (location: geoLocationManager.Location): void => {
    console.info(`locationCallback: data: ${JSON.stringify(location)}`);
    const point: ActivityPoint = {
      lat: location.latitude,
      lon: location.longitude,
      speed: location.speed,
      time: Date.now()
    }
    const pts = currentActivity!.points;
    if (pts.length > 1) {
      const prev = pts[pts.length - 2];
      const d = haversine(prev.lat, prev.lon, point.lat, point.lon);
      if (d >= 2) {
        currentActivity!.distance += d;
      }
    }
    pts.push(point);
  };
  try {
    geoLocationManager.on('locationChange', request, locationCallback);
  } catch (err) {
    console.error(`errCode: ${err.code}, message: ${err.message}`);
  }

}

export function stopTracking() {
  if (!currentActivity) {
    return;
  }
  geoLocationManager.off('locationChange');
  const end = Date.now();
  currentActivity.endTime = end;
  const dtSec = (end - currentActivity.startTime) / 1000;
  currentActivity.avgSpeed = dtSec > 0 ? currentActivity.distance / dtSec : 0;
  ActivityStore.addRecord(currentActivity);
  currentActivity = null;
}

export function getActiveRecord(): ActivityRecord | null {
  return currentActivity;
}
