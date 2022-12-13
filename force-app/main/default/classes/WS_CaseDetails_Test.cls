@isTest
public class WS_CaseDetails_Test{
    @isTest
    public static void caseTest(){
        Franchisee__c franObj=new  Franchisee__c();
        franObj.SAP_Code__c =  'kl07-050';
        INSERT franObj;
        
        String jsonString = '{ "case_details": { "sf_id": "", "customer_phone_number": "1234567890", "customer_email": "", "case_subject": "Test_Subject_2", "priority": "High", "type": "Demo", "case_reason": "New problem", "franchisee_code": "KL07-050", "complaint_details": "Test_Comp_Details_1", "complaint_close_date": "", "product_code": "", "case_status": "On Hold", "quantity": "112", "brand": "Test Brand_1" } }';
        Restrequest req = new Restrequest();
        req.requestURI = 'services/apexrest/caseDetails';
        req.httpMethod = 'Post';
        RestContext.request = req;
        req.requestBody = Blob.valueOf(jsonString);
        WS_CaseDetails.getRespone(); 
    }
    @isTest
    public static void caseTest_1(){
        String jsonString = '{ "case_details": null}';
        Restrequest req = new Restrequest();
        req.requestURI = 'services/apexrest/caseDetails';
        req.httpMethod = 'Post';
        RestContext.request = req;
        req.requestBody = Blob.valueOf(jsonString);
        WS_CaseDetails.getRespone(); 
    }
}