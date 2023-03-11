public without Sharing class OrdeLineitemTriggerHandler{


    public static void ClosedWonOpportunityOnBasisOFOrderItem(map<Id, orderItem> orderNewmap, map<Id, orderItem> orderOldMap){
        Set<Id> AccountIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        Set<Id> orderItemIds = new Set<Id>();

        list<OrderItem> orderItemsList = new List<OrderItem>();
        Map<String, orderItem> SAPCodeWithOrderItemList = new Map<String, orderItem>();
        Map<string, List<orderItem>> AccountIdWithOrderItemList = new Map<string, List<orderItem>>();
        map<String, List<OrderItem>> OrderIdWithOrderListItem = new map<String, List<OrderItem>>();
        map<Id, orderItem> orderitemwithAccount = new map<Id, orderItem>();

        map<String, LisT<OpportunityLineItem>> oppWithOplineItem = new map<String, LisT<OpportunityLineItem>>();
        List<Opportunity> OpportunitiesWithAccountID = new List<Opportunity>();
        List<Account> AccountWithRelatedOpportunities = new List<Account>();
        map<Id, Opportunity> AccountIDWithFirstOpportunity = new map<Id, Opportunity>();
        map<String, opportunitylineItem> SAPCodeWithOppLineItem = new map<String, opportunitylineItem>();
        System.debug('orderNewmap ===> ' + orderNewmap);
        System.debug('orderOldMap ===> ' + orderOldMap);
        try{

            if ( !orderNewmap.isempty() ){
                for ( orderItem ordItem : orderNewmap.values() ){
                    orderItemIds.add(ordItem.Id);
                }
            }
            System.debug('orderItemIds====> ' + orderItemIds);
            if ( !orderItemIds.isEmpty() ){
                orderItemsList = [SELECT AvailableQuantity, Bill_Amount__c, cess_Percentage__c, cess__c, cgst_Ledger_Name__c, cgst_Percentage__c, cgst__c, Coupon_Discount__c, CreatedDate, Description, EndDate, gsttype__c, Id, igst_Ledger_Name__c, igst_Percentage__c, igst__c, Item_Discount__c, ListPrice, OrderId, OrderItemNumber, OriginalOrderItemId, PricebookEntryId, Product2Id, Quantity, ServiceDate, sgst_Ledger_Name__c, sgst_Percentage__c, sgst__c, TotalPrice, UnitPrice, Order.AccountId, Product2.SAP_Code__c
                                  FROM OrderItem
                                  where id IN:orderItemIds];
                if ( !orderItemsList.isEmpty() ){
                    for ( OrderItem ordrItem : orderItemsList ){
                        orderitemwithAccount.put(ordrItem.Id, ordrItem);
                    }
                }
            }
            System.debug('orderitemwithAccount====> ' + orderitemwithAccount);
            if ( !orderitemwithAccount.isempty() ){
                for ( orderItem ordItem : orderitemwithAccount.values() ){

                    System.debug('ordItem.OrderId =====> ' + ordItem.OrderId);
                    System.debug('ordItem.OrderId =====> ' + ordItem.Order.AccountId);
                    orderIds.add(ordItem.OrderId);
                    AccountIds.add(ordItem.Order.AccountId);
                    SAPCodeWithOrderItemList.put(ordItem.Product2.SAP_Code__c, ordItem);

                    if ( OrderIdWithOrderListItem.containsKey(ordItem.OrderId) ){
                        system.debug('inside If');
                        List<OrderItem> orderItemList = OrderIdWithOrderListItem.get(ordItem.OrderId);
                        orderItemList.add(ordItem);

                    }
                    else{
                        system.debug('inside else');
                        List<OrderItem> orderItemList = New List<OrderItem>();
                        orderItemList.add(ordItem);
                        OrderIdWithOrderListItem.put(ordItem.OrderId, orderItemList);
                    }
                    if ( AccountIdWithOrderItemList.containsKey(ordItem.Order.AccountId) ){
                        List<orderItem> ExistingOrderItemList = AccountIdWithOrderItemList.get(ordItem.Order.AccountId);
                        ExistingOrderItemList.add(ordItem);
                    }
                    else{
                        List<orderItem> createNewOrderItemListforAcc = new List<orderItem>();
                        createNewOrderItemListforAcc.add(ordItem);
                        AccountIdWithOrderItemList.put(ordItem.Order.AccountId, createNewOrderItemListforAcc);
                    }

                }
                System.debug('AccountIds ====> ' + AccountIds);
                if ( !AccountIds.isEmpty() ){
                    OpportunitiesWithAccountID = [Select Id, name, Account_Phone__c, StageName, AccountId, (Select id, ListPrice, ProductCode, Name, Product2Id, Quantity, TotalPrice, UnitPrice, Product2.SAP_Code__c, OpportunityId
                                                                                                            From OpportunityLineItems)
                                                  From Opportunity 
                                                  where AccountId In:AccountIds AND StageName != 'Closed Won' AND StageName != 'Closed Lost'
                                                  ORDER BY CreatedDate DESC
                                                  LIMIT 1];
                    AccountWithRelatedOpportunities = [select Id, name, ownerId, (Select Id, name, StageName, AccountId, Amount, Budget_Amount__c, CloseDate, Description, Enquiry_Type__c, Franchisee__c, LeadSource, Pricebook2Id, Product_Category__c, TotalOpportunityQuantity, Type
                                                                                  From Opportunities
                                                                                  Where StageName != 'Closed Won' AND StageName != 'Closed Lost'
                                                                                  ORDER BY CreatedDate DESC)
                                                       From Account 
                                                       where Id In:AccountIds
                                                       LIMIT 1];
                }
                //System.debug('OpportunitiesWithAccountID ====> ' + OpportunitiesWithAccountID);
                System.debug('AccountWithRelatedOpportunities ====> ' + AccountWithRelatedOpportunities);
                if ( !AccountWithRelatedOpportunities.isEmpty() ){
                    // for ( Account acc : AccountWithRelatedOpportunities ){
                    //     AccountIDWithFirstOpportunity.put(acc.id, acc.Opportunities[0]);
                    // }
                }
                if ( !OpportunitiesWithAccountID.isEmpty() ){
                    for ( Opportunity opp : OpportunitiesWithAccountID ){
                        oppWithOplineItem.put(opp.id, opp.OpportunityLineItems);
                    }
                    if (!OpportunitiesWithAccountID[0].OpportunityLineItems.isempty()) {
                        for ( opportunitylineItem OppLI : OpportunitiesWithAccountID[0].OpportunityLineItems ){
                            SAPCodeWithOppLineItem.put(OppLI.Product2.SAP_Code__c, OppLI);
                        }
                    }
                    
                }
                else{
                    CreateOppAndOppLineItem_viaLineItem_MarkasCloasedWon(AccountWithRelatedOpportunities,orderitemwithAccount);

                }
            }

            if ( !SAPCodeWithOppLineItem.isEmpty() && !SAPCodeWithOrderItemList.isEmpty() ){
                System.debug('SAPCodeWithOppLineItem ===> ' + SAPCodeWithOppLineItem);
                System.debug('SAPCodeWithOrderItemList ===> ' + SAPCodeWithOrderItemList);
                UpdateorCreateNewOpportunity_Via_OrderItem(SAPCodeWithOrderItemList, SAPCodeWithOppLineItem, AccountWithRelatedOpportunities, OpportunitiesWithAccountID[0].Id);
                

            }
            else if ( SAPCodeWithOppLineItem.isEmpty() && !SAPCodeWithOrderItemList.isEmpty() && !OpportunitiesWithAccountID.isEmpty() && !orderitemwithAccount.isEmpty()){
                AddOppLineItem_viaOrdlineItem_markasClosedWon(OpportunitiesWithAccountID, orderitemwithAccount);

            }
        }
        catch ( Exception e ){
            System.debug('The Error has occured due to ====> ' + e.getMessage());
            System.debug('The Error has occured at line number ====> ' + e.getLineNumber());
        }
    }

    Public static void UpdateorCreateNewOpportunity_Via_OrderItem(Map<String, orderItem> SAPCodeWithOrderItemList, map<String, opportunitylineItem> SAPCodeWithOppLineItem, List<Account> AccountWithRelatedOpportunities, string oppid){
        integer i = 0;
        Opportunity Opptobeupdated = new Opportunity(  );
        List<OpportunityLineitem> updateOLIList = new List<OpportunityLineitem>();
        List<OpportunityLineitem> OLITobedeletedList = new List<OpportunityLineitem>();
        Map<String, OpportunityLineitem> createNewOppWithOLI = new Map<String, OpportunityLineitem>();
        Map<string, OpportunityLineitem> ExistingOLIListwithSapCode = new Map<string, OpportunityLineitem>();
        List<OpportunityLineitem> ExistingOLIList = new List<OpportunityLineitem>();
        list<OpportunityLineItem> oppLineItemtoBeInserted = new list<OpportunityLineItem>();

        if ( !SAPCodeWithOrderItemList.isEmpty() && !SAPCodeWithOppLineItem.isEmpty() ){
            for ( String SAPCodeStr : SAPCodeWithOppLineItem.keySet() ){
                //ExistingOLIList.add(SAPCodeWithOppLineItem.get(SAPCodeStr));
                Opptobeupdated.id = SAPCodeWithOppLineItem.get(SAPCodeStr).OpportunityId;

                OpportunityLineitem updateOLI = new OpportunityLineitem();
                if ( SAPCodeWithOrderItemList.containsKey(SAPCodeStr) ){
                    ExistingOLIListwithSapCode.put(SAPCodeStr, SAPCodeWithOppLineItem.get(SAPCodeStr));
                    decimal Quantitydifference = SAPCodeWithOrderItemList.get(SAPCodeStr).Quantity - SAPCodeWithOppLineItem.get(SAPCodeStr).Quantity;
                    if ( SAPCodeWithOrderItemList.get(SAPCodeStr).Quantity == SAPCodeWithOppLineItem.get(SAPCodeStr).Quantity ){
                        i++;
                        updateOLI.id = SAPCodeWithOppLineItem.get(SAPCodeStr).Id;
                        updateOLI.unitprice = SAPCodeWithOrderItemList.get(SAPCodeStr).unitprice;
                    }
                    else if ( SAPCodeWithOrderItemList.get(SAPCodeStr).Quantity > SAPCodeWithOppLineItem.get(SAPCodeStr).Quantity ){
                        updateOLI.id = SAPCodeWithOppLineItem.get(SAPCodeStr).Id;
                        updateOLI.unitprice = SAPCodeWithOrderItemList.get(SAPCodeStr).unitprice;
                        updateOLI.Quantity = ( SAPCodeWithOppLineItem.get(SAPCodeStr).Quantity + ( SAPCodeWithOrderItemList.get(SAPCodeStr).Quantity - SAPCodeWithOppLineItem.get(SAPCodeStr).Quantity ) );
                    }
                    else if ( SAPCodeWithOrderItemList.get(SAPCodeStr).Quantity < SAPCodeWithOppLineItem.get(SAPCodeStr).Quantity ){
                        updateOLI.id = SAPCodeWithOppLineItem.get(SAPCodeStr).Id;
                        updateOLI.unitprice = SAPCodeWithOrderItemList.get(SAPCodeStr).unitprice;
                        updateOLI.Quantity = ( SAPCodeWithOppLineItem.get(SAPCodeStr).Quantity - ( SAPCodeWithOppLineItem.get(SAPCodeStr).Quantity - SAPCodeWithOrderItemList.get(SAPCodeStr).Quantity ) );
                    }
                    System.debug('updateOLI  ====> ' + updateOLI);
                    updateOLIList.add(updateOLI);
                }
                else{
                    System.debug('I am inside to be deleted oli');
                    OLITobedeletedList.add(SAPCodeWithOppLineItem.get(SAPCodeStr));
                    createNewOppWithOLI.put(SAPCodeStr, SAPCodeWithOppLineItem.get(SAPCodeStr));

                }
            }
            System.debug('OLITobedeletedList  ====> ' + OLITobedeletedList);
            System.debug('createNewOppWithOLI  ====> ' + createNewOppWithOLI);
            System.debug('updateOLIList ==> ' + updateOLIList);
            if ( !ExistingOLIListwithSapCode.isEmpty() ){
                for ( String SAPCodeStr : SAPCodeWithOrderItemList.keySet() ){
                    if ( !ExistingOLIListwithSapCode.containsKey(SAPCodeStr) ){
                        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = oppid, Quantity = SAPCodeWithOrderItemList.get(SAPCodeStr).Quantity, Product2Id = SAPCodeWithOrderItemList.get(SAPCodeStr).Product2Id, UnitPrice = SAPCodeWithOrderItemList.get(SAPCodeStr).UnitPrice);
                        oppLineItemtoBeInserted.add(oli);
                    }

                }
            }

            //if ( !updateOLIList.isEmpty()){
            if ( OLITobedeletedList.size() != SAPCodeWithOppLineItem.keySet().size() && OLITobedeletedList.size() < SAPCodeWithOppLineItem.keySet().size() ){
                if ( !OLITobedeletedList.isEmpty() ){
                    delete OLITobedeletedList;
                    //CreateNewExtendedOpportunityWithOppLineItem(createNewOppWithOLI, AccountWithRelatedOpportunities);
                }
                if ( !oppLineItemtoBeInserted.isempty() ){
                    insert oppLineItemtoBeInserted;
                }
                if ( !updateOLIList.isEmpty() ){
                    update updateOLIList;
                }
                Opptobeupdated.StageName = 'Closed Won';
                update Opptobeupdated;
                if ( !OLITobedeletedList.isEmpty() ){
                    CreateNewExtendedOpportunityWithOppLineItem(createNewOppWithOLI, AccountWithRelatedOpportunities);
                }
            }
            else if ( OLITobedeletedList.size() == SAPCodeWithOppLineItem.keySet().size() ){
                System.debug('Closed Lost Opportunity');
                Opptobeupdated.StageName = 'Closed Lost';
                System.debug('Opptobeupdated ====> ' + Opptobeupdated);
                System.debug('updateOLIList ====> ' + updateOLIList);
                update Opptobeupdated;
                //update updateOLIList;
                CreateNewClosedWonOpportunity(SAPCodeWithOrderItemList, AccountWithRelatedOpportunities);
            }
        }
    }

    public static void CreateNewExtendedOpportunityWithOppLineItem(Map<String, OpportunityLineitem> createNewOppWithOLI, List<Account> AccountWithRelatedOpportunities){

        if ( !createNewOppWithOLI.isEmpty() ){
            Opportunity NewOpp = new Opportunity(  );
            NewOpp.Name = 'New Extended Opportunity ';
            NewOpp.AccountId = AccountWithRelatedOpportunities[0].Id;
            NewOpp.StageName = 'Open';
            newOpp.CloseDate = system.today().addDays(10);
            NewOpp.Pricebook2Id = [select id, name
                                   from Pricebook2
                                   where name = 'Standard Price Book'].id;
            //NewOpp.CloseDate = System.today();
            NewOpp.OwnerId = AccountWithRelatedOpportunities[0].OwnerId;
            insert NewOpp;
            list<OpportunityLineItem> oppLineItem = new list<OpportunityLineItem>();


            if ( NewOpp.id != null ){
                for ( String SAPCodeStr : createNewOppWithOLI.keySet() ){
                    OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = NewOpp.Id, Quantity = createNewOppWithOLI.get(SAPCodeStr).Quantity, Product2Id = createNewOppWithOLI.get(SAPCodeStr).Product2Id, UnitPrice = createNewOppWithOLI.get(SAPCodeStr).UnitPrice);

                    oppLineItem.add(oli);
                }
                if ( !oppLineItem.isEmpty() ){
                    system.debug('oppLineItem' + oppLineItem);
                    Insert oppLineItem;
                }
            }
        }
    }

    public static void CreateNewClosedWonOpportunity(Map<String, orderItem> SAPCodeWithOrderItemList, List<Account> AccountWithRelatedOpportunities){

        list<OpportunityLineItem> oppLineItem = new list<OpportunityLineItem>();
        if ( !SAPCodeWithOrderItemList.isEmpty() ){
            Opportunity NewOpp = new Opportunity(  );
            NewOpp.Name = 'New Closed Won Opportunity ';
            NewOpp.AccountId = AccountWithRelatedOpportunities[0].Id;
            NewOpp.StageName = 'Open';
            NewOpp.CloseDate = system.today().addDays(10);
            NewOpp.Pricebook2Id = [select id, name
                                   from Pricebook2
                                   where name = 'Standard Price Book'].id;
            //NewOpp.CloseDate = System.today();
            NewOpp.OwnerId = AccountWithRelatedOpportunities[0].OwnerId;
            insert NewOpp;
            if ( NewOpp.id != null ){
                for ( String SAPCodeStr : SAPCodeWithOrderItemList.keySet() ){
                    OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = NewOpp.Id, Quantity = SAPCodeWithOrderItemList.get(SAPCodeStr).Quantity, Product2Id = SAPCodeWithOrderItemList.get(SAPCodeStr).Product2Id, UnitPrice = SAPCodeWithOrderItemList.get(SAPCodeStr).UnitPrice);

                    oppLineItem.add(oli);
                }
                if ( !oppLineItem.isEmpty() ){
                    system.debug('oppLineItem' + oppLineItem);
                    Insert oppLineItem;
                }
            }
        }
    }

    public static void AddOppLineItem_viaOrdlineItem_markasClosedWon(List<opportunity> opplist, map<Id, orderItem> orderitemwithAccount){

        try{

            list<OpportunityLineItem> oppLineItem = new list<OpportunityLineItem>();
            if ( !opplist.isEmpty() && !orderitemwithAccount.isEmpty() ){
                for ( orderItem ordLinItem : orderitemwithAccount.values() ){
                    OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opplist[0].Id, Quantity = ordLinItem.Quantity, Product2Id = ordLinItem.Product2Id, TotalPrice = ordLinItem.TotalPrice//UnitPrice=pro.MRP__c
                    );

                    oppLineItem.add(oli);
                }

                if ( !oppLineItem.isEmpty() ){
                    opportunity opp = new Opportunity(  );
                    opp.Id = opplist[0].Id;
                    opp.StageName = 'Closed Won';
                    update opp;
                    if ( opp.Id != null ){
                        insert oppLineItem;
                    }
                }
            }

        }
        catch ( Exception e ){
            System.debug('the error has occured due to ======> ' + e.getMessage() + ' at line number =====> ' + e.getLineNumber());
            System.debug('Error stack tarce =====> ' + e.getStackTraceString());
        }
    }

    public static void CreateOppAndOppLineItem_viaLineItem_MarkasCloasedWon(List<account> accountList, map<Id, orderItem> orderitemwithAccount){
        list<OpportunityLineItem> oppLineItem = new list<OpportunityLineItem>();

        try{
            if ( !accountList.isEmpty() ){
                Opportunity newOpp = new opportunity(  );
                newOpp.name = accountList[0].Name;
                NewOpp.StageName = 'Closed Won';
                NewOpp.CloseDate = system.today();
                NewOpp.AccountId = accountList[0].Id;
                NewOpp.Pricebook2Id = [select id, name
                                       from Pricebook2
                                       where name = 'Standard Price Book'].id;
                insert NewOpp;

                if ( NewOpp.Id != null ){
                    for ( orderItem ordLinItem : orderitemwithAccount.values() ){
                        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = NewOpp.Id, Quantity = ordLinItem.Quantity, Product2Id = ordLinItem.Product2Id, TotalPrice = ordLinItem.TotalPrice//UnitPrice=pro.MRP__c
                        );

                        oppLineItem.add(oli);
                    }
                    if ( !oppLineItem.isEmpty() ){
                        insert oppLineItem;
                    }
                }
               list<order> ordList = [Select id, Name From order where AccountId =: accountList[0].id order by CreatedDate DESC LIMIT 1];
               if (!ordList.isEmpty() && NewOpp.Id != null ) {
                order ord = new order();
                ord.id = ordList[0].Id;
                ord.opportunityId = NewOpp.Id;
                update ord;
               }
            }
        }
        catch(Exception e) {
            System.debug('the error has occured due to ======> ' + e.getMessage() + ' at line number =====> ' + e.getLineNumber());
            System.debug('Error stack tarce =====> ' + e.getStackTraceString());

        }
    }

}