@isTest
global class WSInventoryCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(request.getEndpoint()=='http://13.71.71.137:7777/eShopaidService/eShopaidService.svc/Token'){
            response.setBody('{ "Response": { "Result": "SUCCESS", "Access_Token":" 0C6065FA997F0EC3A99846E24CCF3FD8D28362A028008E330F440FB59CB06C81943CBE82FFCFDEB0A0BF467D0CCD778913370ACF9DDB55AEF7BFE8745ABC9125CD82E163C8B25452762EEAD8A8203B2E20A454083A4FE48406876A122112C928B7253F93D0BE9B6CE48F579F63B9F15E33F8BF8D3EDAA21F6B87A0018C71C3839A0CEBEC250330E737A66538EFBA5A9DD7B07B681D2D53FC27ADBBC5EEC326EF76050105A38C3C570C949A81954D64C381C02A5C20D8C7F66EAA50EA15DC82A56D37E1F0F62182455D3D7542EB5E7604 "	} }');
        
        }else{
            response.setBody('{"Response":{"Result":"SUCCESS","Data":{"Inventory":[{"Location":"KL01-009","Items":null},{"Location":"KL02-010","Items":{"Item":{"ProductCode":"34358","EANCode":null,"ItemCode":"SUJ-015M000C000S309","ItemName":"SUJATHA JUICER POWERMATIC PLUS","BatchDescription":null,"ExpiryDate":null,"MRP":"6057.000","Stock":"1.000","StockUOM":null}}},{"Location":"KL03-004","Items":{"Item":[{"ProductCode":"40599","EANCode":null,"ItemCode":"PIG-024M000C000S001","ItemName":"PIGEON SANITIZER DISPENSER STAND-M","BatchDescription":null,"ExpiryDate":null,"MRP":"845.000","Stock":"4.000","StockUOM":null},{"ProductCode":"40733","EANCode":null,"ItemCode":"LAN-052M088C000S013","ItemName":"LANZ LED 24 Z2400 0720","BatchDescription":null,"ExpiryDate":null,"MRP":"12690.000","Stock":"5.000","StockUOM":null}]}}]}}}');
        
        }
        response.setStatusCode(200);
        return response; 
    }
}