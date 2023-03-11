global without sharing class ScheduleBatchToSendFollowUpTask  implements Schedulable{
    global void execute(SchedulableContext sc) {
        BatchToSendFollowUpTask batchInstance = new BatchToSendFollowUpTask();
        Database.executeBatch(batchInstance);
    }
}