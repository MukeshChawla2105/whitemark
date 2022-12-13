public class JSONSales {
    
    public Response Response;
    
    public class Response {
		public String Result;
		public WsTransaction WsTransaction;
	}
    
    public class WsTransaction {
		public List<Sales> Sales;
	}
    
    public class Sales {
		public String DocDate;
		public String DocNumber;
		public String DocType;
		public String StoreCode;
		public String StoreGSTIN;
		public String CustomerCode;
		public String CustomerGSTIN;
		public String OrderDate;
		public String OrderNumber;
		public String RefDocDate;
		public String RefDocNumber;
		public String TotalItems;
		public String TotalQuantity;
		public String TotalTax;
		public String TotalAmount;
		public String ROD;
		public String Remarks;
		public String BillingAddress1;
		public String BillingAddress2;
		public String BillingAddress3;
		public String BillingPinCode;
		public String BillingCityCode;
		public String BillingStateCode;
		public String DeliveryAddress1;
		public String DeliveryAddress2;
		public String DeliveryAddress3;
		public String DeliveryPinCode;
		public String AlternateStateCode;
		public String DeliveryCityCode;
		public String UserName;
		public String CreatedOn;
		public String TotalDiscount;
		public String CustomerMobile;
		public String CustomerEmail;
		public String BillTime;
		public String CurrencyCode;
		public String TotalNet;
		public String TotalPayment;
		public String DocNumber2;
		public String CustomerType;
		public String EmployeeID;
		public String CustomerName;
		public String DiscountPercentage;
		public String CGSTValue;
		public String SGSTValue;
		public String IGSTValue;
		public String UTGSTValue;
		public String CESSValue;
		public String TaxableValue;
		public String OrderStoreCode;
		public String OtherDiscountAmount;
		public String CompanyID;
		public String loggedInUserMobile;
		public String buyerSource;
		public String leadId;
		public String ManualBillNumber;
		public String RefOrderNumber;
		public String OrderStatus;
		public String ERPCode4ROD;
		public String ERPCode4Discount;
		public String PaymentIntegration;
		public String ConsignmentStocklocation;
		public String AllowCredit;
		public String CountryCode;
		public String OrderOrigin;
		public String StoreName;
		public String NexusRefCode;
		public String SaleDocNumber;
		public String SaleDocSeries;
		public Items Items;
		public Payments Payments;
		public Customers Customers;
	}
    
    public class Items {
		public List<Item> Item;
	}
    
    public class Item {
		public String DocLineNumber;
		public String SalesmanCode;
		public String ProductCode;
		public String IsSerialNoMandatory;
		public String Quantity;
		public String FreeQuantity;
		public String BatchDescription;
		public String HSNCode;
		public String SalesPrice;
		public String SalesTaxCode;
		public String PDiscountAmt;
		public String PDiscountPer;
		public String DiscountAmount;
		public String OtherDiscountAmt;
		public String SchemeCode;
		public String SchemeDescription;
		public String TaxAmount;
		public String BaseValue;
		public String Amount;
		public String CGST;
		public String SGST;
		public String IGST;
		public String UTGST;
		public String CESS;
		public String ReasonCode;
		public String EffectiveTaxPercentage;
		public String TaxRate;
		public String CGSTPercent;
		public String SGSTPercent;
		public String IGSTPercent;
		public String UTGSTPercent;
		public String CESSPercent;
		public String UOMCode;
		public String DocNumber2;
		public String SalesmanName;
		public String UnitDescription;
		public String Attribute1;
		public String IsBatchNumberCompulsory;
		public String StockType;
		public String Remarks;
		public String IsService;
		public String IsTaxInclusive;
		public String IsGiftVoucherProduct;
		public String ExpiryDate;
		public String AlternateHSNCode;
		public String RateWithTax;
	}
    
    public class Payments {
		public List<Payment> Payment;
	}
    
    public class Payment {
		public String CustomerCode;
		public String PaymentMode;
		public String ModeType;
		public String ModeReference;
		public String ModeValue;
		public String ReferenceDate;
		public String IsDiscount;
		public String LineNumber;
		public String PaymentModeCode;
		public String ID;
		public String ChequeDate;
		public String BankCode;
		public String ERPRefItemCode;
		public String IsAdvance;
		public String BankAccountID;
	}
    
    public class Customers {
		public Customer Customer;
	}
    
    public class Customer {
		public String SourceSystem;
		public String WSCustomerCode;
		public String CustomerCode;
		public String CustomerName;
		public String CustomerGroupCode;
		public String CustomerGroupDescription;
		public String DOB;
		public String DOA;
		public String AllowCredit;
		public String CreditLimit;
		public String TIN;
		public String PAN;
		public String DealerType;
		public String GSTIN;
		public String CAAddress1;
		public String CAAddress2;
		public String CAAddress3;
		public String CAPincode;
		public String CACity;
		public String CACityName;
		public String CAState;
		public String CAStateName;
		public String CAStateAbbreviation;
		public String CACountry;
		public String CACountryName;
		public String CALandLine;
		public String CAMobile;
		public String CAFax;
		public String CAEmail;
		public String CARemarks;
		public String BAAddress1;
		public String BAAddress2;
		public String BAAddress3;
		public String BAPincode;
		public String BACity;
		public String BACityName;
		public String BAState;
		public String BAStateName;
		public String BACountry;
		public String BACountryName;
		public String BALandLine;
		public String BAFax;
		public String DAAddress1;
		public String DAAddress2;
		public String DAAddress3;
		public String DAPincode;
		public String DACity;
		public String DACityName;
		public String DAState;
		public String DAStateName;
		public String DACountry;
		public String DACountryName;
		public String DALandLine;
		public String DAFax;
		public String IsActive;
		public String CurrencyCode;
	}
    
    
    
    public static JSONSales parse(String json) {
		return (JSONSales) System.JSON.deserialize(json, JSONSales.class);
	}

}