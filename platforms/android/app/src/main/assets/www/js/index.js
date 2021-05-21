
/*Captura el evento que dice que la app está lista y ejecuta el manejador.
Captura también los eventos relacionados con la conexión de red y la batería.*/
var app = {

	initialize: function() { 
		
		document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);	
		document.addEventListener("offline", offlineManager, false); 
    		document.addEventListener("online", onlineManager, false);  
    
	},
	
	onDeviceReady: function() {
        
		window.addEventListener("batterystatus", onBatteryStatus, false);    		 
    		loadArticles();
    	}
};


app.initialize();
