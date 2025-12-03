#!/bin/bash
set -e

# --------------------------------------------------
# Vérification des arguments
# --------------------------------------------------
if [ $# -lt 3 ]; then
    echo "Usage: $0 fichier.parquet REGION|ALL ANNEE|ALL"
    exit 1
fi

parquet_file="$1"
region_arg="$2"
year_arg="$3"

if [ ! -f "$parquet_file" ]; then
    echo "❌ Fichier '$parquet_file' introuvable"
    exit 1
fi

# --------------------------------------------------
# Paramètres
# --------------------------------------------------
start_year=2022
end_year=$(date +%Y)

# --------------------------------------------------
# Tableau des régions
# --------------------------------------------------
regions=(
"Auvergne-Rhône-Alpes"
"Bourgogne-Franche-Comté"
"Bretagne"
"Centre-Val de Loire"
"Corse"
"Grand Est"
"Hauts-de-France"
"Île-de-France"
"Normandie"
"Nouvelle-Aquitaine"
"Occitanie"
"Pays de la Loire"
"Sud"
)

# Si filtre région
if [ "$region_arg" != "ALL" ]; then
    regions=("$region_arg")
fi

# Si filtre année
if [ "$year_arg" != "ALL" ]; then
    start_year=$year_arg
    end_year=$year_arg
fi

# --------------------------------------------------
# Boucle sur années et régions
# --------------------------------------------------
for year in $(seq $start_year $end_year); do
    for region in "${regions[@]}"; do
        echo "🚀 Génération CSV pour la région '$region', année $year, fichier '$parquet_file'"

        # Appel du script unitaire
        ./parquet_extract.sh "$parquet_file" "$region" "$year"
    done
done

