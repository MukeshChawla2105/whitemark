public without sharing class ConvertLeadAndCreateAccOppOrder{


    public static AccountAndOppwrapper convertLead(List<SObject> Leadrecord){
        list<OpportunityLineItem> oppLineItem = new list<OpportunityLineItem>();
        List<Account> LeadconvertedAccount = new List<Account>();
        List<Product_Intrest__c> ProdInterestedTobeTaggedUnderAccount = new List<Product_Intrest__c>();

        AccountAndOppwrapper accOppWrap = new AccountAndOppwrapper();

        System.debug('Leadrecord ===> ' + Leadrecord);
        try{
            if ( !Leadrecord.isEmpty() ){
                List<Product_Intrest__c> ProductInterestedLead = [SELECT CreatedDate, Id, Lead__c, MOP1__c, MOP2__c, MRP__c, Product_Name__c, Product__c, Quantity__c, Total__c
                                                                  FROM Product_Intrest__c
                                                                  Where Lead__c = :Leadrecord[0].Id];
                System.debug('ProductInterestedLead =====>  ' + ProductInterestedLead);
                Database.LeadConvert lc = new Database.LeadConvert(  );
                lc.setLeadId(Leadrecord[0].Id);
                lc.setDoNotCreateOpportunity(false);
                LeadStatus convertStatus = [SELECT Id, MasterLabel, IsConverted
                                            FROM LeadStatus
                                            WHERE IsConverted = true
                                            limit 1];
                lc.setConvertedStatus(convertStatus.MasterLabel);
                Database.LeadConvertResult lcResults = Database.convertLead(lc);

                System.debug('lcResults =====> ' + lcResults);
                if ( lcResults.isSuccess() ){
                    string accId = lcResults.getAccountId();
                    System.debug('Converted accId =====> ' + accId);

                    string oppId = lcResults.getOpportunityId();
                    System.debug('Converted oppId =====> ' + oppId);

                    opportunity opp = new Opportunity();
                    opp.id = lcResults.getOpportunityId();
                    Opp.Pricebook2Id = [select id, name
                                        from Pricebook2
                                        where name = 'Standard Price Book'].id;
                    update opp;

                    if ( accId != null && oppId != null ){
                        if (!ProductInterestedLead.isEmpty()) {
                            for ( Product_Intrest__c ProdInterested : ProductInterestedLead ){
                                OpportunityLineItem oli = new OpportunityLineItem();
                                oli.OpportunityId = oppId;
                                oli.Quantity = ProdInterested.Quantity__c;
                                oli.Product2Id = ProdInterested.Product__c;
                                if (ProdInterested.Proposed_Total__c != Null) {
                                    oli.TotalPrice = ProdInterested.Proposed_Total__c;
                                }
                                else{
                                    oli.TotalPrice = ProdInterested.Total__c;
                                }
                                oppLineItem.add(oli);
                                 
                                Product_Intrest__c PI = new Product_Intrest__c();
                                PI.Account__c = accId;
                                PI.Id = ProdInterested.Id;
                                PI.Product__c = ProdInterested.Product__c;
                                PI.Proposed_MRP__c = ProdInterested.Proposed_MRP__c;
                                PI.Proposed_Total__c = ProdInterested.Proposed_Total__c;
                                PI.Quantity__c = ProdInterested.Quantity__c;
                                PI.Total__c = ProdInterested.Total__c;
                                ProdInterestedTobeTaggedUnderAccount.add(PI);
    
                            }
                        }
                        
                        System.debug('oppLineItem ===>  '+ oppLineItem );
                        if ( !oppLineItem.isEmpty() ){
                            //system.debug('oppLineItem' + oppLineItem);
                            Insert oppLineItem;
                        }
                        if (!ProdInterestedTobeTaggedUnderAccount.isEmpty()) {
                            update ProdInterestedTobeTaggedUnderAccount;
                        }
                    }
                    accOppWrap.convertedAcclist = [Select id, Name, OwnerId From account where Id =: accId];
                    accOppWrap.ConvertedoppList = [ Select Id, name, StageName from Opportunity where AccountId =:accId AND StageName !='Closed Lost' And  StageName !='Closed Won' order By CreatedDate Desc LIMIT 1 ];
                    if (accOppWrap.convertedAcclist != null && accOppWrap.ConvertedoppList != null) {
                        return accOppWrap;
                    }
                }
            }
           
        }
        catch ( Exception e ){
            System.debug('the error has occured due to ====> ' + e.getMessage());
            System.debug('the error has occured at ====> ' + e.getLineNumber());
            System.debug('the error stack trace string ====> ' + e.getStackTraceString());
            Execption__c ex = new Execption__c();
            ex.Class_Name__c = 'WS_OrderDetailSync -> ConvertLeadAndCreateAccOppOrder';
            ex.Ececption_Message__c = e.getMessage() +'  '+e.getCause()+'  '+e.getLineNumber() ;
            ex.Stack_Trace__c = e.getStackTraceString();
            ex.Method_Name__c = 'convertLead';
            Insert ex;

        }
        return accOppWrap;
    }

    public class AccountAndOppwrapper{
        public List<Account> convertedAcclist {get; set;}
        public List<Opportunity> ConvertedoppList {get; set;}
    }

}