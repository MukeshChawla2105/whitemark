public with sharing class API_CreateProductWrapper {

    public Boolean IsActive;
	public String Brand;
	public String Capacity_Size;
	public String Category;
	public String Colour;
	public String Features;
	public String Model;
	public String Product_Name;
	public String Product_SKU;
	public String Quantity_Unit_Of_Measure;
	public String SAP_Code;
	public String Star_Rating;
	public String Sub_Category;
	public String Warranty;

	
	public static API_CreateProductWrapper parse(String json) {
		return (API_CreateProductWrapper) System.JSON.deserialize(json, API_CreateProductWrapper.class);
	}
    
}