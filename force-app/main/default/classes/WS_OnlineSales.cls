@RestResource(urlMapping='/onlineSales')
global class WS_OnlineSales {
    global class Response extends WS_Response{
        public Response(){}
        public cls_sales_response sales_status;
    }
    @HttpPost
    global static Response getRespone(){
        List<Account> accList = new List<Account>();
        RestRequest req      = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        System.debug(req.requestBody);
        Response res         = new Response();
        if(req == null || req.requestBody == null){
            res.status          = 'Error';
            res.errorMessage    = 'REQUEST_BODY_IS_NULL';
            res.statusCode      = '400';
            return res;
        }else{
            String jsonData     = req.requestBody.toString();
            RequestStructure franchisee_details = new RequestStructure();
            System.debug('jsonData::: ' + jsonData);
            RequestStructure reqStruct=(RequestStructure)Json.deserialize(jsonData, RequestStructure.class);
            System.debug('reqStruct:::'+reqStruct);
            if(reqStruct != null && reqStruct.customer_details != null){
                Account accObj = new Account();
                if(reqStruct.customer_details.customer_phone_number != null && reqStruct.customer_details.customer_phone_number != ''){
                    accObj.Phone = reqStruct.customer_details.customer_phone_number;
                    accList = [SELECT Id FROM Account WHERE Phone =: reqStruct.customer_details.customer_phone_number];
                    if(accList.size() > 0)
                        accObj.Id = accList[0].Id;
                }
                if(reqStruct.customer_details.customer_first_name != null && reqStruct.customer_details.customer_first_name != '')
                    accObj.FirstName = reqStruct.customer_details.customer_first_name;
                if(reqStruct.customer_details.customer_last_name != null && reqStruct.customer_details.customer_last_name != '')
                    accObj.lastName = reqStruct.customer_details.customer_last_name;
                if(reqStruct.customer_details.alternate_phone != null && reqStruct.customer_details.alternate_phone != '')
                    accObj.Alternate_Phone__c = reqStruct.customer_details.alternate_phone;
                if(reqStruct.customer_details.gender != null && reqStruct.customer_details.gender != '')
                    accObj.Gender__pc = reqStruct.customer_details.gender;
                if(reqStruct.customer_details.email != null && reqStruct.customer_details.email != '')
                    accObj.PersonEmail = reqStruct.customer_details.email;
                if(reqStruct.customer_details.reward_point != null && reqStruct.customer_details.reward_point != '')
                    accObj.Reward_Point__c = Decimal.valueOf(reqStruct.customer_details.reward_point);
                if(reqStruct.customer_details.customer_feedback != null && reqStruct.customer_details.customer_feedback != '')
                    accObj.Customer_Feedback__c = reqStruct.customer_details.customer_feedback;
                if(reqStruct.customer_details.feegdback_comments != null && reqStruct.customer_details.feegdback_comments != '')
                    accObj.Feedback_Comments__c = reqStruct.customer_details.feegdback_comments;
                if(reqStruct.customer_details.delivery_option != null && reqStruct.customer_details.delivery_option != '')
                    accObj.Delivery_Option__c = reqStruct.customer_details.delivery_option;
                if(reqStruct.customer_details.billing_address != null){
                    if(reqStruct.customer_details.billing_address.billing_street != null && reqStruct.customer_details.billing_address.billing_street != '')
                        accObj.BillingStreet = reqStruct.customer_details.billing_address.billing_street;
                    if(reqStruct.customer_details.billing_address.billing_city != null && reqStruct.customer_details.billing_address.billing_city != '')
                        accObj.BillingCity = reqStruct.customer_details.billing_address.billing_city;
                    if(reqStruct.customer_details.billing_address.billing_postal_code != null && reqStruct.customer_details.billing_address.billing_postal_code != '')
                        accObj.BillingPostalCode = reqStruct.customer_details.billing_address.billing_postal_code;
                    if(reqStruct.customer_details.billing_address.billing_state != null && reqStruct.customer_details.billing_address.billing_state != '')
                        accObj.BillingState = reqStruct.customer_details.billing_address.billing_state;
                    if(reqStruct.customer_details.billing_address.billing_country != null && reqStruct.customer_details.billing_address.billing_country != '')
                        accObj.BillingCountry = reqStruct.customer_details.billing_address.billing_country;
                }
                if(reqStruct.customer_details.mailing_address != null){
                    if(reqStruct.customer_details.mailing_address.mailing_street != null && reqStruct.customer_details.mailing_address.mailing_street != '')
                        accObj.ShippingStreet = reqStruct.customer_details.mailing_address.mailing_street;
                    if(reqStruct.customer_details.mailing_address.mailing_city != null && reqStruct.customer_details.mailing_address.mailing_city != '')
                        accObj.ShippingCity = reqStruct.customer_details.mailing_address.mailing_city;
                    if(reqStruct.customer_details.mailing_address.mailing_postal_code != null && reqStruct.customer_details.mailing_address.mailing_postal_code != '')
                        accObj.ShippingPostalCode = reqStruct.customer_details.mailing_address.mailing_postal_code;
                    if(reqStruct.customer_details.mailing_address.mailing_state != null && reqStruct.customer_details.mailing_address.mailing_state != '')
                        accObj.ShippingState = reqStruct.customer_details.mailing_address.mailing_state;
                    if(reqStruct.customer_details.mailing_address.mailing_country != null && reqStruct.customer_details.mailing_address.mailing_country != '')
                        accObj.ShippingCountry = reqStruct.customer_details.mailing_address.mailing_country;
                }
                try{
                    UPSERT accObj;  
                }
                catch(Exception e){
                    System.debug(e.getMessage());
                    if(e.getMessage().contains('DUPLICATES_DETECTED')){
                        res.status          = 'Error';
                        res.errorMessage    = 'Duplicate account detected with respect to phone, alternate phone or email!'; 
                        res.successMessage  = '';
                        res.statusCode      = '400';   
                    }
                    else{
                        res.status          = 'Error';
                        res.errorMessage    = 'Some error occured!'; 
                        res.successMessage  = '';
                        res.statusCode      = '400';
                    }
                    RETURN res;
                }
                if(reqStruct.customer_details.order_details != null){
                    Order orderObj = new Order();
                    List<Pricebook2> pbList = new List<Pricebook2>();
                    List<Pricebookentry> pbEntryList = new List<Pricebookentry>();
                    List<Pricebookentry> pbEntryInsertList = new List<Pricebookentry>();
                    pbList = [SELECT Id FROM Pricebook2 WHERE isStandard = true];
                    orderObj.accountId = accObj.Id;
                    orderObj.Pricebook2Id = pbList[0].Id;
                    //orderObj.ContractId = accObj.Id;
                    if(reqStruct.customer_details.order_details.order_status != null && reqStruct.customer_details.order_details.order_status != '')
                        orderObj.Status = reqStruct.customer_details.order_details.order_status;
                    if(reqStruct.customer_details.order_details.order_date != null && reqStruct.customer_details.order_details.order_date != '')
                        orderObj.EffectiveDate = Date.parse(reqStruct.customer_details.order_details.order_date);
                    if(reqStruct.customer_details.order_details.franchisee_code != null && reqStruct.customer_details.order_details.franchisee_code != '')
                        orderObj.Franchisee__r = new Franchisee__c(SAP_Code__c = reqStruct.customer_details.order_details.franchisee_code);
                    if(reqStruct.customer_details.order_details.total_tax != null && reqStruct.customer_details.order_details.total_tax != '')
                        orderObj.Total_Taxes__c = Decimal.valueOf(reqStruct.customer_details.order_details.total_tax);
                    INSERT orderObj; 
                    if(reqStruct.customer_details.order_details.order_line_items != null && reqStruct.customer_details.order_details.order_line_items.size() > 0){
                        List<OrderItem> oliList = new List<OrderItem>();
                        Set<String> prodCodeSet = new Set<String>();
                        Map<String,Pricebookentry> pbMap = new Map<String,Pricebookentry>();
                        for(cls_order_line_items oli : reqStruct.customer_details.order_details.order_line_items){
                            prodCodeSet.add(oli.product_code);
                        }
                        pbEntryList = [SELECT Id,Product_SAP_Code__c FROM Pricebookentry WHERE Product_SAP_Code__c IN:prodCodeSet AND Pricebook2Id = :pbList[0].Id];
                        for(Pricebookentry pbEntryObj : pbEntryList){
                            System.debug(pbEntryObj.Product_SAP_Code__c);
                            pbMap.put(pbEntryObj.Product_SAP_Code__c,pbEntryObj);
                        }
                        for(cls_order_line_items oli : reqStruct.customer_details.order_details.order_line_items){
                            if(!pbMap.keySet().contains(oli.product_code)){
                                Pricebookentry pbEntryObj = new Pricebookentry();
                                pbEntryObj.Product2 = new Product2(SAP_Code__c = oli.product_code);
                                pbEntryObj.IsActive = true;
                                pbEntryObj.Pricebook2Id = pbList[0].Id;
                                pbEntryObj.UnitPrice = decimal.valueOf(oli.unit_price);
                                pbEntryInsertList.add(pbEntryObj);
                                
                                pbMap.put(oli.product_code,pbEntryObj);
                            }
                        }
                        if(pbEntryInsertList.size() > 0)
                            INSERT pbEntryInsertList;
                        for(cls_order_line_items oli : reqStruct.customer_details.order_details.order_line_items){
                            OrderItem oliobj = new OrderItem(); 
                            oliobj.OrderId = orderObj.id; 
                            oliobj.PricebookEntryId = pbMap.get(oli.product_code).Id;
                            if(oli.product_code != null && oli.product_code != '')
                                oliobj.Product2 = new Product2(SAP_Code__c = oli.product_code);
                            if(oli.qyantity != null && oli.qyantity != '')
                                oliobj.Quantity = Decimal.valueOf(oli.qyantity);
                            if(oli.unit_price != null && oli.unit_price != '')
                                oliobj.UnitPrice = Decimal.valueOf(oli.unit_price);
                            if(oli.coupon_code_availed != null && oli.coupon_code_availed != '')
                                oliobj.Coupon_Code__c = oli.coupon_code_availed;
                            if(oli.coupon_code_discount != null && oli.coupon_code_discount != '')
                                oliobj.Coupon_Discount__c = Decimal.valueOf(oli.coupon_code_discount);
                            if(oli.tax != null && oli.tax != '')
                                oliobj.Tax__c = Decimal.valueOf(oli.tax);
                            oliList.add(oliobj);
                        }
                        INSERT oliList;
                    }
                }
                cls_sales_response salesResObj = new cls_sales_response();
                salesResObj.sf_id = accObj.Id;
                salesResObj.sales_person = '';
                if(accList.size() > 0)
                    salesResObj.identified_customer_type = 'Existing Customer';
                    else
                    salesResObj.identified_customer_type = 'New Customer';
                res.sales_status = salesResObj;
               }
            else{
                res.status          = 'Error';
                res.errorMessage    = 'Sales details can not be empty'; 
                res.successMessage  = '';
                res.statusCode      = '400';
                RETURN res;
            }
        }
        RETURN res;
    }
    public class RequestStructure{
    	public cls_customer_details customer_details;
    }
    class cls_customer_details {
		public String customer_phone_number;
		public String customer_first_name;
		public String customer_last_name;
		public String alternate_phone;
		public String gender;
		public String email;
		public String reward_point;
		public String customer_feedback;
		public String feegdback_comments;
		public String delivery_option;
		public cls_mailing_address mailing_address;
		public cls_billing_address billing_address;
		public cls_order_details order_details;
	}
	class cls_mailing_address {
		public String mailing_street;
		public String mailing_city;
		public String mailing_postal_code;
		public String mailing_state;
		public String mailing_country;
	}
	class cls_billing_address {
		public String billing_street;
		public String billing_city;
		public String billing_postal_code;
		public String billing_state;
		public String billing_country;
	}
	class cls_order_details {
		public String order_status;
		public String franchisee_code;
		public String order_date;
		public String total_value;
		public String total_tax;
		public List<cls_order_line_items> order_line_items;
	}
	class cls_order_line_items {
		public String product_code;
		public String qyantity;
		public String unit_price;
		public String coupon_code_availed;
		public String coupon_code_discount;
		public String value;
        public String tax;
    }
    class cls_sales_response {
        public String sf_id;
        public String identified_customer_type;
        public String sales_person;
    }
}