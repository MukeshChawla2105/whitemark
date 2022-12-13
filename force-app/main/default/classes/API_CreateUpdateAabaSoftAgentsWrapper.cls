public with sharing class API_CreateUpdateAabaSoftAgentsWrapper {
    

    public String FirstName;
	public String LastName;
    public String UserName;
	public String EmailAddress;
    public String ContactNumber;
	public String Password;
    public String AgentUniqueId;
    public string CampaignId;

    public static API_CreateUpdateAabaSoftAgentsWrapper parse(String json) {
		return (API_CreateUpdateAabaSoftAgentsWrapper) System.JSON.deserialize(json, API_CreateUpdateAabaSoftAgentsWrapper.class);
	}

}