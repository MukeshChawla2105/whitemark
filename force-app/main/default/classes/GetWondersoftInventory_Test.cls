@isTest
public class GetWondersoftInventory_Test {
    @testSetup 
    static void setup() {
        Endpoints__C msg= new Endpoints__C();
        msg.EndpointURL__c='http://13.71.71.137:7777/eShopaidService/eShopaidService.svc/Token';
        msg.Name='WondersoftToken';
        msg.User_Name__c='Sample';
        msg.Password__c='Sample';
        msg.Service_MethodName__c='GetToken';
        
        insert msg;
        
        Endpoints__C msg1= new Endpoints__C();
        msg1.EndpointURL__c='http://13.71.71.137:7777/eShopaidService/eShopaidService.svc/ProcessData';
        msg1.Name='WondersoftInventoryData';
        msg1.Service_MethodName__c='GetInventory';
        
        insert msg1;
        
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        
        Update standardPricebook;
        
        Product2 prod=new Product2();
        prod.IsActive=true;
        prod.MRP__c=100;
        prod.Description='Sample';
        prod.Name='Sample';
        Prod.SAP_Code__c='SUJ-015M000C000S319';
        prod.ProductCode='SUJ-015M000C000S319';
        
        Insert prod;
        
        Franchisee__c fr=new Franchisee__c();
        fr.Name='KL02-010';
        fr.SAP_Code__c='KL02-010';
        
        insert fr;
        
        
    }
    static testmethod void testQueueable() {
        JSONFranchiseeInventory parsedJSON= new JSONFranchiseeInventory();
        String jsonBody= '{"Response":{"Result":"SUCCESS","Data":{"Inventory":[{"Location":"KL01-009","Items":null},{"Location":"KL02-010","Items":{"Item":{"ProductCode":"34358","EANCode":null,"ItemCode":"SUJ-015M000C000S319","ItemName":"SUJATHA JUICER POWERMATIC PLUS","BatchDescription":null,"ExpiryDate":null,"MRP":"6057.000","Stock":"1.000","StockUOM":null}}},{"Location":"KL03-004","Items":{"Item":[{"ProductCode":"40599","EANCode":null,"ItemCode":"PIG-024M000C000S001","ItemName":"PIGEON SANITIZER DISPENSER STAND-M","BatchDescription":null,"ExpiryDate":null,"MRP":"845.000","Stock":"4.000","StockUOM":null},{"ProductCode":"40733","EANCode":null,"ItemCode":"LAN-052M088C000S013","ItemName":"LANZ LED 24 Z2400 0720","BatchDescription":null,"ExpiryDate":null,"MRP":"12690.000","Stock":"5.000","StockUOM":null}]}}]}}}';
        jsonBody= jsonBody.replace('"Items":{"Item":{','"Items_Z":{"Item":{');
        parsedJSON=JSONFranchiseeInventory.parse(jsonBody);
        
        Test.setMock(HttpCalloutMock.class, new WSInventoryCalloutMock());
        
        Test.startTest();  
        system.enqueueJob(New GetWondersoftInventory('2020-08-19','2020-08-19'));
        system.enqueueJob(New ProcessWSFranchiseeData(parsedJSON));
        system.enqueueJob(New ProcessWSInventoryData(parsedJSON));
        Test.stopTest(); 
        
    }
    
}