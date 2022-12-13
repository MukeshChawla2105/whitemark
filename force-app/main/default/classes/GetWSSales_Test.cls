@isTest
public class GetWSSales_Test {
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
        msg1.Name='WondersoftPullSales';
        msg1.Service_MethodName__c='PullSales';
        
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
        Prod.SAP_Code__c='PRE-018M000C000S305';
        prod.ProductCode='PRE-018M000C000S305';
        
        Insert prod;
        
        Franchisee__c fr=new Franchisee__c();
        fr.Name='KL02-010';
        fr.SAP_Code__c='KL02-010';
        
        insert fr;
        
        List<RecordType > RT= [SELECT DeveloperName,Id,SobjectType FROM RecordType WHERE DeveloperName = 'PersonAccount'];
        
        Account acc= New Account();
        acc.RecordTypeId=RT[0].Id;
        acc.LastName='Sample';
        acc.Status__c='Active';
        acc.Type='Customer';
        acc.Phone='7510665633';
        
        insert acc;
        
        
    }
    
    static testmethod void testWSSalesQueueable1() {
        
        JSONSales parsedJSON= new JSONSales();
        String jsonBody= '{"Response":{"Result":"SUCCESS","WsTransaction":{"Sales":[{"DocDate":"2020-09-04","DocNumber":"20200904_WM_99_1_342","DocType":"SALES","StoreCode":"KL08-017","StoreGSTIN":"32BUSPM2666P1ZT","CustomerCode":"8400","CustomerGSTIN":null,"OrderDate":null,"OrderNumber":null,"RefDocDate":"1900-01-01 00:00:00.000","RefDocNumber":null,"TotalItems":"2","TotalQuantity":"2.000","TotalTax":"4478.571","TotalAmount":"28050.000","ROD":"0.000","Remarks":null,"BillingAddress1":null,"BillingAddress2":null,"BillingAddress3":null,"BillingPinCode":"680308","BillingCityCode":null,"BillingStateCode":null,"DeliveryAddress1":"koratty","DeliveryAddress2":"koratty","DeliveryAddress3":"koratty","DeliveryPinCode":"680308","AlternateStateCode":null,"DeliveryCityCode":null,"UserName":"KL08-017","CreatedOn":"2020-09-08","TotalDiscount":"0.000","CustomerMobile":"7510665633","CustomerEmail":null,"BillTime":"2020-09-04 17:24:13","CurrencyCode":"INR","TotalNet":"28050.000","TotalPayment":"28050.000","DocNumber2":"009912000342","CustomerType":null,"EmployeeID":null,"CustomerName":"RAIJU ","DiscountPercentage":"0.000","CGSTValue":"2121.429","SGSTValue":"2121.429","IGSTValue":"0.000","UTGSTValue":"0.000","CESSValue":"235.714","TaxableValue":"23571.427","OrderStoreCode":null,"OtherDiscountAmount":"0.000","CompanyID":null,"loggedInUserMobile":null,"buyerSource":null,"leadId":null,"ManualBillNumber":"0","RefOrderNumber":null,"OrderStatus":null,"ERPCode4ROD":null,"ERPCode4Discount":null,"PaymentIntegration":"0","ConsignmentStocklocation":"0","AllowCredit":"0","CountryCode":"India","OrderOrigin":null,"StoreName":"Johns Home Appliances","NexusRefCode":null,"SaleDocNumber":"342","SaleDocSeries":"WM","Items":{"Item":[{"DocLineNumber":"1","SalesmanCode":null,"ProductCode":"PRE-018M000C000S305","IsSerialNoMandatory":"0","Quantity":"1.000","FreeQuantity":"0.000","BatchDescription":null,"HSNCode":"8509.40.90","SalesPrice":"3300.000","SalesTaxCode":"0","PDiscountAmt":"0.000","PDiscountPer":"0.000","DiscountAmount":"0.000","OtherDiscountAmt":"0.000","SchemeCode":"0","SchemeDescription":null,"TaxAmount":"526.891","BaseValue":"2773.109","Amount":"3300.000000","CGST":"249.580","SGST":"249.580","IGST":"0.000","UTGST":"0.000","CESS":"27.731","ReasonCode":null,"EffectiveTaxPercentage":"19.000","TaxRate":"19.000","CGSTPercent":"9.000","SGSTPercent":"9.000","IGSTPercent":"0.000","UTGSTPercent":"0.000","CESSPercent":"1.000","UOMCode":"0","DocNumber2":"009912100342","SalesmanName":null,"UnitDescription":null,"Attribute1":null,"IsBatchNumberCompulsory":"0","StockType":"0","Remarks":null,"IsService":"0","IsTaxInclusive":"1","IsGiftVoucherProduct":"0","ExpiryDate":null,"AlternateHSNCode":"8509.40.90_18.000","RateWithTax":"3300"},{"DocLineNumber":"2","SalesmanCode":null,"ProductCode":"WHL-022M262C307S113","IsSerialNoMandatory":"0","Quantity":"1.000","FreeQuantity":"0.000","BatchDescription":null,"HSNCode":"8450.12.00","SalesPrice":"24750.000","SalesTaxCode":"0","PDiscountAmt":"0.000","PDiscountPer":"0.000","DiscountAmount":"0.000","OtherDiscountAmt":"0.000","SchemeCode":"0","SchemeDescription":null,"TaxAmount":"3951.681","BaseValue":"20798.318","Amount":"24750.000000","CGST":"1871.849","SGST":"1871.849","IGST":"0.000","UTGST":"0.000","CESS":"207.983","ReasonCode":null,"EffectiveTaxPercentage":"19.000","TaxRate":"19.000","CGSTPercent":"9.000","SGSTPercent":"9.000","IGSTPercent":"0.000","UTGSTPercent":"0.000","CESSPercent":"1.000","UOMCode":"0","DocNumber2":"009912100342","SalesmanName":null,"UnitDescription":null,"Attribute1":null,"IsBatchNumberCompulsory":"0","StockType":"0","Remarks":null,"IsService":"0","IsTaxInclusive":"1","IsGiftVoucherProduct":"0","ExpiryDate":null,"AlternateHSNCode":"8450.12.00","RateWithTax":"24750"}]},"Payments":{"Payment":[{"CustomerCode":"8400","PaymentMode":"Cash","ModeType":"INR","ModeReference":"1","ModeValue":"28050.000","ReferenceDate":null,"IsDiscount":"0","LineNumber":"1","PaymentModeCode":"Cash","ID":"16036","ChequeDate":null,"BankCode":null,"ERPRefItemCode":null,"IsAdvance":"0","BankAccountID":null}]},"Customers":{"Customer":{"SourceSystem":"eShopaid","WSCustomerCode":"8400","CustomerCode":null,"CustomerName":"RAIJU ","CustomerGroupCode":null,"CustomerGroupDescription":null,"DOB":null,"DOA":null,"AllowCredit":"0","CreditLimit":"0.000","TIN":null,"PAN":null,"DealerType":"1","GSTIN":null,"CAAddress1":null,"CAAddress2":null,"CAAddress3":null,"CAPincode":null,"CACity":null,"CACityName":null,"CAState":null,"CAStateName":null,"CAStateAbbreviation":null,"CACountry":null,"CACountryName":null,"CALandLine":null,"CAMobile":"7510665633","CAFax":null,"CAEmail":null,"CARemarks":null,"BAAddress1":null,"BAAddress2":null,"BAAddress3":null,"BAPincode":"680308","BACity":null,"BACityName":null,"BAState":null,"BAStateName":"~Kerala","BACountry":null,"BACountryName":null,"BALandLine":null,"BAFax":null,"DAAddress1":null,"DAAddress2":null,"DAAddress3":null,"DAPincode":null,"DACity":null,"DACityName":null,"DAState":null,"DAStateName":null,"DACountry":null,"DACountryName":null,"DALandLine":null,"DAFax":null,"IsActive":"1","CurrencyCode":"1"}}}]}}}';
        parsedJSON=JSONSales.parse(jsonBody);
        
        Test.setMock(HttpCalloutMock.class, new WSSalesCalloutMock());
        
        Test.startTest();  
        system.enqueueJob(New GetWondersoftSales('2020-09-04','2020-09-04','Sales'));
        system.enqueueJob(New ProcessWSSalesCustomer(parsedJSON));
        system.enqueueJob(New ProcessWSSalesProduct(parsedJSON));
        system.enqueueJob(New ProcessWSInvoice(parsedJSON));
        system.enqueueJob(New ProcessWSInvoiceLine(parsedJSON));
        Test.stopTest(); 
        
    }
    static testmethod void testWSSalesQueueable2() {
        
        JSONSales parsedJSON= new JSONSales();
        String jsonBody= '{"Response":{"Result":"SUCCESS","WsTransaction":{"Sales":[{"DocDate":"2020-09-04","DocNumber":"20200904_WM_99_1_342","DocType":"SALES","StoreCode":"KL08-017","StoreGSTIN":"32BUSPM2666P1ZT","CustomerCode":"8400","CustomerGSTIN":null,"OrderDate":null,"OrderNumber":null,"RefDocDate":"1900-01-01 00:00:00.000","RefDocNumber":null,"TotalItems":"2","TotalQuantity":"2.000","TotalTax":"4478.571","TotalAmount":"28050.000","ROD":"0.000","Remarks":null,"BillingAddress1":null,"BillingAddress2":null,"BillingAddress3":null,"BillingPinCode":"680308","BillingCityCode":null,"BillingStateCode":"KL","DeliveryAddress1":"koratty","DeliveryAddress2":"koratty","DeliveryAddress3":"koratty","DeliveryPinCode":"680308","AlternateStateCode":"KL","DeliveryCityCode":null,"UserName":"KL08-017","CreatedOn":"2020-09-08","TotalDiscount":"0.000","CustomerMobile":"7510665633","CustomerEmail":null,"BillTime":"2020-09-04 17:24:13","CurrencyCode":"INR","TotalNet":"28050.000","TotalPayment":"28050.000","DocNumber2":"009912000342","CustomerType":null,"EmployeeID":null,"CustomerName":null,"DiscountPercentage":"0.000","CGSTValue":"2121.429","SGSTValue":"2121.429","IGSTValue":"0.000","UTGSTValue":"0.000","CESSValue":"235.714","TaxableValue":"23571.427","OrderStoreCode":null,"OtherDiscountAmount":"0.000","CompanyID":null,"loggedInUserMobile":null,"buyerSource":null,"leadId":null,"ManualBillNumber":"0","RefOrderNumber":null,"OrderStatus":null,"ERPCode4ROD":null,"ERPCode4Discount":null,"PaymentIntegration":"0","ConsignmentStocklocation":"0","AllowCredit":"0","CountryCode":"India","OrderOrigin":null,"StoreName":null,"NexusRefCode":null,"SaleDocNumber":"342","SaleDocSeries":"WM","Items":{"Item":[{"DocLineNumber":"1","SalesmanCode":null,"ProductCode":"PRE-018M000C000S305","IsSerialNoMandatory":"0","Quantity":"1.000","FreeQuantity":"0.000","BatchDescription":null,"HSNCode":"8509.40.90","SalesPrice":"3300.000","SalesTaxCode":"0","PDiscountAmt":"0.000","PDiscountPer":"0.000","DiscountAmount":"0.000","OtherDiscountAmt":"0.000","SchemeCode":"0","SchemeDescription":null,"TaxAmount":"526.891","BaseValue":"2773.109","Amount":"3300.000000","CGST":"249.580","SGST":"249.580","IGST":"0.000","UTGST":"0.000","CESS":"27.731","ReasonCode":null,"EffectiveTaxPercentage":"19.000","TaxRate":"19.000","CGSTPercent":"9.000","SGSTPercent":"9.000","IGSTPercent":"0.000","UTGSTPercent":"0.000","CESSPercent":"1.000","UOMCode":"0","DocNumber2":"009912100342","SalesmanName":null,"UnitDescription":null,"Attribute1":null,"IsBatchNumberCompulsory":"0","StockType":"0","Remarks":null,"IsService":"0","IsTaxInclusive":"1","IsGiftVoucherProduct":"0","ExpiryDate":null,"AlternateHSNCode":"8509.40.90_18.000","RateWithTax":"3300"},{"DocLineNumber":"2","SalesmanCode":null,"ProductCode":"WHL-022M262C307S113","IsSerialNoMandatory":"0","Quantity":"1.000","FreeQuantity":"0.000","BatchDescription":null,"HSNCode":"8450.12.00","SalesPrice":"24750.000","SalesTaxCode":"0","PDiscountAmt":"0.000","PDiscountPer":"0.000","DiscountAmount":"0.000","OtherDiscountAmt":"0.000","SchemeCode":"0","SchemeDescription":null,"TaxAmount":"3951.681","BaseValue":"20798.318","Amount":"24750.000000","CGST":"1871.849","SGST":"1871.849","IGST":"0.000","UTGST":"0.000","CESS":"207.983","ReasonCode":null,"EffectiveTaxPercentage":"19.000","TaxRate":"19.000","CGSTPercent":"9.000","SGSTPercent":"9.000","IGSTPercent":"0.000","UTGSTPercent":"0.000","CESSPercent":"1.000","UOMCode":"0","DocNumber2":"009912100342","SalesmanName":null,"UnitDescription":null,"Attribute1":null,"IsBatchNumberCompulsory":"0","StockType":"0","Remarks":null,"IsService":"0","IsTaxInclusive":"1","IsGiftVoucherProduct":"0","ExpiryDate":null,"AlternateHSNCode":"8450.12.00","RateWithTax":"24750"}]},"Payments":{"Payment":[{"CustomerCode":"8400","PaymentMode":"Cash","ModeType":"INR","ModeReference":"1","ModeValue":"28050.000","ReferenceDate":null,"IsDiscount":"0","LineNumber":"1","PaymentModeCode":"Cash","ID":"16036","ChequeDate":null,"BankCode":null,"ERPRefItemCode":null,"IsAdvance":"0","BankAccountID":null}]},"Customers":{"Customer":{"SourceSystem":"eShopaid","WSCustomerCode":"8400","CustomerCode":null,"CustomerName":"RAIJU ","CustomerGroupCode":null,"CustomerGroupDescription":null,"DOB":null,"DOA":null,"AllowCredit":"0","CreditLimit":"0.000","TIN":null,"PAN":null,"DealerType":"1","GSTIN":null,"CAAddress1":null,"CAAddress2":null,"CAAddress3":null,"CAPincode":null,"CACity":null,"CACityName":null,"CAState":null,"CAStateName":null,"CAStateAbbreviation":null,"CACountry":null,"CACountryName":null,"CALandLine":null,"CAMobile":"7510665633","CAFax":null,"CAEmail":null,"CARemarks":null,"BAAddress1":null,"BAAddress2":null,"BAAddress3":null,"BAPincode":"680308","BACity":null,"BACityName":null,"BAState":null,"BAStateName":"~Kerala","BACountry":null,"BACountryName":null,"BALandLine":null,"BAFax":null,"DAAddress1":null,"DAAddress2":null,"DAAddress3":null,"DAPincode":null,"DACity":null,"DACityName":null,"DAState":null,"DAStateName":null,"DACountry":null,"DACountryName":null,"DALandLine":null,"DAFax":null,"IsActive":"1","CurrencyCode":"1"}}}]}}}';
        parsedJSON=JSONSales.parse(jsonBody);
        
        Test.setMock(HttpCalloutMock.class, new WSSalesCalloutMock());
        
        Test.startTest();  
        system.enqueueJob(New GetWondersoftSales('2020-09-04','2020-09-04','Sales'));
        system.enqueueJob(New ProcessWSSalesCustomer(parsedJSON));
        system.enqueueJob(New ProcessWSSalesProduct(parsedJSON));
        system.enqueueJob(New ProcessWSInvoice(parsedJSON));
        system.enqueueJob(New ProcessWSInvoiceLine(parsedJSON));
        Test.stopTest(); 
        
    }
    
    static testmethod void testWSSalesQueueable3() {
        
        JSONSales parsedJSON= new JSONSales();
        String jsonBody= '{"Response":{"Result":"SUCCESS","WsTransaction":{"Sales":[{"DocDate":"2020-08-17","DocNumber":"20200817_SR_86_1_1","DocType":"RETURN","StoreCode":"KL07-030","StoreGSTIN":"32ADSPI4618M1Z7","CustomerCode":"2629","CustomerGSTIN":null,"OrderDate":null,"OrderNumber":null,"RefDocDate":"20200816","RefDocNumber":"20200816_WM_86_1_460","TotalItems":"1","TotalQuantity":"1.000","TotalTax":"2315.126","TotalAmount":"14500.000","ROD":"0.000","Remarks":null,"BillingAddress1":"VETTUKADU","BillingAddress2":"ERAMAM","BillingAddress3":"MUPPATHADAM","BillingPinCode":"683562","BillingCityCode":null,"BillingStateCode":null,"DeliveryAddress1":"VETTUKADU","DeliveryAddress2":"ERAMAM","DeliveryAddress3":"MUPPATHADAM","DeliveryPinCode":"683562","DeliveryCityCode":null,"DeliveryStateCode":"32","UserName":"KL07-030","CreatedOn":"2020-09-08","TotalDiscount":"0.000","CustomerMobile":"8156936091","CustomerEmail":null,"BillTime":"2020-08-17 14:44:58","CurrencyCode":"INR","TotalNet":"14500.000","TotalPayment":"0.000","DocNumber2":"008612000001","CustomerType":null,"EmployeeID":null,"CustomerName":"AZEES V ","DiscountPercentage":"0.000","CGSTValue":"-1096.639","SGSTValue":"-1096.639","IGSTValue":"0.000","UTGSTValue":"0.000","CESSValue":"-121.849","TaxableValue":"12184.874","OrderStoreCode":null,"OtherDiscountAmount":"0.000","CompanyID":null,"CountryCode":"India","NexusRefCode":null,"IsCCNCreated":"1","SaleDocNumber":"1","SaleDocSeries":"SR","RefSaleDocNumber":"460","RefSaleDocSeries":"WM","AllowCredit":"0","StoreName":"WhiteMart","StoreAbbrevation":"KL07030","WSCustomerCode":"2629","AlternateCode":null,"StoreRemarks":null,"WSStoreCode":"86","SalesmanName":null,"Items":{"Item":[{"DocLineNumber":"1","SalesmanCode":null,"ProductCode":"SAG-052M081C000S200","IsSerialNoMandatory":"0","Quantity":"-1.000","FreeQuantity":"0.000","BatchDescription":null,"HSNCode":"8528.72.19","SalesPrice":"14500.000","SalesTaxCode":"0","PDiscountAmt":"0.000","PDiscountPer":"0.000","DiscountAmount":"0.000","OtherDiscountAmt":"0.000","SchemeCode":"0","SchemeDescription":null,"TaxAmount":"-2315.126","BaseValue":"-12184.874","Amount":"-14500.000000","CGST":"-1096.639","SGST":"-1096.639","IGST":"0.000","UTGST":"0.000","CESS":"-121.849","ReasonCode":"PRI","EffectiveTaxPercentage":"19.000","CGSTPercent":"9.000","SGSTPercent":"9.000","IGSTPercent":"0.000","UTGSTPercent":"0.000","CESSPercent":"1.000","UOMCode":"0","DocNumber2":"008612100001","SalesmanName":null,"UnitDescription":null,"Attribute1":null,"IsBatchNumberCompulsory":"0","IsTaxInclusive":"1","AlternateHSNCode":"8528.72.19_18.000","RateWithTax":"14500"}]},"Payments":{"Payment":[{"CustomerCode":"2629","PaymentMode":"CCN","ModeType":"INR","ModeReference":"1","ModeValue":"14500.000","Amount":"0.000","ReferenceDate":null,"IsDiscount":"0","LineNumber":"1","BillPaymentID":"8461","PaymentModeCode":"Customer Credit Note"}]}}]}}}';
        parsedJSON=JSONSales.parse(jsonBody);
        
        Test.setMock(HttpCalloutMock.class, new WSSalesRetrunCalloutMock());
        
        Test.startTest(); 
        system.enqueueJob(New GetWondersoftSales('2020-09-04','2020-09-04','Return'));
        system.enqueueJob(New ProcessWSSalesCustomer(parsedJSON));
        system.enqueueJob(New ProcessWSSalesProduct(parsedJSON));
        system.enqueueJob(New ProcessWSInvoice(parsedJSON));
        system.enqueueJob(New ProcessWSInvoiceLine(parsedJSON));
        Test.stopTest(); 
        
    }
 
}