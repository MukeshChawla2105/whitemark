public without Sharing class OpportunityTask {
    
    @AuraEnabled
    Public Static String CreateOpportunity(Id AccounRecId, String name,date closeDate,String Stage ,List<Product2> Productlist){      //, List<Product2> Productlist          
        System.debug('AccounRecId ===> ' + AccounRecId);
        try{
            Opportunity Oppcreate=new Opportunity();
            Oppcreate.AccountId = AccounRecId;
            Oppcreate.name=name;
            system.debug('Opportunity name='+Oppcreate.Name);
            Oppcreate.closeDate=closeDate;
            system.debug('Opportunity name='+Oppcreate.closeDate);
            Oppcreate.StageName=Stage;
            Oppcreate.Pricebook2Id = [select id, name from Pricebook2 where name ='Standard Price Book'].id;
            system.debug('Opportunity name='+Oppcreate.StageName);
            
            insert Oppcreate;
            
            System.debug('ID====='+Oppcreate.Id);
            
            
            system.debug('Productlist='+Productlist);
            
            list<OpportunityLineItem> oppLineItem = new list<OpportunityLineItem>();
            
            for(Product2 Pro:Productlist){
                OpportunityLineItem oli = new OpportunityLineItem(
                    OpportunityId = Oppcreate.Id,
                    Quantity = Pro.ProductQuantity__c,
                    Product2Id  = pro.Id,
                    TotalPrice = Pro.FinalPrice__c
                    //UnitPrice=pro.MRP__c     
                );
                
                oppLineItem.add(oli);
                
            }
            if(!oppLineItem.isEmpty()){
                system.debug('oppLineItem'+oppLineItem);
                Insert oppLineItem;
            }
            
            
        }
        catch(exception e){
            system.debug('the error has occured =====> ' + e.getMessage());
            system.debug('the error has occured at line' + e.getLineNumber());
        }
        
        return 'SUCCESS';
    }
    
    @AuraEnabled(Cacheable=True)
    public static List<Product2> showProductList( string productName){
        if(String.isBlank(productName))
            return new List<Product2>();
        System.debug('ProductName ====> ' + ProductName);
        String searchText= '%'+ProductName+'%' ;
        
        list<Product2> products=[Select Id,Name,ProductCode,MOP1__c,MOP2__c,MRP__c,ProductQuantity__c,FinalPrice__c From Product2 Where Name LIKE:searchText And isactive = true Limit 50 ];
        system.debug('Product2='+products);
        system.debug('Product2='+products.size());
        return products;
    }
    
}