@IsTest
public class JSONCallHistory_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"isSuccess\": true,'+
		'    \"message\": \"Success\",'+
		'    \"data\": ['+
		'        {'+
		'            \"callStartedOn\": \"2020-07-07T08:58:00Z\",'+
		'            \"callDate\": \"2020-07-07T00:00:00\",'+
		'            \"uniqueIdentifier\": \"5f03ebb25ab153.75089421\",'+
		'            \"source\": \"9072689513\",'+
		'            \"destination\": \"9061970421\",'+
		'            \"duration\": \"00:02:27\",'+
		'            \"callRecordingURL\": \"http://whitemart.aabasoft.in/call/PlayRecording.aspx?q=5f03ebb25ab153.75089421\",'+
		'            \"callStatus\": \"ANSWER\"'+
		'        },'+
		'        {'+
		'            \"callStartedOn\": \"2020-07-07T09:01:00Z\",'+
		'            \"callDate\": \"2020-07-07T00:00:00\",'+
		'            \"uniqueIdentifier\": \"5f03ec857d0a26.64012663\",'+
		'            \"source\": \"9072689513\",'+
		'            \"destination\": \"9745049831\",'+
		'            \"duration\": \"00:01:53\",'+
		'            \"callRecordingURL\": \"http://whitemart.aabasoft.in/call/PlayRecording.aspx?q=5f03ec857d0a26.64012663\",'+
		'            \"callStatus\": \"ANSWER\"'+
		'        }'+
		'    ]'+
		'}';
		JSONCallHistory obj = JSONCallHistory.parse(json);
        List<CallHistoryData> obj1= new List<CallHistoryData>();
        obj1=obj.data;
        system.assertEquals(obj1[0].uniqueIdentifier, '5f03ebb25ab153.75089421');
        //obj[0].uniqueIdentifier = '5f03ebb25ab153.75089421'
		System.assert(obj != null);
	}
}