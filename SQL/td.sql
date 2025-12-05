/* Avec COPY, importer les CSV dans des tables RAW (staging) 
Attention à bien parametrer NULL pour les empty strings
*/


--DND ENTRANT
SELECT
	id,
	date_creation::timestamptz,
	date_mise_a_jour::timestamptz,
	declaration_annulee::bool,
	id_public,
	destinataire_siret_etablissement AS destinataire_siret_etablissement,
	destinataire_nom_etablissement,
	destinataire_adresse_etablissement,
	destinataire_ville_etablissement,
	destinataire_code_postal_etablissement,
	declarant_siret_etablissement,
	dechet_code,
	dechet_pop::bool,
	dechet_declare_dangereux::bool,
	destinataire_date_reception::timestamptz,
	dechet_denomination,
	dechet_code_bale,
	dechet_quantite::float8,
	dechet_quantite_type,
	dechet_volume::float8,
	emetteur_initial_profil_etablissement,
	emetteur_initial_id_etablissement,
	emetteur_initial_nom_etablissement,
	emetteur_initial_adresse_etablissement,
	emetteur_initial_code_postal_etablissement,
	emetteur_initial_ville_etablissement,
	emetteur_initial_code_pays_etablissement, 
	STRING_TO_ARRAY(trim( BOTH '[]' FROM emetteur_initial_municipalites_codes_insee_etablissement),', ') AS emetteur_initial_municipalites_codes_insee_etablissement ,
	emetteur_profil_etablissement,
	emetteur_id_etablissement,
	emetteur_nom_etablissement,
	emetteur_adresse_point_de_retrait,
	emetteur_code_postal_point_de_retrait,
	emetteur_ville_point_de_retrait,
	emetteur_code_pays_point_de_retrait,
	courtier_siret_etablissement,
	courtier_nom_etablissement,
	courtier_numero_recepisse,
	negociant_siret_etablissement,
	negociant_nom_etablissement,
	negociant_numero_recepisse,
	eco_organisme_siret,
	eco_organisme_nom,
	traitement_realise_code,
	STRING_TO_ARRAY(trim( BOTH '[]' FROM numeros_identification_transporteurs),', ') AS numeros_identification_transporteurs 
FROM
	odema.td_dnd_entrant_wip
