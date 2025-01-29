#!/bin/bash

# Définir les couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Définir le tableau des fonctions et leurs dossiers
declare -A functions=(
    ["count_vowels"]="ft_count_vowels"
    ["count_words"]="ft_count_words"
    ["reverse_str"]="ft_reverse_str"
    ["count_occurrences"]="ft_count_occurrences"
    ["to_uppercase"]="ft_to_uppercase"
    ["remove_spaces"]="ft_remove_spaces"
    ["is_alpha"]="ft_is_alpha"
    ["str_copy"]="ft_str_copy"
    ["is_digit"]="ft_is_digit"
    ["str_len"]="ft_str_len"
)

# Fonction pour simuler un chargement rapide
loading() {
    echo -n -e "${YELLOW}⏳ Vérification en cours"
    for i in {1..3}; do
        echo -n "."
        sleep 0.5  # Pause rapide pour créer un effet
    done
    echo -e "${NC}"
}

# Vérifier la norme de 42 et compiler chaque fonction
for function in "${!functions[@]}"; do
    dir="${functions[$function]}"
    file="$dir/$dir.c"
    
    echo -e "${BLUE}🔍 Vérification de la fonction : ${function} dans ${file}${NC}"
    
    loading  # Simuler du suspense avant chaque vérification

    # Vérifier si le fichier existe
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}❌ Erreur : Le fichier ${file} n'existe pas.${NC}"
        continue
    fi

    # Simuler un léger suspense avant de vérifier la norme
    loading

    # Vérifier la conformité à la norme 42
    norminette_output=$(norminette "$file")
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}❌ Erreur : Le fichier ${file} ne respecte pas la norme de 42.${NC}"
        echo "$norminette_output"
        continue
    fi

    # Simuler un léger suspense avant la compilation
    loading

    # Compiler le fichier
    gcc -Wall -Wextra -Werror -c "$file" -o "$dir.o" 2>/dev/null
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}❌ Erreur : Le fichier ${file} ne compile pas.${NC}"
        continue
    fi

    echo -e "${GREEN}✅ La fonction ${function} dans ${file} est valide et respecte la norme de 42. Bravo ! 🎉${NC}"
done

echo -e "${GREEN}✅ Vérification terminée. Bon travail à tous ! 🚀${NC}"
