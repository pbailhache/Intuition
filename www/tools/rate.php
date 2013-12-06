<!DOCTYPE html>
<html>
	<head>
		
	</head>
	<body>
		<div id="product">
			
		</div>

		<script type="text/javascript">
				jQuery.getJSON("http://developersrift.projets-bx1.fr/api/getNewTag", function(data){
				$("#notion").text(data.name);
				$("body").css("background-color",data.color);
			});
		</script>
	</body>
</html>