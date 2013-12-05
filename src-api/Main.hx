import php.Web;
import haxe.web.Dispatch;
import php.Session;

using StringTools;

class Main
{
	var api : Api;

	static function main()
	{
		new Main();
	}

	public function new()
	{
		api = new Api();

		// Dispatch
		try
		{
			Dispatch.run(Web.getURI(), Web.getParams(), this);
		}
		catch(error : DispatchError)
		{
			doError(new Dispatch(Web.getURI(), Web.getParams()));
		}
	}

	public function doDefault()
	{
		api.doc();
	}
	public function doApi(dispatch : Dispatch)
	{
		var params = new Array<String>();
		for(param in dispatch.params)
			params.push(param);
		
		try
		{
			Reflect.callMethod(api, Reflect.field(api, dispatch.parts[0]), params);
		}
		catch(s : String)
		{
			trace("Function error");
		}
	}
	
	// Ressources modules
	public function doError(dispatch : Dispatch)
	{
		Sys.print("error");
	}

}