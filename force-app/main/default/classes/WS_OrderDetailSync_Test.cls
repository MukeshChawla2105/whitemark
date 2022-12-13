@isTest
public class WS_OrderDetailSync_Test {
    @isTest
    public static void testMethod1(){
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.Phone = '9786543210';
        INSERT accObj;
        
        Franchisee__c franObj=new  Franchisee__c();
        franObj.SAP_Code__c =  'kl09-007';
        INSERT franObj;
        
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        UPDATE standardPricebook;
        
        Product2 prod=new Product2();
        prod.IsActive=true;
        prod.Description='Test';
        prod.Name='Test';
        Prod.SAP_Code__c='sag-022m209c482s157';
        prod.ProductCode='sag-022m209c482s157';
        
        INSERT prod;
        
        String jsonString = '{ "order_details": { "customer_phone_number": "9786543210", "delivery_option": "Franchisee", "order_status": "Success", "delivery_person_code": "", "order_no": "LANORD002", "created_by_name": "lanmark", "source": "rapidor", "warehouse_id": "", "distributor_code": "KL09-007", "startdate": "21/10/2021", "order_type": "non_d2h", "partner_code": "a546789", "region": "Kannur", "shipping_address": { "shipping_street": "Fort Road", "shipping_city": "Kannur", "shipping_postal_code": "670006", "shipping_state": "Kerala", "shipping_country": "India" }, "billing_address": { "billing_street": "Fort Road", "billing_city": "Kannur", "billing_postal_code": "670006", "billing_state": "Kerala", "billing_country": "India" }, "order_offer_discounts": "0", "orde_total_discounts": "0", "order_scheme_discounts": "0", "order_bill_discounts": "0", "grand_total_discount": "0", "service_charge": "0", "total_taxes": "6781.26", "total": "31000", "total_paid": "0", "order_line_items": [ { "product_code": "SAG-022M209C482S157", "quantity": "1", "unit_price": "24217", "coupon_code_availed": "", "coupon_code_discount": "", "item_discount": "0", "bill_amount": "31000", "gst": { "gst_type": "non-igst", "sgstPercentage": "14", "sgst": "3390.63", "sgstLedgerName": "sgstLedgerName", "igstPercentage": "1", "igst": "2", "igstLedgerName": "igstLedgerName", "cgstPercentage": "14", "cgst": "3390.63", "cgstLedgerName": "cgstLedgerName", "cessPercentage": "3", "cess": "8", "cessLedgerName": "cessLedgerName" } } ] } }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/orderDetailsSync';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        WS_OrderDetailSync.getRespone();
    }
    @isTest
    public static void caseTest_1(){
        String jsonString = '{ "order_details": null}';
        Restrequest req = new Restrequest();
        req.requestURI = '/services/apexrest/orderDetailsSync';
        req.httpMethod = 'Post';
        RestContext.request = req;
        req.requestBody = Blob.valueOf(jsonString);
        WS_OrderDetailSync.getRespone();
    }
}