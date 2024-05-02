%{
#include <stdio.h>
#include <string.h>
#include "project.tab.h"
//COF 20272626
// #define TEXT 1
// #define IDENTIFIER 2
// #define LINE_TERMINATOR 4
// #define STRING_LITERAL 5
// #define SEMICOLON 6
// #define INTEGER 7
// #define FLOAT 8

// #define START 9
// #define MAIN 10
// #define END 11
// #define MOVE 12
// #define ADD 13
// #define INPUT 14
// #define PRINT 15
// #define TO 16
// #define INVALID 17

// #define INTEGER_TYPE 3
// #define FLOAT_TYPE 3

%}

%option caseless
%option yylineno
%option noyywrap

%%

[\t ]+ /* ignore whitespace */ ;
[[:space:]] {}
START                                                       { return START; }
MAIN                                                        { return MAIN;}
END                                                         { return END ;}
MOVE                                                        {return MOVE;}
ADD                                                         { return ADD;}
INPUT                                                       { return INPUT;}
PRINT                                                       { return PRINT;}
TO                                                          { return TO;}

s+                                                          { return INTEGER_TYPE;}
(s+\.\s+)                                                   { return FLOAT_TYPE;}
[a-zA-Z][a-zA-Z0-9-]*|[-][a-zA-Z][a-zA-Z0-9-]*              { return IDENTIFIER;}
\"(\\.|[^\"])*\"                                            { return STRING_LITERAL;}
[\.]					                                    { return LINE_TERMINATOR; }
\;					                                        { return SEMICOLON;}
[0-9]*                                                      { return INTEGER;}
[0-9]+(\.[0-9]+)?                                           { return FLOAT;}

%%
// [0-9][a-zA-Z0-9-]*|[\p{Symbol}^\s-][\p{Symbol}a-zA-Z0-9-]*  { return INVALID;}

/*
int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s input_file\n", argv[0]);
        return 1;
    }

    FILE *inputFile = fopen("example.in", "r");
    if (!inputFile) {
        fprintf(stderr, "Failed to open input file.\n");
        return 1;
    }

    yyrestart(inputFile);

int token;
while ((token = yylex()) != 0) {
    yylex();

}
    fclose(inputFile);

    return 0;
}
*/

// int yywrap() {
//     return(1); 
// }