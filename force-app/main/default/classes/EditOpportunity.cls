public without sharing class EditOpportunity{
    
    @AuraEnabled(cacheable = true)
    Public static Opportunity FetchRecentOpportunities(String OppRecId){
        //OppRecId= '0061m000007MRk1AAG';
        System.debug('OppRecId:: ' + OppRecId);
        //list<Opportunity> SendOpp=new list<Opportunity>();

        Opportunity FetchedOpp = [Select Id, Name, StageName, CloseDate
                                  From Opportunity
                                  Where Id = :OppRecId];
        //SendOpp.add(FetchedOpp);
        system.debug('FetchedOpp=' + FetchedOpp);

        return FetchedOpp;
    }

    @AuraEnabled(cacheable = true)
    Public Static List<OpportunityLineItem> showOppLineItem(String OppRecId){
        //OppRecId= '0061m000007MRk1AAG';
        List<OpportunityLineItem> ShowInnerOppLineItem = new List<OpportunityLineItem>();

        Opportunity opplist = [Select Id, Name, (Select Id, Name, Product2.MOP1__c, Product2.MOP2__c, Quantity, ListPrice, UnitPrice, TotalPrice
                                                 From OpportunityLineItems)
                               From Opportunity 
                               Where ( StageName != 'Closed Won' OR StageName != 'Closed Lost' ) AND Id = :OppRecId];
        system.debug('Opplist=' + opplist);
        for ( OpportunityLineItem oppLitem : opplist.OpportunityLineItems ){
            system.debug('oppLitem name=' + oppLitem.Name);

            ShowInnerOppLineItem.add(oppLitem);

        }
        system.debug('ShowInnerOppLineItem=' + ShowInnerOppLineItem);


        return ShowInnerOppLineItem;
    }

    @AuraEnabled(Cacheable=True)
    public static List<Product2> showProductListForEdit(string productName){

        //String Name = '%' + productName + '%';
        System.debug('productName ======> ' + productName);
        if(String.isBlank(productName))
            return new List<Product2>();

        String searchText= '%'+productName+'%' ;
        list<Product2> products=[Select Id,Name,ProductCode,MOP1__c,MOP2__c,MRP__c,ProductQuantity__c,FinalPrice__c From Product2 Where Name LIKE:searchText AND isactive =true Limit 50 ];
        system.debug('Product2='+products);
        system.debug('Product2='+products.size());
        //system.debug('Product2='+products);
        //Product_List_Price__c-Unable To find
        return products;
    }

    //,List<OpportunityLineItem> UpdateOppLineItem
    @AuraEnabled
    Public Static String InsertUpdatedLineItem(list<Product2> GetNewProductList, List<OpportunityLineItem> UpdateOppLineItem, Opportunity UpdatedOpp){

        System.debug('GetNewProductList ====> ' + GetNewProductList);
        System.debug('UpdateOppLineItem ====> ' + UpdateOppLineItem);
        System.debug('UpdatedOpp ====> ' + UpdatedOpp);

        try{
            list<OpportunityLineItem> newOppLitemSet = new List<OpportunityLineItem>();
            List<OpportunityLineItem> UpdateOpportunityLineItem = new List<OpportunityLineItem>();

            if (!GetNewProductList.isEmpty()) {
                for ( Product2 ProdItem : GetNewProductList ){
                    OpportunityLineItem newoli = new OpportunityLineItem(OpportunityId = UpdatedOpp.id,Quantity = ProdItem.ProductQuantity__c, Product2Id = ProdItem.Id, TotalPrice = ProdItem.FinalPrice__c);
                    newOppLitemSet.add(newoli);
                    system.debug('newOppLitemSet=' + newOppLitemSet);
                }
            }
            
            if (!UpdateOppLineItem.isEmpty()) {
                for ( OpportunityLineItem oppItem : UpdateOppLineItem ){
                    OpportunityLineItem newoppli = new OpportunityLineItem(Id = oppItem.Id, OpportunityId = UpdatedOpp.id, 
                    Quantity = oppItem.Quantity, Product2Id = oppItem.Id, TotalPrice = oppItem.TotalPrice);
                    UpdateOpportunityLineItem.add(newoppli);
                }
            }
            
            List<Opportunity> OppRecUpdate = new List<Opportunity>();

            Opportunity UpdatedOppRecord = new Opportunity(  );

            UpdatedOppRecord.Id = UpdatedOpp.Id;
            system.debug('UpdatedOppRecord=' + UpdatedOppRecord.Id);

            UpdatedOppRecord.Name = UpdatedOpp.Name;
            system.debug('UpdatedOppRecord.Name=' + UpdatedOppRecord.Name);

            UpdatedOppRecord.StageName = UpdatedOpp.StageName;
            system.debug('UpdatedOppRecord.StageName=' + UpdatedOppRecord.StageName);

            UpdatedOppRecord.CloseDate = UpdatedOpp.CloseDate;
            system.debug('UpdatedOppRecord.CloseDate=' + UpdatedOppRecord.CloseDate);

            OppRecUpdate.add(UpdatedOppRecord);

            if ( !OppRecUpdate.isEmpty()){
                Update OppRecUpdate;
            }

            if ( !UpdateOpportunityLineItem.isEmpty() ){
                update UpdateOpportunityLineItem;
            }
            if ( !newOppLitemSet.isEmpty() ){
                Insert newOppLitemSet;
            }

        }
        catch ( exception e ){
            system.debug('the error has occured =====> ' + e.getMessage());
            system.debug('the error has occured at line' + e.getLineNumber());
            System.debug('the error trace =====> ' + e.getStackTraceString());
        }

        return 'SUCCESS';
    }

}