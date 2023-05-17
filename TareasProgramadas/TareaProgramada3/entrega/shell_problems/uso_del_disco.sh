#!/bin/sh

# variables inicializadas por defecto, n es la cantidad de directorios/archivos a mostrar
n=10
# list_all una variable flag que indica si se debe mostrar los archivos también
list_all=false

# Verificamos si se llamó el script sin ningún argumento
if [ $# -eq 0 ]; then
    echo "uso: ./uso_del_disco.sh [-a -n N] directorio..."
    exit 1
fi

# Obtenemos todos los flags que se hayan pasado al comando con getopts
while getopts "an:" opt; do
    case $opt in
        # -a, de estar presente se hace que la variable list_all sea true, para listar todos los archivos y directorios
        a) list_all=true ;;
        # -n N, obtenemos el valor N indicado por -n, para saber cuantos archivos/directorios mostrar
        n) n=$OPTARG ;;
        # en caso de no cumplir con la sintaxis se muestra un mensaje de como se usa
        # además se imprime el mensaje este mensaje en stderr usando >&2 
        \?) 
            echo "uso: ./uso_del_disco.sh [-a -n N] directorio...">&2
            exit 1 ;;
    esac
done

# con shift nos movemos a los siguientes argumentos luego de las flags del comando
# con $OPTIND obtenemos la posición a la que apunta el siguiente argumento que debe ser procesado por getops
if [ -z "$OPTIND" ]; then
    shift $(($OPTIND - 1))
fi

# Como lo que sigue en el comando son las rutas de los directorios podemos usar $@ que nos da todos los argumentos 
# recorremos todos los directorios por medio de un for
for dir in "$@"; do
    # si list_all es true, entonces se muestran los archivos y directorios
    if $list_all; then
        # usando du mostramos el uso del espacio en disco de los archivos y directorios
        # con -h se indica que convierta los valores de los tamaños a valores legibles para usuarios
        # con -d 1 se indica que solo se muestre el uso del espacio en disco de los archivos y subdirectorios inmediatamente contenidos en $dir.
        # luego se le indica el directorio por medio de $dir que es una variable que contiene la ruta del directorio
        # con "$dir"/* hacemos que se listen tanto directorios como archivos
        # con 2>/dev/null redirigimos los posibles errores que podamos tener, es decir, los ignoramos
        # luego con pipe | pasamos los resultado a sort que los presenta en inverso (de más grande a pequeño) con -r y -h se usa para los tamaños legibles por usuarios
        # luego pasamos ese resultado a head con pipe |, se le indica la cantidad de objectos a mostrar con -n usando la variable $n que fue obtenido de las flags del comando
        du -h -d 1 "$dir"/* 2>/dev/null | sort -hr | head -n "$n"
    else
        # si list_all es false, entonces solo se muestran los directorios
        # con "$dir"/ solo se listan los directorios
        du -h -d 1 "$dir"/ 2>/dev/null | sort -hr | head -n "$n"
    fi
done
