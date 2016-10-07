#!/bin/bash
cp ~/Proyecto/herramienta.conf.bak  ~/Proyecto/herramienta.conf
clear
echo "=== CONFIGURANDO USUARIO ==="
echo
echo
echo
echo "[+] NOTA: Ejecutar script con el usuario designado para la conexión ssh, de lo contrario presiona CTRL + C para cancelar"
echo
read -p *

clear
echo "=== CONFIGURANDO LLAVES SSH  === "
echo
echo
echo
echo "[+] NOTA: Deja todos los valores por defecto y no introduzcas ninguna passphrase"
echo
echo
ssh-keygen -t rsa


####### CONFIGURANDO SERVIDOR APACHE #########

clear
echo "=== COPIAR LLAVE PUBLICA SERVIDOR APACHE ==="
echo
echo
echo
echo -n "[?]Ingresa la direccion IP del servidor APACHE: "
read ip
#Validando que la ip no este vacio
until [ ! -z "$ip" ]; do
    clear
    echo "=== COPIAR LLAVE PUBLICA SERVIDOR APACHE ==="
    echo
    echo
    echo
    echo -n "[X] Error: Ingresa la direccion IP del servidor APACHE "
    read ip
done
sed -i -e"s/ipApache=/ipApache=$ip/" ~/Proyecto/herramienta.conf
echo
echo -n "[?]Ingresa cualquier USUARIO con permisos de lectura en el log de APACHE:  "
read usuario
#Validando que la ip no este vacio
until [ ! -z "$usuario" ]; do
    clear
    echo "=== COPIAR LLAVE PUBLICA SERVIDOR APACHE ==="
    echo
    echo
    echo
    echo -n "[X]Error: Ingresa cualquier usuario con permisos de lectura en el log de APACHE:  "
    read usuario
done
sed -i -e"s/usuarioApache=/usuarioApache=$usuario/"  ~/Proyecto/herramienta.conf
echo
echo -n "[+] NOTA: Probablemente pida alguna autorización, favor de decir yes a todas las preguntas y escribir la contraseña del servidor POSTGRES cuando lo solicite, si la contraseña es incorrecta, favor de cancelar el script y volverlo a ejecutar. Verifica la IP y el usuario"
echo
echo
ssh $usuario@$ip mkdir -p .ssh
echo
cat ~/.ssh/id_rsa.pub | ssh $usuario@$ip 'cat >> ~/.ssh/authorized_keys'
echo
ssh $usuario@$ip "chmod 700 .ssh; chmod 640 ~/.ssh/authorized_keys"


############## CONFIGURANDO SERVIDOR BD #################



clear
echo "=== COPIAR LLAVE PUBLICA SERVIDOR POSTGRES ==="
echo
echo
echo
echo -n "[?]Ingresa la direccion IP del servidor POSTGRES:  "
read ip
#Validando que la ip no este vacio
until [ ! -z "$ip" ]; do
    clear
    echo "=== COPIAR LLAVE PUBLICA SERVIDOR POSTGRES ==="
    echo
    echo
    echo
    echo -n "[X] Error: Ingresa la direccion IP del servidor POSTGRES  "
    read ip
done
sed -i -e"s/ipPostgres=/ipPostgres=$ip/"  ~/Proyecto/herramienta.conf

echo
echo -n "[?]Ingresa cualquier USUARIO con permisos de lectura en el log de POSTGRES:  "
read usuario
#Validando que la ip no este vacio
until [ ! -z "$usuario" ]; do
    clear
    echo "=== COPIAR LLAVE PUBLICA SERVIDOR POSTGRES ==="
    echo
    echo
    echo
    echo -n "[X]Error: Ingresa cualquier usuario con permisos de lectura en el log de POSTGRES:"
    read usuario
done
sed -i -e"s/usuarioPostgres=/usuarioPostgres=$usuario/"  ~/Proyecto/herramienta.conf 
echo
echo -n "[+] NOTA: Probablemente pida alguna autorización, favor de decir yes a todas las preguntas y escribir la contraseña del servidor POSTGRES cuando lo solicite, si la contraseña es incorrecta, favor de cancelar el script y volverlo a ejecutar. Verifica la IP y el usuario"
echo
echo
ssh $usuario@$ip mkdir -p .ssh
echo
cat ~/.ssh/id_rsa.pub | ssh $usuario@$ip 'cat >> ~/.ssh/authorized_keys'
echo
ssh $usuario@$ip "chmod 700 .ssh; chmod 640 ~/.ssh/authorized_keys"
