package data;
import sys.db.Types;

@:id(id)
@:table("intuition_productTags")
class ProductTag extends sys.db.Object
{
	public var id : SId;
	@:relation(productId) public var product : Product;
	@:relation(tagId) public var tag : Tag;
	public var score : Float;

	public function new(product : Product, tag : Tag, score : Float)
	{
		super();
		this.product = product;
		this.tag = tag;
		this.score = score;
	}

	public function getObject()
	{
		return
		{
			product : this.product,
			tag : this.tag,
			score : this.score,
		};
	}
}