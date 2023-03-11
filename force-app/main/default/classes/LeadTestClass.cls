@isTest 
private class LeadTestClass {
    @testSetup static void data_setup() {
        // Create common test accounts
        Lead leadRec= new Lead(Firstname='raviteja',LastName='Nalla',Company='Util Labs',Phone='7777777777');
        leadRec.PostalCode ='691530';
        insert leadRec; 
        
        Execution_Criteria__c LeadAssingmentExecutionCriteria = new Execution_Criteria__c();
        LeadAssingmentExecutionCriteria.Name = 'Orange Home Appliance';
        LeadAssingmentExecutionCriteria.Evaluation_Expression_For_Execution__c = '1';
        LeadAssingmentExecutionCriteria.Enabled__c = True;
        insert LeadAssingmentExecutionCriteria;
        
        Assignment_Group__c assGroupInstance = new Assignment_Group__c();
        assGroupInstance.Last_Allocated_RRid__c = 1;
        assGroupInstance.Name = 'Weltech Electronics';
        assGroupInstance.Last_Lead_Alloted_To__c  = 2;
        assGroupInstance.Lead_Stage__c ='New';
        assGroupInstance.Max_Lead_Per_Day__c = 25;
        assGroupInstance.Lead_Assigning_Criteria__c = LeadAssingmentExecutionCriteria.Id;
        insert assGroupInstance;
        
        Scorecard__c ScoreCrd = new Scorecard__c();
        ScoreCrd.Name = 'test score card';
        ScoreCrd.Enabled__c = True;
        ScoreCrd.Object_Type__c = 'Lead';
        ScoreCrd.Total_Weight__c = 1.00;
        insert ScoreCrd;
        
        Execution_Criteria_Entry__c ExecutionInstance = new Execution_Criteria_Entry__c();
        ExecutionInstance.Name = 'Zip Code Criteria';
        ExecutionInstance.Sequence__c = 1;
        ExecutionInstance.Matching_Type__c = 'CONTAINS';
        ExecutionInstance.Field_Type__c = 'Text';
        ExecutionInstance.Field_Name__c = 'PostalCode';
        ExecutionInstance.Matching_Value__c = '691523, 689694, 691530, 689501, 691524, 691554, 689501, 689693, 689502, 689693, 691551, 689693, 689694, 690504, 689501, 691525, 689648, 691555, 691556, 691551, 691553, 691526, 689694, 689502, 689695, 691525, 690522, 691552, 691526';
        ExecutionInstance.Scorecard__c = ScoreCrd.Id;      
        insert ExecutionInstance;
        Execution_Criteria_Entry__c Execution = new Execution_Criteria_Entry__c();
        Execution.Matching_Type__c = '==';
        insert Execution;
         Execution_Criteria_Entry__c Execution1 = new Execution_Criteria_Entry__c();
        Execution1.Matching_Type__c = '<';
        insert Execution1;
        Execution_Criteria_Entry__c Execution2 = new Execution_Criteria_Entry__c();
        Execution2.Matching_Type__c = '>';
         insert Execution2;
        Execution_Criteria_Entry__c Execution3 = new Execution_Criteria_Entry__c();
        Execution3.Matching_Type__c = 'DOES NOT CONTAIN';
         ExecutionInstance.Scorecard__c = ScoreCrd.Id; 
        insert Execution3;
        
           ExecutionInstance.Scorecard__c = ScoreCrd.Id; 
        System.debug('LeadAssingmentExecutionCriteria'+LeadAssingmentExecutionCriteria.Id);  
        System.debug('leadRec'+leadRec.Id);
        System.debug('assGroupInstance'+assGroupInstance.Id);
        System.debug('ExecutionInstance'+ExecutionInstance.Id);
        System.debug('ScoreCrd'+ScoreCrd.Id);
        System.debug('Execution2'+Execution2.Id);
        System.debug('Execution3'+Execution3.Id);
        
    }
    static testMethod void validateLeadInsertion() {
        Test.startTest();
        Lead leadRec= new Lead(Firstname='Ajeet',LastName='Kumar',Company='Util Labs',Phone='9999999999',PostalCode='689694');
        insert leadRec;
        Execution_Criteria__c LeadAssingmentExecutionCriteria = new Execution_Criteria__c();
        LeadAssingmentExecutionCriteria.Name = 'Orange Home Appliance';
        LeadAssingmentExecutionCriteria.Evaluation_Expression_For_Execution__c = '1 AND 2';
        LeadAssingmentExecutionCriteria.Enabled__c = True;
        insert LeadAssingmentExecutionCriteria;
        Test.stopTest();
        
    }
    static testMethod void validateLeadUpdation() {
        Test.startTest();
        Lead leadRec= [Select id,Name from Lead where Phone='07777777777' Limit 1];
        leadRec.Phone = '9999999999';
        update leadRec;
        Test.stopTest();
        
    }
}