@IsTest
public class JSONAccessToken_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"access_token\": \"UNxX8LNDg8V70ki2rLXxBdqo_gM_rFT4m_BVvP4XRsu_xSukVKUXz75bywhNW5tQG-3xHmLdE4VL_RHV-LDjEH3ch6sGQ59W467ZZjj5U3EHyyjD_M6fjLyfDRyORHunyMCF7CR7c9FohCqzgu-xFkRKxfqmwpcB1e1K0jHIXyTrBLb-aNQUScB8C_LsxKXJl2VKXWJnNHbSncoHKuzpoKXeEpXslgmQLtt53_Sm0kA\",'+
		'    \"token_type\": \"bearer\",'+
		'    \"expires_in\": 299,'+
		'    \"refresh_token\": \"hGwNJTwLMFF48NO_gyjfBZxE9_Uu1HKW3Yyfjp6SSlgXD_eiOTMyPZbfkGz89d47dwsAOdXox2xkKzdd5RNQJd5TzEUA7sAUZEEJu6bHF3wZOKsaX59Uuv81fcve_c-o-n4yOX09GFfzykptiUywAn8JVHJk7wL6igJb4b3vCCuzCTwV67qgdOtVJ6Zv4TQVqbyq-IvwpVjJ_bqAPQLCH50XpUCTafYLNtiLx6OM-78\"'+
		'}';
		JSONAccessToken obj = JSONAccessToken.parse(json);
		System.assert(obj != null);
	}
}