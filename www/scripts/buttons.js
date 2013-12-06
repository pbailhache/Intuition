$(document).ready(function(){

	$("#choices .yes").click(function(){
		var name = $("#name").val();
		jQuery.ajax({
			type: "get",
			dataType: "json",
			url:"http://developersrift.projets-bx1.fr/api/addTag",
			data:"?name="+name+"&rating=1",
			
		});
		jQuery.getJSON("http://developersrift.projets-bx1.fr/api/getNewTag", function(data){
			$("#notion").text(data.name);
			$("body").css("background-color",data.color);
		});
		
	});

	$("#choices .unsure").click(function(){
		var name = $("#name").val();
		jQuery.ajax({
			type: "get",
			dataType: "json",
			url:"http://developersrift.projets-bx1.fr/api/addTag",
			data:"?name="+name+"&rating=0",
			
		});
		jQuery.getJSON("http://developersrift.projets-bx1.fr/api/getNewTag", function(data){
			$("#notion").text(data.name);
			$("body").css("background-color",data.color);
		});
	});

	$("#choices .no").click(function(){
		var name = $("#name").val();
		jQuery.ajax({
			type: "get",
			dataType: "json",
			url:"http://developersrift.projets-bx1.fr/api/addTag",
			data:"?name="+name+"&rating=-1",
			
		});
		jQuery.getJSON("http://developersrift.projets-bx1.fr/api/getNewTag", function(data){
			$("#notion").text(data.name);
			$("body").css("background-color",data.color);
		});
	});

	$("#choices").click(function(){
		var color = $("body").css("background-color");
		console.log("color : "+color);

/*		var r = parseInt(color.substr(0,2));
		var g = parseInt(color.substr(2,4));
   		var b = parseInt(color.substr(4));*/

  
   		if ((0.2125 * r + 0.7154 * g + 0.0721 * b)<= 128){
   			$("body").css("color","#f5f5f5");
   			
   		} else {
   			$("body").css("color","#222");

   		}
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