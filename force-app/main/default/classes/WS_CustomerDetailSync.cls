@RestResource(urlMapping='/customerDetailsSync')
global class WS_CustomerDetailSync {
    global class Response extends WS_Response{
        public Response(){}
        public List<cls_customer_response> customer_status;
    }
    @HttpPost
    global static Response getRespone(){
        List<Account> accList = new List<Account>();
        List<Account> accFinalList = new List<Account>();
        Set<String> phoneSet = new Set<String>();
        Map<String,Id> accPhoneMap = new Map<String,Id>();
        RestRequest req      = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        Response res         = new Response();
        if(req == null || req.requestBody == null){
            res.status          = 'Error';
            res.errorMessage    = 'REQUEST_BODY_IS_NULL';
            res.statusCode      = '400';
            return res;
        }else{
            String jsonData     = req.requestBody.toString();
            RequestStructure franchisee_details = new RequestStructure();
            RequestStructure reqStruct=(RequestStructure)Json.deserialize(jsonData, RequestStructure.class);
            if(reqStruct != null && reqStruct.customer_details != null && reqStruct.customer_details.size() > 0){
                for(cls_customer_details custObj: reqStruct.customer_details){
                    if(custObj.customer_phone_number != null && custObj.customer_phone_number != '')
                        phoneSet.add(custObj.customer_phone_number);
                }
                if(phoneSet.size() > 0){
                    accList = [SELECT Id,Phone FROM Account WHERE Phone IN :phoneSet];
                    for(Account accObj : accList){
                        accPhoneMap.put(accObj.Phone,accObj.Id);
                    }
                }
                for(cls_customer_details custObj: reqStruct.customer_details){
                    Account accObj = new Account();
                    if(custObj.customer_phone_number != null && custObj.customer_phone_number != ''){
                        accObj.Phone = custObj.customer_phone_number;
                        accObj.Id = accPhoneMap.get(custObj.customer_phone_number);
                    }
                    if(custObj.customer_first_name != null && custObj.customer_first_name != '')
                        accObj.FirstName = custObj.customer_first_name;
                    //if(custObj.customer_last_name != null){
                        if(custObj.customer_last_name != '' && custObj.customer_last_name != null)
                            accObj.lastName = custObj.customer_last_name;
                        else if(accObj.Id == null && custObj.customer_first_name != null && custObj.customer_first_name != '')
                            accObj.lastName = custObj.customer_first_name;
                    //}
                        
                    if(custObj.alternate_phone != null && custObj.alternate_phone != '')
                        accObj.Alternate_Phone__c = custObj.alternate_phone;
                    if(custObj.gender != null && custObj.gender != '')
                        accObj.Gender__pc = custObj.gender;
                    if(custObj.email != null && custObj.email != '')
                        accObj.PersonEmail = custObj.email;
                    if(custObj.reward_point != null && custObj.reward_point != '')
                        accObj.Reward_Point__c = Decimal.valueOf(custObj.reward_point);
                    if(custObj.franchisee_code != null && custObj.franchisee_code != '')
                        accObj.Franchisee__r = new Franchisee__c(SAP_Code__c = custObj.franchisee_code);
                    if(custObj.billing_address != null){
                        if(custObj.billing_address.billing_street != null && custObj.billing_address.billing_street != '')
                            accObj.BillingStreet = custObj.billing_address.billing_street;
                        if(custObj.billing_address.billing_city != null && custObj.billing_address.billing_city != '')
                            accObj.BillingCity = custObj.billing_address.billing_city;
                        if(custObj.billing_address.billing_postal_code != null && custObj.billing_address.billing_postal_code != '')
                            accObj.BillingPostalCode = custObj.billing_address.billing_postal_code;
                        if(custObj.billing_address.billing_state != null && custObj.billing_address.billing_state != '')
                            accObj.BillingState = custObj.billing_address.billing_state;
                        if(custObj.billing_address.billing_country != null && custObj.billing_address.billing_country != '')
                            accObj.BillingCountry = custObj.billing_address.billing_country;
                    }
                    if(custObj.mailing_address != null){
                        if(custObj.mailing_address.mailing_street != null && custObj.mailing_address.mailing_street != '')
                            accObj.ShippingStreet = custObj.mailing_address.mailing_street;
                        if(custObj.mailing_address.mailing_city != null && custObj.mailing_address.mailing_city != '')
                            accObj.ShippingCity = custObj.mailing_address.mailing_city;
                        if(custObj.mailing_address.mailing_postal_code != null && custObj.mailing_address.mailing_postal_code != '')
                            accObj.ShippingPostalCode = custObj.mailing_address.mailing_postal_code;
                        if(custObj.mailing_address.mailing_state != null && custObj.mailing_address.mailing_state != '')
                            accObj.ShippingState = custObj.mailing_address.mailing_state;
                        if(custObj.mailing_address.mailing_country != null && custObj.mailing_address.mailing_country != '')
                            accObj.ShippingCountry = custObj.mailing_address.mailing_country;
                    }
                    accFinalList.add(accObj);
                }
                UPSERT accFinalList;
                res.customer_status = new List<cls_customer_response>();
                for(Account accObj : accFinalList){
                    cls_customer_response resStatusObj = new cls_customer_response();
                    resStatusObj.sf_id = accObj.Id;
                    if(accPhoneMap.get(accObj.Phone) != null){
                        resStatusObj.identified_customer_type = 'Existing Customer';
                    }
                    else
                        resStatusObj.identified_customer_type = 'New Customer';
                    res.customer_status.add(resStatusObj);
                }
            }
            else{
                res.status          = 'Error';
                res.errorMessage    = 'Customer details can not be empty'; 
                res.successMessage  = '';
                res.statusCode      = '400';
                RETURN res;
            }
        }
        RETURN res;
    }
    public class RequestStructure{
        public List<cls_customer_details> customer_details;
    }
    class cls_customer_details {
		public String customer_phone_number;	//
		public String customer_first_name;	//
		public String customer_last_name;	//
		public String alternate_phone;	//
		public String gender;	//
		public String email;	//
		public String reward_point;	//
        public String franchisee_code;	//
		public cls_mailing_address mailing_address;
		public cls_billing_address billing_address;
	}
	class cls_mailing_address {
		public String mailing_street;	//
		public String mailing_city;	//
		public String mailing_postal_code;	//
		public String mailing_state;	//
		public String mailing_country;	//
	}
	class cls_billing_address {
		public String billing_street;	//
		public String billing_city;	//
		public String billing_postal_code;	//
		public String billing_state;	//
		public String billing_country;	//
	}
    class cls_customer_response {
        public String sf_id;
        public String identified_customer_type;
    }
}