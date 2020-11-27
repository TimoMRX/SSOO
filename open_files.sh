#!/bin/bash

# open_files - Un script que indica el numero 
# de ficheros abiertos por un usuario


##### Opciones por defecto

pattern=*


##### Estilos

TEXT_BOLD=$(tput bold)
TEXT_ULINE=$(tput sgr 0 1)
TEXT_GREEN=$(tput setaf 2)
TEXT_RESET=$(tput sgr0)


##### Funciones

error_exit() {
#        --------------------------------------------------------------
#        Función para salir en caso de error fatal

#                Acepta 1 argumento:
#                        cadena conteniendo un mensaje descriptivo del error
#        --------------------------------------------------------------

  echo "${PROGNAME}: ${1:-"Error desconocido"}" 1>&2
  exit 1
}

usage()
{
   echo "usage: open_files [-f "patron"] [-h]"
}


##### Programa principal

# Procesar la línea de comandos del script para leer las opciones
while [ "$1" != "" ]; do
   case $1 in
    -f)
        shift
        pattern=$1
        ;;
        
    -o | --off_line )
        interactive=1
        ;;

    -u | --user )
        ;;

    -h | --help )
        usage
        exit
        ;;

    * )
        usage
        error_exit "Opcion desconocida"
   esac
   shift
done