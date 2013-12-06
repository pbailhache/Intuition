import data.*;

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
		Sys.print(haxe.Json.stringify({name : "Test", color : "#123456"}));
	}

	@description("Add a tag in the database")
	@param1("name : the name of the tag \"sweet\", \"calm\", ...")
	@param2("color : hexadecimal representation of a corresponding color : 614287")
	public function addTag(name : String, color : String)
	{
		new Tag(name, color).insert();
		Sys.print(haxe.Json.stringify({success : true}));
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

	@description("Return a product tag based on id")
	@param1("id : id of the product tag")
	public function getProductTag(id : Int)
	{
		Sys.print(haxe.Json.stringify(ProductTag.manager.get(id).getObject()));
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
}