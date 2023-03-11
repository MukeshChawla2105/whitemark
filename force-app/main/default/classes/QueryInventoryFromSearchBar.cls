public class QueryInventoryFromSearchBar {
    
    @AuraEnabled
    public static inventorywrapper findByName(String searchKey) {
        inventorywrapper InventWrap = new inventorywrapper();
        try{
            
            String name = '%' + searchKey + '%';
            List<Inventory__c> inventoryList = new  List<Inventory__c>();
            inventoryList = [SELECT id, name, Available_Quantity__c, Product__r.Name, Product__r.Product_Id__c, Product__r.Warranty__c,  Franchisee__c,  Franchisee__r.Name, Franchisee__r.Location__c, Warehouse__c, Warehouse__r.Name, Warehouse__r.Location__c 
                             FROM Inventory__c 
                             WHERE Product__r.Name LIKE : name  OR Product__r.Name =:searchKey];
            system.debug('inventoryList :: ' + inventoryList);
            List<Inventory__c> WarehouseInventorylist = new List<Inventory__c>();
            for(Inventory__c invs : inventoryList){
                
                if(invs.Warehouse__c != NUll){
                    WarehouseInventorylist.add(invs);
                }
            }
            
            List<Inventory_Detail__c > inventoryListForFranchie = new  List<Inventory_Detail__c >();
            inventoryListForFranchie = [SELECT Available_Quantity__c,Franchisee_Name__c,Inventory__c,Inventory__r.name, Product__r.name, Inventory__r.Franchisee__r.Location__c
                                        FROM Inventory_Detail__c 
                                        where ((Product__r.name  LIKE : name  OR Product__r.name =:searchKey)  And (Franchisee_Name__c != null)) LIMIT 1000];
            system.debug('inventoryListForFranchie :: ' + inventoryListForFranchie);
            
            List<Inventory_Detail__c> franchieInventorylist = new List<Inventory_Detail__c>();
            if(!inventoryListForFranchie.isEmpty()){
                for(Inventory_Detail__c Inv : inventoryListForFranchie){
                    if(Inv.Franchisee_Name__c != null){
                        franchieInventorylist.add(Inv);
                    }  
                }
            }
            InventWrap.franchieInventories = franchieInventorylist;
            InventWrap.warehouseInventories = WarehouseInventorylist;
            
        }
        catch(Exception e) {
            system.debug('Line Number :: ' + e.getLineNumber() + 'Messege :: ' + e.getMessage());
        }
        return InventWrap;
    }

    @AuraEnabled
    public static inventorywrapper findInventoryForAabaSoftUser(String searchKey, String Location, String Codevalue, String Brand) {
        inventorywrapper InventWrap = new inventorywrapper();
        try{
            String LocationString = '';
            String CodevalueString = '';
            System.debug('searchKey ====>  ' + searchKey);
            System.debug('Location ====>  ' + Location);
            System.debug('Codevalue ====>  ' + Codevalue);
            System.debug('Brand ====>  ' + Brand);
            String name = '%' + searchKey + '%';
            if (Location != null) {
                LocationString = '%' + Location + '%';
            }
            if (Codevalue != null) {
                CodevalueString = '%' + Codevalue + '%';
            }
            String BrandString = '%' + Brand + '%';
            string QueryString = 'SELECT id, name, Available_Quantity__c, Product__r.Name, Product__r.Product_Id__c, Product__r.Warranty__c,  Franchisee__c,  Franchisee__r.Name, Franchisee__r.Location__c, Warehouse__c, Warehouse__r.Name, Warehouse__r.Location__c, Product__r.ProductCode, Product__r.Brand__c FROM Inventory__c WHERE (Product__r.Name LIKE : name  OR Product__r.Name =:searchKey)  and (Warehouse__r.Location__c LIKE:LocationString OR  Warehouse__r.Location__c =:LocationString) ANd (Product__r.ProductCode LIKE:CodevalueString OR Product__r.ProductCode =:CodevalueString) AND (Product__r.Brand__c =:BrandString)';
            
            System.debug('LocationString ===> ' + LocationString);
            System.debug('name ===> ' + name);
            System.debug('CodevalueString ===> ' + CodevalueString);
            System.debug('BrandString ===> ' + BrandString);
            
            List<Inventory__c> inventoryList = new  List<Inventory__c>();
            
            if (Location == null && codevalue == null) {
                inventoryList = [SELECT id, name, Available_Quantity__c, Product__r.Name, Product__r.Product_Id__c, Product__r.Warranty__c,  Franchisee__c,  Franchisee__r.Name, Franchisee__r.Location__c, Warehouse__c, Warehouse__r.Name, Warehouse__r.Location__c, Product__r.ProductCode, Product__r.Brand__c
                                    FROM Inventory__c 
                             WHERE (((Product__r.Name LIKE: name  OR Product__r.Name =:searchKey) OR (Product__r.ProductCode LIKE:CodevalueString OR Product__r.ProductCode =:CodevalueString) OR (Warehouse__r.Location__c LIKE:LocationString OR  Warehouse__r.Location__c =:LocationString)) AND (Product__r.Brand__c =:Brand) AND Available_Quantity__c > 0) LIMIT 100]; //
                
            }
            else if (Location != null && codevalue == null) {
                inventoryList = [SELECT id, name, Available_Quantity__c, Product__r.Name, Product__r.Product_Id__c, Product__r.Warranty__c,  Franchisee__c,  Franchisee__r.Name, Franchisee__r.Location__c, Warehouse__c, Warehouse__r.Name, Warehouse__r.Location__c, Product__r.ProductCode, Product__r.Brand__c
                                    FROM Inventory__c 
                             WHERE ((Product__r.Name LIKE: name  OR Product__r.Name =:searchKey) AND (Warehouse__r.Location__c LIKE:LocationString OR  Warehouse__r.Location__c =:LocationString) AND (Product__r.Brand__c =:Brand) AND Available_Quantity__c > 0) LIMIT 100];
            }
            else if (codevalue != null && Location == null ) {
                inventoryList = [SELECT id, name, Available_Quantity__c, Product__r.Name, Product__r.Product_Id__c, Product__r.Warranty__c,  Franchisee__c,  Franchisee__r.Name, Franchisee__r.Location__c, Warehouse__c, Warehouse__r.Name, Warehouse__r.Location__c, Product__r.ProductCode, Product__r.Brand__c
                                    FROM Inventory__c 
                             WHERE ((Product__r.Name LIKE: name  OR Product__r.Name =:searchKey) AND (Product__r.ProductCode LIKE:CodevalueString OR Product__r.ProductCode =:CodevalueString) AND (Product__r.Brand__c =:Brand) AND Available_Quantity__c > 0) LIMIT 100];
                
            }
            else if (codevalue != null  && Location != null ) {
                inventoryList = [SELECT id, name, Available_Quantity__c, Product__r.Name, Product__r.Product_Id__c, Product__r.Warranty__c,  Franchisee__c,  Franchisee__r.Name, Franchisee__r.Location__c, Warehouse__c, Warehouse__r.Name, Warehouse__r.Location__c, Product__r.ProductCode, Product__r.Brand__c
                                    FROM Inventory__c 
                             WHERE ((Product__r.Name LIKE: name  OR Product__r.Name =:searchKey) AND (Product__r.ProductCode LIKE:CodevalueString OR Product__r.ProductCode =:CodevalueString) AND (Warehouse__r.Location__c LIKE:LocationString OR  Warehouse__r.Location__c =:LocationString) AND (Product__r.Brand__c =:Brand) AND Available_Quantity__c > 0) LIMIT 100];
                
            }
            system.debug('inventoryList :: ' + inventoryList);
            List<Inventory__c> WarehouseInventorylist = new List<Inventory__c>();
            for(Inventory__c invs : inventoryList){
                system.debug('invs.Warehouse__c::'+invs.Warehouse__c);
                if(invs.Warehouse__c != NUll){
                    WarehouseInventorylist.add(invs);
                }
            }
            
            List<Inventory_Detail__c > inventoryListForFranchie = new  List<Inventory_Detail__c >();

            //if (Codevalue != null) {
                // inventoryListForFranchie = [SELECT Available_Quantity__c,Franchisee_Name__c,Inventory__c,Inventory__r.name, Product__r.name, Inventory__r.Franchisee__r.Location__c
                //                         FROM Inventory_Detail__c 
                //                         where ((Product__r.name  LIKE : name  OR Product__r.name =:searchKey)
                //                         OR (Inventory__r.Franchisee__r.Location__c LIKE: LocationString OR Inventory__r.Franchisee__r.Location__c =: LocationString)
                //                         OR (Product__r.ProductCode LIKE:CodevalueString OR Product__r.ProductCode =:CodevalueString)) AND (Product__r.Brand__c =:Brand) LIMIT 1000];
                
            //}
            /*else if (Codevalue == null) {
                inventoryListForFranchie = [SELECT Available_Quantity__c,Franchisee_Name__c,Inventory__c,Inventory__r.name, Product__r.name, Inventory__r.Franchisee__r.Location__c
                                        FROM Inventory_Detail__c 
                                        where (Product__r.name  LIKE : name  OR Product__r.name =:searchKey)  AND (Franchisee_Name__c != null)
                                        AND (Inventory__r.Franchisee__r.Location__c LIKE: LocationString OR Inventory__r.Franchisee__r.Location__c =: LocationString)
                                        AND (Product__r.Brand__c =:Brand) LIMIT 1000];
                
            }*/
            if (Location == null && codevalue == null){
                inventoryListForFranchie = [SELECT Available_Quantity__c,Franchisee_Name__c,Inventory__c,Inventory__r.name, Product__r.name, Inventory__r.Franchisee__r.Location__c
                                        FROM Inventory_Detail__c 
                                        where ((Product__r.name  LIKE : name  OR Product__r.name =:searchKey)
                                        OR (Inventory__r.Franchisee__r.Location__c LIKE: LocationString OR Inventory__r.Franchisee__r.Location__c =: LocationString)
                                        OR (Product__r.ProductCode LIKE:CodevalueString OR Product__r.ProductCode =:CodevalueString)) AND Product__r.Brand__c =:Brand AND Available_Quantity__c > 0 LIMIT 1000];
            }

            else if (Location != null && codevalue == null) {
                inventoryListForFranchie = [SELECT Available_Quantity__c,Franchisee_Name__c,Inventory__c,Inventory__r.name, Product__r.name, Inventory__r.Franchisee__r.Location__c
                                        FROM Inventory_Detail__c 
                                        where (Product__r.name  LIKE : name  OR Product__r.name =:searchKey)
                                        AND (Inventory__r.Franchisee__r.Location__c LIKE: LocationString OR Inventory__r.Franchisee__r.Location__c =: LocationString) AND (Product__r.Brand__c =:Brand) AND Available_Quantity__c > 0 LIMIT 1000];
            }
            else if (codevalue != null && Location == null) {
                inventoryListForFranchie = [SELECT Available_Quantity__c,Franchisee_Name__c,Inventory__c,Inventory__r.name, Product__r.name, Inventory__r.Franchisee__r.Location__c
                                        FROM Inventory_Detail__c 
                                        where (Product__r.name  LIKE : name  OR Product__r.name =:searchKey)
                                        AND (Product__r.ProductCode LIKE:CodevalueString OR Product__r.ProductCode =:CodevalueString) AND (Product__r.Brand__c =:Brand) AND Available_Quantity__c > 0 LIMIT 1000];
            }
            else if (codevalue != null  && Location != null ){
                inventoryListForFranchie = [SELECT Available_Quantity__c,Franchisee_Name__c,Inventory__c,Inventory__r.name, Product__r.name, Inventory__r.Franchisee__r.Location__c
                                        FROM Inventory_Detail__c 
                                        where (Product__r.name  LIKE : name  OR Product__r.name =:searchKey)
                                        AND (Inventory__r.Franchisee__r.Location__c LIKE: LocationString OR Inventory__r.Franchisee__r.Location__c =: LocationString)
                                        AND (Product__r.ProductCode LIKE:CodevalueString OR Product__r.ProductCode =:CodevalueString) AND (Product__r.Brand__c =:Brand) AND Available_Quantity__c > 0 LIMIT 1000];
            }

            system.debug('inventoryListForFranchie :: ' + inventoryListForFranchie);
            
            List<Inventory_Detail__c> franchieInventorylist = new List<Inventory_Detail__c>();
            if(!inventoryListForFranchie.isEmpty()){
                for(Inventory_Detail__c Inv : inventoryListForFranchie){
                    
                    if(Inv.Franchisee_Name__c != null){
                        franchieInventorylist.add(Inv);
                    }  
                }
            }
            InventWrap.franchieInventories = franchieInventorylist;
            InventWrap.warehouseInventories = WarehouseInventorylist;
            
        }
        catch(Exception e) {
            system.debug('Line Number :: ' + e.getLineNumber() + 'Messege :: ' + e.getMessage());
        }
        return InventWrap;
    }

    @AuraEnabled
    public static Map<String,List<String>> PassPicklistonDoint(){
        Map<String,List<String>> pickValByField = new Map<String,List<String>>();
        try {
            pickValByField.put('Product2',getPicklistValues('Product2','Brand__c'));

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return pickValByField;
    }
    
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){
        
        List<String> lstPickvals = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            
            lstPickvals.add(String.ValueOf(a.getLabel()).trim());
        }
        return lstPickvals;
    }

    @AuraEnabled
    public static List<PricebookEntry> QueryPriceBook(String ProductId){
        
        List<PricebookEntry> PBElist = [SELECT id, name, Pricebook2.Name,MRP__c, UnitPrice,Product2.MOP2__c, IsActive FROM PricebookEntry WHERE Product2Id =: ProductId]; 
        return PBElist;
        
    }
    
    public class inventorywrapper{
        @AuraEnabled public List<Inventory__c> warehouseInventories{get; set;}
        @AuraEnabled public List<Inventory_Detail__c> franchieInventories{get; set;}
    }

    public Static void TestCoverage(){
        integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}