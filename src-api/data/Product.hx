package data;
import sys.db.Types;

@:id(id)
@:table("intuition_products")
class Product extends sys.db.Object
{
	public var id : SId;
	public var name : String;
	public var price : Float;
	public var imageURL : String;
	public var url : String;

	public function new(name : String, price : Float, imageURL : String, url : String)
	{
		super();
		this.name = name;
		this.price = price;
		this.imageURL = imageURL;
		this.url = url;
	}
}