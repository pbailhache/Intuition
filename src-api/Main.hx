import php.Web;
import haxe.web.Dispatch;
import php.Session;
import data.*;

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
		sys.db.Manager.cnx = sys.db.Mysql.connect(
			{
				//
				host : "localhost",
				port : null,
				user : "root",
				pass : "",
				database : "labeli",
				socket : null
				//*/
				/*/
				host : "mysql51-44.pro",
				port : null,
				user : "projetsbxnuit",
				pass : "greenShrimp",
				database : "projetsbxnuit",
				socket : null
				//*/
			}
		);

		// Create missing tables
		if(!sys.db.TableCreate.exists(Product.manager))         { sys.db.TableCreate.create(Product.manager); }
		if(!sys.db.TableCreate.exists(Tag.manager))         	{ sys.db.TableCreate.create(Tag.manager); }

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
			api.doc();
		}
	}
	
	// Ressources modules
	public function doError(dispatch : Dispatch)
	{
		Sys.print("error");
	}
}