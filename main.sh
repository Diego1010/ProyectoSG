#! /bin/bash

# Este script sirve para obtener la informacion de los logs, para ello se basa en el numero de linea
# la informacion se toma cada X miutos

# Leyendo el archivo de configuracion
. ./herramienta.conf


lineaInicioAccess=0
lineaFinAccess=0

lineaInicioError=0
lineaFinError=0

lineaInicioPostgres=0
lineaFinPostgres=0

primerEjecucion=1

#echo $rutaApache
#echo $rutaPostgres

#echo $ipApache
#echo $ipPostgres

#echo $usuarioApache
#echo $usuarioPostgres


lineaInicioAccess=$(wc -l $rutaApacheAccess | cut -d' ' -f1)
lineaInicioError=$(ssh $usuarioApache@$ipApache "wc -l $rutaApacheError | cut -d' ' -f1")
lineaInicioPosgres=$(ssh $usuarioPostgres@$ipPostgres "wc -l $rutaPostgres | cut -d' ' -f1")

while true
do
    nombreAccess="-"
    nombreError="-"
    nombrePostgres="-"
    sleep $tiempoMonitoreo
    lineaFinAccess=$(wc -l $rutaApacheAccess | cut -d' ' -f1)
    lineaFinError=$(ssh $usuarioApache@$ipApache "wc -l $rutaApacheError | cut -d' ' -f1")
    lineaFinPosgres=$(ssh $usuarioPostgres@$ipPostgres "wc -l $rutaPostgres | cut -d' ' -f1")
    fecha=$(date +"%d-%m-%Y::%H:%M")
    echo "[+] Inicia monitoreo: " $fecha
    fecha=$(date +"%s")
    echo

    if [ "$lineaFinAccess" -gt "$lineaInicioAccess" ]
    then
	nombreAccess=$( echo $rutaApacheAccess | awk -F'/' '{print $NF}' )
	nombreAccess=$nombreAccess$fecha
	rutaDestino=$directorioAccess$nombreAccess
	if [ "$primerEjecucion" -eq "0" ]
	then
	    lineaInicioAccess=$((lineaInicioAccess + 1 ))
	fi
	echo "APACHE ACCESS"
	echo $lineaInicioAccess
	echo $lineaFinAccess
	awk "NR >= $lineaInicioAccess && NR <= $lineaFinAccess" $rutaApacheAccess > "$rutaDestino"
	lineaInicioAccess=$((lineaFinAccess ))
	primerEjecucion=0
    fi



    if [ "$lineaFinError" -gt "$lineaInicioError" ]
    then
	nombreError=$( echo $rutaApacheError | awk -F'/' '{print $NF}' )
	nombreError=$nombreError$fecha
        rutaDestino=$directorioError$nombreError
	if [ "$primerEjecucion" -eq "0" ]
	then
	    lineaInicioError=$((lineaInicioError + 1 ))
	fi
	echo "APACHE ERROR"
	echo $lineaInicioError
	echo $lineaFinError
	ssh $usuarioApache@$ipApache "awk 'NR >= $lineaInicioError && NR <= $lineaFinError' $rutaApacheError" > "$rutaDestino"
	lineaInicioError=$((lineaFinError ))
	primerEjecucion=0
    fi


    if [ "$lineaFinPostgres" -gt "$lineaInicioPostgres" ]
    then
	nombrePostgres=$( echo $rutaPostgres | awk -F'/' '{print $NF}' )
	nombrePostgres=$nombrePostgres$fecha
        rutaDestino=$directorioPostgres$nombrePostgres
	if [ "$primerEjecucion" -eq "0" ]
	then
	    lineaInicioPostgres=$((lineaInicioPostgres + 1 ))
	fi
	echo "POSGRES"
	echo $lineaInicioPostgres
	echo $lineaFinPostgres
	ssh $usuarioPostgres@$ipPostgres "awk 'NR >= $lineaInicioPostgres && NR <= $lineaFinPostgres' $rutaPostgres" > "$rutaDestino"
	lineaInicioPostgres=$((lineaFinPostgres ))
	primerEjecucion=0
    fi

    if [ "$nombreAccess" != "-" ] ||[ "$nombreError" != "-" ] ||[ "$nombrePostgres" != "-" ]
    then
	perl Mod_parseo.pl $nombreAccess $nombreError $nombrePostgres
    fi
done
