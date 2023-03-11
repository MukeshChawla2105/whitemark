public class BatchCreateHappyCallTask implements Database.Batchable <Sobject>{
public Database.QueryLocator Start(Database.BatchableContext bc){
        String query = 'select id,AccountId from order where createddate >= 2022-04-15T09:01:00Z and createddate < 2022-06-01T00:00:00Z';
        system.debug('Database.getQueryLocator(query)::'+Database.getQueryLocator(query));
    	return Database.getQueryLocator(query);
    }
    
    public void Execute(Database.BatchableContext bc, List<Order> orderList){
       system.debug('LeadToUpdate::'+orderList.size());
        OrderTriggerHandler.taskAssignmentLogic('Order Task Assignment',orderList);
    }
    
    public void Finish(Database.BatchableContext bc){
        System.debug('Batch Run Successfully');
    }
}