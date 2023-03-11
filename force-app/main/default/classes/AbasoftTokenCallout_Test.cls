@isTest
public class AbasoftTokenCallout_Test {
    @isTest static void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new AbasofttokenHttpCalloutMock()); 
        GetAbasoftToken.Requests req= new GetAbasoftToken.Requests();
        req.Endpoint='http://whitemart.aabasoft.in/api/oauth2/token';
        req.UserName='';
        req.Password='';
        req.ClientId='';
        req.ClientSecret='';
        
         List<GetAbasoftToken.Requests> reqList= new List<GetAbasoftToken.Requests>();
        reqList.add(req);
        
        List<GetAbasoftToken.Results> resList = GetAbasoftToken.getAbasoftTokendetails(reqList);
    }
     @isTest static void testerrorPostCallout() {
        Test.setMock(HttpCalloutMock.class, new AbasofttokenerrorHttpCalloutMock()); 
        GetAbasoftToken.Requests req= new GetAbasoftToken.Requests();
        req.Endpoint='http://whitemart.aabasoft.in/api/oauth2/token';
        req.UserName='';
        req.Password='';
        req.ClientId='';
        req.ClientSecret='';
        
         List<GetAbasoftToken.Requests> reqList= new List<GetAbasoftToken.Requests>();
        reqList.add(req);
        
        List<GetAbasoftToken.Results> resList = GetAbasoftToken.getAbasoftTokendetails(reqList);
    }
    
}