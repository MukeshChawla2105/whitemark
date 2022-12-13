public with sharing class productDetailsLWCcontroller {
    @AuraEnabled(cacheable=true)
    Public Static list<PricebookEntry> getProductList(String prodid){
        list<PricebookEntry> prcbkList = new list<PricebookEntry>();
        prcbkList=[SELECT Id,IsActive,Name,Pricebook2Id,Product2Id,PriceBook2.Name,Price_Book_Name__c,ProductCode,UnitPrice,UseStandardPrice FROM PricebookEntry where Product2Id =:prodid];
        system.debug('prcbkList'+prcbkList);
        return prcbkList;
    }
}