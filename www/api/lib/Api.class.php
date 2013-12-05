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
	public function getTag() {
		Sys::hprint(haxe_Json::stringify(_hx_anonymous(array("name" => "Test", "color" => "#123456")), null));
	}
	public function addProduct($name, $price, $imageURL, $url) {
		_hx_deref(new data_Product($name, Std::parseFloat($price), $imageURL, $url))->insert();
		Sys::hprint(haxe_Json::stringify(_hx_anonymous(array("success" => true)), null));
	}
	static function __meta__() { $args = func_get_args(); return call_user_func_array(self::$__meta__, $args); }
	static $__meta__;
	function __toString() { return 'Api'; }
}
Api::$__meta__ = _hx_anonymous(array("fields" => _hx_anonymous(array("doc" => _hx_anonymous(array("description" => new _hx_array(array("display documentation")))), "getTag" => _hx_anonymous(array("description" => new _hx_array(array("Return some tag based on history")))), "addProduct" => _hx_anonymous(array("description" => new _hx_array(array("Add a product in the database")), "param1" => new _hx_array(array("name")), "param2" => new _hx_array(array("price")), "param3" => new _hx_array(array("imageURL")), "param4" => new _hx_array(array("url"))))))));
