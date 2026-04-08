import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { ActivityRecord, ActivityStore } from '../../../main/ets/data/ActivityStore';

export default function activityStoreTest() {
  describe('ActivityStoreTest', () => {
    it('testDeleteRecord', 0, () => {
      // Setup: clear existing and add two records
      while(ActivityStore.getRecords().length > 0) {
        ActivityStore.deleteRecord(ActivityStore.getRecords()[0].id);
      }

      const rec1: ActivityRecord = {
        id: '1',
        startTime: Date.now(),
        distance: 100,
        avgSpeed: 5,
        points: []
      };
      const rec2: ActivityRecord = {
        id: '2',
        startTime: Date.now() + 1000,
        distance: 200,
        avgSpeed: 10,
        points: []
      };

      ActivityStore.addRecord(rec1);
      ActivityStore.addRecord(rec2);

      expect(ActivityStore.getRecords().length).assertEqual(2);

      // Delete one
      ActivityStore.deleteRecord('1');

      expect(ActivityStore.getRecords().length).assertEqual(1);
      expect(ActivityStore.getRecords()[0].id).assertEqual('2');

      // Delete other
      ActivityStore.deleteRecord('2');
      expect(ActivityStore.getRecords().length).assertEqual(0);
    })
  })
}
