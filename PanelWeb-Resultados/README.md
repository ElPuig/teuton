# Crea un panel web para presentar los resultados de los alumnos

Obtiene la información de los ficheros estandard de resultados de Teuton.

  - Muestra en la primera columna los títulos de cada check que hemos configurado en Teutón
  - Muestra en cada columna, los resultados obtenidos por cada alumno en la última ejecución de teuton.
  - Muestra en una tabla adicional muestra a que alumno corresponde cada columna
  - Mueve el archivo html generado a /var/www/html/
  
Requiere 2 parámetros:
  -  La ruta donde estan los reports de teuton (p.e. var/ftp-asix/)
  -  El nombre que queremos para el fichero html generado (p.e. index.html)
  
Ejemplo:  

    $./resultados.sh var/ftp-asix/ index.html
  
  
  
  ![Alt text](panel.jpg?raw=true "Panel Web de Resultados")
