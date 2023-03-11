global with sharing class BatchToAutoCloseOpportunity implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
         date todayDate = system.today();
         string oppstagename = 'Closed Won';
         string oppStageNameLost = 'Closed Lost';
         date TenDaysBackDate = todayDate.addDays(-10);
        String query = 'SELECT Id, Name, StageName, CloseDate FROM Opportunity Where closedate <=: TenDaysBackDate And Stagename !=:oppstagename AND  Stagename !=:oppStageNameLost LIMIT 49990' ;
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        System.debug('oppList ======> ' + oppList);
        System.debug('oppList size ======> ' + oppList.size());
        // process each batch of records default size is 200
        list<opportunity> oppListTobeUpdated = new List<Opportunity>();
        if (!oppList.isEmpty()) {
            for(opportunity opp : oppList) {        
                // Update the Account Name 
                if (opp.stagename != 'Closed Won' && opp.stageName != 'Closed Lost') {
                    opp.stageName = 'Closed Lost';
                    oppListTobeUpdated.add(opp);
                }
                
            }
            
        }
        System.debug('oppListTobeUpdated =====> ' + oppListTobeUpdated);
        System.debug('oppListTobeUpdated size =====> ' + oppListTobeUpdated.size());
        try {
            // Update the Account Record
            if (!oppListTobeUpdated.isEmpty()) {
                update oppListTobeUpdated;
            }
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    
}