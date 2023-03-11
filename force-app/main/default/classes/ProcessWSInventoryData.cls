public class ProcessWSInventoryData  implements Queueable{
    
    public JSONFranchiseeInventory invResponse= new JSONFranchiseeInventory();
    
    public ProcessWSInventoryData(JSONFranchiseeInventory parsedJSON) {
        this.invResponse=parsedJSON;
    }
    
    public void execute(QueueableContext context) {
        system.debug('ProcessWSInventoryData - JSON is received ---> '+ invResponse);
        
        //variables 
        Map<String, Franchisee__c> srcFranchiseeMap= new  Map<String, Franchisee__c>();
        Map<String, Product2> sourceProdMap= new  Map<String, Product2>();
        
        List<Franchisee__c> franListToInsert= New  List<Franchisee__c>();
        List<Product2> prodListToInsert= New  List<Product2>();
        List<Inventory__c> InvToUpsert= new   List<Inventory__c>();
        
        List<RecordType > RT= [SELECT DeveloperName,Id,SobjectType FROM RecordType WHERE DeveloperName = 'Franchisee_Inventory'];
        List<Franchisee__c> franList= [SELECT Id,Name,SAP_Code__c FROM Franchisee__c];
        List<Product2> prodList= [SELECT Brand__c,Description,Family,Id,IsActive,MRP__c,Name,SAP_Code__c FROM Product2];
        
        for(Franchisee__c curfran: franList){
            srcFranchiseeMap.Put(curfran.SAP_Code__c, curfran);
        }
        
        for(Product2 curProd: prodList){
            sourceProdMap.Put(curProd.SAP_Code__c, curProd);
        }
        
        for(Integer i=0;i<invResponse.Response.Data.Inventory.size();i++){
            if(invResponse.Response.Data.Inventory[i].Items != null){
                for(Integer j=0;j<invResponse.Response.Data.Inventory[i].Items.Item.size();j++){
                    String InventoryKey= invResponse.Response.Data.Inventory[i].Items.Item[j].ItemCode + invResponse.Response.Data.Inventory[i].Location;
                    
                    Inventory__c tempInv= New Inventory__c();
                    
                    tempInv.RecordTypeId= RT[0].Id;
                    tempInv.Product__c= sourceProdMap.get(invResponse.Response.Data.Inventory[i].Items.Item[j].ItemCode).Id;
                    tempInv.Franchisee__c= srcFranchiseeMap.get(invResponse.Response.Data.Inventory[i].Location).Id;
                    tempInv.CurrentIOH__c= Decimal.valueOf(invResponse.Response.Data.Inventory[i].Items.Item[j].Stock);
                    tempInv.Inventory_Key__c=InventoryKey;
                    system.debug('Temp Inventory ---> '+tempInv);
                    InvToUpsert.add(tempInv);
                    
                }   
            }
            if(invResponse.Response.Data.Inventory[i].Items_Z != null){
                
                String InventoryKey= invResponse.Response.Data.Inventory[i].Items_Z.Item.ItemCode + invResponse.Response.Data.Inventory[i].Location;
                Inventory__c tempInv= New Inventory__c();
                
                tempInv.RecordTypeId= RT[0].Id;
                tempInv.Product__c= sourceProdMap.get(invResponse.Response.Data.Inventory[i].Items_Z.Item.ItemCode).Id;
                tempInv.Franchisee__c= srcFranchiseeMap.get(invResponse.Response.Data.Inventory[i].Location).Id;
                tempInv.CurrentIOH__c= Decimal.valueOf(invResponse.Response.Data.Inventory[i].Items_Z.Item.Stock);
                tempInv.Inventory_Key__c=InventoryKey;
                system.debug('TempZ Inventory ---> '+tempInv);
                InvToUpsert.add(tempInv);
            }
        }
        
        If(InvToUpsert.size()>0){
            Schema.SObjectField ftoken = Inventory__c.Fields.Inventory_Key__c;
            Database.UpsertResult[] srList = Database.upsert(InvToUpsert,ftoken,false);


            // Iterate through each returned result
            for (Database.UpsertResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    if (sr.isCreated()) {
                        System.debug('Successfully inserted Inventory. Inventory ID: ' + sr.getId());
                    }else{
                        System.debug('Successfully Updated Inventory. Inventory ID: ' + sr.getId());
                    }
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Inventory fields that affected this error: ' + err.getFields());
                    }  
                }
            }
        }
        
        
    }
}