<?php

class Api {
	public function __construct() { 
	}
	public function doc() {
		Sys::hprint("<!doctype html>\x0D\x0A\x09\x09\x09<html>\x0D\x0A\x09\x09\x09<head>\x0D\x0A\x09\x09\x09<style type=\"text/css\">\x0D\x0A\x09\x09\x09body\x0D\x0A\x09\x09\x09{\x0D\x0A\x09\x09\x09\x09background-color : #CCC;\x0D\x0A\x09\x09\x09\x09margin : 0px;\x0D\x0A\x09\x09\x09\x09font-family : consolas, serif;\x0D\x0A\x09\x09\x09}\x0D\x0A\x09\x09\x09.function\x0D\x0A\x09\x09\x09{\x0D\x0A\x09\x09\x09\x09margin : 5px;\x0D\x0A\x09\x09\x09\x09padding : 10px;\x0D\x0A\x09\x09\x09\x09border-radius : 3px;\x0D\x0A\x09\x09\x09\x09background-color : #FFF;\x0D\x0A\x09\x09\x09}\x0D\x0A\x09\x09\x09.name\x0D\x0A\x09\x09\x09{\x0D\x0A\x09\x09\x09\x09font-size : 2em;\x0D\x0A\x09\x09\x09}\x0D\x0A\x09\x09\x09.description\x0D\x0A\x09\x09\x09{\x0D\x0A\x09\x09\x09\x09font-size : 1.5em;\x0D\x0A\x09\x09\x09\x09opacity : 0.75;\x0D\x0A\x09\x09\x09}\x0D\x0A\x09\x09\x09</style>\x0D\x0A\x09\x09\x09</head>\x0D\x0A\x09\x09\x09<body>\x0D\x0A\x09\x09\x09<h1>Documentation Intuition - API</h1>");
		{
			$_g = 0;
			$_g1 = Type::getInstanceFields(Type::getClass($this));
			while($_g < $_g1->length) {
				$field = $_g1[$_g];
				++$_g;
				Sys::hprint("<div class=\"function\">");
				Sys::hprint("<a class=\"name\" href=\"/api/" . _hx_string_or_null($field) . "\">/api/" . _hx_string_or_null($field) . "</a>");
				$data = haxe_rtti_Meta::getFields(Type::getClass($this));
				try {
					$meta = Reflect::field($data, $field);
					{
						$_g2 = 0;
						$_g3 = Reflect::fields($meta);
						while($_g2 < $_g3->length) {
							$metadata = $_g3[$_g2];
							++$_g2;
							Sys::hprint("<div class=\"" . _hx_string_or_null($metadata) . "\">" . _hx_string_or_null(_hx_array_get(Reflect::field($meta, $metadata), 0)) . "</div>");
							unset($metadata);
						}
						unset($_g3,$_g2);
					}
					unset($meta);
				}catch(Exception $__hx__e) {
					$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
					if(is_string($e = $_ex_)){
					} else throw $__hx__e;;
				}
				Sys::hprint("</div>");
				unset($field,$e,$data);
			}
		}
		Sys::hprint("</body></html>");
	}
	public function getTags() {
		$result = new _hx_array(array());
		if(null == data_Tag::$manager->all(null)) throw new HException('null iterable');
		$__hx__it = data_Tag::$manager->all(null)->iterator();
		while($__hx__it->hasNext()) {
			$tag = $__hx__it->next();
			$result->push($tag->getObject());
		}
		Sys::hprint(haxe_Json::stringify($result, null));
	}
	public function getTag($id) {
		Sys::hprint(haxe_Json::stringify(data_Tag::$manager->unsafeGet($id, false)->getObject(), null));
	}
	public function getNewTag() {
		Sys::hprint(haxe_Json::stringify(_hx_anonymous(array("name" => "Test", "color" => "#123456")), null));
	}
	public function addTag($name, $color) {
		_hx_deref(new data_Tag($name, $color))->insert();
		Sys::hprint(haxe_Json::stringify(_hx_anonymous(array("success" => true)), null));
	}
	public function getProducts() {
		$result = new _hx_array(array());
		if(null == data_Product::$manager->all(null)) throw new HException('null iterable');
		$__hx__it = data_Product::$manager->all(null)->iterator();
		while($__hx__it->hasNext()) {
			$product = $__hx__it->next();
			$result->push($product->getObject());
		}
		Sys::hprint(haxe_Json::stringify($result, null));
	}
	public function getProduct($id) {
		Sys::hprint(haxe_Json::stringify(data_Product::$manager->unsafeGet($id, false)->getObject(), null));
	}
	public function addProduct($name, $price, $imageURL, $url) {
		_hx_deref(new data_Product($name, Std::parseFloat($price), $imageURL, $url))->insert();
		Sys::hprint(haxe_Json::stringify(_hx_anonymous(array("success" => true)), null));
	}
	public function getProductTags() {
		$result = new _hx_array(array());
		if(null == data_ProductTag::$manager->all(null)) throw new HException('null iterable');
		$__hx__it = data_ProductTag::$manager->all(null)->iterator();
		while($__hx__it->hasNext()) {
			$productTags = $__hx__it->next();
			$result->push($productTags->getObject());
		}
		Sys::hprint(haxe_Json::stringify($result, null));
	}
	public function getProductTag($id) {
		Sys::hprint(haxe_Json::stringify(data_ProductTag::$manager->unsafeGet($id, false)->getObject(), null));
	}
	public function addProductTag($productId, $tagId, $score) {
		_hx_deref(new data_ProductTag(data_Product::$manager->unsafeGet(Std::parseInt($productId), false), data_Tag::$manager->unsafeGet(Std::parseInt($tagId), false), Std::parseFloat($score)))->insert();
		Sys::hprint(haxe_Json::stringify(_hx_anonymous(array("success" => true)), null));
	}
	public function initProducts() {
		$this->addProduct("Asterix chez les pictes", "9.14", "http://ecx.images-amazon.com/images/I/51MrKJPb9gL._.jpg", "http://www.amazon.fr/Astérix-chez-Pictes-René-Goscinny/dp/2864972662");
		$this->addProduct("Voyages en absurdie", "15.11", "http://ecx.images-amazon.com/images/I/41C%2BV-n5RNL._SY445_.jpg", "http://www.amazon.fr/Voyages-en-absurdie-Stéphane-Groodt/dp/2259222463");
		$this->addProduct("La femme parfaite est une connasse !", "4.75", "http://ecx.images-amazon.com/images/I/51cXPHdA2kL._SY445_.jpg", "http://www.amazon.fr/femme-parfaite-est-une-connasse/dp/229005948X");
		$this->addProduct("Au revoir là-haut", "21.38", "http://ecx.images-amazon.com/images/I/41w8yS8v-bL._BO2,204,203,200_PIsitb-sticker-arrow-click,TopRight,35,-76_SX342_SY445_CR,0,0,342,445_SH20_OU08_.jpg", "http://www.amazon.fr/Au-revoir-là-haut-Prix-Goncourt/dp/2226249672");
		$this->addProduct("Tablette Kindle Fire HD", "99.00", "http://g-ecx.images-amazon.com/images/G/08/kindle/dp/2012/KT/KT-slate-01-sm-v2._V381449839_.jpg", "http://www.amazon.fr/gp/product/B0083PWAWU/");
		$this->addProduct("Kindle", "59.00", "http://g-ecx.images-amazon.com/images/G/08/kindle/dp/2012/KS/KS-slate-01-sm-vid._V402188781_.jpg", "http://www.amazon.fr/gp/product/B007HCCOD0");
		$this->addProduct("Duracell - Chargeur rapide 45min + 2 Duralock AA 1300mAh + 2 Duralock AAA 750mAh", "14.13", "http://ecx.images-amazon.com/images/I/71o0WTD4DnL._SL1500_.jpg", "http://www.amazon.fr/Duracell-Chargeur-rapide-Duralock-1300mAh/dp/B008TYX7Z4");
		$this->addProduct("Lexibook - MFC157FR - Jeu Électronique - Tablette - Tablet Master 2 - Version FR", "86.30", "http://ecx.images-amazon.com/images/I/81oHTe3JiSL._SL1500_.jpg", "http://www.amazon.fr/gp/product/B00CPENHB8");
		$this->addProduct("Lexibook HP010 Casque Traditionnel Filaire", "9.00", "http://ecx.images-amazon.com/images/I/710rZXSEbLL._SL1500_.jpg", "http://www.amazon.fr/gp/product/B00AZ88KJU");
		$this->addProduct("Lego Star Wars - 75018 - Jeu de Construction - Jek - 14's Stealth Starfighter", "51.74", "http://ecx.images-amazon.com/images/I/71iZf3y8bQL._SL1280_.jpg", "http://www.amazon.fr/gp/product/B00B0IILX4");
		$this->addProduct("Playmobil - 4858 - Jeu de construction - Piscine avec toboggan", "28.49", "http://ecx.images-amazon.com/images/I/81hwH0n52UL._SL1500_.jpg", "http://www.amazon.fr/Playmobil-4858-construction-Piscine-toboggan/dp/B00324REN2");
		$this->addProduct("Samsung Galaxy Trend GT-S7560 Smartphone Ecran tactile 4'' (10,2 cm) Android 4.0.4 Ice Cream Sandwich Bluetooth Wi-Fi Blanc", "132.90", "http://ecx.images-amazon.com/images/I/81DwiWOtSeL._SL1500_.jpg", "http://www.amazon.fr/Samsung-Galaxy-Trend-Smartphone-Bluetooth/dp/B00DM2GN6S");
		$this->addProduct("Wiko Cink Peax 2 Smartphone USB Android 4.1.2 Jelly Bean Blanc", "151.90", "http://ecx.images-amazon.com/images/I/81Qp5jKqLWL._SL1500_.jpg", "http://www.amazon.fr/Wiko-Smartphone-Android-4-1-2-Jelly/dp/B00EBZMOYK");
		$this->addProduct("Samsung Galaxy S4 Smartphone 4,99'' 16 Go Android 4.2 (JB) Noir", " 475.95", "http://ecx.images-amazon.com/images/I/81zlu5qyR-L._SL1500_.jpg", "http://www.amazon.fr/Samsung-Galaxy-Smartphone-Android-Noir/dp/B00C3GBRRO");
		$this->addProduct("SanDisk SDCZ33-032G-B35 Cruzer Fit clé USB 32Go Noir", "18.99", "http://ecx.images-amazon.com/images/I/719qrEaDaIL._SL1500_.jpg", "http://www.amazon.fr/gp/product/B00812F7O8");
		$this->addProduct("7MM Bague Tungstene \"Seigneur des Anneaux 'LORD OF THE RINGS' Plaque D' or Taille 63", "19.99", "http://ecx.images-amazon.com/images/I/41wMb-x4hfL._SY395_.jpg", "http://www.amazon.fr/Tungstene-Seigneur-Anneaux-Plaque-Taille/dp/B007KPLGOC");
		$this->addProduct("Anneau Hommes - Cléopâtre - or jaune 18 carats 750/1000 Taille - /56", "4297.00", "http://ecx.images-amazon.com/images/I/51KTGkpUF%2BL._SY395_.jpg", "http://www.amazon.fr/Anneau-Hommes-Cléopâtre-jaune-carats-750-Taille/dp/B007JL2ZJ2");
		$this->addProduct("Nikon D3200 Kit Reflex 24,2 Mpix Noir + Objectif AF-S DX 18-55 mm VR", "398.90", "http://ecx.images-amazon.com/images/I/91c-hHhsafL._SL1500_.jpg", "http://www.amazon.fr/Nikon-D3200-Reflex-Objectif-18-55/dp/B007VBGTX8");
		$this->addProduct("Toshiba 24W1333G TV LCD 24 (\"61 cm) LED HDTV 1080p 50 Hz 1 HDMI 2 USB Classe: A", "179.00", "http://ecx.images-amazon.com/images/I/5109zI0IRUL.jpg", "http://www.amazon.fr/Toshiba-24W1333G-HDTV-1080p-Classe/dp/B00BB9VC42");
		$this->addProduct("TomTom XL Classic Europe 23 (1ET0.054.22)", "93.10", "http://ecx.images-amazon.com/images/I/71sLmqeFcdL._SL1500_.jpg", "http://www.amazon.fr/TomTom-XL-Classic-Europe-1ET0-054-22/dp/B008RJPXRQ");
		$this->addProduct("Diesel manteau WERON homme veste d`hiver blouson parka", "149.90", "http://ecx.images-amazon.com/images/I/41TPNE1mcEL._SY445_.jpg", "http://www.amazon.fr/Diesel-manteau-WERON-d`hiver-blouson/dp/B00FQGOXFQ");
		$this->addProduct("Morgan 132-1Eifel.A, Escarpins femme", "84.99", "http://ecx.images-amazon.com/images/I/41Ve5qT-P4L._SS45_.jpg", "http://www.amazon.fr/Morgan-132-1Eifel-A-Escarpins-femme-Noir/dp/B00CZCEBQU");
		$this->addProduct("Ted Lapidus - D0460RBPW - Montre Femme - Quartz Analogique - Cadran Blanc - Bracelet Acier Argent", "89.90", "http://ecx.images-amazon.com/images/I/41uEhiNLXGL._SX32_SY45_CR,0,0,32,45_.jpg", "http://www.amazon.fr/Ted-Lapidus-D0460RBPW-Analogique-Bracelet/dp/B003JBIZOU");
		$this->addProduct("Console PlayStation 4", "399.00", "http://ecx.images-amazon.com/images/I/61Tgs1T1fxL._SL1425_.jpg", "http://www.amazon.fr/Sony-Ps4-Console-0711719268475-PlayStation/dp/B00BIYAO3K");
	}
	static function __meta__() { $args = func_get_args(); return call_user_func_array(self::$__meta__, $args); }
	static $__meta__;
	function __toString() { return 'Api'; }
}
Api::$__meta__ = _hx_anonymous(array("fields" => _hx_anonymous(array("doc" => _hx_anonymous(array("description" => new _hx_array(array("display documentation")))), "getTags" => _hx_anonymous(array("description" => new _hx_array(array("Return the list of tags")))), "getTag" => _hx_anonymous(array("description" => new _hx_array(array("Return a tag based on id")), "param1" => new _hx_array(array("id : id of the product")))), "getNewTag" => _hx_anonymous(array("description" => new _hx_array(array("Return some tag based on history")))), "addTag" => _hx_anonymous(array("description" => new _hx_array(array("Add a tag in the database")), "param1" => new _hx_array(array("name : the name of the tag \"sweet\", \"calm\", ...")), "param2" => new _hx_array(array("color : hexadecimal representation of a corresponding color : 614287")))), "getProducts" => _hx_anonymous(array("description" => new _hx_array(array("Return the list of products")))), "getProduct" => _hx_anonymous(array("description" => new _hx_array(array("Return a product based on id")), "param1" => new _hx_array(array("id : id of the product")))), "addProduct" => _hx_anonymous(array("description" => new _hx_array(array("Add a product in the database")), "param1" => new _hx_array(array("name : The name of the product")), "param2" => new _hx_array(array("price : The price of the product as a Float (0.75)")), "param3" => new _hx_array(array("imageURL : an url to an image of the product")), "param4" => new _hx_array(array("url : an url to buy the product")))), "getProductTags" => _hx_anonymous(array("description" => new _hx_array(array("Return the list of product tags")))), "getProductTag" => _hx_anonymous(array("description" => new _hx_array(array("Return a product tag based on id")), "param1" => new _hx_array(array("id : id of the product tag")))), "addProductTag" => _hx_anonymous(array("description" => new _hx_array(array("Add a product tag in the database")), "param1" => new _hx_array(array("productId : The id of the product")), "param2" => new _hx_array(array("tagId : The id of the tag")), "param3" => new _hx_array(array("score : The score")))), "initProducts" => _hx_anonymous(array("description" => new _hx_array(array("Init product database"))))))));
