$(document).ready(function(){
	$("#envoyer").click(function(){
		var name = $("#name").val();
		var color = $("#color").val();
		jQuery.ajax({
			type: "get",
			dataType: "json",
			url:"http://developersrift.projets-bx1.fr/api/addTag",
			data:"?name="+name+"&color="+color,
			
		});
	});
});
