@RestResource(urlMapping='/caseDetails')
global class WS_CaseDetails {
    global class Response extends WS_Response{
        public Response(){}
        public cls_case_response case_registration_status;
    }
    @HttpPost
    global static Response getRespone(){
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
            cls_case_response case_registration_status = new cls_case_response();
            res.case_registration_status = case_registration_status;
            if(reqStruct != null && reqStruct.case_details != null){
                Case caseObj = new Case();
                case_registration_status.identified_customer_type = 'Existing Customer';
                if(reqStruct.case_details.sf_id != null && reqStruct.case_details.sf_id != ''){
                    caseObj.Id = reqStruct.case_details.sf_id;   
                    //case_registration_status.identified_customer_type = 'Existing Customer';
                }
                else{
                    List<Account> accList = new List<Account>();
                    accList = [SELECT Id FROM Account WHERE Phone =:reqStruct.case_details.customer_phone_number ORDER By CreatedDate DESC];
                    if(accList.size() > 0){
                        caseObj.AccountId = accList[0].Id;
                    }
                    //case_registration_status.identified_customer_type = 'New Customer';
                }
                if(reqStruct.case_details.case_subject != null && reqStruct.case_details.case_subject != '')
                    caseObj.Subject = reqStruct.case_details.case_subject;
                if(reqStruct.case_details.priority != null && reqStruct.case_details.priority != '')
                    caseObj.priority = reqStruct.case_details.priority;
                if(reqStruct.case_details.type != null && reqStruct.case_details.type != '')
                    caseObj.type = reqStruct.case_details.type;
                if(reqStruct.case_details.case_reason != null && reqStruct.case_details.case_reason != '')
                    caseObj.Reason = reqStruct.case_details.case_reason;
                if(reqStruct.case_details.franchisee_code != null && reqStruct.case_details.franchisee_code != '')
                    caseObj.Franchisee_Name__r = new Franchisee__c(SAP_Code__c = reqStruct.case_details.franchisee_code);
                if(reqStruct.case_details.complaint_details != null && reqStruct.case_details.complaint_details != '')
                    caseObj.Complaint_Details__c = reqStruct.case_details.complaint_details;
                if(reqStruct.case_details.complaint_close_date != null && reqStruct.case_details.complaint_close_date != '')
                    caseObj.Status = 'Completed';
                if(reqStruct.case_details.product_code != null && reqStruct.case_details.product_code != '')
                    caseObj.Product__r = new Product2(SAP_Code__c = reqStruct.case_details.product_code);
                if(reqStruct.case_details.case_status != null && reqStruct.case_details.case_status != '')
                    caseObj.Status = reqStruct.case_details.case_status;
                if(reqStruct.case_details.quantity != null && reqStruct.case_details.quantity != '')
                    caseObj.Quantity__c = Decimal.valueOf(reqStruct.case_details.quantity);
                if(reqStruct.case_details.brand != null && reqStruct.case_details.brand != '')
                    caseObj.Brand__c = reqStruct.case_details.brand;
                UPSERT caseObj;
                case_registration_status.sf_id = caseObj.Id;
            }
            else{
                res.status          = 'Error';
                res.errorMessage    = 'Case details can not be empty'; 
                res.successMessage  = '';
                res.statusCode      = '400';
                RETURN res;
            }
        }
        
        RETURN res;
    }
    public class RequestStructure{
        public cls_case_details case_details;
    }
    class cls_case_details {
		public String sf_id;
		public String customer_phone_number;
		public String customer_email;
		public String case_subject;
		public String priority;
		public String type;
		public String case_reason;
		public String franchisee_code;
		public String complaint_details;
		public String complaint_close_date;
		public String product_code;
		public String case_status;
		public String quantity;
		public String brand;
	}
    class cls_case_response {
        public String sf_id;
        public String identified_customer_type;
    }
}