public with sharing class API_UpdateTaskAfterCallWrapper {
    
    public String PhoneNumber;
    public String callStartTime;
	public String callEndTime;
    public String CallDuration;
	public String RecordingLink;
    public String CallStatus;
    public String AgentUniqueId;
    public String CampaignId;
    public String dataUniqueID;

    public static API_UpdateTaskAfterCallWrapper parse(String json) {
		return (API_UpdateTaskAfterCallWrapper) System.JSON.deserialize(json, API_UpdateTaskAfterCallWrapper.class);
	}
}