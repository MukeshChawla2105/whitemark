public class BatchLeadPhoneUpdate implements Database.Batchable <Sobject> {

    public Database.QueryLocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id,Phone,Updated_Phone__c FROM Lead WHERE Phone != null';
        return Database.getQueryLocator(query);
    }
    
    public void Execute(Database.BatchableContext bc, List<Lead> LeadToUpdate){
        try{
            
            for(Lead ledList : LeadToUpdate){
            if(ledList.Phone != null && ledList.Updated_Phone__c != true){
                String ledPhone = ledList.Phone.right(10);
                ledList.Phone = '0'+ledPhone;
                ledList.Updated_Phone__c = true;
            }
        }
        if(!LeadToUpdate.isEmpty()){
            update LeadToUpdate;
        }
            
        }catch(Exception e){
            System.debug('The Error Message :'+e.getMessage());
            System.debug('The Error Line :'+e.getLineNumber());
        }
        
    }
    
    public void Finish(Database.BatchableContext bc){
        System.debug('Batch Run Successfully');
    }
}