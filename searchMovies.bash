#!/bin/bash

read -p "Introduce el nombre de la peli: " nameMovie
searchParams=$(echo "$nameMovie" | sed 's/ /+/g')

searchResults=()
searchResults+=($(curl -s "https://entrepeliculasyseries.nz/?s=$searchParams" | hxnormalize -x | hxselect -s '\n' section.home-movies div.TPost a | grep -o 'href="[^"]*"' | awk -F '"' '{print $2}'))

results=${#searchResults[@]}
if [ $results -gt 0 ]; then
    echo "Resultados para" $nameMovie":"
    for indice in "${!searchResults[@]}"; do
        valor="${searchResults[$indice]}"
        name= basename "${searchResults[$indice]}"
        echo $indice":" $name $valor
    done

    echo "Elija cual desea ver, ingresando el respectivo número"
    read -p "Ingrese el número de película:" numberMovie

    xdg-open ${searchResults[$numberMovie]}
else
    echo "No se encontraron resultados para $nameMovie"
fi
