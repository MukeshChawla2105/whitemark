public withOut sharing class ProductIntrestController {
   
    @AuraEnabled(Cacheable=true)
    public static List<Product2> getProductList(string leadId){
        list<Product_Intrest__c> selectedProdList = [select name,id,Product__c from Product_Intrest__c where lead__c =:leadId];
        list<string> productIdList = New List<string>();
        for(Product_Intrest__c selectedProd:selectedProdList){
            productIdList.add(selectedProd.Product__c);
        }
        list<Product2> prodListToDisplay = [select name,Brand__c,Capacity_Size__c,MOP1__c,MOP2__c,MRP__c,Product_Id__c,ProductQuantity__c,Star_Rating__c from Product2 where ID NOT IN :productIdList];
        return prodListToDisplay;
    }

    @AuraEnabled
    public static string saveListProductIntrest(list<Product_Intrest__c> productListToInsert){
        system.debug('productListToInsert--'+productListToInsert);
        try {
            for(Product_Intrest__c producToInsert:productListToInsert){
                system.debug('-----'+producToInsert);
                if(producToInsert.Total__c != null){
                    producToInsert.Total__c = integer.valueOf(producToInsert.Total__c);
                }
                if(producToInsert.Total__c != null){
                    producToInsert.Quantity__c = integer.valueOf(producToInsert.Quantity__c);
                }
            }
           // database.upsert(productListToInsert,false) ;
           upsert productListToInsert;
            system.debug('productListToInsert--'+productListToInsert);

        } catch (Exception e) {
            system.debug('line '+e.getLineNumber()+'-----'+e.getMessage());
        }
        return 'success';
    }

    @AuraEnabled(Cacheable=true)
    public static string getProducts (Id selectedleadId){
    List <Product_Intrest__c> prodList = [SELECT Name,Id,MOP1__c,MOP2__c,MRP__c,Product_Name__c,Proposed_MRP__c,Quantity__c,Total__c,Product__c,Proposed_Total__c FROM Product_Intrest__c where lead__c =:selectedleadId];
    System.debug('prodList: ' +prodList);
    return JSON.serialize(prodList);
}

@AuraEnabled(cacheable=true)
public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName) {    
    List < sObject > returnList = new List < sObject > ();
    string sWildCardText = '%' + searchKey + '%';
    string sQuery = 'Select Id,Name,MOP1__c,MOP2__c,MRP__c From ' + sObjectApiName + ' Where Name Like : sWildCardText order by createdDate DESC';
    for (sObject obj: database.query(sQuery)) {
        returnList.add(obj);
    }
    return returnList;
}

// Method to fetch lookup default value 
@AuraEnabled(cacheable=true)
public static sObject fetchDefaultRecord(string recordId , string sObjectApiName) {
    string sRecId = recordId;    
    string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
    for (sObject obj: database.query(sQuery)) {
        return obj;
    }
    return null;
}


@AuraEnabled(cacheable=true)
public static Product2 getProductDetails(string proId){
    try {
        System.debug('proId ====> ' + proId);
        List <Product2> prodList = [SELECT Name,Id,MOP1__c,MOP2__c,MRP__c FROM Product2 where Id =:proId];
        System.debug('prodList: ' +prodList);
        if(prodList.size() > 0){
            return prodList[0];
        }else{
            return null;
        }

    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}

@AuraEnabled
public static void deleteProductIntrest(string productId){
    try {
        System.debug('productId: ' +productId);
        delete New Product_Intrest__c(Id=productId);
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}
}