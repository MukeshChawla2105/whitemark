public class OrderCompController {
    
    @AuraEnabled
    public static map<String,Map<String,String>> GetPicklistvalue (){
        
        map<String,Map<String,String>> FinalMap = new map<String,Map<String,String>>();
        Map<String,String> hpyClOptions = new Map<String, String>();
        Map<String,String> lossReasonOptions = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResultforHpyCl = Order.Happy_Call__c.getDescribe();
        Schema.DescribeFieldResult fieldResultforLossReason = Opportunity.Loss_Reason__c.getDescribe();
        
        List<Schema.PicklistEntry> hpyClValues = fieldResultforHpyCl.getPicklistValues();
        List<Schema.PicklistEntry> reasonValues = fieldResultforLossReason.getPicklistValues();
        
        for (Schema.PicklistEntry p: hpyClValues) {
            hpyClOptions.put(p.getValue(), p.getLabel());
        }
        for (Schema.PicklistEntry p: reasonValues) {
            lossReasonOptions.put(p.getValue(), p.getLabel());
        }
        FinalMap.put('HpyCl',hpyClOptions);
        FinalMap.put('reason',lossReasonOptions);
        
        return FinalMap;        
    }
    
    @AuraEnabled
    public static Order getOrderDetail(string orderId){
        system.debug('orderId ====>' + orderId);
        Order orderRec = [SELECT Id, Name, Happy_Call__c, Opportunity.Loss_Reason__c FROM Order WHERE Id =: orderId];
        return orderRec;
    }
    
    @AuraEnabled
     public static string updateOrder (Order oRecord){
         try{
             if(oRecord != null) {
                 update oRecord;
             }
             return 'SUCCESS';
         }
         catch(Exception e){
             throw new AuraHandledException(e.getMessage());
         }
     }
    
}