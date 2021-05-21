/*Manejador para los eventos relacionados con el cambio de estado en la batería del dipositivo móvil.
Dependiendo del nivel de la batería carga un logo de pila u otro */
function onBatteryStatus(status){

	batteryNotification = document.getElementById("batteryNotification");
        batteryNotification.style.display = "block";

        if (status.level < 10)
            batteryNotification.className = "fa fa-battery-0 text-danger";
        else if (status.level < 25)
            batteryNotification.className = "fa fa-battery-1 text-danger";
        else if (status.level < 50)
            batteryNotification.className = "fa fa-battery-2 text-warning";
        else if (status.level < 75)
            batteryNotification.className = "fa fa-battery-3 text-success";
        else
            batteryNotification.className = "fa fa-battery-4 text-success";	
    
}


/*Manejador para los eventos relacionados con la pérdida de la conexión del dipositivo móvil.
Mostrará un logo wifi en rojo en señal de aviso*/
function offlineManager (){

    var networkState = navigator.connection.type;
	
	
    document.getElementById("NoWifiNotification").style.display = "none";
    document.getElementById("wifiNotification").style.display = "none";
    document.getElementById("4gConnection").style.display = "none";
    document.getElementById("3gConnection").style.display = "none";
    document.getElementById("connection").style.display = "none";

    if (networkState == Connection.NONE){

	document.getElementById("NoWifiNotification").style.display = "block";
        
    }

}

/*Manejador para los eventos relacionados la conexión del dipositivo móvil, cuando esta existe.
Dependiendo de si la conexión es wifi, 4g, 3g o cualquier otra, muestra un logo u otro*/
function onlineManager (){
    
    var networkState = navigator.connection.type;


    document.getElementById("NoWifiNotification").style.display = "none";
    document.getElementById("wifiNotification").style.display = "none";
    document.getElementById("4gConnection").style.display = "none";
    document.getElementById("3gConnection").style.display = "none";
    document.getElementById("connection").style.display = "none";
        
    if (networkState == Connection.WIFI){	        
	document.getElementById("wifiNotification").style.display = "block";
	return;
    }

    if (networkState == Connection.CELL_4G){	        
	document.getElementById("4gConnection").style.display = "block";
	return;
    }
   
    if (networkState == Connection.CELL_3G){	        
	document.getElementById("3gConnection").style.display = "block";
	return;
    }
        
    document.getElementById("connection").style.display = "block";

    return;    
    
}

/* Función que se llama desde una noticia concreta para compartirla por redes sociales*/
function share(url) {
    navigator.share && navigator.share({
        title: "Latest Space News",
        text: "Checkout this piece of news",
        url: url,
    });
}
