#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
RESET="\033[0m"

success=0
fail=0

print_result() {
	if [ $1 -eq 0 ]; then
		echo -e "${GREEN}✔ $2${RESET}"
		((success++))
	else
		echo -e "${RED}✘ $2${RESET}"
		((fail++))
	fi
}

check_norme() {
	dir=$1
	if [ -d "$dir" ]; then
		norm_output=$(norminette "$dir"/*.c 2>/dev/null)
		error_lines=$(echo "$norm_output" | grep "Error" | grep -v "Header")
		if [ -n "$error_lines" ]; then
			print_result 1 "$dir : Norminette error"
			return 1
		else
			print_result 0 "$dir : Norminette OK"
			return 0
		fi
	else
		print_result 1 "$dir : Dossier introuvable"
		return 1
	fi
}

### EX00 ###
check_norme ex00 || skip_ex00=1
if [ -z "$skip_ex00" ] && [ -f ex00/count_syllabes.c ]; then
cat > ex00/main.c <<EOF
#include <stdio.h>
int count_syllables(char *);
int main() {
	printf("%d\n", count_syllables("bonjour"));  // 2
	printf("%d\n", count_syllables("salut"));    // 2
	printf("%d\n", count_syllables("aime"));     // 2
	printf("%d\n", count_syllables("oui"));      // 1
	printf("%d\n", count_syllables("crypt"));    // 1
	printf("%d\n", count_syllables("aeiouy"));   // 1
	return 0;
}
EOF

	gcc -Wall -Wextra -Werror ex00/count_syllabes.c ex00/main.c -o ex00/test00
	if [ $? -eq 0 ]; then
		output=$(./ex00/test00)
		expected="2
2
2
1
1
1"
		diff <(echo "$output") <(echo "$expected") > /dev/null
		print_result $? "Ex00 : count_syllables"
	else
		print_result 1 "Ex00 : Compilation failed"
	fi
	rm -f ex00/test00 ex00/main.c
elif [ ! -f ex00/count_syllabes.c ]; then
	print_result 1 "Ex00 : Fichier manquant"
fi

### EX01 ###
check_norme ex01 || skip_ex01=1
if [ -z "$skip_ex01" ] && [ -f ex01/print_numbers.c ]; then
cat > ex01/main.c <<EOF
#include <stdio.h>
void print_numbers();
int main() {
	print_numbers();
	return 0;
}
EOF

	gcc -Wall -Wextra -Werror ex01/print_numbers.c ex01/main.c -o ex01/test01
	if [ $? -eq 0 ]; then
		output=$(./ex01/test01)
		expected=$(for i in {1..50}; do if [ $((i % 3)) -ne 0 ] && [ $((i % 6)) -ne 0 ]; then printf "%d, " $i; fi; done | sed 's/, $//')
		diff <(echo "$output") <(echo "$expected") > /dev/null
		print_result $? "Ex01 : print_numbers"
	else
		print_result 1 "Ex01 : Compilation failed"
	fi
	rm -f ex01/test01 ex01/main.c
elif [ ! -f ex01/print_numbers.c ]; then
	print_result 1 "Ex01 : Fichier manquant"
fi

### EX02 ###
check_norme ex02 || skip_ex02=1
if [ -z "$skip_ex02" ] && [ -f ex02/uppercase_middle_letter.c ]; then
cat > ex02/main.c <<EOF
#include <stdio.h>
void uppercase_middle_letter(char *);
int main() {
	char w1[] = "bonjour";   // impaire
	char w2[] = "python";    // paire
	char w3[] = "abc";       // impaire
	char w4[] = "java";      // paire
	char w5[] = "superbe";   // impaire
	uppercase_middle_letter(w1);
	uppercase_middle_letter(w2);
	uppercase_middle_letter(w3);
	uppercase_middle_letter(w4);
	uppercase_middle_letter(w5);
	printf("%s\n", w1); // bonJour
	printf("%s\n", w2); // python
	printf("%s\n", w3); // aBc
	printf("%s\n", w4); // java
	printf("%s\n", w5); // supErbe
	return 0;
}
EOF

	gcc -Wall -Wextra -Werror ex02/uppercase_middle_letter.c ex02/main.c -o ex02/test02
	if [ $? -eq 0 ]; then
		output=$(./ex02/test02)
		expected="bonJour
python
aBc
java
supErbe"
		diff <(echo "$output") <(echo "$expected") > /dev/null
		print_result $? "Ex02 : uppercase_middle_letter"
	else
		print_result 1 "Ex02 : Compilation failed"
	fi
	rm -f ex02/test02 ex02/main.c
elif [ ! -f ex02/uppercase_middle_letter.c ]; then
	print_result 1 "Ex02 : Fichier manquant"
fi

### EX03 ###
check_norme ex03 || skip_ex03=1
if [ -z "$skip_ex03" ] && [ -f ex03/is_balanced.c ]; then
cat > ex03/main.c <<EOF
#include <stdio.h>
int is_balanced(const char *);
int main() {
	printf("%d\n", is_balanced("(()())")); // 1
	printf("%d\n", is_balanced("(()"));    // 0
	printf("%d\n", is_balanced("())("));   // 0
	printf("%d\n", is_balanced(""));       // 1
	printf("%d\n", is_balanced("()"));     // 1
	printf("%d\n", is_balanced("("));      // 0
	return 0;
}
EOF

	gcc -Wall -Wextra -Werror ex03/is_balanced.c ex03/main.c -o ex03/test03
	if [ $? -eq 0 ]; then
		output=$(./ex03/test03)
		expected="1
0
0
1
1
0"
		diff <(echo "$output") <(echo "$expected") > /dev/null
		print_result $? "Ex03 : is_balanced"
	else
		print_result 1 "Ex03 : Compilation failed"
	fi
	rm -f ex03/test03 ex03/main.c
elif [ ! -f ex03/is_balanced.c ]; then
	print_result 1 "Ex03 : Fichier manquant"
fi

### EX04 ###
check_norme ex04 || skip_ex04=1
if [ -z "$skip_ex04" ] && [ -f ex04/main.c ]; then
	gcc -Wall -Wextra -Werror ex04/main.c -o ex04/calculatrice
	if [ $? -eq 0 ]; then
		test_calc() {
			output=$(./ex04/calculatrice "$1" "$2" "$3")
			expected="$4"
			diff <(echo "$output") <(echo "$expected") > /dev/null
			print_result $? "Ex04 : $1 $2 $3 == $4"
		}
		test_calc 10 '+' 5 15
		test_calc 10 '-' 5 5
		test_calc 10 '*' 5 50
		test_calc 10 '/' 5 2
		test_calc 10 '/' 0 "Error : Division by zero."
	else
		print_result 1 "Ex04 : Compilation failed"
	fi
	rm -f ex04/calculatrice
elif [ ! -f ex04/main.c ]; then
	print_result 1 "Ex04 : Fichier manquant"
fi

### Résumé ###
echo
echo -e "Résultat final : ${GREEN}${success} réussites${RESET}, ${RED}${fail} échecs${RESET}"