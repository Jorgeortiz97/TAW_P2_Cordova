/*Captura el evento que dice que la app está lista y ejecuta el manejador.
Captura también los eventos relacionados con la conexión de red y la batería.*/
var app = {

	initialize: function() { 
		
		document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);	
		document.addEventListener("offline", offlineManager, false); 
    		document.addEventListener("online", onlineManager, false);  
    
	},
	/*Procesa los parámetros que llegan por la URL relacionados con la búsqueda almacenada a cargar.
	Redefine la URL sin parámetros.*/
	onDeviceReady: function() {
        
		window.addEventListener("batterystatus", onBatteryStatus, false); 
   		 
    		var URLpage = window.location.search;
    		var query = URLpage.split('url=')[1];
    
    		query = query.split("&_start=")[1].substring(1).trim();
    		history.pushState(null, "", "saved-search.html");
    		loadArticles({ query: query });
    	}
};


app.initialize();


