public with sharing class DeleteIntegrationLogBatch Implements Database.batchable<sobject>{
    public Date deleteTo;
    public DeleteIntegrationLogBatch(Integer Year, Integer Month, Integer myDate){
        deleteTo = date.newinstance(Year, Month, myDate);
    }

    public Database.QueryLocator Start(Database.BatchableContext bc){
        system.debug('Date::' + deleteTo);
        return Database.getQueryLocator('SELECT Id, CreatedDate FROM Integration_Log__c WHERE CreatedDate <: deleteTo');
    }

    public void execute(Database.BatchableContext BC, List<Integration_Log__c> logListToBeDeleted){
        system.debug('LogListToBeDeleted:: ' + logListToBeDeleted);
        try{
            if ( !logListToBeDeleted.isEmpty() ){
                delete logListToBeDeleted;
            }
        }
        catch ( Exception e ){
            system.debug('Error>> ' + e.getMessage() + 'at Line Number>> ' + e.getLineNumber());
        }
    }

    public void finish(Database.BatchableContext BC){
        system.debug('Batch run successfully');
    }

}