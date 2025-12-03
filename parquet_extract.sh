#!/bin/bash
set -e
shopt -s expand_aliases   # nécessaire pour que les alias soient reconnus
alias ogr2ogr-latest='docker run --rm --init -v "$PWD":"$PWD" -w "$PWD" --user $(id -u):$(id -g) ghcr.io/osgeo/gdal:alpine-normal-latest  ogr2ogr'
alias ogrinfo-latest='docker run --rm --init -v "$PWD":"$PWD" -w "$PWD" --user $(id -u):$(id -g) ghcr.io/osgeo/gdal:alpine-normal-latest ogrinfo'

output_format="ods"

trap 'echo "💥 Interruption !"; pkill -P $$; exit 1' SIGINT

# Paramètres
parquet_file="$1"    # fichier parquet à traiter
region="$2"          # nom de la région
year="$3"            # année

input_file="dnd_entrant.parquet"
registre_name=$(basename "$input_file")  # pour nommer le CSV final

# Départements par région
declare -A regions
regions["Auvergne-Rhône-Alpes"]="01,03,07,15,26,38,42,43,63,69,73,74"
regions["Bourgogne-Franche-Comté"]="21,25,39,58,70,71,89,90"
regions["Bretagne"]="22,29,35,56"
regions["Centre-Val de Loire"]="18,28,36,37,41,45"
regions["Corse"]="2A,2B,20"
regions["Grand Est"]="08,10,51,52,54,55,57,67,68,88"
regions["Hauts-de-France"]="02,59,60,62,80"
regions["Île-de-France"]="75,77,78,91,92,93,94,95"
regions["Normandie"]="14,27,50,61,76"
regions["Nouvelle-Aquitaine"]="16,17,19,23,24,33,40,47,64,79,86,87"
regions["Occitanie"]="09,11,12,30,31,32,34,46,48,65,66,81,82"
regions["Pays de la Loire"]="44,49,53,72,85"    
regions["Provence-Alpes-Côte d'Azur"]="04,05,06,13,83,84"

layer_name=$(ogrinfo-latest "$parquet_file" | grep -oP '1: \K\w+')
#echo "layer name : $layer_name"

possible_code_fields=(
    "destinataire_code_commune"
    "destinataire_code_postal_etablissement"
    "destinataire_ville_etablissement" # en attendant fix sur dnd_sortant
    "destinataire_code_postal_lieu_de_depot"
    "emetteur_initial_code_postal_etablissement"
    "emetteur_code_postal_point_de_retrait"
    "emetteur_code_postal_chantier"
    "emetteur_code_commune"
    "expediteur_code_commune"
    "expediteur_code_postal_etablissement"
    "expediteur_code_postal_lieu_de_collecte"
    "lieu_de_collecte_code_postal_etablissement"

)

layer_schema=$(ogrinfo-latest "$parquet_file" "$layer_name" -so)

existing_fields=()
for f in "${possible_code_fields[@]}"; do
    if echo "$layer_schema" | grep -qE "^$f:"; then
        existing_fields+=("$f")
    fi
done

    


if [ ${#existing_fields[@]} -eq 0 ]; then
    echo "⚠️ Aucun champ de code postal valide trouvé dans $parquet_file"
    exit 1
fi

deps=${regions[$region]}


echo "🔍 Champs de filtre : ${existing_fields[@]}"
echo "ℹ️ Departement: $deps"

where_clause=""
for dep in $(echo "$deps" | tr ',' ' '); do
    for field in "${existing_fields[@]}"; do
        where_clause+=" $field like '${dep}%%' OR"
    done
done
where_clause=${where_clause%OR}

# Répertoire de sortie
out_base="regions/${region// /_}/$year"
mkdir -p "$out_base"

# Dates pour filtrage performant
start_date="${year}-01-01"
end_date="$((year+1))-01-01"

# Fichier CSV de sortie
registre_name=$(basename "$parquet_file")
output_file="$out_base/${registre_name}.${output_format}"

echo "📂 Génération CSV pour région '$region', année $year -> $output_file"
ogr2ogr-latest "$output_file" "$parquet_file" -where "( $where_clause ) AND date_creation >= '$start_date' AND date_creation < '$end_date'"

echo "✅ Terminé"
