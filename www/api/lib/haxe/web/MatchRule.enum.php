<?php

class haxe_web_MatchRule extends Enum {
	public static $MRBool;
	public static $MRDispatch;
	public static $MRFloat;
	public static $MRInt;
	public static function MROpt($r) { return new haxe_web_MatchRule("MROpt", 6, array($r)); }
	public static function MRSpod($c, $lock) { return new haxe_web_MatchRule("MRSpod", 5, array($c, $lock)); }
	public static $MRString;
	public static $__constructors = array(1 => 'MRBool', 4 => 'MRDispatch', 2 => 'MRFloat', 0 => 'MRInt', 6 => 'MROpt', 5 => 'MRSpod', 3 => 'MRString');
	}
haxe_web_MatchRule::$MRBool = new haxe_web_MatchRule("MRBool", 1);
haxe_web_MatchRule::$MRDispatch = new haxe_web_MatchRule("MRDispatch", 4);
haxe_web_MatchRule::$MRFloat = new haxe_web_MatchRule("MRFloat", 2);
haxe_web_MatchRule::$MRInt = new haxe_web_MatchRule("MRInt", 0);
haxe_web_MatchRule::$MRString = new haxe_web_MatchRule("MRString", 3);
