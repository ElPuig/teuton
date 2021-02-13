#!/bin/bash
if [[ -d "${1}" && -n "${2}" ]]
then
	echo "generando resultados...."
	echo "Comprobacion" > $1resultados.csv
	grep 'Description' $1case-01.txt | cut -d":" -f2 | cut -c2- >> $1resultados.csv

	for i in $(ls $1case-*.txt)
	do
		    echo $i | tr "-" "\n"|tail -n 1  | cut -d"." -f1 > $1resultados01.csv
		    grep '/1.0)' $i | cut -d"(" -f2|cut -d"/" -f1 >> $1resultados01.csv
		    paste -d ';' $1resultados.csv $1resultados01.csv > $1resultados_final.csv
		    cat $1resultados_final.csv > $1resultados.csv
	done

	tabla_resul="<table border='1' align='left'>"
	tit=" scope= row"
	while read INPUT
		do
			HT=$(echo "<tr><th$tit align='left'>${INPUT//;/</td><td>}</td></tr>")
			CEROS=$(echo "${HT//'<td>0.0</td>'/<td bgcolor=FFCCCD>--</td>}")
			tabla_resul=$tabla_resul"${CEROS//'<td>1.0</td>'/<td bgcolor=CCFFCC>OK</td>}"
			tit=""
	done < $1resultados_final.csv
	tabla_resul=$tabla_resul"</table>"

	tabla_cases="<table border='1' align='left' font face='Courier New'><tbody><tr><td>"
	#cp $1resultados.csv $1resultados/resultados$(date +%y_%m_%d.%H_%M_%S).csv
	#tabla_cases=$tabla_cases"$(date)"
	while read INPUT
	do
		if [[ $INPUT = 'CASES' ]]
		then
			COPY='1'
		fi
		if [[ $COPY = '1' ]]
		then
			tabla_cases=$tabla_cases"$INPUT<br>"
		fi
	done < $1resume.txt
	tabla_cases=$tabla_cases"<br></td></tr></tbody></table>"

	# Tomamos como origen el archivo de notas para el moodle y añadimos a un archivo de histórico de notas todas aquellas que sean diferentes de cero
	# 	El archivo será $1resultadosmoodle.csv
	sed '/,0.0,/d' $1moodle.csv | sed  '/MoodleID/d' >> $1resultadosmoodle.csv

	# calculamos la maxima nota de cada alumno y creamos una tabla en html
	#	El archivo de origen es el archivo de notas mayores de cero historico, y nos quedaremos solo con la nóta máxima de cada alumno.

	notas_html="<table style='border-collapse: collapse; width: 20%;' border='1'><tbody><tr><td style='width: 80%;'><strong>Alumno</strong></td><td style='width: 20%;'><strong>Nota</strong></td></tr>"

	for i in $(cut -d' ' -f2 $1moodle.csv | sed  '/Teuton/d' | sort -u | cut -c 1-7)
	do
		notas_html=$notas_html"<tr><td style='width: 30%;'>"$i"</td>"
		notas_html=$notas_html"<td style='width: 20%;'>"$(sort -n -t "," -k 2 $1resultadosmoodle.csv |grep $i |tail -n 1|cut -d',' -f2)"</td></tr>"
        	#echo "$i:$(sort -n -t "," -k 2 moodle.csv |grep $i |tail -n 1|cut -d',' -f2)"
	done
	notas_html=$notas_html"</tbody></table>"


	#Formateamos la salida html
        tabla_main="<head><meta http-equiv='refresh' content='30'></head>"
        tabla_main=$tabla_main"<table border='0'><tr><td>"
        #aqui tablaresult
	tabla_main=$tabla_main$tabla_resul
        tabla_main=$tabla_main"</td></tr><tr><td>"
	#Si queremos dejar la fecha
	tabla_main=$tabla_main"</td></tr><tr><td>$(date)</td></tr><tr><td>"
	#aqui tablaCases (relacion columna <-> IP VPN)
	tabla_main=$tabla_main$tabla_cases
	tabla_main=$tabla_main"</td></tr></tabla>"
	#si queremos incluir una tabla con las máxima nota de cada alumno en la web:
	tabla_main=$tabla_main$notas_html



	echo $tabla_main > $2

	sudo mv $2 /var/www/html/$2

	echo "................................................."
	echo "........... Finalizada exportacion .............."
	echo "................................................."

else
        echo "................................................."
        echo "........... Faltan parámetros .... .............."
        echo "................................................."
	echo -e "Tienes que indicar los siguientes parámetros: \n"
	echo -e "\tresultados.sh projectGNS3 salida.html\n"
	echo -e "Donde:\n\tproject: es el projecto teutón del que extraer los resultados\n\tsalida.html: es el archivo html al que enviar los resultados formateados (se moverá a /var/www/html/)"
	echo "................................................."

fi
