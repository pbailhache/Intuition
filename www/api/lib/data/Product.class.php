<?php

class data_Product extends sys_db_Object {
	public function __construct($name, $price, $imageURL, $url) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->name = $name;
		$this->price = $price;
		$this->imageURL = $imageURL;
		$this->url = $url;
	}}
	public $id;
	public $name;
	public $price;
	public $imageURL;
	public $url;
	public function getObject() {
		return _hx_anonymous(array("id" => $this->id, "name" => $this->name, "price" => $this->price, "imageURL" => $this->imageURL, "url" => $this->url));
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
	static $manager;
	function __toString() { return 'data.Product'; }
}
data_Product::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey18:intuition_productsy7:indexesahy9:relationsahy7:hfieldsby3:urloR0R5y6:isNullfy1:tjy17:sys.db.RecordType:15:0gy2:idoR0R9R6fR7jR8:0:0gR0oR0R0R6fR7r5gy8:imageURLoR0R10R6fR7r5gy5:priceoR0R11R6fR7jR8:7:0ghy3:keyaR9hy6:fieldsar6r8r10r9r4hg"))))));
data_Product::$manager = new sys_db_Manager(_hx_qtype("data.Product"));
