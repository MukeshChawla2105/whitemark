public class JSONCallHistory {

    @auraenabled
	public Boolean isSuccess;
    
    @auraenabled
	public String message;
    
    @auraenabled
	public List<CallHistoryData> data;

	public static JSONCallHistory parse(String json) {
		return (JSONCallHistory) System.JSON.deserialize(json, JSONCallHistory.class);
	}
}