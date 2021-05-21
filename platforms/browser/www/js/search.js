var start;
var query;

function search() {

    let title = document.getElementById("title").value,
        summary = document.getElementById("summary").value,
        before = document.getElementById("before").value,
        after = document.getElementById("after").value,
        featured = document.getElementById("featured").checked;

    query = "";
    if (title)
        query += "&title_contains=" + title;
    if (summary)
        query += "&summary_contains=" + summary;
    if (before)
        query += "&publishedAt_lt=" + before;
    if (after)
        query += "&publishedAt_gt=" + after;
    if (featured)
        query += "&featured=true";
    loadArticles({ query: query, showToast: true });
    start = "false";
}

/*Comprueba si se ha querido almacenar una búsqueda antes de que se haya producido*/
function saveSearch() {

    if (start == "true") {
        $('.alert').show();
        setTimeout(function() {
            $(".alert").hide();
        }, 2000);
    } else {
        $("#modal-name").modal("show");
        document.getElementById("required-name").style.display = "none";
    }

}

/*Comprueba que la pulsar el botón para almecenar una búsqueda se haya introducido un nombre,
si es así se almacena en el Local Storage*/
function saveSearchName(e) {
    e.preventDefault();
    var name = document.getElementById("input-name").value;

    if (name == "") {
        document.getElementById("required-name").style.display = "block";
    } else {
        localSave(name, query);
        document.getElementById("input-name").value = null;
        $("#modal-name").modal('hide');
    }
}

/*Almacena una búsqueda en el Local Storage*/
function localSave(name, query) {

    let fecha = new Date();
    let index = selectIndex();

    /* Save data using local storage */
    window.localStorage.setItem("url#" + index.toString(), url + "#@" + name + "#@" + fecha.getDate() + "#@" + (fecha.getMonth() + 1) + "#@" + fecha.getFullYear());
}


/* - Selecciona el siguiente índice que corresponde para el didentificador de almacenamiento de la búsqueda.   
   - Comprueba que lo que va recuperando del Loacal Storage sea una búsqueda nuestra y no otra entidad almacenada. */
function selectIndex() {

    var lowest_idx = 0;
    let keys = Object.keys(window.localStorage);

    for (i = 0; i < keys.length; i++) {
        let idx = parseInt(keys[i].split("#")[1]);
    	if ((idx >= lowest_idx) && (keys[i].split("#")[0] == "url") && (keys[i].split("#").length == 2) && (!window.isNaN((keys[i].split("#")[1])))){
            lowest_idx = idx + 1;
	}
    }
    return lowest_idx;
}

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
    		 $(".datepicker").datepicker({
        		dateFormat: 'yy-mm-dd',
    		});
    
    		document.getElementById("searchBtn").onclick = search;
    		document.getElementById("saveSearchBtn").onclick = saveSearch;
    		document.getElementById("saveSearchNameBtn").onclick = saveSearchName;
    		start = "true";
    	}
};


app.initialize();


