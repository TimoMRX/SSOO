#!/bin/bash

# open_files - Un script que indica el numero 
# de ficheros abiertos por un usuario


##### Opciones por defecto

pattern=

##### Constantes

PROGNAME=$(basename $0)

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

usage() {
   echo "usage: open_files [-f "patron"] [-h]"
}

open_files() {
  printf "NOMBRE\tNº_FICHEROS_ABIERTOS\tUID\tPID_PROCESO_MAS_ANTIGUO\n"
  if [ $(ps -u $(who | cut -d" " -f 1) -eo tty,time --no-headers | sort -k2r | head -n 1 | cut -d"0" -f 1) == "?" ]; then
   tty="?"
  else 
   tty="p"
  fi
  for i in $(who | cut -d" " -f 1); do
    printf "%s \t %s \t %s \t %s\n" "$i" "$(lsof -u $i | wc -l)" "$(id -u $i)" "$(ttyf $i)" 
  done
}

ttyf() {
  ps -u $1 -eo pid,tty,time --no-headers | sort -k3r | head -n 1 | cut -d"$tty" -f 1
} 

pattern_files() {
  printf "NOMBRE\tNº_FICHEROS_ABIERTOS_PATRON\tUID\tPID_PROCESO_MAS_ANTIGUO\n"
  for i in $(who | cut -d" " -f 1); do
    printf "%s \t %s \t %s \t %s\n" "$i" "lsof -u $i | wc -l" "$(id -u $i)"
  done
}

##### Programa principal

# Procesar la línea de comandos del script para leer las opciones
while [ "$1" != "" ]; do
   case $1 in
    -f | --)
        shift
        pattern=$1
        pattern_files pattern
        exit 0
        ;;
        
    -o | --off_line )
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

open_files
exit 0