package data;
import sys.db.Types;

@:id(id)
@:table("intuition_tags")
class Tag extends sys.db.Object
{
	public var id : SId;
	public var name : String;
	public var color : String;

	public function new(name : String, color : String)
	{
		super();
		this.name = name;
		this.color = color;
	}

	public function getObject()
	{
		return
		{
			id : this.id,
			name : this.name,
			color : this.color,
		};
	}
}