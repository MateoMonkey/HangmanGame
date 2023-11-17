#!/bin/bash

# Fonction pour choisir un mot aléatoire du fichier
choisir_mot() {
    local fichier="$1"
    local mot
    mot=$(shuf -n 1 "$fichier")
    echo "$mot"
}

# Fonction pour initialiser le mot masqué
initialiser_mot_masque() {
    local mot="$1"
    local mot_masque=""
    for ((i = 0; i < ${#mot}; i++)); do
        mot_masque+="_"
    done
    echo "$mot_masque"
}

# Fonction pour afficher le mot masqué
afficher_mot_masque() {
    local mot_masque="$1"
    echo "$mot_masque"
}

# Fonction pour mettre à jour le mot masqué avec les lettres trouvées
mettre_a_jour_mot_masque() {
    local mot="$1"
    local mot_masque="$2"
    local lettre="$3"
    local nouveau_mot_masque=""
    for ((i = 0; i < ${#mot}; i++)); do
        if [ "${mot:$i:1}" = "$lettre" ]; then
            nouveau_mot_masque+="$lettre"
        else
            nouveau_mot_masque+="${mot_masque:$i:1}"
        fi
    done
    echo "$nouveau_mot_masque"
}

# Fichier contenant la liste de mots
fichier_mots="pli07.txt"

# Choisir un mot aléatoire
mot_a_deviner=$(choisir_mot "$fichier_mots")

# Initialisation des variables
mot_masque=$(initialiser_mot_masque "$mot_a_deviner")
lettres_devinees=""
tentatives_restantes=6

# Boucle principale du jeu
while [[ $tentatives_restantes -gt 0 ]]; do
    clear
    echo "Mot à deviner :"
    afficher_mot_masque "$mot_masque"
    echo "Lettres devinées : $lettres_devinees"
    echo "Tentatives restantes : $tentatives_restantes"

    # Demander au joueur de deviner une lettre
    read -p "Devinez une lettre : " lettre
    if [[ "$lettre" =~ ^[A-Z]$ ]]; then
        if [[ "$lettres_devinees" == *"$lettre"* ]]; then
            echo "Vous avez déjà deviné cette lettre."
            sleep 1
        elif [[ "$mot_a_deviner" == *"$lettre"* ]]; then
            lettres_devinees+="$lettre"
            mot_masque=$(mettre_a_jour_mot_masque "$mot_a_deviner" "$mot_masque" "$lettre")
            if [ "$mot_masque" = "$mot_a_deviner" ]; then
                clear
                echo "Bravo ! Vous avez gagné. Le mot était : $mot_a_deviner"
                exit 0
            fi
        else
            lettres_devinees+="$lettre"
            ((tentatives_restantes--))
        fi
    else
        echo "Veuillez entrer une lettre valide."
        sleep 1
    fi
done

clear
echo "Dommage, vous avez perdu. Le mot était : $mot_a_deviner"
