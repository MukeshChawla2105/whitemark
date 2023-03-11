global without sharing class ScheduleBatchToAutoCloseOpportunity implements Schedulable{
    global void execute(SchedulableContext sc) {
        BatchToAutoCloseOpportunity batchInstance = new BatchToAutoCloseOpportunity();
        Database.executeBatch(batchInstance);
    }
}