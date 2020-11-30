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
#                cadena conteniendo un mensaje descriptivo del error
#        --------------------------------------------------------------

  echo "${PROGNAME}: ${1:-"Error desconocido"}" 1>&2
  exit 1
}

usage() {
#        ---------------------------------------------------
#         Función que describe el uso correcto del programa
#        ---------------------------------------------------
   echo "usage: open_files [-f'pattern'] [-h] [-o] [-u user1 user2 ...]"
}

lsof_install() {
#        ------------------------------------------
#         Función que verifica si el programa lsof
#               esta correctamente instalado
#        ------------------------------------------
  if [ "$(echo $(which lsof) $?)" = "1" ]; then
    error_exit "lsof no instalado: sudo apt install lsof"
  fi
}

tty_f() {
  ps -u $1 -oetime -o tty,pid --no-headers | sort -k3.1n | head -n 1 | cut -d"$tty" -f 2
}

user_iterator() {
  who | cut -d" " -f 1
}

open_files() {
  printf "NOMBRE\tNº_FICHEROS_ABIERTOS\tUID\tPID_PROCESO_MAS_ANTIGUO\n"
  
  for i in $(who | cut -d" " -f 1); do
    if [ "$(ps -u $i -oetime,tty --no-headers | head -n 1 | awk '{printf $2}')" = "?" ]; then
      tty="?"
    else 
      tty="p"
    fi
    printf "%s \t\t %s \t\t %s %s\n" "$i" "$(lsof -u $i | wc -l)" "$(id -u $i)" "$(tty_f $i)" 
  done
}



pattern_files() {
  if [ "$pattern" = "" ];then
    usage
    error_exit "Introduzca un patron"
  fi

  printf "NOMBRE\tNº_FICHEROS_ABIERTOS_PATRON\tUID\tPID_PROCESO_MAS_ANTIGUO\n"
  for i in $(who | cut -d" " -f 1); do
    printf "%s \t %s \t\t\t %s \t %s\n" "$i" "$(lsof -u $i | grep -E -c $pattern)" "$(id -u $i)" ""
  done
}

##### Programa principal

  lsof_install
# Procesar la línea de comandos del script para leer las opciones
  while [ "$1" != "" ]; do
    case $1 in
      -f | --)
          shift
          pattern=$1
          pattern_files
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