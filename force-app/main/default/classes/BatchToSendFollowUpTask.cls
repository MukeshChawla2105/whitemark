global without sharing class BatchToSendFollowUpTask implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        string subjectname = '%' + 'Follow-Up';
        Datetime presentdatetime = system.now();
        Datetime OneHourLaterTime = system.now().addHours(1);
        String query = 'SELECT Id, subject, what.Phone, Follow_Up_date__c, what.name, whatId, Product_Purchase_Date__c FROM task where Follow_Up_date__c != null AND Follow_Up_date__c >=: presentdatetime AND Follow_Up_date__c <=: OneHourLaterTime AND subject LIKe:subjectname';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<task> tasklist) {
        set<id> taskidset = new set<id>();

        List<Task> taskListTobeSend = new List<task>();
        if(!tasklist.isempty()){
            for(task tas : tasklist){

                if (tas.Follow_Up_date__c != null) {
                    taskidset.add(tas.id);
                }
                //taskidset.add(tas.id);
            }  
        }
        if(!taskidset.isempty()){
            CallOut_TaskTransfer.TransferFollowUpTask(taskidset);
        }
        
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    
}