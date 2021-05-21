/*Elimina todas las entidades almacenadas en el Local Storage*/
function deleteLocalStorage() {

    window.localStorage.clear();
    location.reload();
}

/*Recupera todas las búsquedas almacenadas en el Local Storage y va construyendo una tabla HTML con ellas.
Recupera el nombre de la búsqueda y la fecha en la que se almacenó.*/
function localLoad() {

    var searchs = [],
	indexes = [],
        keys = Object.keys(window.localStorage),
        i = keys.length,
	j;
      

    while (i--) {
	if ((keys[i].split("#")[0] == "url") && (keys[i].split("#").length == 2) && (!window.isNaN((keys[i].split("#")[1])))){
        	searchs.push(localStorage.getItem(keys[i]));
		indexes.push(keys[i]);
	}
    }
    
    var searchsHtml = '<div class="table-wrapper-scroll-y my-custom-scrollbar"><div class="table-responsive">' + ' <table class="table table-bordred table-sm"><thead class="thead-light"><th>Search history</th><th></th><th></th></thead><tbody>';
    j=0;

    for (search of searchs) {
	
        var searchComponents = search.split("#@");

	if (searchComponents.length == 5){

        	searchsHtml += '<tr><td><a href="#" id="' + searchComponents[0] + '" onclick="goSearch(this.id)">' + searchComponents[1] + '</a></td>' + '<td>' + searchComponents[2] + "/" + searchComponents[3] + "/" + searchComponents[4] + '</td><td align="center"><p data-placement="top" data-toggle="tooltip" title="Delete"><i id="' + indexes[j] + '" class="fa fa-trash fa-sm" onclick="deleteSearch(this.id)"></i></p></td></tr>';
		j++;
	}
    }
    searchsHtml += '</tbody></table></div></div>';
    document.getElementById("search-files").innerHTML = searchsHtml;
}

/*Borra del Local Storage una búsqueda concreta*/
function deleteSearch(key) {

    window.localStorage.removeItem(key);
    location.reload();
}

/*Redirige a la página de una búsqueda almacenada pasando parámetros de la búsqueda que hay que cargar*/
function goSearch(url) {
    window.location.href = './saved-search.html?url=' + url;
}


window.onload = function() {

    localLoad();    
    document.getElementById("deleteLocalStorageBtn").onclick = deleteLocalStorage;

};
