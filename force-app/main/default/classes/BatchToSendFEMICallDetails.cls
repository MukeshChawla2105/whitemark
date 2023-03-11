global class BatchToSendFEMICallDetails implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        date todaydate = system.today();
        date onemonthbackdate = todaydate.addMonths(-1);
        date Firstdateofthebackmonth = onemonthbackdate.toStartOfMonth();
        date fifteenthofthebackmonth = Firstdateofthebackmonth.addDays(15);

        date Twomonthbackdate = todaydate.addMonths(-2);
        System.debug('onemonthbackdate =====> ' + onemonthbackdate);
        date Firstdateofthetwobackmonth = Twomonthbackdate.toStartOfMonth();
        date sixteenthofthetwobackmonth = Firstdateofthetwobackmonth.addDays(16);

        string subjectname = 'FEMI Call';
        String query = 'SELECT Id, subject, what.Phone, what.name, whatId, Product_Purchase_Date__c FROM task where Product_Purchase_Date__c != null AND subject =:subjectname AND Product_Purchase_Date__c >=: sixteenthofthetwobackmonth AND Product_Purchase_Date__c <=: fifteenthofthebackmonth';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<task> tasklist) {
        set<id> taskidset = new set<id>();
        if(!tasklist.isempty()){
            for(task tas : tasklist){
                taskidset.add(tas.id);
            }  
        }
        if(!taskidset.isempty()){
            CallOut_TaskTransfer.transferFEMICallDetails(taskidset);
        }
        
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    
    
}