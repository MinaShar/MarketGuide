(function(){

	// alert('the script is ready!');

	var productDefinitorTimeOut,
    setupSideBar = function(){
		$('.sidebaritem').off().on('click',function(){
			var itemClicked=$(this).data('item');
			switch(itemClicked){
				case 'Map':
				getMapPage();
				break;
			}
		});
	},getMapPage = function(){

		////////////////get the url/////////////////////
		var CurURL=window.location.href;
		var NewURL = CurURL.substring(0, CurURL.indexOf("public/")+7);
    	////////////////////////////////////////////////

    	$.ajax({
    		type: "GET",
    		url: NewURL+"getMapPage",
    		processData: false,  
    		contentType: false,
    		success: function (data) {
    			document.getElementById("MainContent").innerHTML=data;

                var body = document.body,
                html = document.documentElement;

                var height = Math.max( body.scrollHeight, body.offsetHeight, 
                 html.clientHeight, html.scrollHeight, html.offsetHeight );
                $('.navbar.navbar-default.sidebar').css("height",height+'px');
                $('.navbar.navbar-default.sidebar').hide().show(0);

    			createGrid(50);

                $('#ShowMapNodes').on('click',function(){
                    getMapNodes();
                });

                var check_timer = null,
                mouse_douwn_events = 0;
                // var flag_for_clicks = false;

                $('#MapMainContent').off('mousedown').on('mousedown',function(event){

                    mouse_douwn_events++;

                    var self=$(this);
                    $('#MapMainContent').off('mouseup').on('mouseup',function(){
                        mouse_douwn_events--;
                    });
                    // if (flag_for_clicks == true) {
                    //     flag_for_clicks = false;
                    //     return;
                    // }

                    if (check_timer == null) {

                        check_timer = setTimeout(function(){
                            clearTimeout(check_timer);
                            check_timer = null;
                            if (mouse_douwn_events > 0) {
                                mouse_douwn_events = 0;
                                createRegions(self,event);
                            }
                            
                        },1000);


                    }else{
                        mouse_douwn_events = 0;
                        clearTimeout(check_timer);
                        check_timer = null;
                        console.log("the event :");
                        console.log(event);
                    
                        if(event.target.parentNode.classList[0]=="MapComponent"){
                            $('.MapComponent').trigger("dblclick",event)
                        }else{
                            $('.grid').trigger("dblclick",event);
                        }
                        // flag_for_clicks = true;
                    }

                });

                $('.grid').off().on('dblclick',function(event,custom_event){
                    // alert('Oprn handler now!');

                    if (custom_event) {
                        event = custom_event;
                    }

                    var elem = document.getElementById("gridContainer");
                    var rect = elem.getBoundingClientRect();
                    console.log(rect.top, rect.right, rect.bottom, rect.left);

                    var top_scroll=parseInt($(window).scrollTop());
                    var left_scroll=parseInt($(window).scrollLeft());

                    var offsetX = event.pageX - rect.left - left_scroll;
                    var offsetY = event.pageY - rect.top - top_scroll ;

                    $("#MapComponentDescriptionModal").modal("show");

                    $('#AddNewComponentFrm').off().on('submit',function(ev){
                        ev.preventDefault();

                        var selectedValue=$(this).find('select[name=ComponentType]').val();

                        switch(selectedValue){
                            case "1":
                            var NewElement = $('<div class="MapComponent MapComponentVerical" style="top: '+offsetY+'px;left: '+offsetX+'px;" />').appendTo('#gridContainer');
                            break;
                            case "2":
                            var NewElement = $('<div class="MapComponent MapComponentHorizontal" style="top: '+offsetY+'px;left: '+offsetX+'px;" />').appendTo('#gridContainer');
                            break;
                        }

                        $("#MapComponentDescriptionModal").modal("hide");

                        setupAddingProductsLocation();

                        Draggable.create(".MapComponent", {type:"x,y", edgeResistance:0.65, bounds:"#gridContainer", throwProps:true});

                        // var form=$(this);
                        // var f = form;

                    });
                    // var e = event;
                    // $("#MapComponentDescriptionModal").modal("show");
                });


                $('#SaveMapBtn').off().on('click',function(event){

                    var elem = document.getElementById("gridContainer");
                    var rect = elem.getBoundingClientRect();
                    console.log(rect.top, rect.right, rect.bottom, rect.left);

                    event.preventDefault();

                    ////////////////////// save map regions ///////////////////////////
                    var AllRegions = [];
                    $(".MapRegions").each(function(index,obj){
                        var smallelement=obj.getBoundingClientRect();
                        var X = smallelement.left - rect.left;
                        var Y = smallelement.top - rect.top;
                        var width = parseInt( obj.style.width , 10);
                        var height = parseInt( obj.style.height , 10);
                        var rgb = obj.style.background;
                        rgb = rgb.substring(5, rgb.length-1).replace(/ /g, '').split(',');
                        var name = obj.childNodes[0].innerHTML;
                        AllRegions.push({
                            x: X,
                            y: Y,
                            width: width,
                            height: height,
                            r: rgb[0],
                            g: rgb[1],
                            b: rgb[2],
                            name:name
                        });
                    });

                    console.log(AllRegions);
                    ///////////////////////////////////////////////////////////////////
                    var AllComponents = [];
                    $(".MapComponent").each(function(index,obj){
                        var smallelement=obj.getBoundingClientRect();
                        var X = smallelement.left - rect.left;
                        var Y = smallelement.top - rect.top;
                        var is_vertical = $(this).hasClass('MapComponentVerical')? 1 : 0;
                        AllComponents.push({
                            X: X,
                            Y: Y,
                            is_vertical: is_vertical
                        });

                    });

                    // console.log(AllComponents);

                    $.ajax({
                        type: "POST",
                        url: NewURL+"create_map",
                        data: jQuery.param({ map : AllComponents , regions: AllRegions }),
                        processData: false,  
                        // contentType: false,
                        success: function (data) {
                            //MapCreationConfirmMsg
                            if (data.code == 1) {
                                $("#MapCreationConfirmMsg").modal("show");
                            }else{
                                alert("Somothing error happened!");
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

                });


            },
            error: function(xhr, ajaxOptions, thrownError){
            	alert('sent url= '+this.url);
            	alert(xhr.status);
            	alert(xhr.responseText);
            	alert(thrownError);
            	document.getElementById("ForTestingIssues").innerHTML=xhr.responseText;
            }
        });

        },createGrid = function(size) {
            var ratioW = Math.floor($("#MapMainContent").width()/size),
            ratioH = Math.floor($("#MapMainContent").height()/size);

            var parent = $('<div />', {
                class: 'grid',
                id: 'gridContainer',
                width: $("#MapMainContent").width(), 
                height: $("#MapMainContent").height()
            }).appendTo('#MapMainContent');

            for (var i = 0; i < ratioH; i++) {
                for(var p = 0; p < ratioW; p++){
                   $('<div />', {
                    width: size - 1 , 
                    height: size - 1
                }).appendTo(parent);
               }
            }
        },setupAddingProductsLocation = function(){
            $('.MapComponent').off().on('dblclick',function(event,custom_event){
                
                if (custom_event) {
                    event = custom_event;
                }
                event.preventDefault();
                event.stopPropagation();

                ////////////////get the url/////////////////////
                var CurURL=window.location.href;
                var NewURL = CurURL.substring(0, CurURL.indexOf("public/")+7);
                ////////////////////////////////////////////////


                var elem = document.getElementById("gridContainer");
                var rect = elem.getBoundingClientRect();
                console.log(rect.top, rect.right, rect.bottom, rect.left);

                var top_scroll=parseInt($(window).scrollTop());
                var left_scroll=parseInt($(window).scrollLeft());

                var offsetX = event.pageX - rect.left - left_scroll;
                var offsetY = event.pageY - rect.top - top_scroll ;


                $.ajax({
                    type: "GET",
                    url: "get_all_products",
                    // data: formData ,
                    processData: false,  
                    contentType: false,
                    success: function (data) {

                        $("#AddProductLocationModal #AddProductLoactionFrm select[name=Product] option").remove();
                        
                        var result = data.products;

                        $.each(result, function(key, value) {   
                            $('#AddProductLocationModal #AddProductLoactionFrm select[name=Product]')
                           .append($("<option></option>")
                            .attr("value",value.id)
                            .text(value.name)); 
                       });

                        $("#AddProductLocationModal").modal("show");

                        $("#AddProductLoactionFrm").off().on('submit',function(eve){
                            eve.preventDefault();
                            eve.stopPropagation();

                            var selectedID=$('#AddProductLocationModal #AddProductLoactionFrm select[name=Product]').val();
                            // alert("you selected product with id = "+selectedID);


                            $.ajax({
                                type: "POST",
                                url: NewURL+"add_product_location",
                                data: jQuery.param({ product_id : selectedID , x : offsetX , y : offsetY }),
                                processData: false,  
                                // contentType: false,
                                success: function (data) {

                                    var productlocationID = data.data.id;

                                    $('<div data-id='+productlocationID+' class="circleBase circleDiv" style="top: '+offsetY+'px;left: '+offsetX+'px;" />').appendTo('#gridContainer');
                                    bindProductLocationEvent();
                                    // alert("Request sent successfully!");
                                    $("#AddProductLocationModal").modal("hide");
                                        // if (data.code == 1) {
                                        //     $("#MapCreationConfirmMsg").modal("show");
                                        // }else{
                                        //     alert("Somothing error happened!");
                                        // }
                                    }
                                    ,error: function(xhr, ajaxOptions, thrownError){
                                        alert('sent url= '+this.url);
                                        alert(xhr.status);
                                        alert(xhr.responseText);
                                        alert(thrownError);
                                        document.getElementById("ForTestingIssues").innerHTML=xhr.responseText;
                                    }
                                });

                        });

                    },
                    error: function(xhr, ajaxOptions, thrownError){
                        alert('sent url= '+this.url);
                        alert(xhr.status);
                        alert(xhr.responseText);
                        alert(thrownError);
                        document.getElementById("ForTestingIssues").innerHTML=xhr.responseText;
                    }
                });
                // alert("you dblcliced a wall");
            });
        },bindProductLocationEvent = function(){
            $('.circleBase').off().on('mouseenter',function(event){
                // alert("you hovered on location with id = "+ $(this).data('id') );

                var product_location_id = $(this).data('id');
                var left  = event.clientX  + "px";
                var top  = event.clientY  + "px";

                var container_div=document.getElementById("ProductDefinitor");
                container_div.style.left = left;
                container_div.style.top = top;

                ////////////////////setup the container////////////////////////
                var heigher_z_index = -1;
                $('.MapComponent').each(function(){
                    var zindex = parseInt($(this).css("z-index"), 10);
                    if(zindex > heigher_z_index) {
                        heigher_z_index = zindex;
                    }

                });
                heigher_z_index++;
                ///////////////////////////////////////////////////////////////


                $.ajax({
                    type: "GET",
                    url: "get_product_by_product_location_id?product_location_id="+product_location_id,
                    // data: formData ,
                    processData: false,  
                    contentType: false,
                    success: function (data) {
                        $("#ProductDefinitor").find('h3').text(data.name);
                        $("#ProductDefinitor").css("z-index",heigher_z_index);
                        $("#ProductDefinitor").css("display","block");        
                    },
                    error: function(xhr, ajaxOptions, thrownError){
                        alert('sent url= '+this.url);
                        alert(xhr.status);
                        alert(xhr.responseText);
                        alert(thrownError);
                        document.getElementById("ForTestingIssues").innerHTML=xhr.responseText;
                    }
                });

                

                $('.circleBase,#ProductDefinitor').on('mouseleave',function(){
                    productDefinitorTimeOut = setTimeout(function(){
                        if ( ($('.circleBase:hover').length == 0) && ($('#ProductDefinitor:hover').length == 0) ) {
                            $("#ProductDefinitor").css("display","none");
                            // clearTimeout(productDefinitorTimeOut);
                        }else{
                            // alert("($('.circleBase:hover').length == 0) resulting => "+($('.circleBase:hover').length == 0)+" while $('#ProductDefinitor:hover').length == 0 resulting in "+($('#ProductDefinitor:hover').length == 0));
                        }
                    },1000);
                });

            });
        },getMapNodes = function(){

            var elem = document.getElementById("gridContainer");
            var rect = elem.getBoundingClientRect();
            console.log(rect.top, rect.right, rect.bottom, rect.left);

            $.ajax({
                    type: "GET",
                    url: "get_map_nodes",
                    // data: formData ,
                    processData: false,  
                    contentType: false,
                    success: function (data) {

                        alert('nodes length = '+data.nodes.length);

                        for (var i = 0; i < data.nodes.length; i++) {
                            // $('<div class="circleBase circleDiv" style="top: '+data.nodes[i].Y+'px;left: '+data.nodes[i].X+'px;" />').appendTo('#gridContainer');
                            $('<div style="position:absolute;top: '+data.nodes[i].Y+'px;left: '+data.nodes[i].X+'px;z-index:100;">'+data.nodes[i].id+'</div>').appendTo('#gridContainer');
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

        };

    setupSideBar();

})();


var static_background_index = 0
function createRegions(Map,e){
    // alert('Object create successfully');
    // console.log(Map);

    Map.off('mouseup');

    var mouse = {
        x: 0,
        y: 0,
        startX: 0,
        startY: 0
    };

    var is_dragging = true;

    var elem = document.getElementById("MapMainContent");
    var rect = elem.getBoundingClientRect();
    // console.log(rect.top, rect.right, rect.bottom, rect.left);

    var top_scroll=parseInt($(window).scrollTop());
    var left_scroll=parseInt($(window).scrollLeft());

    var offsetX = e.pageX - rect.left - left_scroll;
    var offsetY = e.pageY - rect.top - top_scroll ;

    var get_random_background = function(){

        var backgrounds = ['rgba(12,12,12,0.2)','rgba(159,210,28,0.2)','rgba(31, 14, 189,0.2)','rgba(245, 55, 34,0.2)'],
        length = backgrounds.length;
        last_index = static_background_index;
        static_background_index+=1;
        static_background_index = static_background_index % backgrounds.length;

        return backgrounds[ last_index % length ]
    };

    var element = document.createElement('div');
    console.log(element);
    console.log("begun.");
    mouse.startX = offsetX;
    mouse.startY = offsetY;
    element.className = 'MapRegions'
    element.style.left = offsetX + 'px';
    element.style.top = offsetY + 'px';
    element.style.background = get_random_background();
    Map.append(element);
    Map.css("cursor","crosshair");



    var mouseuphandler = function (e) {
        is_dragging = false;
        Map.css("cursor","default");
        console.log("finsihed.");
        console.log(element);

        $("#RegionNameModal").modal("show");

        $("#RegionNameModal input[type=submit]").off().on('click',function(event){
            event.preventDefault();
            var newname = $("#RegionNameModal input.newregionname.form-control").val();
            var new_element_text=document.createElement("div");
            new_element_text.innerHTML = newname;
            new_element_text.style.position = "absolute";
            new_element_text.style.display = "block";
            
            // console.log(element);
            element.appendChild(new_element_text);
            // $(new_element_text).hide().show(0);
            // new_element_text.style.visibility = "hidden";
            
            new_element_text.style.left = ((parseInt(element.style.width,10) / 2) - (parseInt(new_element_text.clientWidth,10) / 2)) + 'px';
            new_element_text.style.top = ((parseInt(element.style.height,10) / 2) - (parseInt(new_element_text.clientHeight,10) / 2)) + 'px';
            // new_element_text.style.visibility = "visible";
        });

        $('body').off('mousemove',"#MapMainContent",mousemovehandler);
        $('body').off('mouseup',"#MapMainContent",mouseuphandler);
        // element = null;

    },mousemovehandler = function (e) {
        if (is_dragging == true) {
            console.log("moving");
            setMousePosition(e);
            // console.log(mouse);

            element.style.width = Math.abs(mouse.x - mouse.startX) + 'px';
            element.style.height = Math.abs(mouse.y - mouse.startY) + 'px';
            element.style.left = (mouse.x - mouse.startX < 0) ? mouse.x + 'px' : mouse.startX + 'px';
            element.style.top = (mouse.y - mouse.startY < 0) ? mouse.y + 'px' : mouse.startY + 'px';

            // console.log("now the width = "+element.style.width+" height = "+element.style.height);
            // console.log("left = "+element.style.left+" top = "+element.style.top);
        }else{
            console.log("moving called from outside");
        }
    },setMousePosition = function(e) {
        var ev = e || window.event; //Moz || IE

        var top_scroll=parseInt($(window).scrollTop());
        var left_scroll=parseInt($(window).scrollLeft());

        mouse.x = e.pageX - rect.left - left_scroll;
        mouse.y = e.pageY - rect.top - top_scroll;
    };

    $('body').on('mousemove',"#MapMainContent",mousemovehandler);
    $('body').on('mouseup', "#MapMainContent",mouseuphandler );
}