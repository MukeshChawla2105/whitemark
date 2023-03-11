public class JSONConverted_API_orderSync {
    
    
    public static void JsonConverted(){
        List<cls_order_line_items> OLItemsList = new List<cls_order_line_items>();
        cls_shipping_address ShipAddress = new cls_shipping_address();
        ShipAddress.shipping_street = '';
        ShipAddress.shipping_city = '';
        ShipAddress.shipping_postal_code = '';
        ShipAddress.shipping_state = '';
        ShipAddress.shipping_country = '';
        
        cls_billing_address BillAddress = new cls_billing_address();
        BillAddress.billing_street = '';
        BillAddress.billing_city = '';
        BillAddress.billing_postal_code = '';
        BillAddress.billing_state = '';
        BillAddress.billing_country = '';
        
        cls_gst Gstdetail = new cls_gst();
        Gstdetail.gst_type= '';
        Gstdetail.sgstPercentage = '';
        Gstdetail.sgst = '';
        Gstdetail.sgstLedgerName = '';
        Gstdetail.igstPercentage = '';
        Gstdetail.igst = '';
        Gstdetail.igstLedgerName = '';
        Gstdetail.cgstPercentage = '';
        Gstdetail.cgst = '';
        Gstdetail.cgstLedgerName = '';
        Gstdetail.cessPercentage = '';
        Gstdetail.cess = '';
        Gstdetail.cessLedgerName = '';
        
        cls_order_line_items OLItems = new cls_order_line_items();
        OLItems.product_code= 'A';
        OLItems.quantity = 'A';
        OLItems.unit_price = 'A';
        OLItems.coupon_code_availed = 'A';
       	OLItems.coupon_code_discount = 'A';
        OLItems.item_discount = 'A';
        OLItems.bill_amount= 'A';
        OLItems.gst = Gstdetail;
        OLItemsList.add(OLItems);
        
        cls_order_line_items OLItemssecond = new cls_order_line_items();
        OLItemssecond.product_code= 'B';
        OLItemssecond.quantity = 'B';
        OLItemssecond.unit_price = 'B';
        OLItemssecond.coupon_code_availed = 'B';
       	OLItemssecond.coupon_code_discount = 'B';
        OLItemssecond.item_discount = 'B';
        OLItemssecond.bill_amount= 'B';
        OLItemssecond.gst = Gstdetail;
        OLItemsList.add(OLItemssecond);
        system.debug('OLItemsList === >'+ OLItemsList);
        
        cls_order_details orderDetail = new cls_order_details();
        orderDetail.customer_phone_number = '';
        orderDetail.delivery_option = '';
        orderDetail.order_status = '';
        orderDetail.delivery_person_code = '';
        orderDetail.order_no= '';
        orderDetail.created_by_name = '';
        orderDetail.source = '';
        orderDetail.warehouse_id = '';
        orderDetail.distributor_code = '';
        orderDetail.startdate  = '';
        orderDetail.order_type = '';
        orderDetail.partner_code = '';
        orderDetail.region = '';
        orderDetail.shipping_address = ShipAddress ;
        orderDetail.billing_address= BillAddress;
        orderDetail.order_offer_discounts = '';
        orderDetail.orde_total_discounts = '';
        orderDetail.order_scheme_discounts = '';
        orderDetail.order_bill_discounts = '';
        orderDetail.grand_total_discount = '';
        orderDetail.service_charge = '';
        orderDetail.total_taxes = '';
        orderDetail.total = '';
        orderDetail.total_paid = '';
        orderDetail.order_line_items = OLItemsList ;
        
        RequestStructure ReqStructure = new RequestStructure();
        ReqStructure.order_details = orderDetail;
            String str = JSON.serialize(ReqStructure);
        system.debug('str ===> ' + str);
    }
    
    public class RequestStructure{
        public cls_order_details order_details;
    }
    class cls_order_details {
        public String customer_phone_number;
        public String delivery_option;
        public String order_status;
        public String delivery_person_code;
        public String order_no;
        public String created_by_name;
        public String source;
        public String warehouse_id;
        public String distributor_code;
        public String startdate;
        public String order_type;
        public String partner_code;
        public String region;
        public cls_shipping_address shipping_address;
        public cls_billing_address billing_address;
        public String order_offer_discounts;
        public String orde_total_discounts;
        public String order_scheme_discounts;
        public String order_bill_discounts;
        public String grand_total_discount;
        public String service_charge;
        public String total_taxes;
        public String total;
        public String total_paid;
        public cls_order_line_items[] order_line_items;
    }
    class cls_shipping_address {
        public String shipping_street;
        public String shipping_city;
        public String shipping_postal_code;
        public String shipping_state;
        public String shipping_country;
    }
    class cls_billing_address {
        public String billing_street;
        public String billing_city;
        public String billing_postal_code;
        public String billing_state;
        public String billing_country;
    }
    class cls_order_line_items {
        public String product_code;
        public String quantity;
        public String unit_price;
        public String coupon_code_availed;
        public String coupon_code_discount;
        public String item_discount;
        public String bill_amount;
        public cls_gst gst;
    }
    class cls_gst {
        public String gst_type;
        public String sgstPercentage;
        public String sgst;
        public String sgstLedgerName;
        public String igstPercentage;
        public String igst;
        public String igstLedgerName;
        public String cgstPercentage;
        public String cgst;
        public String cgstLedgerName;
        public String cessPercentage;
        public String cess;
        public String cessLedgerName;
    }
    class cls_order_response {
        public String sf_id;
    }

}