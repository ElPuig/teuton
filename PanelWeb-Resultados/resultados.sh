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

	echo "<head><meta http-equiv='refresh' content='30'></head>" > $2
	echo "<table border='0'><tr><td><table border='1' align='left'>" >> $2
	tit=" scope= row"
	while read INPUT 
		do 
			HT=$(echo "<tr><th$tit align='left'>${INPUT//;/</td><td>}</td></tr>")
			CEROS=$(echo "${HT//'<td>0.0</td>'/<td bgcolor=FFCCCD>--</td>}")
			echo "${CEROS//'<td>1.0</td>'/<td bgcolor=CCFFCC>OK</td>}"  >>$2
			tit=""
	done < $1resultados_final.csv 
	echo "</table></td></tr><tr><td>" >> $2
	echo "<table border='1' align='left' font face='Courier New'><tbody><tr><td>" >> $2
	#cp $1resultados.csv $1resultados/resultados$(date +%y_%m_%d.%H_%M_%S).csv
	date >> $2
	while read INPUT
	do
		if [[ $INPUT = 'CASES' ]]
		then
			COPY='1'
		fi
		if [[ $COPY = '1' ]]
		then
			echo "$INPUT<br>" >>$2
		fi
	done < $1resume.txt
	echo "<br>
	</td></tr></tbody></table></td></tr></tabla>" >> $2
	sudo mv $2 /var/www/html/$2
	#cat $1moodle.csv >> $1resultadosmoodle.csv
	sed '/,0.0,/d' $1moodle.csv | sed  '/MoodleID/d' >> $1resultadosmoodle.csv

	#rm $1case-*.txt
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
