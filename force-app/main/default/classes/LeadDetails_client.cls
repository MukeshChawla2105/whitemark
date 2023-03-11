public class LeadDetails_client {
    
    public String FirstName;
    public String LastName;
    public String Phone;
    
    public static LeadDetails_client parse(String json) {
        return (LeadDetails_client) System.JSON.deserialize(json, LeadDetails_client.class);
    }

}