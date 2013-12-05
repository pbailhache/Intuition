<?php

class data_Tag extends sys_db_Object {
	public function __construct($name, $color) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->name = $name;
		$this->color = $color;
	}}
	public $id;
	public $name;
	public $color;
	public function getObject() {
		return _hx_anonymous(array("id" => $this->id, "name" => $this->name, "color" => $this->color));
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
	function __toString() { return 'data.Tag'; }
}
data_Tag::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey14:intuition_tagsy7:indexesahy9:relationsahy7:hfieldsby2:idoR0R5y6:isNullfy1:tjy17:sys.db.RecordType:0:0gR0oR0R0R6fR7jR8:15:0gy5:coloroR0R9R6fR7r7ghy3:keyaR5hy6:fieldsar4r6r8hg"))))));
data_Tag::$manager = new sys_db_Manager(_hx_qtype("data.Tag"));
