#!/bin/bash 
#FUNCION CTRL_C  
ctrl_c(){
echo -e "[!] Saliendo..."
exit 1$
}
trap ctrl_c INT
sleep 10 
#/// VARIABLES DE VALIDACION/////
variableValidacionUno=0
#FUNCIONES GENERALES///////
panelAyuda()
{
echo -e "[+]Uso del programa:"
echo -e "[m)]Buscar por nombre de la maquina"
echo -e "[h)]Mostrar panel de ayuda"
echo -e "[u)]Mostrar actualizaciones"
echo -e "[i)]Mostrar por direccion ip"
echo -e "[l)]Mostrar URL de la resolucion de la maquina"
echo -e "[d)]Mostrar por dificultad"
echo -e "[s)]Mostrar por sistema opretivo"
echo -e "[d and s)]Mostrar por dificultad y so:"
echo -e "[k)]Mostrar por skills:"
}
mostarActualisaciones ()
{
 if [[ ! -f bundle.js ]]; then
  echo -e "El archivo no existe, Creando archivo..."
  touch bundle.js 
  curl -s https://htbmachines.github.io/bundle.js > bundle.js
  js-beautify bundle.js | sponge bundle.js
  sleep 5 
  echo -e "Archivo creado con exito!"
 elif [[ -f bundle.js ]]; then
  echo -e "Checando Actualisaciones..."
  touch bundlecp.js 
  curl -s https://htbmachines.github.io/bundle.js > bundlecp.js
  js-beautify bundlecp.js | sponge bundlecp.js
  hashArchivoOriginal=$(md5sum bundle.js | awk '{print $1}')
  hashArchivoCopia=$(md5sum bundlecp.js | awk '{print $1}')
        if [[ $hashArchivoOriginal != $hashArchivoCopia ]]; then
         echo -e "Actualizaciones necesarias. Actualizando..."
         sleep 5  
         rm -r bundle.js  
          mv bundlecp.js bundle.js
          echo -e "Actualisacion finalizada con exito."
          else
            rm -r bundlecp.js
            echo -e "Tu documento tiene todas las actualisaciones disponibles. "    
        fi 
 fi
}
buscadorMaquina()
{
nombre=$nombreMaquina

resultadoNombreCheck=$(cat bundle.js | awk "/name: \"$nombre\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '""' | sed 's/^ *//')
resultadoNombre=$(cat bundle.js | awk "/name: \"$nombre\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '""' | sed 's/^ *//')
if [[ $resultadoNombreCheck  ]]; then  
echo -e "Los datos de la maquina son..."
echo -e "$resultadoNombre"
else
  echo -e "La maquina proporcionqada no existe!"
fi

}

buscadorXIP()
{
ipMaquina="$1"
ResultadoIPCheck=$(cat bundle.js | grep "ip: \"$ipMaquina\"" -B 3 | grep "name: " | awk 'NF{print $NF}'| tr -d '""|,')
ResultadoIP=$(cat bundle.js | grep "ip: \"$ipMaquina\"" -B 3 | grep "name: " | awk 'NF{print $NF}'| tr -d '""|,')
if [[ $ResultadoIPCheck ]]; then
    echo -e "[!]La maquina correspondiente para la IP :$ipMaquina" es: "$ResultadoIP"
else
  echo -e "La ip proporcionada no existe!"
fi

} 

obtenerLink ()
{
nombreXLink="$1"
linkChek=$(cat bundle.js | awk "/name: \"$nombreXLink\"/,/resuelta:/" | grep "youtube:" | tr -d '"",' | sed 's/^ *//')

link=$(cat bundle.js | awk "/name: \"$nombreXLink\"/,/resuelta:/" | grep "youtube:" | tr -d '"",' | sed 's/^ *//')
if [[ $linkChek ]]; then
  echo -e "el link es:\n $link"
  else
    echo "Datos introcucidos erroneos"
fi
}


buscadorDificultad(){
dificultad=$1

nombreXDicicultadCheck=$(cat bundle.js | grep "dificultad: \"$dificultad\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"",')
nombreXDicicultad=$(cat bundle.js | grep "dificultad: \"$dificultad\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"",' | column )
if [[ $nombreXDicicultadCheck ]]; then  
echo -e "$nombreXDicicultad \n la dificultad de estas maquinas son: $dificultad"
else
  echo "La dificultad introducida no existe"
fi
}
buscarXSo()
{
  sistemaO=$1
 buscadorSO=$(cat bundle.js | grep "so: \"$sistemaO\"" -B 4 | grep "name:" | awk 'NF{print$NF}' | tr -d '"",' | column)

if [[ $buscadorSO ]]; then
  echo -e "$buscadorSO \n Estas maquinas tienen como S.O: $sistemaO"
else
  echo "S.O inexistente"
fi
}


getopsDifYcultyMachonesOS(){
dificultad="$1"
sistemaO="$2"
buscador_so_dificultad=$(cat bundle.js | grep "dificultad: \"$dificultad\"" -C 5 | grep "so: \"$sistemaO\"" -B 4 | grep "name:" | awk 'NF{print $NF}' | tr -d '"",' | column )
if [[ $buscador_so_dificultad ]]; then
  echo -e "Filtrando maquinas con dificultad:$dificultad y os:$sistemaO \n $buscador_so_dificultad"
else
  echo -e  "Se ha indicado Dificultad o OS incorrectos"
fi
}


obtenerskills(){
skill=$1
buscadorSkill=$(cat bundle.js | grep "skills:" -B 6 | grep "$skill" -i -B 6 | grep "name:" |awk 'NF{print $NF}' | tr -d '"",' | column)

if [[ $buscadorSkill ]]; then
  echo -e "Las maquinas con ese skill $skill son:\n $buscadorSkill"
  else
    echo -e  "No se encontro la skill introducida"
fi

}
#CHIVATOS////////////
declare -i chivato_dificulty=0
declare -i chivato_os=0

#DECLRACION DE ARGUMENTOS///////////
while getopts "m:l:d:i:s:k:uh" arg; do
  case $arg in 
    h)let variableValidacionUno+=1;;
    u)let variableValidacionUno+=2;;
    m)nombreMaquina=$OPTARG; let variableValidacionUno+=3;;
    i)ipMaquina=$OPTARG; let variableValidacionUno+=4;;
    l)nombreXLink=$OPTARG; let variableValidacionUno+=5;;
    d)dificultad=$OPTARG; chivato_dificulty=1; let variableValidacionUno+=6;;
    s)sistemaO=$OPTARG; chivato_os=1; let variableValidacionUno+=7;;
    k)skill=$OPTARG; let variableValidacionUno+=8;;
  esac 
done
if [[ variableValidacionUno -eq 1 ]]; then
  panelAyuda
elif [[ variableValidacionUno -eq 2 ]]; then
    mostarActualisaciones
elif [[ variableValidacionUno -eq 3 ]]; then
  buscadorMaquina $nombreMaquina
elif [[ variableValidacionUno -eq 4 ]]; then
  buscadorXIP $ipMaquina
elif [[ variableValidacionUno -eq 5 ]]; then
  obtenerLink $nombreXLink
elif [[ variableValidacionUno -eq 6 ]]; then
buscadorDificultad $dificultad
elif [[ variableValidacionUno -eq 7 ]]; then
  buscarXSo $sistemaO
elif [[ $chivato_os -eq 1 ]] && [[ $chivato_dificulty -eq 1 ]]; then
  getopsDifYcultyMachonesOS $dificultad $sistemaO
elif [[ variableValidacionUno -eq 8 ]]; then
obtenerskills "$skill"
fi






