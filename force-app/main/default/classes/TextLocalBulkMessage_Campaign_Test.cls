@isTest
global class TextLocalBulkMessage_Campaign_Test implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type', 'application/json');
        //  response.setBody('{"test_mode": true,"balance": 16,"batch_id": 99,"cost": 1,"num_messages": 1,"message": {"num_parts": 1, "sender": "WHMART","content": "Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart"},  "receipt_url": "", "custom": "", "messages": [{"id": 1,"recipient": 918374728729}], "status": "success"}');
        response.setBody('{"warnings":[{"code":3,"message":"Invalid number"}],"errors":[{"code":7,"message":"No recipients specified"},{"code":6,"message":"Message too long"},{"code":32,"message":"Invalid number format"},{"code":43,"message":"Invalid sender name"},{"code":44,"message":"No sender name specified"},{"code":4,"message":"Insufficient credits"},{"code":80,"message":"Invalid Template"},{"code":191,"message":"Schedule time is outside that allowed"},{"code":192,"message":"You cannot send message at this time"}],"status":"failure"}');
        response.setStatusCode(200);
        return response; 
    }
    
    public static testmethod void test3(){
        
        Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;
        
        contact con = new Contact(FirstName = 'Robin', LastName = 'Koehler', AccountId = acct.Id, phone = '9999999122');
        insert con;
        
        Campaign cam = new Campaign();
        cam.Name = 'Email Campaign';
        cam.IsActive = false;
        cam.Scheduled_at__c  = 'Immediately';
        cam.Scheduled_Date_Time__c = system.now()+1;
        cam.Text_Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590200168?text=Hi.\nThanks\nWhitemart';
        Insert cam;
        
        
        CampaignMember member = new CampaignMember(
            ContactId = con.Id,
            Status = 'sent',
            CampaignId = cam.Id
        ); 
        insert member;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalBulkMessage_Campaign_Test()); 
        TextLocalBulkMessage_CampaignV2.sendBulkSMS(cam.Id);        
        test.stopTest();
    }
    public static testmethod void test4(){
        
        Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;
        
        contact con = new Contact(FirstName = 'Robin', LastName = 'Koehler', AccountId = acct.Id, phone = '9999999122');
        insert con;
        
        Campaign cam = new Campaign();
        cam.Name = 'Email Campaign';
        cam.IsActive = true;
        cam.Scheduled_Date_Time__c = system.now()+1;
        cam.Text_Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590200168?text=Hi.\nThanks\nWhitemart';
        Insert cam;
        
        
        CampaignMember member = new CampaignMember(ContactId = con.Id, Status = 'sent', CampaignId = cam.Id  ); 
        insert member;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalBulkMessage_Campaign_Test()); 
        TextLocalBulkMessage_CampaignV2.sendBulkSMS(cam.Id);        
        test.stopTest();
    }
    public static testmethod void test5(){
        
        Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;
        
        contact con = new Contact(FirstName = 'Robin', LastName = 'Koehler', AccountId = acct.Id, phone = '9999999122');
        insert con;
        
        Campaign cam = new Campaign();
        cam.Name = 'Email Campaign';
        cam.IsActive = true;
        cam.Scheduled_at__c = 'Specific Date/Time';
        //   cam.Scheduled_Date_Time__c = system.now()+1;
        cam.Text_Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590200168?text=Hi.\nThanks\nWhitemart';
        Insert cam;
        
        
        CampaignMember member = new CampaignMember(ContactId = con.Id, Status = 'sent', CampaignId = cam.Id  ); 
        insert member;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalBulkMessage_Campaign_Test()); 
        TextLocalBulkMessage_CampaignV2.sendBulkSMS(cam.Id);        
        test.stopTest();
    }
    public static testmethod void test6(){
        
        Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;
        
        contact con = new Contact(FirstName = 'Robin', LastName = 'Koehler', AccountId = acct.Id, phone = '9999999122');
        insert con;
        
        Campaign cam = new Campaign();
        cam.Name = 'Email Campaign';
        cam.IsActive = true;
        cam.Scheduled_at__c = 'Specific Date/Time';
        cam.Scheduled_Date_Time__c = system.now()-1;
        cam.Text_Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590200168?text=Hi.\nThanks\nWhitemart';
        Insert cam;
        
        
        CampaignMember member = new CampaignMember(ContactId = con.Id, Status = 'sent', CampaignId = cam.Id  ); 
        insert member;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalBulkMessage_Campaign_Test()); 
        TextLocalBulkMessage_CampaignV2.sendBulkSMS(cam.Id);        
        test.stopTest();
    }
    public static testmethod void test(){
        
        Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;
        
        contact con = new Contact(FirstName = 'Robin', LastName = 'Koehler', AccountId = acct.Id, phone = '9999999122');
        insert con;
        
        Campaign cam = new Campaign();
        cam.Name = 'Email Campaign';
        cam.IsActive = true;
        cam.Scheduled_at__c  = 'Immediately';
        cam.Scheduled_Date_Time__c = system.now()+1;
        cam.Text_Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590200168?text=Hi.\nThanks\nWhitemart';
        Insert cam;
        
        
        CampaignMember member = new CampaignMember(
            ContactId = con.Id,
            Status = 'sent',
            CampaignId = cam.Id
        ); 
        insert member;
        
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails.Api_Key__c = 'NmY0NjU5NmE0ODc0NTU3OTU1NTQzMjczNDgzMzUwMzg=';
        apiDetails.Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart';
        apiDetails.Sender__c = 'WHMART';
        INSERT apiDetails; 
        string test1 = string.valueof(false); 
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalBulkMessage_Campaign_Test()); 
        TextLocalBulkMessage_CampaignV2.sendBulkSMS(cam.Id);        
        test.stopTest();
    }
   
    public static testmethod void test7(){
        
        Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;
        
        contact con = new Contact(FirstName = 'Robin', LastName = 'Koehler', AccountId = acct.Id, phone = '9999999122');
        insert con;
        
        Campaign cam = new Campaign();
        cam.Name = 'Email Campaign';
        cam.IsActive = true;
        cam.Scheduled_at__c  = 'Specific Date/Time';
        cam.Scheduled_Date_Time__c = system.now()+1;
        cam.Text_Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590200168?text=Hi.\nThanks\nWhitemart';
        Insert cam;
        
        
        CampaignMember member = new CampaignMember(
            ContactId = con.Id,
            Status = 'sent',
            CampaignId = cam.Id
        ); 
        insert member;
        
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails.Api_Key__c = 'NmY0NjU5NmE0ODc0NTU3OTU1NTQzMjczNDgzMzUwMzg=';
        apiDetails.Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart';
        apiDetails.Sender__c = 'WHMART';
        INSERT apiDetails; 
        string test1 = string.valueof(false); 
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalBulkMessage_Campaign_Test()); 
        TextLocalBulkMessage_CampaignV2.sendBulkSMS(cam.Id);        
        test.stopTest();
    }
    public static testmethod void test1(){
        
        Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;
        
        contact con = new Contact(FirstName = 'Robin', LastName = 'Koehlerd', AccountId = acct.Id, phone = '9999999999'); insert con;   
        
        contact con1 = new Contact(FirstName = 'Robi', LastName = 'Koehl', AccountId = acct.Id, phone = '9999999991'); insert con1;
        contact con2 = new Contact(FirstName = 'Robiwn', LastName = 'Koehlser1', AccountId = acct.Id, phone = '9999999992'); insert con2;
        contact con3 = new Contact(FirstName = 'Rogdbin', LastName = 'Koehler2', AccountId = acct.Id, phone = '9999999978'); insert con3;
        contact con4 = new Contact(FirstName = 'Robisn', LastName = 'Koehleggr3', AccountId = acct.Id, phone = '9999999994'); insert con4;
        contact con5 = new Contact(FirstName = 'Robscin', LastName = 'Koehjkler4', AccountId = acct.Id, phone = '9999999995'); insert con5;
        contact con6 = new Contact(FirstName = 'Robfwcin', LastName = 'Koehhlhger5', AccountId = acct.Id, phone = '9991999678'); insert con6;
        contact con7 = new Contact(FirstName = 'Roadvbin', LastName = 'Koehledfbr6', AccountId = acct.Id, phone = '9999999997'); insert con7;
        contact con8 = new Contact(FirstName = 'Rodhjbin', LastName = 'Koehlesadr7', AccountId = acct.Id, phone = '9999999998'); insert con8;
        contact con9 = new Contact(FirstName = 'Robefin', LastName = 'Koehlesvr8', AccountId = acct.Id, phone = '9999999999'); insert con9;
        contact con10 = new Contact(FirstName = 'Robetin', LastName = 'Koehlafe9r', AccountId = acct.Id, phone = '9999999910'); insert con10;
        contact con11 = new Contact(FirstName = 'Robnqin', LastName = 'Koehlegrr10', AccountId = acct.Id, phone = '9999999911'); insert con11;
        contact con12 = new Contact(FirstName = 'Rosqbiwn', LastName = 'Koehqslergh11', AccountId = acct.Id, phone = '9999399912'); insert con12;
        contact con13 = new Contact(FirstName = 'Robqesin', LastName = 'Koehldaertuu12', AccountId = acct.Id, phone = '9999296913'); insert con13;
        contact con14 = new Contact(FirstName = 'Robrtin', LastName = 'Koehler136u', AccountId = acct.Id, phone = '9999999914'); insert con14;
        contact con15 = new Contact(FirstName = 'Robiyyn', LastName = 'Koehler1e5h4', AccountId = acct.Id, phone = '9999999915'); insert con15;
        contact con16 = new Contact(FirstName = 'Robnjiuun', LastName = 'Koehlolere5y15', AccountId = acct.Id, phone = '9912999916'); insert con16;
        contact con17 = new Contact(FirstName = 'Robiuyin', LastName = 'Koehler1erh6', AccountId = acct.Id, phone = '9999999917'); insert con17;
        contact con18 = new Contact(FirstName = 'Robisgedgnn', LastName = 'Koeheelere5hy17', AccountId = acct.Id, phone = '9956999918'); insert con18;
        contact con19 = new Contact(FirstName = 'Robidhn', LastName = 'Koehlerrh18', AccountId = acct.Id, phone = '9999999919'); insert con19;
        contact con20 = new Contact(FirstName = 'Robisgn', LastName = 'Koehlererh19', AccountId = acct.Id, phone = '9999999920'); insert con20;
        contact con21 = new Contact(FirstName = 'Rofvbsegin', LastName = 'Kogmlehlererh20', AccountId = acct.Id, phone = '9922999921'); insert con21;
        contact con22 = new Contact(FirstName = 'Rqwqobin', LastName = 'Koehlerhr21', AccountId = acct.Id, phone = '9999999922'); insert con22;
        contact con23 = new Contact(FirstName = 'Rertobin', LastName = 'Koehlerhr22', AccountId = acct.Id, phone = '9999999923'); insert con23;
        contact con24 = new Contact(FirstName = 'Rykluiobin', LastName = 'Koehjhlerhr23', AccountId = acct.Id, phone = '9909999924'); insert con24;
        contact con25 = new Contact(FirstName = 'Ropiobin', LastName = 'Koehlerhr24', AccountId = acct.Id, phone = '9999999925'); insert con25;
        contact con26 = new Contact(FirstName = 'Roasdbin', LastName = 'Koehlerhr25', AccountId = acct.Id, phone = '9999999926'); insert con26;
        contact con27 = new Contact(FirstName = 'Rdfgobin', LastName = 'Koehlerwhr26', AccountId = acct.Id, phone = '9999999927'); insert con27;
        contact con28 = new Contact(FirstName = 'Rghjobin', LastName = 'Koehlerrh27', AccountId = acct.Id, phone = '9999999928'); insert con28;
        contact con29 = new Contact(FirstName = 'Rjklobin', LastName = 'Koehler2h68', AccountId = acct.Id, phone = '9999999929'); insert con29;
        contact con30 = new Contact(FirstName = 'Rdcvobin', LastName = 'Koehler29r', AccountId = acct.Id, phone = '9999999930'); insert con30;
        contact con31 = new Contact(FirstName = 'Rghbobin', LastName = 'Koehlfxer30', AccountId = acct.Id, phone = '9999999931'); insert con31;
        contact con32 = new Contact(FirstName = 'Roghbbin', LastName = 'Koehghler31', AccountId = acct.Id, phone = '9avfbn932'); insert con32; 
        
        
        Campaign cam = new Campaign();
        cam.Name = 'Email Campaign';
        cam.IsActive = true;
        cam.Scheduled_at__c  = 'Immediately';
        cam.Scheduled_Date_Time__c = system.now()+1;
        cam.Text_Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590200168?text=Hi.\nThanks\nWhitemart';
        Insert cam;
        
        
        CampaignMember member = new CampaignMember( ContactId = con.Id, Status = 'sent', CampaignId = cam.Id );  insert member;
        CampaignMember member1 = new CampaignMember( ContactId = con1.Id, Status = 'sent', CampaignId = cam.Id );  insert member1;
        CampaignMember member2 = new CampaignMember( ContactId = con2.Id, Status = 'sent', CampaignId = cam.Id );  insert member2;
        CampaignMember member3 = new CampaignMember( ContactId = con3.Id, Status = 'sent', CampaignId = cam.Id );  insert member3;
        CampaignMember member4 = new CampaignMember( ContactId = con4.Id, Status = 'sent', CampaignId = cam.Id );  insert member4;
        CampaignMember member5 = new CampaignMember( ContactId = con5.Id, Status = 'sent', CampaignId = cam.Id );  insert member5;
        CampaignMember member6 = new CampaignMember( ContactId = con6.Id, Status = 'sent', CampaignId = cam.Id );  insert member6;
        CampaignMember member7 = new CampaignMember( ContactId = con7.Id, Status = 'sent', CampaignId = cam.Id );  insert member7;
        CampaignMember member8 = new CampaignMember( ContactId = con8.Id, Status = 'sent', CampaignId = cam.Id );  insert member8;
        CampaignMember member9 = new CampaignMember( ContactId = con9.Id, Status = 'sent', CampaignId = cam.Id );  insert member9;
        CampaignMember member10 = new CampaignMember( ContactId = con10.Id, Status = 'sent', CampaignId = cam.Id ); insert member10;
        CampaignMember member11= new CampaignMember( ContactId = con11.Id, Status = 'sent', CampaignId = cam.Id );  insert member11;
        CampaignMember member12 = new CampaignMember( ContactId = con12.Id, Status = 'sent', CampaignId = cam.Id );  insert member12;
        CampaignMember member13 = new CampaignMember( ContactId = con13.Id, Status = 'sent', CampaignId = cam.Id );  insert member13;
        CampaignMember member14 = new CampaignMember( ContactId = con14.Id, Status = 'sent', CampaignId = cam.Id );  insert member14;
        CampaignMember member15 = new CampaignMember( ContactId = con15.Id, Status = 'sent', CampaignId = cam.Id );  insert member15;
        CampaignMember member16 = new CampaignMember( ContactId = con16.Id, Status = 'sent', CampaignId = cam.Id );  insert member16;
        CampaignMember member17 = new CampaignMember( ContactId = con17.Id, Status = 'sent', CampaignId = cam.Id );  insert member17;
        CampaignMember member18 = new CampaignMember( ContactId = con18.Id, Status = 'sent', CampaignId = cam.Id );  insert member18;
        CampaignMember member19 = new CampaignMember( ContactId = con19.Id, Status = 'sent', CampaignId = cam.Id );  insert member19;
        CampaignMember member20 = new CampaignMember( ContactId = con20.Id, Status = 'sent', CampaignId = cam.Id );  insert member20;
        CampaignMember member21 = new CampaignMember( ContactId = con21.Id, Status = 'sent', CampaignId = cam.Id );  insert member21;
        CampaignMember member22 = new CampaignMember( ContactId = con22.Id, Status = 'sent', CampaignId = cam.Id );  insert member22;
        CampaignMember member23 = new CampaignMember( ContactId = con23.Id, Status = 'sent', CampaignId = cam.Id );  insert member23;
        CampaignMember member24 = new CampaignMember( ContactId = con24.Id, Status = 'sent', CampaignId = cam.Id );  insert member24;
        CampaignMember member25 = new CampaignMember( ContactId = con25.Id, Status = 'sent', CampaignId = cam.Id );  insert member25;
        CampaignMember member26 = new CampaignMember( ContactId = con26.Id, Status = 'sent', CampaignId = cam.Id );  insert member26;
        CampaignMember member27 = new CampaignMember( ContactId = con27.Id, Status = 'sent', CampaignId = cam.Id );  insert member27;
        CampaignMember member28 = new CampaignMember( ContactId = con28.Id, Status = 'sent', CampaignId = cam.Id );  insert member28;
        CampaignMember member29 = new CampaignMember( ContactId = con29.Id, Status = 'sent', CampaignId = cam.Id );  insert member29;
        CampaignMember member30 = new CampaignMember( ContactId = con30.Id, Status = 'sent', CampaignId = cam.Id );  insert member30;
        CampaignMember member31 = new CampaignMember( ContactId = con31.Id, Status = 'sent', CampaignId = cam.Id );  insert member31;
        CampaignMember member32 = new CampaignMember( ContactId = con32.Id, Status = 'sent', CampaignId = cam.Id );  insert member32; 
        
        
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails.Api_Key__c = 'NmY0NjU5NmE0ODc0NTU3OTU1NTQzMjczNDgzMzUwMzg=';
        apiDetails.Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart';
        apiDetails.Sender__c = 'WHMART';
        INSERT apiDetails; 
        string test1 = string.valueof(false); 
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalBulkMessage_Campaign_Test()); 
        TextLocalBulkMessage_CampaignV2.sendBulkSMS(cam.Id);        
        test.stopTest();
    }
    
    public static testmethod void test2(){
        
        Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;
        
        contact con = new Contact(FirstName = 'Robin', LastName = 'Koehlerd', AccountId = acct.Id, phone = '9999999999'); insert con;   
        
        contact con1 = new Contact(FirstName = 'Robi', LastName = 'Koehl', AccountId = acct.Id, phone = '9999999991'); insert con1;
        contact con2 = new Contact(FirstName = 'Robiwn', LastName = 'Koehlser1', AccountId = acct.Id, phone = '9999999992'); insert con2;
        contact con3 = new Contact(FirstName = 'Rogdbin', LastName = 'Koehler2', AccountId = acct.Id, phone = '9999999978'); insert con3;
        contact con4 = new Contact(FirstName = 'Robisn', LastName = 'Koehleggr3', AccountId = acct.Id, phone = '9999999994'); insert con4;
        contact con5 = new Contact(FirstName = 'Robscin', LastName = 'Koehjkler4', AccountId = acct.Id, phone = '9999999995'); insert con5;
        contact con6 = new Contact(FirstName = 'Robfwcin', LastName = 'Koehhlhger5', AccountId = acct.Id, phone = '9991999678'); insert con6;
        contact con7 = new Contact(FirstName = 'Roadvbin', LastName = 'Koehledfbr6', AccountId = acct.Id, phone = '9999999997'); insert con7;
        contact con8 = new Contact(FirstName = 'Rodhjbin', LastName = 'Koehlesadr7', AccountId = acct.Id, phone = '9999999998'); insert con8;
        contact con9 = new Contact(FirstName = 'Robefin', LastName = 'Koehlesvr8', AccountId = acct.Id, phone = '9999999999'); insert con9;
        contact con10 = new Contact(FirstName = 'Robetin', LastName = 'Koehlafe9r', AccountId = acct.Id, phone = '9999999910'); insert con10;
        contact con11 = new Contact(FirstName = 'Robnqin', LastName = 'Koehlegrr10', AccountId = acct.Id, phone = '9999999911'); insert con11;
        contact con12 = new Contact(FirstName = 'Rosqbiwn', LastName = 'Koehqslergh11', AccountId = acct.Id, phone = '9999399912'); insert con12;
        contact con13 = new Contact(FirstName = 'Robqesin', LastName = 'Koehldaertuu12', AccountId = acct.Id, phone = '9999296913'); insert con13;
        contact con14 = new Contact(FirstName = 'Robrtin', LastName = 'Koehler136u', AccountId = acct.Id, phone = '9999999914'); insert con14;
        contact con15 = new Contact(FirstName = 'Robiyyn', LastName = 'Koehler1e5h4', AccountId = acct.Id, phone = '9999999915'); insert con15;
        contact con16 = new Contact(FirstName = 'Robnjiuun', LastName = 'Koehlolere5y15', AccountId = acct.Id, phone = '9912999916'); insert con16;
        contact con17 = new Contact(FirstName = 'Robiuyin', LastName = 'Koehler1erh6', AccountId = acct.Id, phone = '9999999917'); insert con17;
        contact con18 = new Contact(FirstName = 'Robisgedgnn', LastName = 'Koeheelere5hy17', AccountId = acct.Id, phone = '9956999918'); insert con18;
        contact con19 = new Contact(FirstName = 'Robidhn', LastName = 'Koehlerrh18', AccountId = acct.Id, phone = '9999999919'); insert con19;
        contact con20 = new Contact(FirstName = 'Robisgn', LastName = 'Koehlererh19', AccountId = acct.Id, phone = '9999999920'); insert con20;
        contact con21 = new Contact(FirstName = 'Rofvbsegin', LastName = 'Kogmlehlererh20', AccountId = acct.Id, phone = '9922999921'); insert con21;
        contact con22 = new Contact(FirstName = 'Rqwqobin', LastName = 'Koehlerhr21', AccountId = acct.Id, phone = '9999999922'); insert con22;
        contact con23 = new Contact(FirstName = 'Rertobin', LastName = 'Koehlerhr22', AccountId = acct.Id, phone = '9999999923'); insert con23;
        contact con24 = new Contact(FirstName = 'Rykluiobin', LastName = 'Koehjhlerhr23', AccountId = acct.Id, phone = '9909999924'); insert con24;
        contact con25 = new Contact(FirstName = 'Ropiobin', LastName = 'Koehlerhr24', AccountId = acct.Id, phone = '9999999925'); insert con25;
        contact con26 = new Contact(FirstName = 'Roasdbin', LastName = 'Koehlerhr25', AccountId = acct.Id, phone = '9999999926'); insert con26;
        contact con27 = new Contact(FirstName = 'Rdfgobin', LastName = 'Koehlerwhr26', AccountId = acct.Id, phone = '9999999927'); insert con27;
        contact con28 = new Contact(FirstName = 'Rghjobin', LastName = 'Koehlerrh27', AccountId = acct.Id, phone = '9999999928'); insert con28;
        contact con29 = new Contact(FirstName = 'Rjklobin', LastName = 'Koehler2h68', AccountId = acct.Id, phone = '9999999929'); insert con29;
        contact con30 = new Contact(FirstName = 'Rdcvobin', LastName = 'Koehler29r', AccountId = acct.Id, phone = '9999999930'); insert con30;
        contact con31 = new Contact(FirstName = 'Rghbobin', LastName = 'Koehlfxer30', AccountId = acct.Id, phone = 'hjabsxhbqs'); insert con31;
        contact con32 = new Contact(FirstName = 'Roghbbin', LastName = 'Koehghler31', AccountId = acct.Id, phone = 'bbxxb'); insert con32; 
        
        
        Campaign cam = new Campaign();
        cam.Name = 'Email Campaign';
        cam.IsActive = true;
        cam.Scheduled_at__c  = 'Specific Date/Time';
        cam.Scheduled_Date_Time__c = system.now()+1;
        cam.Text_Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590200168?text=Hi.\nThanks\nWhitemart';
        Insert cam;
        
        List<CampaignMember> camlst = new List<CampaignMember>();
        CampaignMember member = new CampaignMember( ContactId = con.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member);
        CampaignMember member1 = new CampaignMember( ContactId = con1.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member1);
        CampaignMember member2 = new CampaignMember( ContactId = con2.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member2);
        CampaignMember member3 = new CampaignMember( ContactId = con3.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member3);
        CampaignMember member4 = new CampaignMember( ContactId = con4.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member4);
        CampaignMember member5 = new CampaignMember( ContactId = con5.Id, Status = 'sent', CampaignId = cam.Id ); camlst.add(member5);
        CampaignMember member6 = new CampaignMember( ContactId = con6.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member6);
        CampaignMember member7 = new CampaignMember( ContactId = con7.Id, Status = 'sent', CampaignId = cam.Id ); camlst.add(member7);
        CampaignMember member8 = new CampaignMember( ContactId = con8.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member8);
        CampaignMember member9 = new CampaignMember( ContactId = con9.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member9);
        CampaignMember member10 = new CampaignMember( ContactId = con10.Id, Status = 'sent', CampaignId = cam.Id ); camlst.add(member10);
        CampaignMember member11= new CampaignMember( ContactId = con11.Id, Status = 'sent', CampaignId = cam.Id );   camlst.add(member11);
        CampaignMember member12 = new CampaignMember( ContactId = con12.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member12);
        CampaignMember member13 = new CampaignMember( ContactId = con13.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member13);
        CampaignMember member14 = new CampaignMember( ContactId = con14.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member14);
        CampaignMember member15 = new CampaignMember( ContactId = con15.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member15);
        CampaignMember member16 = new CampaignMember( ContactId = con16.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member16);
        CampaignMember member17 = new CampaignMember( ContactId = con17.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member17);
        CampaignMember member18 = new CampaignMember( ContactId = con18.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member18);
        CampaignMember member19 = new CampaignMember( ContactId = con19.Id, Status = 'sent', CampaignId = cam.Id ); camlst.add(member19);
        CampaignMember member20 = new CampaignMember( ContactId = con20.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member20);
        CampaignMember member21 = new CampaignMember( ContactId = con21.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member21);
        CampaignMember member22 = new CampaignMember( ContactId = con22.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member22);
        CampaignMember member23 = new CampaignMember( ContactId = con23.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member23);
        CampaignMember member24 = new CampaignMember( ContactId = con24.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member24);
        CampaignMember member25 = new CampaignMember( ContactId = con25.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member25);
        CampaignMember member26 = new CampaignMember( ContactId = con26.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member26);
        CampaignMember member27 = new CampaignMember( ContactId = con27.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member27);
        CampaignMember member28 = new CampaignMember( ContactId = con28.Id, Status = 'sent', CampaignId = cam.Id ); camlst.add(member28);
        CampaignMember member29 = new CampaignMember( ContactId = con29.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member29);
        CampaignMember member30 = new CampaignMember( ContactId = con30.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member30);
        CampaignMember member31 = new CampaignMember( ContactId = con31.Id, Status = 'sent', CampaignId = cam.Id );  camlst.add(member31);
        CampaignMember member32 = new CampaignMember( ContactId = con32.Id, Status = 'sent', CampaignId = cam.Id ); camlst.add(member32);
        Insert camlst;
        list<string> lstconadd = new List<string>();
      //  lstconadd.addall(camlst);
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails.Api_Key__c = 'NmY0NjU5NmE0ODc0NTU3OTU1NTQzMjczNDgzMzUwMzg=';
        apiDetails.Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart';
        apiDetails.Sender__c = 'WHMART';
        INSERT apiDetails; 
        string test1 = string.valueof(false); 
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalBulkMessage_Campaign_Test()); 
        TextLocalBulkMessage_CampaignV2.sendBulkSMS(cam.Id);        
        test.stopTest();
    }
    
}