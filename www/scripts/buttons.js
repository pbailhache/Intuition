$(document).ready(function(){

	$("#choices .yes").click(function(){
		jQuery.getJSON("http://developersrift.projets-bx1.fr/api/getNewTag", function(data){
			$("#notion").text(data.name);
			$("body").css("background-color",data.color);
		});
	});

	$("#choices .unsure").click(function(){
		jQuery.getJSON("http://developersrift.projets-bx1.fr/api/getNewTag", function(data){
			$("#notion").text(data.name);
			$("body").css("background-color",data.color);
		});
	});

	$("#choices .no").click(function(){
		jQuery.getJSON("http://developersrift.projets-bx1.fr/api/getNewTag", function(data){
			$("#notion").text(data.name);
			$("body").css("background-color",data.color);
		});
	});

	$("#colorblind").click(function(){
		if($("body").css("color") == "rgb(245, 245, 245)" || $("body").css("color") == "#f5f5f5"){
			$("body").css("color","#222");
		}
		else{
			$("body").css("color","#f5f5f5");
		}
	});


});