<?php

class haxe_Serializer {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->buf = new StringBuf();
		$this->cache = new _hx_array(array());
		$this->useCache = haxe_Serializer::$USE_CACHE;
		$this->useEnumIndex = haxe_Serializer::$USE_ENUM_INDEX;
		$this->shash = new haxe_ds_StringMap();
		$this->scount = 0;
	}}
	public $buf;
	public $cache;
	public $shash;
	public $scount;
	public $useCache;
	public $useEnumIndex;
	public function toString() {
		return $this->buf->b;
	}
	public function serializeString($s) {
		$x = $this->shash->get($s);
		if($x !== null) {
			$this->buf->add("R");
			$this->buf->add($x);
			return;
		}
		$this->shash->set($s, $this->scount++);
		$this->buf->add("y");
		$s = rawurlencode($s);
		$this->buf->add(strlen($s));
		$this->buf->add(":");
		$this->buf->add($s);
	}
	public function serializeRef($v) {
		{
			$_g1 = 0;
			$_g = $this->cache->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				if(_hx_equal($this->cache[$i], $v)) {
					$this->buf->add("r");
					$this->buf->add($i);
					return true;
				}
				unset($i);
			}
		}
		$this->cache->push($v);
		return false;
	}
	public function serializeFields($v) {
		{
			$_g = 0;
			$_g1 = Reflect::fields($v);
			while($_g < $_g1->length) {
				$f = $_g1[$_g];
				++$_g;
				$this->serializeString($f);
				$this->serialize(Reflect::field($v, $f));
				unset($f);
			}
		}
		$this->buf->add("g");
	}
	public function serialize($v) {
		{
			$_g = Type::typeof($v);
			switch($_g->index) {
			case 0:{
				$this->buf->add("n");
			}break;
			case 1:{
				if(_hx_equal($v, 0)) {
					$this->buf->add("z");
					return;
				}
				$this->buf->add("i");
				$this->buf->add($v);
			}break;
			case 2:{
				if(Math::isNaN($v)) {
					$this->buf->add("k");
				} else {
					if(!Math::isFinite($v)) {
						$this->buf->add((($v < 0) ? "m" : "p"));
					} else {
						$this->buf->add("d");
						$this->buf->add($v);
					}
				}
			}break;
			case 3:{
				$this->buf->add((($v) ? "t" : "f"));
			}break;
			case 6:{
				$c = $_g->params[0];
				{
					if((is_object($_t = $c) && !($_t instanceof Enum) ? $_t === _hx_qtype("String") : $_t == _hx_qtype("String"))) {
						$this->serializeString($v);
						return;
					}
					if($this->useCache && $this->serializeRef($v)) {
						return;
					}
					switch($c) {
					case _hx_qtype("Array"):{
						$ucount = 0;
						$this->buf->add("a");
						$l = _hx_len($v);
						{
							$_g1 = 0;
							while($_g1 < $l) {
								$i = $_g1++;
								if($v[$i] === null) {
									$ucount++;
								} else {
									if($ucount > 0) {
										if($ucount === 1) {
											$this->buf->add("n");
										} else {
											$this->buf->add("u");
											$this->buf->add($ucount);
										}
										$ucount = 0;
									}
									$this->serialize($v[$i]);
								}
								unset($i);
							}
						}
						if($ucount > 0) {
							if($ucount === 1) {
								$this->buf->add("n");
							} else {
								$this->buf->add("u");
								$this->buf->add($ucount);
							}
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("List"):{
						$this->buf->add("l");
						$v1 = $v;
						if(null == $v1) throw new HException('null iterable');
						$__hx__it = $v1->iterator();
						while($__hx__it->hasNext()) {
							$i = $__hx__it->next();
							$this->serialize($i);
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("Date"):{
						$d = $v;
						$this->buf->add("v");
						$this->buf->add($d->toString());
					}break;
					case _hx_qtype("haxe.ds.StringMap"):{
						$this->buf->add("b");
						$v1 = $v;
						if(null == $v1) throw new HException('null iterable');
						$__hx__it = $v1->keys();
						while($__hx__it->hasNext()) {
							$k = $__hx__it->next();
							$this->serializeString($k);
							$this->serialize($v1->get($k));
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("haxe.ds.IntMap"):{
						$this->buf->add("q");
						$v1 = $v;
						if(null == $v1) throw new HException('null iterable');
						$__hx__it = $v1->keys();
						while($__hx__it->hasNext()) {
							$k = $__hx__it->next();
							$this->buf->add(":");
							$this->buf->add($k);
							$this->serialize($v1->get($k));
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("haxe.ds.ObjectMap"):{
						$this->buf->add("M");
						$v1 = $v;
						$__hx__it = new _hx_array_iterator(array_values($v1->hk));
						while($__hx__it->hasNext()) {
							$k = $__hx__it->next();
							$this->serialize($k);
							$this->serialize($v1->get($k));
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("haxe.io.Bytes"):{
						$v1 = $v;
						$i = 0;
						$max = $v1->length - 2;
						$charsBuf = new StringBuf();
						$b64 = haxe_Serializer::$BASE64;
						while($i < $max) {
							$b1 = null;
							{
								$pos = $i++;
								$b1 = ord($v1->b[$pos]);
								unset($pos);
							}
							$b2 = null;
							{
								$pos = $i++;
								$b2 = ord($v1->b[$pos]);
								unset($pos);
							}
							$b3 = null;
							{
								$pos = $i++;
								$b3 = ord($v1->b[$pos]);
								unset($pos);
							}
							$charsBuf->add(_hx_char_at($b64, $b1 >> 2));
							$charsBuf->add(_hx_char_at($b64, ($b1 << 4 | $b2 >> 4) & 63));
							$charsBuf->add(_hx_char_at($b64, ($b2 << 2 | $b3 >> 6) & 63));
							$charsBuf->add(_hx_char_at($b64, $b3 & 63));
							unset($b3,$b2,$b1);
						}
						if($i === $max) {
							$b1 = null;
							{
								$pos = $i++;
								$b1 = ord($v1->b[$pos]);
							}
							$b2 = null;
							{
								$pos = $i++;
								$b2 = ord($v1->b[$pos]);
							}
							$charsBuf->add(_hx_char_at($b64, $b1 >> 2));
							$charsBuf->add(_hx_char_at($b64, ($b1 << 4 | $b2 >> 4) & 63));
							$charsBuf->add(_hx_char_at($b64, $b2 << 2 & 63));
						} else {
							if($i === $max + 1) {
								$b1 = null;
								{
									$pos = $i++;
									$b1 = ord($v1->b[$pos]);
								}
								$charsBuf->add(_hx_char_at($b64, $b1 >> 2));
								$charsBuf->add(_hx_char_at($b64, $b1 << 4 & 63));
							}
						}
						$chars = $charsBuf->b;
						$this->buf->add("s");
						$this->buf->add(strlen($chars));
						$this->buf->add(":");
						$this->buf->add($chars);
					}break;
					default:{
						$this->cache->pop();
						if(_hx_field($v, "hxSerialize") !== null) {
							$this->buf->add("C");
							$this->serializeString(Type::getClassName($c));
							$this->cache->push($v);
							$v->hxSerialize($this);
							$this->buf->add("g");
						} else {
							$this->buf->add("c");
							$this->serializeString(Type::getClassName($c));
							$this->cache->push($v);
							$this->serializeFields($v);
						}
					}break;
					}
				}
			}break;
			case 4:{
				if($this->useCache && $this->serializeRef($v)) {
					return;
				}
				$this->buf->add("o");
				$this->serializeFields($v);
			}break;
			case 7:{
				$e = $_g->params[0];
				{
					if($this->useCache && $this->serializeRef($v)) {
						return;
					}
					$this->cache->pop();
					$this->buf->add((($this->useEnumIndex) ? "j" : "w"));
					$this->serializeString(Type::getEnumName($e));
					if($this->useEnumIndex) {
						$this->buf->add(":");
						$this->buf->add($v->index);
					} else {
						$this->serializeString($v->tag);
					}
					$this->buf->add(":");
					$l = count($v->params);
					if($l === 0 || _hx_field($v, "params") === null) {
						$this->buf->add(0);
					} else {
						$this->buf->add($l);
						{
							$_g1 = 0;
							while($_g1 < $l) {
								$i = $_g1++;
								$this->serialize($v->params[$i]);
								unset($i);
							}
						}
					}
					$this->cache->push($v);
				}
			}break;
			case 5:{
				throw new HException("Cannot serialize function");
			}break;
			default:{
				throw new HException("Cannot serialize " . Std::string($v));
			}break;
			}
		}
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
	static $USE_CACHE = false;
	static $USE_ENUM_INDEX = false;
	static $BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
	function __toString() { return $this->toString(); }
}
