public class JSONAccessToken {
    @auraenabled
    public String access_token;
    
    @auraenabled
    public String token_type;
    
    @auraenabled
    public Integer expires_in;
    
    @auraenabled
    public String refresh_token;
    
    
    public static JSONAccessToken parse(String json) {
        return (JSONAccessToken) System.JSON.deserialize(json, JSONAccessToken.class);
    }
}