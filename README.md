# Toolbox Trackdéchets

Boite à outils pour manipuler les .parquets fournis par vigiedéchets.

Le script permet d'exploser les parquets en Région et années.
Le filtrage par région exploite différents champs contenant des code postaux ou code "insee" de communes (destinataire, émetteur ou chantier).

## Utilisation

```sh

# Toutes les régions pour l'année 2025
./parquet_csv_exporter.sh bsdd.parquet ALL 2025

# Toutes les régions et toutes les années depuis 2022
./parquet_csv_exporter.sh bsdd.parquet ALL ALL

# Une région spécifique pour une année spécifique
./parquet_csv_exporter.sh bsdd.parquet "Bretagne" 2024

# Une seule région pour toutes les années
./parquet_csv_exporter.sh bsdd.parquet "Île-de-France" ALL

```
