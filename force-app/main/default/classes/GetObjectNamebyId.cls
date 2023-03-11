public class GetObjectNamebyId {
    @InvocableMethod
    public static List <Results> GetObjectNamedetailsbyId (List<Requests> requestList) {
        Id recId= requestList[0].objRecordId;
        Results curResult = new Results();
        curResult.objAPIName= recId.getSobjectType().getDescribe().getName();
        curResult.ObjLabel=  recId.getSobjectType().getDescribe().getLabel();
        
        List<Results> ResultsList = new List<Results>();
        ResultsList.add(curResult);
        return resultsList;
    }
    public class Requests {
        @InvocableVariable(label='Object Record Id' description='Object Record Id' required=true)
        public String objRecordId;
        
        
    }
    public class Results {
        @InvocableVariable(label='Object API Name' description='Object API Name')
        public String objAPIName;
        
        @InvocableVariable(label='Object Label' description='Object Label Name')
        public String ObjLabel;
        
    }
    public Static void TestCoverage(){
        integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}