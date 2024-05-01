%{
#include <stdio.h>

//COF 20272626
#define TEXT 1
#define IDENTIFIER 2
#define LINE_TERMINATOR 4
#define STRING_LITERAL 5
#define SEMICOLON 6
#define INTEGER 7
#define FLOAT 8

#define START 9
#define MAIN 10
#define END 11
#define MOVE 12
#define ADD 13
#define INPUT 14
#define PRINT 15
#define TO 16
#define INVALID 17

#define INTEGER_TYPE 3
#define FLOAT_TYPE 3

%}

%option caseless

%%

[\t ]+ /* ignore whitespace */ ;
"START"                                                     {printf("current %s is a valid KEYWORD\n", yytext); return(START);}
"MAIN"                                                      {printf("current %s is a valid KEYWORD\n", yytext); return(MAIN);}
"END"                                                       {printf("current %s is a valid KEYWORD\n", yytext); return(END);}
"MOVE"                                                      {printf("current %s is a valid KEYWORD\n", yytext); return(MOVE);}
"ADD"                                                       {printf("current %s is a valid KEYWORD\n", yytext); return(ADD);}
"INPUT"                                                     {printf("current %s is a valid KEYWORD\n", yytext); return(INPUT);}
"PRINT"                                                     {printf("current %s is a valid KEYWORD\n", yytext); return(PRINT);}
"TO"                                                        {printf("current %s is a valid KEYWORD\n", yytext); return(TO);}

s+                                                          {printf("current %s is a valid INTEGER_TYPE\n", yytext); return(INTEGER_TYPE);}
(s+\.\s+)                                                   {printf("current %s is a valid FLOAT_TYPE\n", yytext); return(FLOAT_TYPE);}
[a-zA-Z][a-zA-Z0-9-]*|[-][a-zA-Z][a-zA-Z0-9-]*              {printf("current %s is a valid IDENTIFIER\n", yytext); return(IDENTIFIER);}
\"(\\.|[^\"])*\"                                            {printf("current %s is a valid STRING_LITERAL\n", yytext); return STRING_LITERAL;}
\.					                                        {printf("current %s is a valid LINE_TERMINATOR\n", yytext); return LINE_TERMINATOR;}
\;					                                        {printf("current %s is a valid SEMICOLON\n", yytext); return SEMICOLON;}
[0-9]*                                                      {printf("current %s is a valid INTEGER\n", yytext); return INTEGER;}
[0-9]+(\.[0-9]+)?                                           {printf("current %s is a valid FLOAT\n", yytext); return FLOAT;}
[0-9][a-zA-Z0-9-]*|[\p{Symbol}^\s-][\p{Symbol}a-zA-Z0-9-]*  {printf("current %s is INVALID\n", yytext); return INVALID;}

%%

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


int yywrap() {
    return(1); 
}