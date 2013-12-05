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

	@description("Return some tag based on history")
	public function getTag()
	{
		Sys.print(haxe.Json.stringify({name : "Test", color : "#123456"}));
	}


	@description("Add a product in the database")
	@param1("name")
	@param2("price")
	@param3("imageURL")
	@param4("url")
	public function addProduct(name : String, price : String, imageURL : String, url : String)
	{
		new Product(name, Std.parseFloat(price), imageURL, url).insert();
		Sys.print(haxe.Json.stringify({success : true}));
	}
}