public class JSONclicktocall {
    @auraenabled
    public Boolean isSuccess;
    
    @auraenabled
    public String message;
    
    @auraenabled
    public String data;
    
    
    public static JSONclicktocall parse(String json) {
        return (JSONclicktocall) System.JSON.deserialize(json, JSONclicktocall.class);
    }
}