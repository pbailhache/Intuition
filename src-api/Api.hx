import data.*;
import php.Session;

class Api
{
	public function new()
	{
	}

	@description("display documentation")
	public function doc()
	{
		Sys.print("<!doctype html>
			<html>
			<head>
			<style type=\"text/css\">
			body
			{
				background-color : #CCC;
				margin : 0px;
				padding : 10px;
				font-family : consolas, serif;
			}
			.function
			{
				margin : 5px;
				padding : 10px;
				border-radius : 3px;
				background-color : #FFF;
			}
			.name
			{
				font-size : 2em;
			}
			.description
			{
				font-size : 1.5em;
				opacity : 0.75;
			}
			</style>
			</head>
			<body>
			<h1>Documentation Intuition - API</h1>");
		for(field in Type.getInstanceFields(Type.getClass(this)))
		{
			Sys.print("<div class=\"function\">");
			Sys.print("<a class=\"name\" href=\"/api/"+field+"\">/api/"+field+"</a>");
			var data = haxe.rtti.Meta.getFields(Type.getClass(this));
			try
			{
				var meta = Reflect.field(data, field);
				for(metadata in Reflect.fields(meta))
					Sys.print("<div class=\""+metadata+"\">"+Reflect.field(meta, metadata)[0]+"</div>");
			}
			catch(e : String)
			{
			}
			Sys.print("</div>");
		}
		Sys.print("</body></html>");
	}

	/*
	 * TAGS FUNCTIONS
	 */

	@description("Return the list of tags")
	public function getTags()
	{
		var result = [];
		for(tag in Tag.manager.all())
			result.push(tag.getObject());
		Sys.print(haxe.Json.stringify(result));
	}

	@description("Return a tag based on id")
	@param1("id : id of the product")
	public function getTag(id : Int)
	{
		Sys.print(haxe.Json.stringify(Tag.manager.get(id).getObject()));
	}

	@description("Return some tag based on history")
	public function getNewTag()
	{
		var result = [];
		for(tag in Tag.manager.all())
			result.push(tag.getObject());
		Sys.print(haxe.Json.stringify(result[Std.random(result.length)]));
	}

	@description("Add a tag in the database")
	@param1("name : the name of the tag \"sweet\", \"calm\", ...")
	@param2("color : hexadecimal representation of a corresponding color : 614287")
	public function addTag(name : String, color : String)
	{
		name = name.toLowerCase();
		if(name == "" || color == "" || Tag.manager.count($name == name) > 0)
		{
			Sys.print(haxe.Json.stringify({success : false}));
		}
		else
		{
			new Tag(name, color).insert();
			Sys.print(haxe.Json.stringify({success : true}));
		}
	}

	/*
	 * PRODUCTS FUNCTIONS
	 */

	@description("Return the list of products")
	public function getProducts()
	{
		var result = [];
		for(product in Product.manager.all())
			result.push(product.getObject());
		Sys.print(haxe.Json.stringify(result));
	}

	@description("Return a product based on id")
	@param1("id : id of the product")
	public function getProduct(id : Int)
	{
		Sys.print(haxe.Json.stringify(Product.manager.get(id).getObject()));
	}

	@description("Add a product in the database")
	@param1("name : The name of the product")
	@param2("price : The price of the product as a Float (0.75)")
	@param3("imageURL : an url to an image of the product")
	@param4("url : an url to buy the product")
	public function addProduct(name : String, price : String, imageURL : String, url : String)
	{
		new Product(name, Std.parseFloat(price), imageURL, url).insert();
		Sys.print(haxe.Json.stringify({success : true}));
	}

	/*
	 * PRODUCTTAGS FUNCTIONS
	 */

	@description("Return the list of product tags")
	public function getProductTags()
	{
		var result = [];
		for(productTags in ProductTag.manager.all())
			result.push(productTags.getObject());
		Sys.print(haxe.Json.stringify(result));
	}

	@description("Return products tag based on product id")
	@param1("id : id of the product")
	public function getProductTagsByProduct(id : Int)
	{
		var result = [];
		for(productTags in ProductTag.manager.search($productId == id))
			result.push(productTags.getObject());
		Sys.print(haxe.Json.stringify(result));
	}
	@description("Return a product tag based on tag id")
	@param1("id : id of the tag")
	public function getProductTagsByTag(id : Int)
	{
		var result = [];
		for(productTags in ProductTag.manager.search($tagId == id))
			result.push(productTags.getObject());
		Sys.print(haxe.Json.stringify(result));
	}

	@description("Add a product tag in the database")
	@param1("productId : The id of the product")
	@param2("tagId : The id of the tag")
	@param3("score : The score")
	public function addProductTag(productId : String, tagId : String, score : String)
	{
		new ProductTag(Product.manager.get(Std.parseInt(productId)), Tag.manager.get(Std.parseInt(tagId)), Std.parseFloat(score)).insert();
		Sys.print(haxe.Json.stringify({success : true}));
	}

	/*
	 * USER FUNCTIONS
	 */

	@description("Get user tags")
	public function getUserTags()
	{
		if(!Session.exists("ratings"))
			Session.set("ratings", "{}");
		Sys.print(Session.get("ratings"));
	}

	@description("Rate a tag")
	@param1("tag : The tag to be rated")
	@param2("rating : the rating (-1 : Deny, 0 : Ignore, 1 : Accept)")
	public function rateTag(tag : String, rating : String)
	{
		if(!Session.exists("ratings"))
			Session.set("ratings", "{}");
		var ratings = haxe.Json.parse(Session.get("ratings"));
		Reflect.setField(ratings, tag, Std.parseInt(rating));
		Session.set("ratings", haxe.Json.stringify(ratings));
		
		Sys.print(haxe.Json.stringify({success : true}));
	}

	@description("Get products based on user ratings, null if none")
	private function getAvailProducts()
	{
		var res = new Array<Dynamic>();
		var userTags = haxe.Json.parse(Session.exists("ratings") ? Session.get("ratings") : "{}");

		for(product in Product.manager.all())
		{
			var factor = 0.0; 
			var productTags = ProductTag.manager.search($productId == product.id);
			for(productTag in productTags)
			{
				if(Reflect.hasField(userTags, productTag.tag.name))
				{
					switch(Reflect.field(userTags, productTag.tag.name))
					{
						case -1 : factor += 1-productTag.score;
						case 1 : factor += productTag.score;
						default : 0;
					}
				}
			}

			if(factor > 2.5)
				res.push(product.getObject());
		}
		if(res.length <= 0)
			Sys.print("null");
		else
			Sys.print(haxe.Json.stringify(res));
	}

	@description("Reset user ratings")
	private function resetUserRatings()
	{
		php.Session.clear();
	}

	@description("Init product database")
	public function initProducts()
	{
		addProduct("Asterix chez les pictes", "9.14", "http://ecx.images-amazon.com/images/I/51MrKJPb9gL._.jpg", "http://www.amazon.fr/Astérix-chez-Pictes-René-Goscinny/dp/2864972662");
		addProduct("Voyages en absurdie","15.11", "http://ecx.images-amazon.com/images/I/41C%2BV-n5RNL._SY445_.jpg", "http://www.amazon.fr/Voyages-en-absurdie-Stéphane-Groodt/dp/2259222463");
		addProduct("La femme parfaite est une connasse !","4.75", "http://ecx.images-amazon.com/images/I/51cXPHdA2kL._SY445_.jpg", "http://www.amazon.fr/femme-parfaite-est-une-connasse/dp/229005948X");
		addProduct("Au revoir là-haut","21.38","http://ecx.images-amazon.com/images/I/41w8yS8v-bL._BO2,204,203,200_PIsitb-sticker-arrow-click,TopRight,35,-76_SX342_SY445_CR,0,0,342,445_SH20_OU08_.jpg","http://www.amazon.fr/Au-revoir-là-haut-Prix-Goncourt/dp/2226249672");
		addProduct("Tablette Kindle Fire HD", "99.00", "http://g-ecx.images-amazon.com/images/G/08/kindle/dp/2012/KT/KT-slate-01-sm-v2._V381449839_.jpg", "http://www.amazon.fr/gp/product/B0083PWAWU/");
		addProduct("Kindle", "59.00", "http://g-ecx.images-amazon.com/images/G/08/kindle/dp/2012/KS/KS-slate-01-sm-vid._V402188781_.jpg", "http://www.amazon.fr/gp/product/B007HCCOD0");
		addProduct("Duracell - Chargeur rapide 45min + 2 Duralock AA 1300mAh + 2 Duralock AAA 750mAh", "14.13", "http://ecx.images-amazon.com/images/I/71o0WTD4DnL._SL1500_.jpg", "http://www.amazon.fr/Duracell-Chargeur-rapide-Duralock-1300mAh/dp/B008TYX7Z4");
		addProduct("Lexibook - MFC157FR - Jeu Électronique - Tablette - Tablet Master 2 - Version FR", "86.30", "http://ecx.images-amazon.com/images/I/81oHTe3JiSL._SL1500_.jpg", "http://www.amazon.fr/gp/product/B00CPENHB8");
		addProduct("Lexibook HP010 Casque Traditionnel Filaire", "9.00", "http://ecx.images-amazon.com/images/I/710rZXSEbLL._SL1500_.jpg", "http://www.amazon.fr/gp/product/B00AZ88KJU");
		addProduct("Lego Star Wars - 75018 - Jeu de Construction - Jek - 14's Stealth Starfighter", "51.74", "http://ecx.images-amazon.com/images/I/71iZf3y8bQL._SL1280_.jpg", "http://www.amazon.fr/gp/product/B00B0IILX4");
		addProduct("Playmobil - 4858 - Jeu de construction - Piscine avec toboggan", "28.49", "http://ecx.images-amazon.com/images/I/81hwH0n52UL._SL1500_.jpg", "http://www.amazon.fr/Playmobil-4858-construction-Piscine-toboggan/dp/B00324REN2");
		addProduct("Samsung Galaxy Trend GT-S7560 Smartphone Ecran tactile 4'' (10,2 cm) Android 4.0.4 Ice Cream Sandwich Bluetooth Wi-Fi Blanc", "132.90", "http://ecx.images-amazon.com/images/I/81DwiWOtSeL._SL1500_.jpg", "http://www.amazon.fr/Samsung-Galaxy-Trend-Smartphone-Bluetooth/dp/B00DM2GN6S");
		addProduct("Wiko Cink Peax 2 Smartphone USB Android 4.1.2 Jelly Bean Blanc", "151.90", "http://ecx.images-amazon.com/images/I/81Qp5jKqLWL._SL1500_.jpg", "http://www.amazon.fr/Wiko-Smartphone-Android-4-1-2-Jelly/dp/B00EBZMOYK");
		addProduct("Samsung Galaxy S4 Smartphone 4,99'' 16 Go Android 4.2 (JB) Noir"," 475.95", "http://ecx.images-amazon.com/images/I/81zlu5qyR-L._SL1500_.jpg", "http://www.amazon.fr/Samsung-Galaxy-Smartphone-Android-Noir/dp/B00C3GBRRO");
		addProduct("SanDisk SDCZ33-032G-B35 Cruzer Fit clé USB 32Go Noir", "18.99", "http://ecx.images-amazon.com/images/I/719qrEaDaIL._SL1500_.jpg", "http://www.amazon.fr/gp/product/B00812F7O8");
		addProduct("7MM Bague Tungstene \"Seigneur des Anneaux 'LORD OF THE RINGS' Plaque D' or Taille 63", "19.99", "http://ecx.images-amazon.com/images/I/41wMb-x4hfL._SY395_.jpg", "http://www.amazon.fr/Tungstene-Seigneur-Anneaux-Plaque-Taille/dp/B007KPLGOC");
		addProduct("Anneau Hommes - Cléopâtre - or jaune 18 carats 750/1000 Taille - /56", "4297.00", "http://ecx.images-amazon.com/images/I/51KTGkpUF%2BL._SY395_.jpg", "http://www.amazon.fr/Anneau-Hommes-Cléopâtre-jaune-carats-750-Taille/dp/B007JL2ZJ2");
		addProduct("Nikon D3200 Kit Reflex 24,2 Mpix Noir + Objectif AF-S DX 18-55 mm VR", "398.90", "http://ecx.images-amazon.com/images/I/91c-hHhsafL._SL1500_.jpg", "http://www.amazon.fr/Nikon-D3200-Reflex-Objectif-18-55/dp/B007VBGTX8");
		addProduct("Toshiba 24W1333G TV LCD 24 (\"61 cm) LED HDTV 1080p 50 Hz 1 HDMI 2 USB Classe: A", "179.00", "http://ecx.images-amazon.com/images/I/5109zI0IRUL.jpg", "http://www.amazon.fr/Toshiba-24W1333G-HDTV-1080p-Classe/dp/B00BB9VC42");
		addProduct("TomTom XL Classic Europe 23 (1ET0.054.22)", "93.10", "http://ecx.images-amazon.com/images/I/71sLmqeFcdL._SL1500_.jpg", "http://www.amazon.fr/TomTom-XL-Classic-Europe-1ET0-054-22/dp/B008RJPXRQ");
		addProduct("Diesel manteau WERON homme veste d`hiver blouson parka", "149.90", "http://ecx.images-amazon.com/images/I/41TPNE1mcEL._SY445_.jpg", "http://www.amazon.fr/Diesel-manteau-WERON-d`hiver-blouson/dp/B00FQGOXFQ");
		addProduct("Morgan 132-1Eifel.A, Escarpins femme", "84.99", "http://ecx.images-amazon.com/images/I/41Ve5qT-P4L._SS45_.jpg", "http://www.amazon.fr/Morgan-132-1Eifel-A-Escarpins-femme-Noir/dp/B00CZCEBQU");
		addProduct("Ted Lapidus - D0460RBPW - Montre Femme - Quartz Analogique - Cadran Blanc - Bracelet Acier Argent", "89.90", "http://ecx.images-amazon.com/images/I/41uEhiNLXGL._SX32_SY45_CR,0,0,32,45_.jpg", "http://www.amazon.fr/Ted-Lapidus-D0460RBPW-Analogique-Bracelet/dp/B003JBIZOU");
		addProduct("Console PlayStation 4", "399.00", "http://ecx.images-amazon.com/images/I/61Tgs1T1fxL._SL1425_.jpg", "http://www.amazon.fr/Sony-Ps4-Console-0711719268475-PlayStation/dp/B00BIYAO3K");
	}

	private function initProductTags()
	{
		addProductTag("14", "14", "0.096976348");
		addProductTag("14", "9", "0.392418758");
		addProductTag("14", "10", "0.073798042");
		addProductTag("14", "11", "0.819092503");
		addProductTag("14", "12", "0.568703051");
		addProductTag("14", "17", "0.253672762");
		addProductTag("14", "19", "0.692809364");
		addProductTag("14", "20", "0.267169752");
		addProductTag("14", "21", "0.094270849");
		addProductTag("14", "22", "0.797215931");
		addProductTag("14", "23", "0.603538938");
		addProductTag("14", "24", "0.518479273");
		addProductTag("14", "25", "0.774241959");
		addProductTag("14", "27", "0.429646837");
		addProductTag("14", "28", "0.082260113");
		addProductTag("14", "29", "0.623339417");
		addProductTag("14", "30", "0.122306368");
		addProductTag("14", "31", "0.023181609");
		addProductTag("14", "33", "0.74331645");
		addProductTag("14", "34", "0.833224687");
		addProductTag("14", "35", "0.159459236");
		addProductTag("14", "36", "0.460067639");
		addProductTag("14", "38", "0.018648606");
		addProductTag("14", "40", "0.880147912");
		addProductTag("14", "42", "0.109616871");
		addProductTag("14", "43", "0.403255239");
		addProductTag("14", "41", "0.358265511");
		addProductTag("14", "44", "0.58371821");
		addProductTag("14", "45", "0.928749768");
		addProductTag("14", "46", "0.35649638");
		addProductTag("14", "47", "0.819131544");
		addProductTag("14", "49", "0.119799093");
		addProductTag("14", "50", "0.026499874");
		addProductTag("14", "51", "0.313865913");
		addProductTag("14", "52", "0.106227101");
		addProductTag("14", "53", "0.384549961");
		addProductTag("14", "54", "0.908449924");
		addProductTag("14", "55", "0.610674902");
		addProductTag("14", "56", "0.90076249");
		addProductTag("14", "57", "0.692903312");
		addProductTag("14", "59", "0.949775196");
		addProductTag("14", "60", "0.51229766");
		addProductTag("14", "61", "0.899798312");
		addProductTag("14", "62", "0.854331406");
		addProductTag("14", "63", "0.807832952");
		addProductTag("4", "14", "0.944513027");
		addProductTag("4", "9", "0.317463267");
		addProductTag("4", "10", "0.554119947");
		addProductTag("4", "11", "0.616382507");
		addProductTag("4", "12", "0.460176223");
		addProductTag("4", "17", "0.987905426");
		addProductTag("4", "19", "0.633194458");
		addProductTag("4", "20", "0.05601381");
		addProductTag("4", "21", "0.711159069");
		addProductTag("4", "22", "0.822587879");
		addProductTag("4", "23", "0.757697717");
		addProductTag("4", "24", "0.712442328");
		addProductTag("4", "25", "0.918516052");
		addProductTag("4", "27", "0.883410258");
		addProductTag("4", "28", "0.071224695");
		addProductTag("4", "29", "0.975079906");
		addProductTag("4", "30", "0.306331117");
		addProductTag("4", "31", "0.092397621");
		addProductTag("4", "33", "0.260953268");
		addProductTag("4", "34", "0.808278045");
		addProductTag("4", "35", "0.821609977");
		addProductTag("4", "36", "0.149048975");
		addProductTag("4", "38", "0.489130125");
		addProductTag("4", "40", "0.905936508");
		addProductTag("4", "42", "0.717581137");
		addProductTag("4", "43", "0.43996425");
		addProductTag("4", "41", "0.466668767");
		addProductTag("4", "44", "0.186926386");
		addProductTag("4", "45", "0.896280332");
		addProductTag("4", "46", "0.573896688");
		addProductTag("4", "47", "0.278142482");
		addProductTag("4", "49", "0.855087922");
		addProductTag("4", "50", "0.810030634");
		addProductTag("4", "51", "0.374107783");
		addProductTag("4", "52", "0.206628252");
		addProductTag("4", "53", "0.330749841");
		addProductTag("4", "54", "0.281406838");
		addProductTag("4", "55", "0.487800162");
		addProductTag("4", "56", "0.078737459");
		addProductTag("4", "57", "0.940030676");
		addProductTag("4", "59", "0.8981149");
		addProductTag("4", "60", "0.391091636");
		addProductTag("4", "61", "0.846700609");
		addProductTag("4", "62", "0.254868664");
		addProductTag("4", "63", "0.254542391");
		addProductTag("5", "14", "0.412415258");
		addProductTag("5", "9", "0.827446504");
		addProductTag("5", "10", "0.235487265");
		addProductTag("5", "11", "0.780344382");
		addProductTag("5", "12", "0.36097226");
		addProductTag("5", "17", "0.351269192");
		addProductTag("5", "19", "0.859498314");
		addProductTag("5", "20", "0.302696541");
		addProductTag("5", "21", "0.550956222");
		addProductTag("5", "22", "0.149474148");
		addProductTag("5", "23", "0.47310561");
		addProductTag("5", "24", "0.15489164");
		addProductTag("5", "25", "0.735521016");
		addProductTag("5", "27", "0.640644837");
		addProductTag("5", "28", "0.973735045");
		addProductTag("5", "29", "0.568493772");
		addProductTag("5", "30", "0.538028726");
		addProductTag("5", "31", "0.620336189");
		addProductTag("5", "33", "0.414513215");
		addProductTag("5", "34", "0.034949809");
		addProductTag("5", "35", "0.742845987");
		addProductTag("5", "36", "0.611768725");
		addProductTag("5", "38", "0.38259256");
		addProductTag("5", "40", "0.673381779");
		addProductTag("5", "42", "0.618637893");
		addProductTag("5", "43", "0.97022788");
		addProductTag("5", "41", "0.407016184");
		addProductTag("5", "44", "0.626063769");
		addProductTag("5", "45", "0.274741739");
		addProductTag("5", "46", "0.807638175");
		addProductTag("5", "47", "0.683905539");
		addProductTag("5", "49", "0.808322547");
		addProductTag("5", "50", "0.410001237");
		addProductTag("5", "51", "0.601550479");
		addProductTag("5", "52", "0.657361188");
		addProductTag("5", "53", "0.509647872");
		addProductTag("5", "54", "0.059911558");
		addProductTag("5", "55", "0.759467787");
		addProductTag("5", "56", "0.238490686");
		addProductTag("5", "57", "0.135993557");
		addProductTag("5", "59", "0.558427183");
		addProductTag("5", "60", "0.511718742");
		addProductTag("5", "61", "0.163107216");
		addProductTag("5", "62", "0.607464253");
		addProductTag("5", "63", "0.776922489");
		addProductTag("6", "14", "0.101431026");
		addProductTag("6", "9", "0.384056644");
		addProductTag("6", "10", "0.432048084");
		addProductTag("6", "11", "0.587509777");
		addProductTag("6", "12", "0.359917545");
		addProductTag("6", "17", "0.372587839");
		addProductTag("6", "19", "0.517594979");
		addProductTag("6", "20", "0.324835284");
		addProductTag("6", "21", "0.640414823");
		addProductTag("6", "22", "0.021778756");
		addProductTag("6", "23", "0.501272111");
		addProductTag("6", "24", "0.235046964");
		addProductTag("6", "25", "0.327623471");
		addProductTag("6", "27", "0.035073684");
		addProductTag("6", "28", "0.087484196");
		addProductTag("6", "29", "0.495444139");
		addProductTag("6", "30", "0.680312776");
		addProductTag("6", "31", "0.240546128");
		addProductTag("6", "33", "0.980337154");
		addProductTag("6", "34", "0.365721826");
		addProductTag("6", "35", "0.706195581");
		addProductTag("6", "36", "0.213437719");
		addProductTag("6", "38", "0.288144832");
		addProductTag("6", "40", "0.351057462");
		addProductTag("6", "42", "0.35461882");
		addProductTag("6", "43", "0.575777378");
		addProductTag("6", "41", "0.578848284");
		addProductTag("6", "44", "0.468862591");
		addProductTag("6", "45", "0.797244875");
		addProductTag("6", "46", "0.347459362");
		addProductTag("6", "47", "0.207388317");
		addProductTag("6", "49", "0.242941491");
		addProductTag("6", "50", "0.737388962");
		addProductTag("6", "51", "0.20462164");
		addProductTag("6", "52", "0.428941335");
		addProductTag("6", "53", "0.354813205");
		addProductTag("6", "54", "0.776310992");
		addProductTag("6", "55", "0.362109533");
		addProductTag("6", "56", "0.849475278");
		addProductTag("6", "57", "0.546564417");
		addProductTag("6", "59", "0.558584604");
		addProductTag("6", "60", "0.444771593");
		addProductTag("6", "61", "0.971921105");
		addProductTag("6", "62", "0.856673193");
		addProductTag("6", "63", "0.30908504");
		addProductTag("7", "14", "0.386394839");
		addProductTag("7", "9", "0.232052624");
		addProductTag("7", "10", "0.749896937");
		addProductTag("7", "11", "0.617336246");
		addProductTag("7", "12", "0.829317095");
		addProductTag("7", "17", "0.773018366");
		addProductTag("7", "19", "0.752182775");
		addProductTag("7", "20", "0.232998537");
		addProductTag("7", "21", "0.947821337");
		addProductTag("7", "22", "0.232972508");
		addProductTag("7", "23", "0.327177177");
		addProductTag("7", "24", "0.482201424");
		addProductTag("7", "25", "0.030930365");
		addProductTag("7", "27", "0.926723583");
		addProductTag("7", "28", "0.054435539");
		addProductTag("7", "29", "0.063270146");
		addProductTag("7", "30", "0.762435363");
		addProductTag("7", "31", "0.596489307");
		addProductTag("7", "33", "0.559092923");
		addProductTag("7", "34", "0.383075031");
		addProductTag("7", "35", "0.173288026");
		addProductTag("7", "36", "0.814356104");
		addProductTag("7", "38", "0.831922234");
		addProductTag("7", "40", "0.648537605");
		addProductTag("7", "42", "0.212438136");
		addProductTag("7", "43", "0.563588768");
		addProductTag("7", "41", "0.231342758");
		addProductTag("7", "44", "0.669276033");
		addProductTag("7", "45", "0.972427961");
		addProductTag("7", "46", "0.821745365");
		addProductTag("7", "47", "0.7243868");
		addProductTag("7", "49", "0.620442549");
		addProductTag("7", "50", "0.622142555");
		addProductTag("7", "51", "0.00909259");
		addProductTag("7", "52", "0.748888991");
		addProductTag("7", "53", "0.877509107");
		addProductTag("7", "54", "0.542646294");
		addProductTag("7", "55", "0.380993662");
		addProductTag("7", "56", "0.269530568");
		addProductTag("7", "57", "0.139807137");
		addProductTag("7", "59", "0.620215617");
		addProductTag("7", "60", "0.519198771");
		addProductTag("7", "61", "0.089573551");
		addProductTag("7", "62", "0.870070118");
		addProductTag("7", "63", "0.273366905");
		addProductTag("8", "14", "0.297304247");
		addProductTag("8", "9", "0.615681768");
		addProductTag("8", "10", "0.37170705");
		addProductTag("8", "11", "0.640342978");
		addProductTag("8", "12", "0.017751226");
		addProductTag("8", "17", "0.529063326");
		addProductTag("8", "19", "0.630881159");
		addProductTag("8", "20", "0.477819164");
		addProductTag("8", "21", "0.877067012");
		addProductTag("8", "22", "0.852161306");
		addProductTag("8", "23", "0.066485111");
		addProductTag("8", "24", "0.054795014");
		addProductTag("8", "25", "0.864666605");
		addProductTag("8", "27", "0.410990325");
		addProductTag("8", "28", "0.212529095");
		addProductTag("8", "29", "0.126117873");
		addProductTag("8", "30", "0.881310884");
		addProductTag("8", "31", "0.897258382");
		addProductTag("8", "33", "0.810003692");
		addProductTag("8", "34", "0.315600102");
		addProductTag("8", "35", "0.737960612");
		addProductTag("8", "36", "0.279437334");
		addProductTag("8", "38", "0.926080197");
		addProductTag("8", "40", "0.330926306");
		addProductTag("8", "42", "0.426953681");
		addProductTag("8", "43", "0.384234622");
		addProductTag("8", "41", "0.204465546");
		addProductTag("8", "44", "0.346806279");
		addProductTag("8", "45", "0.667394607");
		addProductTag("8", "46", "0.61997371");
		addProductTag("8", "47", "0.861754075");
		addProductTag("8", "49", "0.36679521");
		addProductTag("8", "50", "0.300943942");
		addProductTag("8", "51", "0.295966164");
		addProductTag("8", "52", "0.297572027");
		addProductTag("8", "53", "0.788123692");
		addProductTag("8", "54", "0.083131307");
		addProductTag("8", "55", "0.061619877");
		addProductTag("8", "56", "0.524830776");
		addProductTag("8", "57", "0.641529245");
		addProductTag("8", "59", "0.960608105");
		addProductTag("8", "60", "0.085861145");
		addProductTag("8", "61", "0.476535646");
		addProductTag("8", "62", "0.500629855");
		addProductTag("8", "63", "0.082678821");
		addProductTag("9", "14", "0.515113544");
		addProductTag("9", "9", "0.402227069");
		addProductTag("9", "10", "0.325111684");
		addProductTag("9", "11", "0.145096252");
		addProductTag("9", "12", "0.514447991");
		addProductTag("9", "17", "0.579592532");
		addProductTag("9", "19", "0.498374641");
		addProductTag("9", "20", "0.635160093");
		addProductTag("9", "21", "0.558468865");
		addProductTag("9", "22", "0.838577502");
		addProductTag("9", "23", "0.669341871");
		addProductTag("9", "24", "0.922531593");
		addProductTag("9", "25", "0.989406955");
		addProductTag("9", "27", "0.028288319");
		addProductTag("9", "28", "0.511784657");
		addProductTag("9", "29", "0.289880928");
		addProductTag("9", "30", "0.436760453");
		addProductTag("9", "31", "0.584256663");
		addProductTag("9", "33", "0.931744455");
		addProductTag("9", "34", "0.824198742");
		addProductTag("9", "35", "0.516217264");
		addProductTag("9", "36", "0.840924524");
		addProductTag("9", "38", "0.266982466");
		addProductTag("9", "40", "0.068167667");
		addProductTag("9", "42", "0.510111997");
		addProductTag("9", "43", "0.927716921");
		addProductTag("9", "41", "0.597541079");
		addProductTag("9", "44", "0.687930747");
		addProductTag("9", "45", "0.162163729");
		addProductTag("9", "46", "0.454555");
		addProductTag("9", "47", "0.235892451");
		addProductTag("9", "49", "0.475842248");
		addProductTag("9", "50", "0.844398145");
		addProductTag("9", "51", "0.423452353");
		addProductTag("9", "52", "0.908486905");
		addProductTag("9", "53", "0.022133326");
		addProductTag("9", "54", "0.225806547");
		addProductTag("9", "55", "0.77890122");
		addProductTag("9", "56", "0.997365759");
		addProductTag("9", "57", "0.591312356");
		addProductTag("9", "59", "0.377555383");
		addProductTag("9", "60", "0.950414323");
		addProductTag("9", "61", "0.794028483");
		addProductTag("9", "62", "0.166471454");
		addProductTag("9", "63", "0.709344788");
		addProductTag("10", "14", "0.622847144");
		addProductTag("10", "9", "0.20331512");
		addProductTag("10", "10", "0.667042712");
		addProductTag("10", "11", "0.765161253");
		addProductTag("10", "12", "0.077404967");
		addProductTag("10", "17", "0.80142519");
		addProductTag("10", "19", "0.842131856");
		addProductTag("10", "20", "0.437934703");
		addProductTag("10", "21", "0.07752046");
		addProductTag("10", "22", "0.952680511");
		addProductTag("10", "23", "0.359464966");
		addProductTag("10", "24", "0.816489339");
		addProductTag("10", "25", "0.544498889");
		addProductTag("10", "27", "0.919350764");
		addProductTag("10", "28", "0.168421724");
		addProductTag("10", "29", "0.272814955");
		addProductTag("10", "30", "0.261937073");
		addProductTag("10", "31", "0.842712759");
		addProductTag("10", "33", "0.832909632");
		addProductTag("10", "34", "0.137581711");
		addProductTag("10", "35", "0.109327877");
		addProductTag("10", "36", "0.24777223");
		addProductTag("10", "38", "0.151684227");
		addProductTag("10", "40", "0.455637489");
		addProductTag("10", "42", "0.375642692");
		addProductTag("10", "43", "0.512593008");
		addProductTag("10", "41", "0.865924298");
		addProductTag("10", "44", "0.465007566");
		addProductTag("10", "45", "0.777677188");
		addProductTag("10", "46", "0.967598991");
		addProductTag("10", "47", "0.051109997");
		addProductTag("10", "49", "0.227365068");
		addProductTag("10", "50", "0.108324605");
		addProductTag("10", "51", "0.737153379");
		addProductTag("10", "52", "0.424265537");
		addProductTag("10", "53", "0.605487871");
		addProductTag("10", "54", "0.567552938");
		addProductTag("10", "55", "0.459985629");
		addProductTag("10", "56", "0.35375648");
		addProductTag("10", "57", "0.966672263");
		addProductTag("10", "59", "0.655915898");
		addProductTag("10", "60", "0.164399372");
		addProductTag("10", "61", "0.336169209");
		addProductTag("10", "62", "0.834252826");
		addProductTag("10", "63", "0.658260217");
		addProductTag("11", "14", "0.254268816");
		addProductTag("11", "9", "0.198546593");
		addProductTag("11", "10", "0.912144193");
		addProductTag("11", "11", "0.580823321");
		addProductTag("11", "12", "0.038229926");
		addProductTag("11", "17", "0.415907544");
		addProductTag("11", "19", "0.874805513");
		addProductTag("11", "20", "0.159015508");
		addProductTag("11", "21", "0.352973464");
		addProductTag("11", "22", "0.245973416");
		addProductTag("11", "23", "0.923823601");
		addProductTag("11", "24", "0.728022458");
		addProductTag("11", "25", "0.83589951");
		addProductTag("11", "27", "0.435202059");
		addProductTag("11", "28", "0.691496094");
		addProductTag("11", "29", "0.050376831");
		addProductTag("11", "30", "0.496808808");
		addProductTag("11", "31", "0.709148956");
		addProductTag("11", "33", "0.238768613");
		addProductTag("11", "34", "0.469961124");
		addProductTag("11", "35", "0.21765496");
		addProductTag("11", "36", "0.145585952");
		addProductTag("11", "38", "0.140916064");
		addProductTag("11", "40", "0.5996042");
		addProductTag("11", "42", "0.789430517");
		addProductTag("11", "43", "0.008688873");
		addProductTag("11", "41", "0.550168275");
		addProductTag("11", "44", "0.11479457");
		addProductTag("11", "45", "0.457400476");
		addProductTag("11", "46", "0.03644152");
		addProductTag("11", "47", "0.865972776");
		addProductTag("11", "49", "0.286368824");
		addProductTag("11", "50", "0.917999874");
		addProductTag("11", "51", "0.99487241");
		addProductTag("11", "52", "0.7301038");
		addProductTag("11", "53", "0.340928331");
		addProductTag("11", "54", "0.24215171");
		addProductTag("11", "55", "0.131011989");
		addProductTag("11", "56", "0.67543276");
		addProductTag("11", "57", "0.519091031");
		addProductTag("11", "59", "0.951256666");
		addProductTag("11", "60", "0.600344709");
		addProductTag("11", "61", "0.790392267");
		addProductTag("11", "62", "0.974213435");
		addProductTag("11", "63", "0.152926018");
		addProductTag("12", "14", "0.310747491");
		addProductTag("12", "9", "0.859249805");
		addProductTag("12", "10", "0.914116607");
		addProductTag("12", "11", "0.100653859");
		addProductTag("12", "12", "0.888561094");
		addProductTag("12", "17", "0.992052544");
		addProductTag("12", "19", "0.76844198");
		addProductTag("12", "20", "0.423311084");
		addProductTag("12", "21", "0.279541374");
		addProductTag("12", "22", "0.358477909");
		addProductTag("12", "23", "0.22671519");
		addProductTag("12", "24", "0.533263528");
		addProductTag("12", "25", "0.91768484");
		addProductTag("12", "27", "0.125192986");
		addProductTag("12", "28", "0.434863113");
		addProductTag("12", "29", "0.71576151");
		addProductTag("12", "30", "0.44497785");
		addProductTag("12", "31", "0.112488176");
		addProductTag("12", "33", "0.421328202");
		addProductTag("12", "34", "0.658273542");
		addProductTag("12", "35", "0.387963394");
		addProductTag("12", "36", "0.510105478");
		addProductTag("12", "38", "0.638068286");
		addProductTag("12", "40", "0.271488807");
		addProductTag("12", "42", "0.044921249");
		addProductTag("12", "43", "0.247144207");
		addProductTag("12", "41", "0.666018368");
		addProductTag("12", "44", "0.299701762");
		addProductTag("12", "45", "0.443246895");
		addProductTag("12", "46", "0.56388169");
		addProductTag("12", "47", "0.986731644");
		addProductTag("12", "49", "0.983462848");
		addProductTag("12", "50", "0.664965751");
		addProductTag("12", "51", "0.950155099");
		addProductTag("12", "52", "0.120450352");
		addProductTag("12", "53", "0.281150295");
		addProductTag("12", "54", "0.567631178");
		addProductTag("12", "55", "0.305807614");
		addProductTag("12", "56", "0.52386431");
		addProductTag("12", "57", "0.285689204");
		addProductTag("12", "59", "0.093108842");
		addProductTag("12", "60", "0.326433118");
		addProductTag("12", "61", "0.343195436");
		addProductTag("12", "62", "0.758302689");
		addProductTag("12", "63", "0.575400652");
		addProductTag("13", "14", "0.515427158");
		addProductTag("13", "9", "0.341135381");
		addProductTag("13", "10", "0.752635435");
		addProductTag("13", "11", "0.147779057");
		addProductTag("13", "12", "0.402416358");
		addProductTag("13", "17", "0.186289149");
		addProductTag("13", "19", "0.014873678");
		addProductTag("13", "20", "0.188371546");
		addProductTag("13", "21", "0.002159201");
		addProductTag("13", "22", "0.035379229");
		addProductTag("13", "23", "0.951921645");
		addProductTag("13", "24", "0.617568673");
		addProductTag("13", "25", "0.187091587");
		addProductTag("13", "27", "0.276224868");
		addProductTag("13", "28", "0.14935608");
		addProductTag("13", "29", "0.350770188");
		addProductTag("13", "30", "0.37155469");
		addProductTag("13", "31", "0.980508446");
		addProductTag("13", "33", "0.594503212");
		addProductTag("13", "34", "0.438287062");
		addProductTag("13", "35", "0.953410073");
		addProductTag("13", "36", "0.207538418");
		addProductTag("13", "38", "0.086492684");
		addProductTag("13", "40", "0.359202559");
		addProductTag("13", "42", "0.582651369");
		addProductTag("13", "43", "0.490505631");
		addProductTag("13", "41", "0.69735925");
		addProductTag("13", "44", "0.565606644");
		addProductTag("13", "45", "0.609562491");
		addProductTag("13", "46", "0.183536207");
		addProductTag("13", "47", "0.212808117");
		addProductTag("13", "49", "0.326787326");
		addProductTag("13", "50", "0.935138856");
		addProductTag("13", "51", "0.62437542");
		addProductTag("13", "52", "0.388345212");
		addProductTag("13", "53", "0.852444278");
		addProductTag("13", "54", "0.863399365");
		addProductTag("13", "55", "0.258297047");
		addProductTag("13", "56", "0.226995331");
		addProductTag("13", "57", "0.910105883");
		addProductTag("13", "59", "0.031893389");
		addProductTag("13", "60", "0.954523455");
		addProductTag("13", "61", "0.651857304");
		addProductTag("13", "62", "0.98567646");
		addProductTag("13", "63", "0.62311475");
		addProductTag("14", "14", "0.819605846");
		addProductTag("14", "9", "0.515635069");
		addProductTag("14", "10", "0.197399703");
		addProductTag("14", "11", "0.103997714");
		addProductTag("14", "12", "0.934761317");
		addProductTag("14", "17", "0.071729986");
		addProductTag("14", "19", "0.957822945");
		addProductTag("14", "20", "0.858732285");
		addProductTag("14", "21", "0.268277134");
		addProductTag("14", "22", "0.523596978");
		addProductTag("14", "23", "0.981395962");
		addProductTag("14", "24", "0.134862718");
		addProductTag("14", "25", "0.016689889");
		addProductTag("14", "27", "0.88425485");
		addProductTag("14", "28", "0.585657342");
		addProductTag("14", "29", "0.540764909");
		addProductTag("14", "30", "0.191594916");
		addProductTag("14", "31", "0.816879253");
		addProductTag("14", "33", "0.800944248");
		addProductTag("14", "34", "0.495245873");
		addProductTag("14", "35", "0.851694477");
		addProductTag("14", "36", "0.56744023");
		addProductTag("14", "38", "0.497922306");
		addProductTag("14", "40", "0.031790179");
		addProductTag("14", "42", "0.919741441");
		addProductTag("14", "43", "0.432884298");
		addProductTag("14", "41", "0.796801876");
		addProductTag("14", "44", "0.804382379");
		addProductTag("14", "45", "0.58356109");
		addProductTag("14", "46", "0.91412294");
		addProductTag("14", "47", "0.771860413");
		addProductTag("14", "49", "0.207875725");
		addProductTag("14", "50", "0.557292833");
		addProductTag("14", "51", "0.45284569");
		addProductTag("14", "52", "0.752258677");
		addProductTag("14", "53", "0.917005018");
		addProductTag("14", "54", "0.127624987");
		addProductTag("14", "55", "0.789909966");
		addProductTag("14", "56", "0.949297542");
		addProductTag("14", "57", "0.843988506");
		addProductTag("14", "59", "0.684124777");
		addProductTag("14", "60", "0.336485067");
		addProductTag("14", "61", "0.98717926");
		addProductTag("14", "62", "0.303774034");
		addProductTag("14", "63", "0.652761453");
		addProductTag("15", "14", "0.345808468");
		addProductTag("15", "9", "0.052719087");
		addProductTag("15", "10", "0.437029532");
		addProductTag("15", "11", "0.686444813");
		addProductTag("15", "12", "0.150607876");
		addProductTag("15", "17", "0.375503038");
		addProductTag("15", "19", "0.397584064");
		addProductTag("15", "20", "0.448881356");
		addProductTag("15", "21", "0.766643626");
		addProductTag("15", "22", "0.666017153");
		addProductTag("15", "23", "0.337725947");
		addProductTag("15", "24", "0.764503018");
		addProductTag("15", "25", "0.080429029");
		addProductTag("15", "27", "0.210069816");
		addProductTag("15", "28", "0.194154733");
		addProductTag("15", "29", "0.185842424");
		addProductTag("15", "30", "0.064476852");
		addProductTag("15", "31", "0.450666486");
		addProductTag("15", "33", "0.373791035");
		addProductTag("15", "34", "0.237539401");
		addProductTag("15", "35", "0.864052165");
		addProductTag("15", "36", "0.06155787");
		addProductTag("15", "38", "0.629175866");
		addProductTag("15", "40", "0.225509214");
		addProductTag("15", "42", "0.223575412");
		addProductTag("15", "43", "0.889407841");
		addProductTag("15", "41", "0.772403404");
		addProductTag("15", "44", "0.844170216");
		addProductTag("15", "45", "0.947759659");
		addProductTag("15", "46", "0.737510936");
		addProductTag("15", "47", "0.047859592");
		addProductTag("15", "49", "0.750581919");
		addProductTag("15", "50", "0.057672768");
		addProductTag("15", "51", "0.680244731");
		addProductTag("15", "52", "0.27455681");
		addProductTag("15", "53", "0.825862547");
		addProductTag("15", "54", "0.987106779");
		addProductTag("15", "55", "0.797867149");
		addProductTag("15", "56", "0.075921838");
		addProductTag("15", "57", "0.330048375");
		addProductTag("15", "59", "0.762199827");
		addProductTag("15", "60", "0.392436952");
		addProductTag("15", "61", "0.239683404");
		addProductTag("15", "62", "0.695250298");
		addProductTag("15", "63", "0.154353576");
		addProductTag("16", "14", "0.036403419");
		addProductTag("16", "9", "0.476078499");
		addProductTag("16", "10", "0.759274773");
		addProductTag("16", "11", "0.060514088");
		addProductTag("16", "12", "0.516562682");
		addProductTag("16", "17", "0.647405486");
		addProductTag("16", "19", "0.367580361");
		addProductTag("16", "20", "0.058132575");
		addProductTag("16", "21", "0.909069732");
		addProductTag("16", "22", "0.036362093");
		addProductTag("16", "23", "0.164917518");
		addProductTag("16", "24", "0.670784136");
		addProductTag("16", "25", "0.997910605");
		addProductTag("16", "27", "0.258701418");
		addProductTag("16", "28", "0.13946673");
		addProductTag("16", "29", "0.665372607");
		addProductTag("16", "30", "0.175886846");
		addProductTag("16", "31", "0.371106943");
		addProductTag("16", "33", "0.655639466");
		addProductTag("16", "34", "0.510593496");
		addProductTag("16", "35", "0.531535116");
		addProductTag("16", "36", "0.262069935");
		addProductTag("16", "38", "0.692923137");
		addProductTag("16", "40", "0.880000151");
		addProductTag("16", "42", "0.61830317");
		addProductTag("16", "43", "0.084774632");
		addProductTag("16", "41", "0.204385518");
		addProductTag("16", "44", "0.217000847");
		addProductTag("16", "45", "0.846548312");
		addProductTag("16", "46", "0.829316228");
		addProductTag("16", "47", "0.503617286");
		addProductTag("16", "49", "0.151637701");
		addProductTag("16", "50", "0.92990945");
		addProductTag("16", "51", "0.081909003");
		addProductTag("16", "52", "0.302207198");
		addProductTag("16", "53", "0.2622529");
		addProductTag("16", "54", "0.789379745");
		addProductTag("16", "55", "0.211359163");
		addProductTag("16", "56", "0.118538244");
		addProductTag("16", "57", "0.318862569");
		addProductTag("16", "59", "0.752295892");
		addProductTag("16", "60", "0.303255309");
		addProductTag("16", "61", "0.430802063");
		addProductTag("16", "62", "0.043060552");
		addProductTag("16", "63", "0.426063839");
		addProductTag("17", "14", "0.454916236");
		addProductTag("17", "9", "0.29450939");
		addProductTag("17", "10", "0.490904253");
		addProductTag("17", "11", "0.402543725");
		addProductTag("17", "12", "0.552042309");
		addProductTag("17", "17", "0.535525787");
		addProductTag("17", "19", "0.099864364");
		addProductTag("17", "20", "0.933139348");
		addProductTag("17", "21", "0.011328818");
		addProductTag("17", "22", "0.639977783");
		addProductTag("17", "23", "0.921286922");
		addProductTag("17", "24", "0.092290644");
		addProductTag("17", "25", "0.310994958");
		addProductTag("17", "27", "0.517207642");
		addProductTag("17", "28", "0.745048484");
		addProductTag("17", "29", "0.9378457");
		addProductTag("17", "30", "0.79249559");
		addProductTag("17", "31", "0.480023608");
		addProductTag("17", "33", "0.917015084");
		addProductTag("17", "34", "0.754677708");
		addProductTag("17", "35", "0.609425715");
		addProductTag("17", "36", "0.009081384");
		addProductTag("17", "38", "0.891733992");
		addProductTag("17", "40", "0.159370377");
		addProductTag("17", "42", "0.821635095");
		addProductTag("17", "43", "0.280697392");
		addProductTag("17", "41", "0.256281072");
		addProductTag("17", "44", "0.564716796");
		addProductTag("17", "45", "0.83304524");
		addProductTag("17", "46", "0.420493175");
		addProductTag("17", "47", "0.270208098");
		addProductTag("17", "49", "0.024079007");
		addProductTag("17", "50", "0.459271865");
		addProductTag("17", "51", "0.318502506");
		addProductTag("17", "52", "0.564486918");
		addProductTag("17", "53", "0.855717062");
		addProductTag("17", "54", "0.115341019");
		addProductTag("17", "55", "0.693062663");
		addProductTag("17", "56", "0.018046845");
		addProductTag("17", "57", "0.571624595");
		addProductTag("17", "59", "0.403357943");
		addProductTag("17", "60", "0.221380043");
		addProductTag("17", "61", "0.908264175");
		addProductTag("17", "62", "0.146601737");
		addProductTag("17", "63", "0.503383168");
		addProductTag("18", "14", "0.05798888");
		addProductTag("18", "9", "0.045737723");
		addProductTag("18", "10", "0.752627065");
		addProductTag("18", "11", "0.085849101");
		addProductTag("18", "12", "0.430549547");
		addProductTag("18", "17", "0.460416996");
		addProductTag("18", "19", "0.059524771");
		addProductTag("18", "20", "0.263347001");
		addProductTag("18", "21", "0.413636534");
		addProductTag("18", "22", "0.740237206");
		addProductTag("18", "23", "0.824318472");
		addProductTag("18", "24", "0.369388747");
		addProductTag("18", "25", "0.009552175");
		addProductTag("18", "27", "0.100024667");
		addProductTag("18", "28", "0.124691812");
		addProductTag("18", "29", "0.427815804");
		addProductTag("18", "30", "0.98954993");
		addProductTag("18", "31", "0.0916114");
		addProductTag("18", "33", "0.367488864");
		addProductTag("18", "34", "0.514075806");
		addProductTag("18", "35", "0.567426736");
		addProductTag("18", "36", "0.192385736");
		addProductTag("18", "38", "0.509187778");
		addProductTag("18", "40", "0.666887602");
		addProductTag("18", "42", "0.427751882");
		addProductTag("18", "43", "0.680910893");
		addProductTag("18", "41", "0.298817796");
		addProductTag("18", "44", "0.895865843");
		addProductTag("18", "45", "0.589543747");
		addProductTag("18", "46", "0.177245511");
		addProductTag("18", "47", "0.138739955");
		addProductTag("18", "49", "0.994405129");
		addProductTag("18", "50", "0.861732307");
		addProductTag("18", "51", "0.437074102");
		addProductTag("18", "52", "0.323664651");
		addProductTag("18", "53", "0.786562548");
		addProductTag("18", "54", "0.199459132");
		addProductTag("18", "55", "0.035045763");
		addProductTag("18", "56", "0.673487248");
		addProductTag("18", "57", "0.37842921");
		addProductTag("18", "59", "0.825723158");
		addProductTag("18", "60", "0.936903236");
		addProductTag("18", "61", "0.709631956");
		addProductTag("18", "62", "0.486097584");
		addProductTag("18", "63", "0.061286639");
		addProductTag("19", "14", "0.182877195");
		addProductTag("19", "9", "0.332504033");
		addProductTag("19", "10", "0.358662694");
		addProductTag("19", "11", "0.233627118");
		addProductTag("19", "12", "0.254147226");
		addProductTag("19", "17", "0.671081813");
		addProductTag("19", "19", "0.638375727");
		addProductTag("19", "20", "0.895367766");
		addProductTag("19", "21", "0.704411589");
		addProductTag("19", "22", "0.723147443");
		addProductTag("19", "23", "0.368204574");
		addProductTag("19", "24", "0.932143502");
		addProductTag("19", "25", "0.07339085");
		addProductTag("19", "27", "0.75930075");
		addProductTag("19", "28", "0.384452746");
		addProductTag("19", "29", "0.016654623");
		addProductTag("19", "30", "0.378468832");
		addProductTag("19", "31", "0.575821698");
		addProductTag("19", "33", "0.694859115");
		addProductTag("19", "34", "0.90384299");
		addProductTag("19", "35", "0.10070584");
		addProductTag("19", "36", "0.914277392");
		addProductTag("19", "38", "0.617240426");
		addProductTag("19", "40", "0.495324275");
		addProductTag("19", "42", "0.466793067");
		addProductTag("19", "43", "0.217308611");
		addProductTag("19", "41", "0.023941401");
		addProductTag("19", "44", "0.109352425");
		addProductTag("19", "45", "0.110620134");
		addProductTag("19", "46", "0.53346717");
		addProductTag("19", "47", "0.617174422");
		addProductTag("19", "49", "0.865881147");
		addProductTag("19", "50", "0.775810248");
		addProductTag("19", "51", "0.208801078");
		addProductTag("19", "52", "0.882941715");
		addProductTag("19", "53", "0.394474709");
		addProductTag("19", "54", "0.207528687");
		addProductTag("19", "55", "0.48819028");
		addProductTag("19", "56", "0.326121203");
		addProductTag("19", "57", "0.624143819");
		addProductTag("19", "59", "0.652039266");
		addProductTag("19", "60", "0.705484295");
		addProductTag("19", "61", "0.020719332");
		addProductTag("19", "62", "0.493491383");
		addProductTag("19", "63", "0.979602816");
		addProductTag("20", "14", "0.64671404");
		addProductTag("20", "9", "0.017623853");
		addProductTag("20", "10", "0.717997527");
		addProductTag("20", "11", "0.390995482");
		addProductTag("20", "12", "0.135188417");
		addProductTag("20", "17", "0.657851961");
		addProductTag("20", "19", "0.388986677");
		addProductTag("20", "20", "0.105869697");
		addProductTag("20", "21", "0.167140384");
		addProductTag("20", "22", "0.831666434");
		addProductTag("20", "23", "0.396858178");
		addProductTag("20", "24", "0.072413567");
		addProductTag("20", "25", "0.340808521");
		addProductTag("20", "27", "0.766330114");
		addProductTag("20", "28", "0.778459912");
		addProductTag("20", "29", "0.16233595");
		addProductTag("20", "30", "0.210358566");
		addProductTag("20", "31", "0.866197547");
		addProductTag("20", "33", "0.084675379");
		addProductTag("20", "34", "0.679298889");
		addProductTag("20", "35", "0.525823226");
		addProductTag("20", "36", "0.607149256");
		addProductTag("20", "38", "0.641358695");
		addProductTag("20", "40", "0.688552171");
		addProductTag("20", "42", "0.52795831");
		addProductTag("20", "43", "0.345372001");
		addProductTag("20", "41", "0.187443163");
		addProductTag("20", "44", "0.254922724");
		addProductTag("20", "45", "0.067525254");
		addProductTag("20", "46", "0.82861366");
		addProductTag("20", "47", "0.22211017");
		addProductTag("20", "49", "0.525200517");
		addProductTag("20", "50", "0.964704354");
		addProductTag("20", "51", "0.599692081");
		addProductTag("20", "52", "0.592068583");
		addProductTag("20", "53", "0.552122182");
		addProductTag("20", "54", "0.191362411");
		addProductTag("20", "55", "0.186636903");
		addProductTag("20", "56", "0.406127617");
		addProductTag("20", "57", "0.233185255");
		addProductTag("20", "59", "0.795337181");
		addProductTag("20", "60", "0.03742573");
		addProductTag("20", "61", "0.448186264");
		addProductTag("20", "62", "0.970491344");
		addProductTag("20", "63", "0.096977605");
		addProductTag("21", "14", "0.620134075");
		addProductTag("21", "9", "0.639236388");
		addProductTag("21", "10", "0.993114225");
		addProductTag("21", "11", "0.043437429");
		addProductTag("21", "12", "0.253774256");
		addProductTag("21", "17", "0.275770617");
		addProductTag("21", "19", "0.873740543");
		addProductTag("21", "20", "0.761154251");
		addProductTag("21", "21", "0.496777049");
		addProductTag("21", "22", "0.37335103");
		addProductTag("21", "23", "0.208064531");
		addProductTag("21", "24", "0.595529387");
		addProductTag("21", "25", "0.942213177");
		addProductTag("21", "27", "0.274524381");
		addProductTag("21", "28", "0.015719835");
		addProductTag("21", "29", "0.119397451");
		addProductTag("21", "30", "0.82300371");
		addProductTag("21", "31", "0.371817917");
		addProductTag("21", "33", "0.320097669");
		addProductTag("21", "34", "0.25618529");
		addProductTag("21", "35", "0.033391096");
		addProductTag("21", "36", "0.099326875");
		addProductTag("21", "38", "0.03976258");
		addProductTag("21", "40", "0.403130712");
		addProductTag("21", "42", "0.060575065");
		addProductTag("21", "43", "0.145446826");
		addProductTag("21", "41", "0.603438424");
		addProductTag("21", "44", "0.864183572");
		addProductTag("21", "45", "0.014110238");
		addProductTag("21", "46", "0.988403793");
		addProductTag("21", "47", "0.193198794");
		addProductTag("21", "49", "0.169618139");
		addProductTag("21", "50", "0.823904599");
		addProductTag("21", "51", "0.66829913");
		addProductTag("21", "52", "0.628114972");
		addProductTag("21", "53", "0.702952427");
		addProductTag("21", "54", "0.12624292");
		addProductTag("21", "55", "0.23922471");
		addProductTag("21", "56", "0.711630703");
		addProductTag("21", "57", "0.747680084");
		addProductTag("21", "59", "0.496907415");
		addProductTag("21", "60", "0.037702437");
		addProductTag("21", "61", "0.6717021");
		addProductTag("21", "62", "0.617953544");
		addProductTag("21", "63", "0.978335");
		addProductTag("22", "14", "0.965040672");
		addProductTag("22", "9", "0.896064645");
		addProductTag("22", "10", "0.131420498");
		addProductTag("22", "11", "0.269168952");
		addProductTag("22", "12", "0.535519136");
		addProductTag("22", "17", "0.124436816");
		addProductTag("22", "19", "0.44410642");
		addProductTag("22", "20", "0.712042073");
		addProductTag("22", "21", "0.504687144");
		addProductTag("22", "22", "0.107274741");
		addProductTag("22", "23", "0.549330621");
		addProductTag("22", "24", "0.478666846");
		addProductTag("22", "25", "0.004056285");
		addProductTag("22", "27", "0.945541356");
		addProductTag("22", "28", "0.218396545");
		addProductTag("22", "29", "0.421837046");
		addProductTag("22", "30", "0.003749976");
		addProductTag("22", "31", "0.668173068");
		addProductTag("22", "33", "0.981059857");
		addProductTag("22", "34", "0.404327768");
		addProductTag("22", "35", "0.067697987");
		addProductTag("22", "36", "0.522199436");
		addProductTag("22", "38", "0.116603264");
		addProductTag("22", "40", "0.570958304");
		addProductTag("22", "42", "0.901331117");
		addProductTag("22", "43", "0.029638812");
		addProductTag("22", "41", "0.6647394");
		addProductTag("22", "44", "0.106619796");
		addProductTag("22", "45", "0.143395311");
		addProductTag("22", "46", "0.975099314");
		addProductTag("22", "47", "0.252930946");
		addProductTag("22", "49", "0.188425105");
		addProductTag("22", "50", "0.208203254");
		addProductTag("22", "51", "0.455848907");
		addProductTag("22", "52", "0.553540259");
		addProductTag("22", "53", "0.604653962");
		addProductTag("22", "54", "0.669632081");
		addProductTag("22", "55", "0.963550955");
		addProductTag("22", "56", "0.740191707");
		addProductTag("22", "57", "0.598917128");
		addProductTag("22", "59", "0.927347859");
		addProductTag("22", "60", "0.685397983");
		addProductTag("22", "61", "0.274349248");
		addProductTag("22", "62", "0.224677219");
		addProductTag("22", "63", "0.338152206");
		addProductTag("23", "14", "0.360052605");
		addProductTag("23", "9", "0.227502098");
		addProductTag("23", "10", "0.504396259");
		addProductTag("23", "11", "0.425489782");
		addProductTag("23", "12", "0.421156576");
		addProductTag("23", "17", "0.043129102");
		addProductTag("23", "19", "0.944476705");
		addProductTag("23", "20", "0.321389447");
		addProductTag("23", "21", "0.328929421");
		addProductTag("23", "22", "0.319400263");
		addProductTag("23", "23", "0.906314124");
		addProductTag("23", "24", "0.275448146");
		addProductTag("23", "25", "0.159804996");
		addProductTag("23", "27", "0.183576015");
		addProductTag("23", "28", "0.258468006");
		addProductTag("23", "29", "0.273419995");
		addProductTag("23", "30", "0.189894091");
		addProductTag("23", "31", "0.881852381");
		addProductTag("23", "33", "0.871137187");
		addProductTag("23", "34", "0.976101681");
		addProductTag("23", "35", "0.430018142");
		addProductTag("23", "36", "0.946589303");
		addProductTag("23", "38", "0.399975995");
		addProductTag("23", "40", "0.306411766");
		addProductTag("23", "42", "0.843921695");
		addProductTag("23", "43", "0.20107041");
		addProductTag("23", "41", "0.02264272");
		addProductTag("23", "44", "0.340867068");
		addProductTag("23", "45", "0.855387635");
		addProductTag("23", "46", "0.835347139");
		addProductTag("23", "47", "0.977013257");
		addProductTag("23", "49", "0.32960249");
		addProductTag("23", "50", "0.834543197");
		addProductTag("23", "51", "0.531087133");
		addProductTag("23", "52", "0.090546157");
		addProductTag("23", "53", "0.196285691");
		addProductTag("23", "54", "0.378048647");
		addProductTag("23", "55", "0.836594772");
		addProductTag("23", "56", "0.042953118");
		addProductTag("23", "57", "0.885329149");
		addProductTag("23", "59", "0.704076798");
		addProductTag("23", "60", "0.881930532");
		addProductTag("23", "61", "0.753834178");
		addProductTag("23", "62", "0.711463419");
		addProductTag("23", "63", "0.616608134");
		addProductTag("24", "14", "0.112769872");
		addProductTag("24", "9", "0.14277082");
		addProductTag("24", "10", "0.950576208");
		addProductTag("24", "11", "0.362564463");
		addProductTag("24", "12", "0.046991488");
		addProductTag("24", "17", "0.421982214");
		addProductTag("24", "19", "0.700299582");
		addProductTag("24", "20", "0.517207064");
		addProductTag("24", "21", "0.631989374");
		addProductTag("24", "22", "0.697793414");
		addProductTag("24", "23", "0.017802946");
		addProductTag("24", "24", "0.576380791");
		addProductTag("24", "25", "0.150462146");
		addProductTag("24", "27", "0.879806861");
		addProductTag("24", "28", "0.405390568");
		addProductTag("24", "29", "0.799109774");
		addProductTag("24", "30", "0.843503109");
		addProductTag("24", "31", "0.372695996");
		addProductTag("24", "33", "0.149866455");
		addProductTag("24", "34", "0.4804038");
		addProductTag("24", "35", "0.263689088");
		addProductTag("24", "36", "0.025035481");
		addProductTag("24", "38", "0.271390667");
		addProductTag("24", "40", "0.521203148");
		addProductTag("24", "42", "0.452712296");
		addProductTag("24", "43", "0.821166486");
		addProductTag("24", "41", "0.776304724");
		addProductTag("24", "44", "0.414755263");
		addProductTag("24", "45", "0.746545189");
		addProductTag("24", "46", "0.382558702");
		addProductTag("24", "47", "0.654592043");
		addProductTag("24", "49", "0.134746939");
		addProductTag("24", "50", "0.351067094");
		addProductTag("24", "51", "0.979234334");
		addProductTag("24", "52", "0.477792701");
		addProductTag("24", "53", "0.322342781");
		addProductTag("24", "54", "0.249854181");
		addProductTag("24", "55", "0.383131675");
		addProductTag("24", "56", "0.241606718");
		addProductTag("24", "57", "0.440594387");
		addProductTag("24", "59", "0.894943655");
		addProductTag("24", "60", "0.136115964");
		addProductTag("24", "61", "0.311352506");
		addProductTag("24", "62", "0.190784302");
		addProductTag("24", "63", "0.406584762");
		addProductTag("25", "14", "0.618655708");
		addProductTag("25", "9", "0.521999002");
		addProductTag("25", "10", "0.819263272");
		addProductTag("25", "11", "0.146325509");
		addProductTag("25", "12", "0.262950378");
		addProductTag("25", "17", "0.454367326");
		addProductTag("25", "19", "0.998762155");
		addProductTag("25", "20", "0.028732899");
		addProductTag("25", "21", "0.932367436");
		addProductTag("25", "22", "0.805115027");
		addProductTag("25", "23", "0.67421693");
		addProductTag("25", "24", "0.435862819");
		addProductTag("25", "25", "0.88523044");
		addProductTag("25", "27", "0.031800236");
		addProductTag("25", "28", "0.266221321");
		addProductTag("25", "29", "0.788147484");
		addProductTag("25", "30", "0.719153706");
		addProductTag("25", "31", "0.73810896");
		addProductTag("25", "33", "0.53131318");
		addProductTag("25", "34", "0.14651993");
		addProductTag("25", "35", "0.644684601");
		addProductTag("25", "36", "0.086944288");
		addProductTag("25", "38", "0.298921009");
		addProductTag("25", "40", "0.005923521");
		addProductTag("25", "42", "0.749877028");
		addProductTag("25", "43", "0.837381537");
		addProductTag("25", "41", "0.670307086");
		addProductTag("25", "44", "0.810712419");
		addProductTag("25", "45", "0.085079423");
		addProductTag("25", "46", "0.778182415");
		addProductTag("25", "47", "0.873637822");
		addProductTag("25", "49", "0.967751711");
		addProductTag("25", "50", "0.769107102");
		addProductTag("25", "51", "0.073984824");
		addProductTag("25", "52", "0.472041764");
		addProductTag("25", "53", "0.905855544");
		addProductTag("25", "54", "0.18510669");
		addProductTag("25", "55", "0.211953266");
		addProductTag("25", "56", "0.148939392");
		addProductTag("25", "57", "0.635349812");
		addProductTag("25", "59", "0.586659525");
		addProductTag("25", "60", "0.336393874");
		addProductTag("25", "61", "0.797805679");
		addProductTag("25", "62", "0.151128585");
		addProductTag("25", "63", "0.420052662");
		addProductTag("25", "14", "0.66402333");
		addProductTag("25", "9", "0.787318583");
		addProductTag("25", "10", "0.768595446");
		addProductTag("25", "11", "0.767403365");
		addProductTag("25", "12", "0.899886989");
		addProductTag("25", "17", "0.954874484");
		addProductTag("25", "19", "0.171682552");
		addProductTag("25", "20", "0.66520429");
		addProductTag("25", "21", "0.721662393");
		addProductTag("25", "22", "0.661659532");
		addProductTag("25", "23", "0.515043367");
		addProductTag("25", "24", "0.930412234");
		addProductTag("25", "25", "0.936894892");
		addProductTag("25", "27", "0.708257663");
		addProductTag("25", "28", "0.783278955");
		addProductTag("25", "29", "0.177204468");
		addProductTag("25", "30", "0.582514535");
		addProductTag("25", "31", "0.753227684");
		addProductTag("25", "33", "0.941860267");
		addProductTag("25", "34", "0.625599391");
		addProductTag("25", "35", "0.076508656");
		addProductTag("25", "36", "0.495454805");
		addProductTag("25", "38", "0.900204638");
		addProductTag("25", "40", "0.350204049");
		addProductTag("25", "42", "0.78593413");
		addProductTag("25", "43", "0.497375834");
		addProductTag("25", "41", "0.932403772");
		addProductTag("25", "44", "0.741691282");
		addProductTag("25", "45", "0.039972759");
		addProductTag("25", "46", "0.861116945");
		addProductTag("25", "47", "0.314817402");
		addProductTag("25", "49", "0.700721968");
		addProductTag("25", "50", "0.166745629");
		addProductTag("25", "51", "0.222209157");
		addProductTag("25", "52", "0.769664594");
		addProductTag("25", "53", "0.187315971");
		addProductTag("25", "54", "0.846216171");
		addProductTag("25", "55", "0.634580389");
		addProductTag("25", "56", "0.816076623");
		addProductTag("25", "57", "0.118701951");
		addProductTag("25", "59", "0.37519264");
		addProductTag("25", "60", "0.169583079");
		addProductTag("25", "61", "0.358081813");
		addProductTag("25", "62", "0.791418775");
		addProductTag("25", "63", "0.742331493");
		addProductTag("26", "14", "0.960745777");
		addProductTag("26", "9", "0.249819966");
		addProductTag("26", "10", "0.895032565");
		addProductTag("26", "11", "0.164028032");
		addProductTag("26", "12", "0.627341983");
		addProductTag("26", "17", "0.252110522");
		addProductTag("26", "19", "0.531084045");
		addProductTag("26", "20", "0.690344547");
		addProductTag("26", "21", "0.791743006");
		addProductTag("26", "22", "0.972924797");
		addProductTag("26", "23", "0.769169614");
		addProductTag("26", "24", "0.96652283");
		addProductTag("26", "25", "0.019681446");
		addProductTag("26", "27", "0.915342162");
		addProductTag("26", "28", "0.980434628");
		addProductTag("26", "29", "0.263893434");
		addProductTag("26", "30", "0.556821198");
		addProductTag("26", "31", "0.254183406");
		addProductTag("26", "33", "0.566029793");
		addProductTag("26", "34", "0.254079025");
		addProductTag("26", "35", "0.627956809");
		addProductTag("26", "36", "0.358881568");
		addProductTag("26", "38", "0.465645393");
		addProductTag("26", "40", "0.515713448");
		addProductTag("26", "42", "0.367477908");
		addProductTag("26", "43", "0.837487621");
		addProductTag("26", "41", "0.023793411");
		addProductTag("26", "44", "0.744721307");
		addProductTag("26", "45", "0.967296931");
		addProductTag("26", "46", "0.016031223");
		addProductTag("26", "47", "0.802455492");
		addProductTag("26", "49", "0.209878697");
		addProductTag("26", "50", "0.452470906");
		addProductTag("26", "51", "0.919069025");
		addProductTag("26", "52", "0.719542055");
		addProductTag("26", "53", "0.685183762");
		addProductTag("26", "54", "0.587906198");
		addProductTag("26", "55", "0.087331643");
		addProductTag("26", "56", "0.591090333");
		addProductTag("26", "57", "0.097189697");
		addProductTag("26", "59", "0.840724671");
		addProductTag("26", "60", "0.132832351");
		addProductTag("26", "61", "0.997719829");
		addProductTag("26", "62", "0.349903026");
		addProductTag("26", "63", "0.418044393");
	}
}