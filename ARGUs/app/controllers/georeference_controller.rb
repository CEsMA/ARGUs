class GeoreferenceController < ApplicationController
  wsdl_service_name 'Georeference'

  def georeference(info)
    puntos = ''
    count = 0
    ## info = info.split('#')
    for p in info
      ## array = p.split('|')
      puntos << " newpoints[#{count}] = new Array( #{p.longitud},#{p.latitud}, icon0, '#{count+1}', '<div style=\"width: 210px; padding-right: 10px\">#{p.informacion}</div>'); "
      count = count + 1
    end
    
 
    inicio = "

<div align=\"center\">

<script src=\" http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAQXg9v_4YZgsHMjQDNACQQxRU8pCR_eiJ8Aijvq5aFAMflX02ShQ7Q6JFi9Y76LM_qy6ERhrZnH7Tvw\" type=\"text/javascript\"></script>
<script type=\"text/javascript\">


//<![CDATA[
var map;
var icon0;
var icon1;

var latNO;
var longNO;
var latSE;
var longSE;

var areaSelector;

var newpoints = new Array();
var highlightCircle;
var currentMarker;

addLoadEvent(loadMap);
addLoadEvent(addPoints);


//Funcion que se encarga de iluminar los GIcons.
function highlightCurrentMarker(type){
      var markerPoint = currentMarker.getPoint();
      var polyPoints = Array();

      if (highlightCircle) {
        map.removeOverlay(highlightCircle);
      }

      var mapNormalProj = G_NORMAL_MAP.getProjection();
      var mapZoom = map.getZoom();
      var clickedPixel = mapNormalProj.fromLatLngToPixel(markerPoint, mapZoom);
      var polySmallRadius = 20;
      var polyNumSides = 20;
      var polySideLength = 18;

      for (var a = 0; a<(polyNumSides+1); a++) {
        var aRad = polySideLength*a*( Math.PI/180);
        var polyRadius = polySmallRadius;
               var pixelX = clickedPixel.x + polyRadius * Math.cos(aRad);
        var pixelY = clickedPixel.y + polyRadius * Math.sin(aRad);
        var polyPixel = new GPoint(pixelX,pixelY);
        var polyPoint = mapNormalProj.fromPixelToLatLng(polyPixel,mapZoom);
        polyPoints.push(polyPoint);
      }  
      if (type == \"draggable\") {
           highlightCircle = new GPolygon(polyPoints,\"#000000\",2, 0.0,\"#FF0000\",.5);
      }else{
           highlightCircle = new GPolygon(polyPoints,\"#000000\",2,0.0,\"#FF00FF\",.5);
      }
    map.addOverlay(highlightCircle);
   }




function addLoadEvent(func) {
    var oldonload = window.onload;
    if (typeof window.onload != 'function'){
        window.onload = func
    } else {
        window.onload = function() {
            oldonload();
            func();
        }
    }
}
 


// Agrega al mapa los 2 selectores y carga por primera vez los input fields asociados al GMarker.
function createSelectors(){
    var counter = 0;
    var marker;

    var addSelectors = GEvent.bind(map, \"click\", this, function(marker,point) {         
            //Se define el GIcon por defecto
            icon1 = new GIcon();
            icon1.image = \"http://maps.google.com/mapfiles/arrow.png\";
            icon1.iconSize = new GSize(39, 34);
            icon1.iconAnchor = new GPoint(11, 34);
            icon1.infoWindowAnchor = new GPoint(9, 2);
            icon1.infoShadowAnchor = new GPoint(18, 25);  

            if (counter <= 1) {
              if (point && counter==1){
             marker = new GMarker(point, {draggable:true, title:\"Soy un delimitador\", icon:icon1});
             document.getElementById(\"longB\").value=marker.getPoint().lng();
              document.getElementById(\"latB\").value=marker.getPoint().lat();
             updatePointSelectors();
             map.addOverlay(addMarkersEvent(\"S-E\",\"draggable\", marker, \"<br/>Upss, soy un selector.\"));
          
             if (areaSelector) {
                    map.removeOverlay(areaSelector);
                 }

             areaSelector = new GPolygon([
             new GLatLng(latNO, longNO),
             new GLatLng(latSE, longNO),
             new GLatLng(latSE, longSE),
             new GLatLng(latNO, longSE),
             new GLatLng(latNO, longNO)
             ],
            \"#f33f00\", 1, 1, \"#ff0000\", 0.2);
            map.addOverlay(areaSelector);               


              }else{
             marker = new GMarker(point, {draggable:true, title:\"Soy un delimitador\", icon:icon1});       
             document.getElementById(\"longA\").value=marker.getPoint().lng();
              document.getElementById(\"latA\").value=marker.getPoint().lat();
             updatePointSelectors();
              map.addOverlay(addMarkersEvent(\"N-O\",\"draggable\", marker, \"<br/>Upss, soy un selector.\"));
              }
               counter++;
            } else {
                GEvent.removeListener (addSelectors);
            }
    });
}

//Keeps updated the points of the areaSelectors.
function updatePointSelectors(){
 latNO = document.getElementById(\"latA\").value;
 longNO = document.getElementById (\"longA\").value;
 latSE = document.getElementById(\"latB\").value;
 longSE = document.getElementById(\"longB\").value;
}



function loadMap() {
    map = new GMap2(document.getElementById (\"map\"));
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.setCenter(new GLatLng( 6.664607562172585, -64.248046875 ), 5, G_HYBRID_MAP);
   
    //Se define el GIcon por defecto
    icon0 = new GIcon();
    icon0.image = \"http://www.google.com/mapfiles/marker.png\";
    icon0.iconSize = new GSize(20, 34);
    icon0.iconAnchor = new GPoint(9, 34);
    icon0.infoWindowAnchor = new GPoint(9, 2);
    icon0.infoShadowAnchor = new GPoint(18, 25);

    if(document.getElementById (\"longA\") && document.getElementById(\"latA\") && document.getElementById(\"longB\") && document.getElementById(\"latB\")){
        createSelectors();
    }
}
 



// Agrega los Gmarkers pasados como parametros.
function addPoints() {"

final = "
 for(var i = 0; i < newpoints.length; i++) {
    var point = new GPoint(newpoints[i][0],newpoints[i][1]);
    var popuphtml = newpoints[i][4] ;
    var marker = createMarker(point,newpoints[i][2],popuphtml);
    map.addOverlay(marker);
 }
}



// Agrega los eventos a los GIcons.
function addMarkersEvent(whois,type, marker,popuphtml){

     GEvent.addListener(marker, \"dragstart\", function() {
                map.closeInfoWindow();
         });
   
     GEvent.addListener(marker, \"click\", function() {
        marker.openInfoWindowHtml (popuphtml);
     });
   
      // This line highlights the marker when it's clicked
          GEvent.addListener(marker, \"click\", function() {
          currentMarker = marker;
          highlightCurrentMarker(type);   
          });

      // This line highlights the marker when its moused over
          GEvent.addListener(marker, \"mouseover\", function() {
          currentMarker = marker;
          highlightCurrentMarker(type);   
          });

       // This line highlights the marker while dragging and keeps updated de input fields.
          GEvent.addListener(marker, \"drag\", function() {
          currentMarker = marker;
          highlightCurrentMarker(type);   
          if(whois!=\"false\"){
                    if(whois==\"N-O\"){       
                document.getElementById (\"longA\").value=marker.getPoint ().lng();
                document.getElementById(\"latA\").value=marker.getPoint().lat();
            }else{
                document.getElementById(\"longB\").value= marker.getPoint().lng();
                document.getElementById(\"latB\").value=marker.getPoint().lat();
            }
            updatePointSelectors();

            if (areaSelector) {
                    map.removeOverlay(areaSelector);
                }           
          
            areaSelector = new GPolygon([
            new GLatLng(latNO, longNO),
            new GLatLng(latSE, longNO),
            new GLatLng(latSE, longSE),
            new GLatLng(latNO, longSE),
            new GLatLng(latNO, longNO)
            ],
            \"#f33f00\", 1, 1, \"#ff0000\", 0.2);
            map.addOverlay(areaSelector);   
            }   
        });
    return marker;
}



//Crea los Gmarkers que representan los puntos pasados como parametros.
function createMarker(point, icon, popuphtml) {
    var marker = new GMarker(point,icon0);
    marker = addMarkersEvent(\"false\",\"false\", marker,popuphtml);
    return marker;
}


//]]>
    </script>

  <div id=\"map\" style=\"width: 600px; height: 450px\"></div>
</div>
 "

  return inicio<<puntos<<final
  end
end
