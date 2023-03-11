public class JSONFranchiseeInventory {
    
    public Response Response;
    
    public class Response {
		public String Result;
		public Data Data;
	}
    
    public class Data {
		public List<Inventory> Inventory;
	}
    
    public class Inventory {
		public String Location;
		public Items Items;
        public Items_Z Items_Z;
	}

	public class Items_Z {
		public Item Item;
	}
    
	public class Item {
		public String ProductCode;
		public String EANCode;
		public String ItemCode;
		public String ItemName;
		public String BatchDescription;
		public String ExpiryDate;
		public String MRP;
		public String Stock;
		public String StockUOM;
	}

	public class Items {
		public List<Item> Item;
	}

	public static JSONFranchiseeInventory parse(String json) {
		return (JSONFranchiseeInventory) System.JSON.deserialize(json, JSONFranchiseeInventory.class);
	}
}