<?php

class data_ProductTag extends sys_db_Object {
	public function __construct($product, $tag, $score) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->set_product($product);
		$this->set_tag($tag);
		$this->score = $score;
	}}
	public $id;
	public $score;
	public function getObject() {
		return _hx_anonymous(array("product" => $this->get_product(), "tag" => $this->get_tag(), "score" => $this->score));
	}
	public function get_product() {
		return data_Product::$manager->h__get($this, "product", "productId", false);
	}
	public function set_product($_v) {
		return data_Product::$manager->h__set($this, "product", "productId", $_v);
	}
	public function get_tag() {
		return data_Tag::$manager->h__get($this, "tag", "tagId", false);
	}
	public function set_tag($_v) {
		return data_Tag::$manager->h__set($this, "tag", "tagId", $_v);
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
	static $__properties__ = array("set_tag" => "set_tag","get_tag" => "get_tag","set_product" => "set_product","get_product" => "get_product");
	function __toString() { return 'data.ProductTag'; }
}
data_ProductTag::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey21:intuition_productTagsy7:indexesahy9:relationsaoy4:lockfy4:propy7:producty4:typey12:data.Producty7:cascadefy6:isNullfy3:keyy9:productIdgoR4fR5y3:tagR7y8:data.TagR9fR10fR11y5:tagIdghy7:hfieldsby2:idoR0R17R10fy1:tjy17:sys.db.RecordType:0:0gy5:scoreoR0R20R10fR18jR19:7:0gR12oR0R12R10fR18jR19:1:0gR15oR0R15R10fR18r11ghR11aR17hy6:fieldsar6r8r10r12hg"))))));
data_ProductTag::$manager = new sys_db_Manager(_hx_qtype("data.ProductTag"));
