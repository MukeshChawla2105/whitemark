public with sharing class API_ProductPriceDataWrapper {
    
    
    public Double MOP1;
	public Double MOP2;
	public Double MRP;
	public String Product_SAP_Code;

    public static API_ProductPriceDataWrapper parse(String json) {
		return (API_ProductPriceDataWrapper) System.JSON.deserialize(json, API_ProductPriceDataWrapper.class);
	}
}