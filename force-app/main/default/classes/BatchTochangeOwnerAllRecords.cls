global with sharing class BatchTochangeOwnerAllRecords implements Database.Batchable<sObject>{
    
    global  String newUserId ;
    global  String objApiName ;
    
    global BatchTochangeOwnerAllRecords(String newUserId,String objApiName) {
        
        this.newUserId = newUserId;
        this.objApiName = objApiName;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id, OwnerId, Owner.isActive FROM '+ objApiName +' Where owner.IsActive = false LIMIT 49990' ;
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        System.debug('Sobject Records ======> ' + scope);
        System.debug('Sobject Records size ======> ' + scope.size());
        // process each batch of records default size is 200
        List<sObject> listtobeupdated = new List<sObject>();
        if (!scope.isEmpty()) {
            for(Sobject sobj : scope) {        
                sobj.put('Ownerid',newUserId);
                listtobeupdated.add(sobj);
                
            }
            
        }
        System.debug('UpdatedSobjectRecords =====> ' + listtobeupdated);
        System.debug('UpdatedSobjectRecords size =====> ' + listtobeupdated.size());
        try {
            if (!listtobeupdated.isEmpty()) {
                //update listtobeupdated;
            }
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}