#!/bin/bash

# Tomamos el nombre del fichero sin extensión:
basename=$(basename "$1")
nombre="${basename%.*}"
# Creamos los nombres de ficheros intermedios:
nombre_en_olpe="$nombre"'.olpe'
nombre_en_asm="$nombre"'.asm'
nombre_en_obj="$nombre"'.o'
nombre_en_exe="$nombre"'.exe'
echo $nombre_en_olpe
echo $nombre_en_asm
echo $nombre_en_obj
echo $nombre_en_exe
# Transpilamos con OLPE:
node ../src/olpe.bin.js $nombre_en_olpe
# Compilamos con NASM:
nasm -f elf64 -o $nombre_en_obj $nombre_en_asm
# Linkeamos con LD:
ld $nombre_en_obj $nombre_en_exe
# Ejecutamos tal cual:
$nombre_en_exe
