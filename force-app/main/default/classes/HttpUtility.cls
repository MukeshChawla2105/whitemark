public with sharing class HttpUtility {
    static final String NO_RESPONSE = 'NO_RESPONSE';
    static final String HTTP_ERROR = 'ERROR WHILE MAKING REQUEST';
    //static WhiteMart_Configuration__c whitemartObj;

    
    static HttpUtility httpUtilityInstance;
    
    private HttpUtility() {}

    // public static HttpUtility getInstance() {
    //     if(httpUtilityInstance == null) {
    //         httpUtilityInstance = new HttpUtility();
    //         whitemartObj = WhiteMart_Configuration__c.getInstance();
    //     }
    //     return httpUtilityInstance;
    // }

    public static void httpReqHelper( string classname, string methodname, String method, HttpRequest httpReq, HttpResponse httpRes ) {
        Integration_Log__c logger = new Integration_Log__c();
        logger.HTTP_Method__c = method;
        logger.Integration_Type__c = 'CALLOUT';
        try {
            logger.Start_Date_And_Time__c = System.now();
            logger.End_Date_And_Time__c = System.now();
            createLog(logger, httpReq, httpRes);
            //System.debug('whitemartObj =====> ' + whitemartObj );
            // if(whitemartObj != null && whitemartObj.Enable_Integration_Logger__c){
            //     createLog(logger, httpReq, httpRes);
            // }
        }catch (Exception e) {
            System.debug('--- e-message '+ e.getMessage());
            System.debug('--- e-line-no '+ e.getLineNumber());

            Execption__c ex = new Execption__c();
            ex.Class_Name__c = classname;
            ex.Ececption_Message__c = e.getMessage();
            ex.Method_Name__c = methodname;
            ex.Stack_Trace__c = e.getStackTraceString();
            insert ex;
        }

    }

    private static void createLog(Integration_Log__c logger, HttpRequest httpReq, HttpResponse httpRes) {
        if(httpReq != null) {
            logger.Request_Body__c = httpReq.getBody();
            logger.EndPoint__c = httpReq.getEndPoint();
        }
        if(httpRes != null) {
            logger.Response_Body__c = httpRes.getBody();
            logger.Response_Status_Code__c = httpRes.getStatusCode();
        }
        System.debug('logger ======> ' + logger);
        insert logger;
    }

    /*public void createServiceLogger(String reqBody, String resBody, String endPoint, String method, Integer statusCode, DateTime startDatetime, DateTime endDateTime) {
        try {
            if(arjunaObj != null && arjunaObj.Enable_Apex_Service_Logger__c) {
                Integration_Log__c logger = new Integration_Log__c();
                logger.HTTP_Method__c = method;
                logger.Integration_Type__c = 'SERVICE';
                logger.Request_Body__c = reqBody;
                logger.Response_Body__c = resBody;
                logger.EndPoint__c = endPoint;
                logger.Response_Status_Code__c = statusCode;
                logger.Start_Date_And_Time__c = startDatetime;
                logger.End_Date_And_Time__c = endDatetime;
                insert logger;
            }
        }catch(DMLException e){
            System.debug('--- e-message '+ e.getMessage());
            System.debug('--- e-line-no '+ e.getLineNumber());
            HandleBusinessException.captureError('HttpUtility', 'httpReqHelper', e);
        }
    }*/
}