@IsTest
public class JSONclicktocall_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"isSuccess\": true,'+
		'    \"message\": \"Success\",'+
		'    \"data\": \"5f0588b65bf147.16148568\"'+
		'}';
		JSONclicktocall obj = JSONclicktocall.parse(json);
		System.assert(obj != null);
	}
}