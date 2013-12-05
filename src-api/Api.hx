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

	@description("Add a tag in the database")
	@param1("name : the name of the tag \"sweet\", \"calm\", ...")
	@param2("color : hexadecimal representation of a corresponding color : #614287")
	public function addTag(name : String, color : String)
	{
		new Tag(name, color).insert();
		Sys.print(haxe.Json.stringify({success : true}));
	}

	@description("Return the list of tags")
	public function getTags()
	{
		var result = [];
		for(tag in Tag.manager.all())
			result.push(tag.getObject());
		Sys.print(haxe.Json.stringify(result));
	}

	@description("Return some tag based on history")
	public function getNewTag()
	{
		Sys.print(haxe.Json.stringify({name : "Test", color : "#123456"}));
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

	@description("Return a product based on id")
	@param1("id : id of the product")
	public function getProduct(id : Int)
	{
		Sys.print(haxe.Json.stringify(Product.manager.get(id).getObject()));
	}

	@description("Return a tag based on id")
	@param1("id : id of the product")
	public function getTag(id : Int)
	{
		Sys.print(haxe.Json.stringify(Tag.manager.get(id).getObject()));
	}
}