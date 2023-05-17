#!/bin/sh

# Obtener los sufijos para hacer match de la variable de ambiente SUFIJOS (por defecto ".c")
if [ -z "$SUFIJOS" ]; then
    SUFIJOS=".c"
fi

# Obtener el compilador y las banderas de las variables de ambiente CC y CFLAGS (por defecto "gcc" y "-std=gnu99 -Wall")
if [ -z "$CC" ]; then
    CC="gcc"
fi
if [ -z "$CFLAGS" ]; then
    CFLAGS="-std=gnu99 -Wall"
fi

# Recorremos todos los archivos en el directorio actual con el sufijo especificado en SUFIJOS
for archivo in *$SUFIJOS; do 
    # si la variable VERBOSE está seteado mostramos el comando ejecutado
    if [ $VERBOSE -eq 1 ]; then
        echo "$CC $CFLAGS $archivo -o ${archivo%$SUFIJOS}"
    fi
    # compilamos el archivo fuente en un ejecutable
    $CC $CFLAGS $archivo -o ${archivo%$SUFIJOS}
    # verificamos si la compilación tuvo éxito, de no ser así, salimos con un status distinto de cero
    if [ "$?" -ne 0 ]; then
        echo "Problema en la compilación del archivo: ${archivo%SUFIJOS}"
        echo exit 1
        exit 1
    fi
done