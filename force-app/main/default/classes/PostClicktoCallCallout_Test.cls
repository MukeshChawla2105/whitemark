@isTest
public class PostClicktoCallCallout_Test {
    @isTest static void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new ClicktoCallHttpCalloutMock()); 
        PostClicktoCall.Requests req= new PostClicktoCall.Requests();
        req.Endpoint='http://whitemart.aabasoft.in/api/clicktocall';
        req.accessToken='';
        req.sourceMobileNumber='';
        req.destinationMobileNumber='';
        
         List<PostClicktoCall.Requests> reqList= new List<PostClicktoCall.Requests>();
        reqList.add(req);
        
        List<PostClicktoCall.Results> resList = PostClicktoCall.PostClicktoCalldetails(reqList);
    }
    @isTest static void testErrorPostCallout() {
        Test.setMock(HttpCalloutMock.class, new ClicktoCallErrorHttpCalloutMock()); 
        PostClicktoCall.Requests req= new PostClicktoCall.Requests();
        req.Endpoint='http://whitemart.aabasoft.in/api/clicktocall';
        req.accessToken='';
        req.sourceMobileNumber='';
        req.destinationMobileNumber='';
        
         List<PostClicktoCall.Requests> reqList= new List<PostClicktoCall.Requests>();
        reqList.add(req);
        
        List<PostClicktoCall.Results> resList = PostClicktoCall.PostClicktoCalldetails(reqList);
    }
}