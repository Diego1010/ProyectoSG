#!/bin/bash
clear
echo "=== INSTALAR SERVER ==="
echo
echo
echo
echo "[+] NOTA: Ejecutar script como root, de lo contrario habran errores"
echo
echo "Favor de ingresar un nombre de USUARIO del sistema, si no existe se creará uno nuevo"
read usuario

#Validando que el usuario no este vacio
until [ ! -z "$usuario" ]; do
    clear
    echo "=== INSTALAR SFTP SERVER ==="
    echo
    echo
    echo
    echo "[X] Error: Ingresa un nombre de USUARIO"
    read usuario
done

mkdir -p  /home/$usuario/Proyecto/logs/accessApache
mkdir -p  /home/$usuario/Proyecto/logs/errorApache
mkdir -p  /home/$usuario/Proyecto/logs/postgres
mkdir -p  /home/$usuario/Proyecto/parsedLogs/accessApache
mkdir -p  /home/$usuario/Proyecto/parsedLogs/errorApache
mkdir -p  /home/$usuario/Proyecto/parsedLogs/postgres
ln -L /var/log/apache2/access.log  /home/$usuario/Proyecto/
cp installSSH.sh /home/$usuario/Proyecto/
cp main.sh /home/$usuario/Proyecto/
cp herramienta.conf /home/$usuario/Proyecto/herramienta.conf.bak
cp  Mod_parseo.pl /home/$usuario/Proyecto/
chown -R  $usuario:$usuario /home/$usuario/Proyecto/
chmod -R 755 /home/$usuario/Proyecto/


apt-get install openssh-server -y
clear
echo "=== INSTALAR SERVER ==="
echo
echo
echo
echo "[+] NOTA: Ejecuta los siguientes comandos:"
echo "su $usuario"
echo "sh /home/$usuario/Proyecto/installSSH.sh"
