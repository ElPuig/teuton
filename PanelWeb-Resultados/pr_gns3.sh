#/bin/bash
cd /home/ubuntu/teuton
echo -e "Inicio:\t"$(date)" - GNS3">>log.txt 
/usr/local/bin/teuton run gns3
./resultados.sh var/gns3/ gns3.html
echo -e "\tFinal:\t"$(date)" - GNS3">>log.txt
