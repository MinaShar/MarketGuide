(function(){

	var AttachLoinEvent = function(){
		$('#LoginFrm input[type=submit]').on('click',function(event){
			
			event.preventDefault();

			alert('You pressed on login button');

			////////////////get the url/////////////////////
			var CurURL=window.location.href;
			var NewURL = CurURL.substring(0, CurURL.indexOf("public/")+7);
    		////////////////////////////////////////////////
    		var form = document.getElementById("LoginFrm");

    		var formdata=new FormData(form);

    		$.ajax({
    			type: "POST",
    			url: NewURL+"AdminLoginAttempt",
    			data: formdata ,
    			processData: false,  
    			contentType: false,
    			success: function (data) {

    				if (data.code == 1) {
    					$('#LoginFrm').submit();
    				}

    			},
    			error: function(xhr, ajaxOptions, thrownError){
    				alert('sent url= '+this.url);
    				alert(xhr.status);
    				alert(xhr.responseText);
    				alert(thrownError);
    				document.getElementById("ForTestingIssues").innerHTML=xhr.responseText;
    			}
    		});

    		return false;
    	});
	};

	AttachLoinEvent();

	alert('THE SCRIPT IS READY!');

})();