public with sharing class API_CreateWareHouseInventoryDataWrapper {
    
    public String Inventor_Date;
	public String Product_SAP_Code;
	public String Warehouse_SAP_Code;
	public Integer Available_Quantity;

    public static API_CreateWareHouseInventoryDataWrapper parse(String json) {
		return (API_CreateWareHouseInventoryDataWrapper) System.JSON.deserialize(json, API_CreateWareHouseInventoryDataWrapper.class);
	}
}