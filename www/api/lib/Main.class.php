<?php

class Main {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		sys_db_Manager::set_cnx(sys_db_Mysql::connect(_hx_anonymous(array("host" => "mysql51-44.pro", "port" => null, "user" => "projetsbxnuit", "pass" => "greenShrimp", "database" => "projetsbxnuit", "socket" => null))));
		if(!sys_db_TableCreate::exists(data_Product::$manager)) {
			sys_db_TableCreate::create(data_Product::$manager, null);
		}
		$this->api = new Api();
		try {
			_hx_deref(new haxe_web_Dispatch(php_Web::getURI(), php_Web::getParams()))->runtimeDispatch(haxe_web_Dispatch::extractConfig($this));
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			if(($error = $_ex_) instanceof haxe_web_DispatchError){
				$this->doError(new haxe_web_Dispatch(php_Web::getURI(), php_Web::getParams()));
			} else throw $__hx__e;;
		}
	}}
	public $api;
	public function doDefault() {
	}
	public function doApi($dispatch) {
		$params = new _hx_array(array());
		if(null == $dispatch->params) throw new HException('null iterable');
		$__hx__it = $dispatch->params->iterator();
		while($__hx__it->hasNext()) {
			$param = $__hx__it->next();
			$params->push($param);
		}
		try {
			Reflect::callMethod($this->api, Reflect::field($this->api, $dispatch->parts[0]), $params);
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			if(is_string($s = $_ex_)){
				$this->api->doc();
			} else throw $__hx__e;;
		}
	}
	public function doError($dispatch) {
		Sys::hprint("error");
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	static function __meta__() { $args = func_get_args(); return call_user_func_array(self::$__meta__, $args); }
	static $__meta__;
	static function main() {
		new Main();
	}
	function __toString() { return 'Main'; }
}
Main::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("dispatchConfig" => new _hx_array(array("oy5:errorjy21:haxe.web.DispatchRule:0:1jy18:haxe.web.MatchRule:4:0y3:apijR1:0:1jR2:4:0y7:defaultjR1:1:1ahg"))))));
