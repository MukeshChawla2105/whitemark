@RestResource(urlMapping = '/orderDetailsSync')
global class WS_OrderDetailSync{
    global class Response extends WS_Response{
        public Response(){
        }

        public cls_order_response order_status;
    }

    @HttpPost
    global static Response getRespone(){
        RestRequest req = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        System.debug(req.requestBody);
        String jsonDataForJP = req.requestBody.toString();
        RequestStructure reqStructforJP = (RequestStructure)Json.deserialize(jsonDataForJP, RequestStructure.class);

        List<JSON_Payload__c> JPList = new List<JSON_Payload__c>();
        JSON_Payload__c JP = new JSON_Payload__c();
        JP.class_Name__c = 'WS_OrderDetailSync';
        JP.Payload_Request__c = jsonDataForJP;
        JPList.add(JP);
        if (!JPList.isEmpty()){
            insert JPList;
        }
        Response res = new Response();
        if (req == null || req.requestBody == null){
            res.status = 'Error';
            res.errorMessage = 'REQUEST_BODY_IS_NULL';
            res.statusCode = '400';
            return res;
        } else{
            String jsonData = req.requestBody.toString();
            RequestStructure franchisee_details = new RequestStructure();
            System.debug('jsonData::: ' + jsonData);
            RequestStructure reqStruct = (RequestStructure)Json.deserialize(jsonData, RequestStructure.class);
            System.debug('reqStruct:::' + reqStruct);
            if (reqStruct != null && reqStruct.order_details != null){
                if (reqStruct.order_details.customer_phone_number != null && reqStruct.order_details.customer_phone_number != ''){


                    List<Account> accList = new List<Account>();
                    List<Opportunity> oppList = new List<Opportunity>();
                    //accList = [SELECT Id,Name,OwnerId FROM Account WHERE Phone =:reqStruct.order_details.customer_phone_number ORDER BY CreatedDate DESC];

                    List<Lead> LeadList = [Select Id, Name, Email, Company, phone, ownerId, CreatedDate
                                           From Lead
                                           Where phone = :reqStruct.order_details.customer_phone_number AND IsConverted = false
                                           ORDER BY CreatedDate DESC
                                           LIMIT 1];

                    if (LeadList.size() > 0){
                        ConvertLeadAndCreateAccOppOrder.AccountAndOppwrapper accountOppWrap = ConvertLeadAndCreateAccOppOrder.convertLead(LeadList);
                        accList = accountOppWrap.convertedAcclist;
                        oppList = accountOppWrap.ConvertedoppList;
                    } else{
                        accList = [SELECT Id, Name, OwnerId
                                   FROM Account
                                   WHERE Phone = :reqStruct.order_details.customer_phone_number
                                   ORDER BY CreatedDate DESC];
                        if (accList.size() > 0){
                            oppList = [Select Id, name, StageName
                                       from Opportunity
                                       where AccountId = :accList[0].id And StageName != 'Closed Lost' And StageName != 'Closed Won'
                                       order By CreatedDate Desc
                                       LIMIT 1];
                        }

                    }

                    if (accList.size() > 0){
                        Pricebook2 standardBook = [SELECT Id
                                                   FROM Pricebook2
                                                   WHERE isStandard = true
                                                   LIMIT 1];
                        List<Pricebookentry> pbEntryList = new List<Pricebookentry>();
                        List<Pricebookentry> pbEntryInsertList = new List<Pricebookentry>();
                        Opportunity oppObj = new Opportunity();
                        oppObj.Name = accList[0].Name;
                        oppObj.AccountId = accList[0].Id;
                        oppObj.StageName = 'Closed Won';
                        oppObj.CloseDate = System.today();
                        oppObj.LeadSource = 'Rapidor';
                        oppObj.OwnerId = accList[0].OwnerId;
                        try{
                            //INSERT oppObj;
                        } catch (Exception e){
                            Execption__c ex = new Execption__c();
                            ex.Class_Name__c = 'WS_OrderDetailSync';
                            ex.Ececption_Message__c = e.getMessage() + '  ' + e.getCause() + '  ' + e.getLineNumber();
                            ex.Stack_Trace__c = e.getStackTraceString();
                            ex.Method_Name__c = 'execute';
                            Insert ex;

                        }
                        List<Franchisee__c> Franc = [SELECT id, Owner_Address__c, SAP_Code__c
                                                     FROM Franchisee__c
                                                     Where SAP_Code__c = :reqStruct.order_details.distributor_code];

                        Order orderObj = new Order();
                        orderObj.OwnerId = accList[0].OwnerId;
                        orderObj.accountId = accList[0].Id;
                        if (!oppList.isEmpty()){
                            orderObj.OpportunityId = oppList[0].Id;
                        }
                        orderObj.Pricebook2Id = standardBook.Id;
                        if (!Franc.isEmpty() && Franc.size() > 0){
                            orderObj.Franchisee__c = Franc[0].Id;
                        }
                        //if(Franc != Null)

                        if (reqStruct.order_details.delivery_option != null && reqStruct.order_details.delivery_option != '')
                            orderObj.Delivery_Option__c = reqStruct.order_details.delivery_option;
                        if (reqStruct.order_details.order_status != null && reqStruct.order_details.order_status != ''){
                            orderObj.Status = reqStruct.order_details.order_status;
                        } else{
                            orderObj.Status = 'Draft';
                        }
                        if (reqStruct.order_details.order_no != null && reqStruct.order_details.order_no != '')
                            orderObj.Rapidor_Order_Number__c = reqStruct.order_details.order_no;
                        if (reqStruct.order_details.created_by_name != null && reqStruct.order_details.created_by_name != '')
                            orderObj.Order_Created_By_Name__c = reqStruct.order_details.created_by_name;
                        if (reqStruct.order_details.source != null && reqStruct.order_details.source != '')
                            orderObj.Order_Source__c = reqStruct.order_details.source;
                        if (reqStruct.order_details.warehouse_id != null && reqStruct.order_details.warehouse_id != '')
                            orderObj.Warehouse__r = new Warehouse__c(SAP_Code__c = reqStruct.order_details.warehouse_id);
                        if (reqStruct.order_details.startdate != null && reqStruct.order_details.startdate != '')
                            orderObj.EffectiveDate = Date.parse(reqStruct.order_details.startdate);
                        if (reqStruct.order_details.order_type != null && reqStruct.order_details.order_type != '')
                            orderObj.Type = reqStruct.order_details.order_type;
                        if (reqStruct.order_details.region != null && reqStruct.order_details.region != '')
                            orderObj.Region__c = reqStruct.order_details.region;
                        if (reqStruct.order_details.order_offer_discounts != null && reqStruct.order_details.order_offer_discounts != '')
                            orderObj.Order_Offer_Discounts__c = Decimal.valueOf(reqStruct.order_details.order_offer_discounts);
                        if (reqStruct.order_details.orde_total_discounts != null && reqStruct.order_details.orde_total_discounts != '')
                            orderObj.Orde_Total_Discounts__c = Decimal.valueOf(reqStruct.order_details.orde_total_discounts);
                        if (reqStruct.order_details.order_scheme_discounts != null && reqStruct.order_details.order_scheme_discounts != '')
                            orderObj.Order_Scheme_Discounts__c = Decimal.valueOf(reqStruct.order_details.order_scheme_discounts);
                        if (reqStruct.order_details.order_bill_discounts != null && reqStruct.order_details.order_bill_discounts != '')
                            orderObj.Order_Bill_Discounts__c = Decimal.valueOf(reqStruct.order_details.order_bill_discounts);
                        if (reqStruct.order_details.grand_total_discount != null && reqStruct.order_details.grand_total_discount != '')
                            orderObj.Grand_Total_Discount__c = Decimal.valueOf(reqStruct.order_details.grand_total_discount);
                        if (reqStruct.order_details.service_charge != null && reqStruct.order_details.service_charge != '')
                            orderObj.Service_Charge__c = Decimal.valueOf(reqStruct.order_details.service_charge);
                        if (reqStruct.order_details.total_taxes != null && reqStruct.order_details.total_taxes != '')
                            orderObj.Total_Taxes__c = Decimal.valueOf(reqStruct.order_details.total_taxes);
                        if (reqStruct.order_details.total_paid != null && reqStruct.order_details.total_paid != '')
                            orderObj.Total_Paid__c = Decimal.valueOf(reqStruct.order_details.total_paid);
                        if (reqStruct.order_details.total != null && reqStruct.order_details.total != '')
                            orderObj.Total_Amount__c = Decimal.valueOf(reqStruct.order_details.total);
                        if (reqStruct.order_details.billing_address != null){
                            if (reqStruct.order_details.billing_address.billing_street != null && reqStruct.order_details.billing_address.billing_street != '')
                                orderObj.Billing_Street__c = reqStruct.order_details.billing_address.billing_street;
                            if (reqStruct.order_details.billing_address.billing_city != null && reqStruct.order_details.billing_address.billing_city != '')
                                orderObj.Billing_City__c = reqStruct.order_details.billing_address.billing_city;
                            if (reqStruct.order_details.billing_address.billing_postal_code != null && reqStruct.order_details.billing_address.billing_postal_code != '')
                                orderObj.Billing_Postal_Code__c = reqStruct.order_details.billing_address.billing_postal_code;
                            if (reqStruct.order_details.billing_address.billing_state != null && reqStruct.order_details.billing_address.billing_state != '')
                                orderObj.Billing_State__c = reqStruct.order_details.billing_address.billing_state;
                            if (reqStruct.order_details.billing_address.billing_country != null && reqStruct.order_details.billing_address.billing_country != '')
                                orderObj.Billing_Country__c = reqStruct.order_details.billing_address.billing_country;
                        }
                        if (reqStruct.order_details.shipping_address != null){
                            if (reqStruct.order_details.shipping_address.shipping_street != null && reqStruct.order_details.shipping_address.shipping_street != '')
                                orderObj.Shipping_Street__c = reqStruct.order_details.shipping_address.shipping_street;
                            if (reqStruct.order_details.shipping_address.shipping_city != null && reqStruct.order_details.shipping_address.shipping_city != '')
                                orderObj.Shipping_City__c = reqStruct.order_details.shipping_address.shipping_city;
                            if (reqStruct.order_details.shipping_address.shipping_postal_code != null && reqStruct.order_details.shipping_address.shipping_postal_code != '')
                                orderObj.Shipping_Postal_Code__c = reqStruct.order_details.shipping_address.shipping_postal_code;
                            if (reqStruct.order_details.shipping_address.shipping_state != null && reqStruct.order_details.shipping_address.shipping_state != '')
                                orderObj.Shipping_State__c = reqStruct.order_details.shipping_address.shipping_state;
                            if (reqStruct.order_details.shipping_address.shipping_country != null && reqStruct.order_details.shipping_address.shipping_country != '')
                                orderObj.Shipping_Country__c = reqStruct.order_details.shipping_address.shipping_country;
                        }
                        try{
                            INSERT orderObj;

                            if (reqStruct.order_details.order_line_items != null && reqStruct.order_details.order_line_items.size() > 0){
                                List<OrderItem> oliList = new List<OrderItem>();
                                Set<String> prodCodeSet = new Set<String>();
                                Map<String, Pricebookentry> pbMap = new Map<String, Pricebookentry>();
                                for (cls_order_line_items oli : reqStruct.order_details.order_line_items){
                                    prodCodeSet.add(oli.product_code);
                                }
                                pbEntryList = [SELECT Id, Product_SAP_Code__c
                                               FROM Pricebookentry
                                               WHERE Product_SAP_Code__c IN:prodCodeSet AND Pricebook2Id = :standardBook.Id];
                                for (Pricebookentry pbEntryObj : pbEntryList){
                                    System.debug(pbEntryObj.Product_SAP_Code__c);
                                    pbMap.put(pbEntryObj.Product_SAP_Code__c, pbEntryObj);
                                }
                                for (cls_order_line_items oli : reqStruct.order_details.order_line_items){
                                    if (!pbMap.keySet().contains(oli.product_code)){
                                        Pricebookentry pbEntryObj = new Pricebookentry();
                                        pbEntryObj.Product2 = new Product2(SAP_Code__c = oli.product_code);
                                        pbEntryObj.IsActive = true;
                                        pbEntryObj.Pricebook2Id = standardBook.Id;
                                        pbEntryObj.UnitPrice = decimal.valueOf(oli.unit_price);
                                        pbEntryInsertList.add(pbEntryObj);

                                        pbMap.put(oli.product_code, pbEntryObj);
                                    }
                                }
                                if (pbEntryInsertList.size() > 0)
                                    try{
                                        INSERT pbEntryInsertList;
                                } catch (Exception e){
                                    Execption__c ex = new Execption__c();
                                    ex.Class_Name__c = 'WS_OrderDetailSync';
                                    ex.Ececption_Message__c = e.getMessage() + '  ' + e.getCause() + '  ' + e.getLineNumber();
                                    ex.Stack_Trace__c = e.getStackTraceString();
                                    ex.Method_Name__c = 'execute';
                                    Insert ex;

                                }
                                for (cls_order_line_items oli : reqStruct.order_details.order_line_items){
                                    OrderItem oliobj = new OrderItem();
                                    oliobj.OrderId = orderObj.id;
                                    if (oli.quantity != null && oli.quantity != '')
                                        oliobj.Quantity = Decimal.valueOf(oli.quantity) > 0 ? Decimal.valueOf(oli.quantity) : 1;
                                    if (oli.unit_price != null && oli.unit_price != '')
                                        oliobj.UnitPrice = Decimal.valueOf(oli.unit_price);
                                    if (oli.bill_amount != null && oli.bill_amount != '')
                                        oliobj.Bill_Amount__c = Decimal.valueOf(oli.bill_amount);
                                    if (oli.coupon_code_discount != null && oli.coupon_code_discount != '')
                                        oliobj.Coupon_Discount__c = Decimal.valueOf(oli.coupon_code_discount);
                                    if (oli.item_discount != null && oli.item_discount != '')
                                        oliobj.Item_Discount__c = Decimal.valueOf(oli.item_discount);
                                    oliobj.PricebookEntryId = pbMap.get(oli.product_code).Id;
                                    if (oli.gst != null){
                                        if (oli.gst.gst_type != null && oli.gst.gst_type != '')
                                            oliobj.gsttype__c = oli.gst.gst_type;
                                        if (oli.gst.sgstPercentage != null && oli.gst.sgstPercentage != '')
                                            oliobj.sgst_Percentage__c = Decimal.valueOf(oli.gst.sgstPercentage);
                                        if (oli.gst.sgst != null && oli.gst.sgst != '')
                                            oliobj.sgst__c = Decimal.valueOf(oli.gst.sgst);
                                        if (oli.gst.sgstLedgerName != null && oli.gst.sgstLedgerName != '')
                                            oliobj.sgst_Ledger_Name__c = oli.gst.sgstLedgerName;
                                        if (oli.gst.igstPercentage != null && oli.gst.igstPercentage != '')
                                            oliobj.igst_Percentage__c = Decimal.valueOf(oli.gst.igstPercentage);
                                        if (oli.gst.igst != null && oli.gst.igst != '')
                                            oliobj.igst__c = Decimal.valueOf(oli.gst.igst);
                                        if (oli.gst.igstLedgerName != null && oli.gst.igstLedgerName != '')
                                            oliobj.igst_Ledger_Name__c = oli.gst.igstLedgerName;
                                        if (oli.gst.cgstPercentage != null && oli.gst.cgstPercentage != '')
                                            oliobj.cgst_Percentage__c = Decimal.valueOf(oli.gst.cgstPercentage);
                                        if (oli.gst.cgst != null && oli.gst.cgst != '')
                                            oliobj.cgst__c = Decimal.valueOf(oli.gst.cgst);
                                        if (oli.gst.cgstLedgerName != null && oli.gst.cgstLedgerName != '')
                                            oliobj.cgst_Ledger_Name__c = oli.gst.cgstLedgerName;
                                        if (oli.gst.cessPercentage != null && oli.gst.cessPercentage != '')
                                            oliobj.cess_Percentage__c = Decimal.valueOf(oli.gst.cessPercentage);
                                        if (oli.gst.cess != null && oli.gst.cess != '')
                                            oliobj.cess__c = Decimal.valueOf(oli.gst.cess);
                                        if (oli.gst.cessLedgerName != null && oli.gst.cessLedgerName != '')
                                            oliobj.cess_Ledger_Name__c = oli.gst.cessLedgerName;
                                    }
                                    oliList.add(oliobj);
                                }
                                if (oliList.size() > 0)
                                    try{
                                        INSERT oliList;
                                } catch (Exception e){
                                    Execption__c ex = new Execption__c();
                                    ex.Class_Name__c = 'WS_OrderDetailSync';
                                    ex.Ececption_Message__c = e.getMessage() + '  ' + e.getCause() + '  ' + e.getLineNumber();
                                    ex.Stack_Trace__c = e.getStackTraceString();
                                    ex.Method_Name__c = 'execute';
                                    Insert ex;

                                }

                            }
                        } catch (Exception e){
                            Execption__c ex = new Execption__c();
                            ex.Class_Name__c = 'WS_OrderDetailSync';
                            ex.Ececption_Message__c = e.getMessage() + '  ' + e.getCause() + '  ' + e.getLineNumber();
                            ex.Stack_Trace__c = e.getStackTraceString();
                            ex.Method_Name__c = 'execute';
                            Insert ex;

                        }

                        cls_order_response order_status = new cls_order_response();
                        order_status.sf_id = orderObj.id;
                        res.order_status = order_status;
                    } else{
                        res.status = 'Error';
                        res.errorMessage = 'No customer found with phone number as: ' + reqStruct.order_details.customer_phone_number;
                        res.successMessage = '';
                        res.statusCode = '400';
                        RETURN res;
                    }
                } else{
                    res.status = 'Error';
                    res.errorMessage = 'Customer phone can not be empty';
                    res.successMessage = '';
                    res.statusCode = '400';
                    RETURN res;
                }

            } else{
                res.status = 'Error';
                res.errorMessage = 'Order details can not be empty';
                res.successMessage = '';
                res.statusCode = '400';
                RETURN res;
            }
        }
        RETURN res;
    }

    public class RequestStructure{
        public cls_order_details order_details;
    }

    class cls_order_details{
        public String customer_phone_number;
        public String delivery_option;
        public String order_status;
        public String delivery_person_code;
        public String order_no;
        public String created_by_name;
        public String source;
        public String warehouse_id;
        public String distributor_code;
        public String startdate;
        public String order_type;
        public String partner_code;
        public String region;
        public cls_shipping_address shipping_address;
        public cls_billing_address billing_address;
        public String order_offer_discounts;
        public String orde_total_discounts;
        public String order_scheme_discounts;
        public String order_bill_discounts;
        public String grand_total_discount;
        public String service_charge;
        public String total_taxes;
        public String total;
        public String total_paid;
        public cls_order_line_items[] order_line_items;
    }

    class cls_shipping_address{
        public String shipping_street;
        public String shipping_city;
        public String shipping_postal_code;
        public String shipping_state;
        public String shipping_country;
    }

    class cls_billing_address{
        public String billing_street;
        public String billing_city;
        public String billing_postal_code;
        public String billing_state;
        public String billing_country;
    }

    class cls_order_line_items{
        public String product_code;
        public String quantity;
        public String unit_price;
        public String coupon_code_availed;
        public String coupon_code_discount;
        public String item_discount;
        public String bill_amount;
        public cls_gst gst;
    }

    class cls_gst{
        public String gst_type;
        public String sgstPercentage;
        public String sgst;
        public String sgstLedgerName;
        public String igstPercentage;
        public String igst;
        public String igstLedgerName;
        public String cgstPercentage;
        public String cgst;
        public String cgstLedgerName;
        public String cessPercentage;
        public String cess;
        public String cessLedgerName;
    }

    class cls_order_response{
        public String sf_id;

    }

}