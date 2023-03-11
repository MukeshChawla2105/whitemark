public class BatchToShareAccountOrderToFranchisee implements
    Database.Batchable<sObject>, Database.Stateful{
        
        public Database.QueryLocator start(Database.BatchableContext bc) {
        
            String QueryString = 'SELECT AccountId,CreatedDate,Franchisee_Name__c,Franchisee__c,Id,OwnerId FROM Order Where Createddate =LAST_N_MONTHS:4 order by CreatedDate Asc';
            return Database.getQueryLocator(QueryString);
    }
    public void execute(Database.BatchableContext bc, List<Order> OrderRecords){
        // process each batch of records
        system.debug('OrderList :: ' + OrderRecords);
        for(order ord : OrderRecords){
            system.debug('ord ::' + ord);
        }
        OrderTriggerHandler.OrdermanualShareRead(OrderRecords);
    }
        
    public void finish(Database.BatchableContext bc){
        
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email
        
    }

}