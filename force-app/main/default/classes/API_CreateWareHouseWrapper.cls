public with sharing class API_CreateWareHouseWrapper {

    public String City;
	public String Comments;
	public String Location;
	public String Pin_Code;
	public String SAP_Code;
	public String State;
	public String Street_Address;
	public String Warehouse_Name;

    public static API_CreateWareHouseWrapper parse(String json) {
		return (API_CreateWareHouseWrapper) System.JSON.deserialize(json, API_CreateWareHouseWrapper.class);
	}

}