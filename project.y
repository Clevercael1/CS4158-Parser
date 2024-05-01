
%token LINE_TERMINATOR STRING_LITERAL START MAIN END MOVE ADD INPUT PRINT TO SEMICOLON
%token <sval> INTEGER_TYPE
%token <sval> FLOAT_TYPE
%token <sval> IDENTIFIER
%token <ival> INTEGER
%token <fval> FLOAT

%union {
    int ival;
    char *sval;
    float fval;
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

extern FILE* yyin;
extern int yylineno;

int yylex();
void yyerror(const char *msg);

#define MAX_SYMBOLS_SIZE 100000

struct symbol {
    char name[100];
    int value;
    int size;
};

struct symbol symbol_table[MAX_SYMBOLS_SIZE];
int num_symbols = 0;

void add_symbol_to_table(char* name, char* size);
int find_symbol_from_table(char* name);

%}

/*

The parser should report when it has been presented with a well-formed/not-well-formed program. 
It should also flag an error if the program attempts to assign a value to a variable that is not declared, 
or assign a value to a variable which is bigger than its declared capacity. For example, using the program above, 
if a program tried to ‘MOVE 500000 TO Y’ a warning flag should be raised (as Y is only declared as ‘SSSS’). 
For top marks the parser should detect if you try to put a float value (ADD or MOVE) into an integer. 
For example, in the correct code above, if we tried to move Z (or 50.3) to -Y. 

invalid needed as a token?
need to update lines 88 onwards.
need to change methods around
input statement needs to take 3 identifiers

start
declare int 
declare float

main
print 
add 
move 
input 
end 


*/

%%
bucol : START LINE_TERMINATOR declaration_section MAIN LINE_TERMINATOR main_section END LINE_TERMINATOR

declaration_section : declaration_statement
                    | declaration_section declaration_statement 
                    ;

declaration_statement : INTEGER_TYPE IDENTIFIER LINE_TERMINATOR { add_symbol_to_table($2, $1); }
                      | FLOAT_TYPE IDENTIFIER LINE_TERMINATOR { add_symbol_to_table($2, $1); }
                      ;

main_section : main_statement
             | main_section main_statement
             ;

main_statement : move_assignment_statement
               | add_assignment_statement
               | input_assignment_statement
               | print_statement
               ;


move_assignment_statement : MOVE IDENTIFIER TO IDENTIFIER LINE_TERMINAL { 
                                                                    int index_one = find_symbol_from_table($2);
                                                                    if (index_one == -1) {
                                                                        char str[100];
                                                                        sprintf(str, "Undeclared variable: %s", $2);
                                                                        yyerror(str);
                                                                    }

                                                                    int index_two = find_symbol_from_table($4);
                                                                    if (index_two == -1) {
                                                                        char str[100];
                                                                        sprintf(str, "Undeclared variable: %s", $4);
                                                                        yyerror(str);
                                                                    }

                                                                    if (symbol_table[index_one].size > symbol_table[index_two].size){
                                                                        char str[100];
                                                                        sprintf(str, "%s is larger than the capacity of %s", $2, $4);
                                                                        yyerror(str);
                                                                    }
                                                                    symbol_table[index_two].value = (int)$2;                                                                     
                                                                }
                          | MOVE INTEGER TO IDENTIFIER LINE_TERMINAL { 
                                                                int index = find_symbol_from_table($4);
                                                                if (index == -1) {
                                                                    char str[100];
                                                                    sprintf(str, "Undeclared variable: %s", $4);
                                                                    yyerror(str);
                                                                }
                                                                int val = $2;
                                                                int num_digits = 0;
                                                                while (val != 0) {
                                                                    val /= 10;
                                                                    num_digits++;
                                                                }

                                                                if (num_digits > symbol_table[index].size){
                                                                    char str[100];
                                                                    sprintf(str, "%d is larger than the capacity of %s", (int)$2, $4);
                                                                    yyerror(str);
                                                                }
                                                                symbol_table[index].value = $2; 
                                                            }
                          | MOVE FLOAT TO IDENTIFIER LINE_TERMINAL { 
                                                                int index = find_symbol_from_table($4);
                                                                if (index == -1) {
                                                                    char str[100];
                                                                    sprintf(str, "Undeclared variable: %s", $4);
                                                                    yyerror(str);
                                                                }
                                                                int val = $2;
                                                                int num_digits = 0;
                                                                while (val != 0) {
                                                                    val /= 10;
                                                                    num_digits++;
                                                                }

                                                                if (num_digits > symbol_table[index].size){
                                                                    char str[100];
                                                                    sprintf(str, "%d is larger than the capacity of %s", (int)$2, $4);
                                                                    yyerror(str);
                                                                }
                                                                symbol_table[index].value = $2; 
                                                            }
                          ;

add_assignment_statement : ADD INTEGER TO IDENTIFIER LINE_TERMINAL { 
                                                                    int index = find_symbol_from_table($4);
                                                                    if (index == -1) {
                                                                        char str[100];
                                                                        sprintf(str, "Undeclared variable: %s", $4);
                                                                        yyerror(str);
                                                                    }
                                                                    int val = symbol_table[index].value;
                                                                    int new_val = $2 + val;
                                                                    int num_digits = 0;
                                                                    while (new_val != 0){
                                                                        new_val/=10;
                                                                        num_digits++;
                                                                    }
                                                                    if (num_digits > symbol_table[index].size){
                                                                        char str[100];
                                                                        sprintf(str, "The summation is larger than the capacity of: %s", $4);
                                                                        yyerror(str);
                                                                    }
                                                                    symbol_table[index].value = $2 + val;
                                                                }
                         | ADD IDENTIFIER TO IDENTIFIER LINE_TERMINAL { 
                                                                    int index_one = find_symbol_from_table($2);
                                                                    if (index_one == -1) {
                                                                        char str[100];
                                                                        sprintf(str, "Undeclared variable: %s", $2);
                                                                        yyerror(str);
                                                                    }

                                                                    int index_two = find_symbol_from_table($4);
                                                                    if (index_two == -1) {
                                                                        char str[100];
                                                                        sprintf(str, "Undeclared variable: %s", $4);
                                                                        yyerror(str);
                                                                    }

                                                                    int val2 = symbol_table[index_two].value;
                                                                    int val1 = symbol_table[index_one].value;
                                                                    int newVal = val1 + val2;
                                                                    int num_digits = 0;
                                                                    while(newVal != 0){
                                                                        newVal/=10;
                                                                        num_digits++;
                                                                    }
                                                                    if (num_digits > symbol_table[index_two].size){
                                                                        char str[100];
                                                                        sprintf(str, "the summation is larger than the capacity of: %s", $4);
                                                                        yyerror(str);
                                                                    }
                                                                    symbol_table[index_two].value = val1 + val2;
                                                                }
                         | : ADD FLOAT TO IDENTIFIER LINE_TERMINAL { 
                                                                    int index = find_symbol_from_table($4);
                                                                    if (index == -1) {
                                                                        char str[100];
                                                                        sprintf(str, "Undeclared variable: %s", $4);
                                                                        yyerror(str);
                                                                    }
                                                                    int val = symbol_table[index].value;
                                                                    int new_val = $2 + val;
                                                                    int num_digits = 0;
                                                                    while (new_val != 0){
                                                                        new_val/=10;
                                                                        num_digits++;
                                                                    }
                                                                    if (num_digits > symbol_table[index].size){
                                                                        char str[100];
                                                                        sprintf(str, "The summation is larger than the capacity of: %s", $4);
                                                                        yyerror(str);
                                                                    }
                                                                    symbol_table[index].value = $2 + val;
                                                                }
                         ;
input_assignment_statement : INPUT IDENTIFIER LINE_TERMINAL {
                                                        int index_one = find_symbol_from_table($2);
                                                        if (index_one == -1) {
                                                            char str[100];
                                                            sprintf(str, "Undeclared variable: %s", $2);
                                                            yyerror(str);
                                                        }
                                                  }
                           | INPUT identifier_list IDENTIFIER LINE_TERMINAL {
                                                                        int index_one = find_symbol_from_table($3);
                                                                        if (index_one == -1) {
                                                                            char str[100];
                                                                            sprintf(str, "Undeclared variable: %s", $3);
                                                                            yyerror(str);
                                                                        }
                                                                   }
                           ;

identifier_list : IDENTIFIER SEMI_COLON {
                                            int index_one = find_symbol_from_table($1);
                                            if (index_one == -1) {
                                                char str[100];
                                                sprintf(str, "Undeclared variable: %s", $1);
                                                yyerror(str);
                                            }
                                        }
                | identifier_list IDENTIFIER SEMI_COLON {
                                                            int index_one = find_symbol_from_table($2);
                                                            if (index_one == -1) {
                                                                char str[100];
                                                                sprintf(str, "Undeclared variable: %s", $2);
                                                                yyerror(str);
                                                            }
                                                        }
                ;

print_statement : PRINT print_element LINE_TERMINAL
                 | PRINT print_list
                 ;

print_list : print_element SEMI_COLON
           | print_list print_element SEMI_COLON
           | print_list print_element LINE_TERMINAL
           ;

print_element : STRING_LITERAL
              | IDENTIFIER {
                                int index_one = find_symbol_from_table($1);
                                if (index_one == -1) {
                                    char str[100];
                                    sprintf(str, "Undeclared variable: %s", $1);
                                    yyerror(str);
                                }
                            }
              ;
%%
/*
extern FILE *yyin;

main()
{
do yyparse();
while(!feof(yyin));
}

yyerror(char *s)
{
fprintf(stderr, "%s\n", s);
}
*/

void add_symbol_to_table(char* name, char* size) {
    int index = find_symbol_from_table(name);
    if (index == -1) {
        strcpy(symbol_table[num_symbols].name, name);
        symbol_table[num_symbols].value = 0;
        symbol_table[num_symbols].size =strlen(size);
        num_symbols++;
    }
}

int find_symbol_from_table(char* name) {
    int i;
    for (i = 0; i < num_symbols; i++) {
        if (strcmp(name, symbol_table[i].name) == 0) {
            return i;
        }
    }
    return -1;
}

void yyerror(const char *msg) {
    printf("Invalid Program!\n");
    fprintf(stderr, "Line %d: %s\n", yylineno, msg);
    exit(1);
}

int main(int argc, char** argv) {
  if (argc != 2) {
    printf("Input file required");
    return 1;
  }

  FILE* input_file = fopen(argv[1], "r");
  if (!input_file) {
    printf("Failed to open file %s\n", argv[1]);
    return 1;
  }

  yyin = input_file;
  int parseResult = yyparse();
  if (parseResult == 0){
    printf("Program is well formed!\n");
  }else if (parseResult == 2){
    printf("Program ran out of memory!\n");
  }
  
  fclose(input_file);
  return 0;
}