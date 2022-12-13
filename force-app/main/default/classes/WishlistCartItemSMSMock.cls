@isTest
    global class WishlistCartItemSMSMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('warnings Invalid number No recipients specified Insufficient credits Message too long Invalid number format Invalid sender name No sender name specified Invalid Template Schedule time is outside that allowed You cannot send message at this time');
        return res;
    }
}