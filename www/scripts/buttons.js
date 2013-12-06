$(document).ready(function(){

	var products = null;

	$("#choices .yes").click(function(){
		buttonPress(1);
	});

	$("#choices .unsure").click(function(){
		buttonPress(0);
	});

	$("#choices .no").click(function(){
		buttonPress(-1);
	});



	$("#colorblind").click(function(){
		if($("body").css("color") == "rgb(245, 245, 245)" || $("body").css("color") == "#f5f5f5"){
			$("body").css("color","#222");
			$("#lg").css("content", "url(../src-icons/logo60x60b.png)");
		}
		else{
			$("body").css("color","#f5f5f5");
			$("#lg").css("content", "url(../src-icons/logo60x60.png)");
		}
	});
	

	function buttonPress(code)
	{
		var name = $("#notion").text();
		

		jQuery.getJSON("http://developersrift.projets-bx1.fr/api/getAvailProducts", function(data){
			console.log(data)
			products = data;
		});

		if(products != null && products.length >= 3){
			$("#notion").text("peut-être ?");
			$("#notion").append("<div class=\"productFrame\">");
			$("#notion").append("<img class=\"productImage\" src=\""+products[0]["imageURL"]+"\"/>");
			$("#notion").append("<span class=\"productPrice\">"+products[0]["price"]+" €</span>");
			$("#notion").append("</div>");

		} else {
			jQuery.ajax({
			type: "get",
			dataType: "json",
			url:"http://developersrift.projets-bx1.fr/api/rateTag",
			data:"tag="+name+"&rating="+code,
			
			});
			jQuery.getJSON("http://developersrift.projets-bx1.fr/api/getNewTag", function(data){
				$("#notion").text(data.name);
				$("body").css("background-color",data.color);
			});
			var color = $("body").css("background-color");
		    var digits = /(.*?)rgb\((\d+), (\d+), (\d+)\)/.exec(color);

		    var red = parseInt(digits[2]);
		    var green = parseInt(digits[3]);
		    var blue = parseInt(digits[4]);

	  
			if ((0.2125 * red + 0.7154 * green + 0.0721 * blue)<= 128){
		   		$("body").css("color","#f5f5f5");	
		   	} else {
		   		$("body").css("color","#222");
		   	}
	}
}

});