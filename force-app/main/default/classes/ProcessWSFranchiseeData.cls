public class ProcessWSFranchiseeData implements Queueable {
    
    public JSONFranchiseeInventory invResponse= new JSONFranchiseeInventory();
    
    public ProcessWSFranchiseeData(JSONFranchiseeInventory parsedJSON) {
        this.invResponse=parsedJSON;
    }
    
    public void execute(QueueableContext context) {
        system.debug('JSON is received ---> '+ invResponse);
        
        //Processing variables
        Map<String, Franchisee__c> srcFranchiseeMap= new  Map<String, Franchisee__c>();
        List<Franchisee__c> franListToInsert= New  List<Franchisee__c>();
        
        List<Franchisee__c> franList= [SELECT Id,Name,SAP_Code__c FROM Franchisee__c];
        for(Franchisee__c curfran: franList){
            srcFranchiseeMap.Put(curfran.SAP_Code__c, curfran);
        }
        system.debug('srcFranchiseeMap -- >'+ srcFranchiseeMap);
        
        for(Integer i=0;i<invResponse.Response.Data.Inventory.size();i++){
            if(invResponse.Response.Data.Inventory[i].Items != null){
                if(srcFranchiseeMap.get(invResponse.Response.Data.Inventory[i].Location) == Null){
                    Franchisee__c tempfran= New Franchisee__c();
                    tempfran.Name= invResponse.Response.Data.Inventory[i].Location;
                    tempfran.SAP_Code__c= invResponse.Response.Data.Inventory[i].Location;
                    franListToInsert.add(tempfran);
                }
                
            }
            if(invResponse.Response.Data.Inventory[i].Items_Z != null){
                Franchisee__c tempfran= New Franchisee__c();
                tempfran.Name= invResponse.Response.Data.Inventory[i].Location;
                tempfran.SAP_Code__c= invResponse.Response.Data.Inventory[i].Location;
                franListToInsert.add(tempfran);    
            }
        }
        
        If(franListToInsert.size()>0){
            Database.SaveResult[] srList = Database.insert(franListToInsert,false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Franchisee. Franchisee ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Franchisee fields that affected this error: ' + err.getFields());
                    }  
                }
            }
        }
         if(!Test.isRunningTest()){
             System.enqueueJob(new ProcessWSInventoryData(invResponse));
         } 
    }  
}