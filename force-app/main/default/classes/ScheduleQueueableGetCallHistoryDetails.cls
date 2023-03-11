public with sharing class ScheduleQueueableGetCallHistoryDetails implements Schedulable {
    public void execute(SchedulableContext SC)  {
        ID jobID = System.enqueueJob(new ScheduleGetCallHistoryDetails_Batch());
    }
}