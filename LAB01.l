
/**=================== Definitions ===================**/
%{
    #include <stdio.h>
    #include <ctype.h>
    #include <iostream>
    #include <vector>
    #include <string>
    #include "LAB02.tab.h"
    
    using namespace std;

    vector<string> identifiers;

    int num_errors = 0;

    char* toUpper(char* str) {
        for (int i = 0; str[i]; i++) {
            str[i] = toupper(str[i]);
        }
        return str;
    }

    int search_id(string id) {
        for (int i = 0; i < identifiers.size(); i++) {
            if (identifiers.at(i) == id) {
                return i;
            }
        }
        return -1;
    }

    void add_id(string id) {
        identifiers.insert(identifiers.end(), id);
    }
%}

/** GRAMATICA **/

/*----- COMANDOS -------*/
COMMAND {CREATE}|{DROP}|{SEARCH}|{MANIPULATION}|{FUNCTION}|{RESERVED}|{TABLE}

/* Creación y eliminación (CREATE TABLE, DROP TABLE) */
TABLE [tT][aA][bB][lL][eE]               { return TABLE; }
CREATE [cC][rR][eE][aA][tT][eE]          { return CREATE; }
DROP [dD][rR][oO][pP]

/* Busqueda (SELECT, WHERE, GROUP BY, ORDER BY) */
SEARCH {SELECT}|{WHERE}|{GROUP}|{BY}|{ORDER}        
SELECT [sS][eE][lL][eE][cC][tT]                     { return SELECT; }
WHERE [wW][hH][eE][rR][eE]                          { return WHERE; }
BY [bB][yY]                                         { return BY; }
GROUP [gG][rR][oO][uU][pP]                          { return GROUP; }
ORDER [oO][rR][dD][eE][rR]                          { return ORDER; }

/* Manipulación (INSERT, DELETE, UPDATE)*/
MANIPULATION {INSERT}|{DELETE}|{UPDATE}
INSERT [iI][nN][sS][eE][rR][tT]                      { return INSERT; }
DELETE [dD][eE][lL][eE][tT][eE]                      { return DELETE; }
UPDATE [uU][pP][dD][aA][tT][eE]                      { return UPDATE; }

/* Funciones (MAX, MIN, AVG, COUNT) */
FUNCTION {MAX}|{MIN}|{AVG}|{COUNT}                  
MAX [mM][aA][xX]                                     { return MAX; }   
MIN [mM][iI][nN]                                     { return MIN; }
AVG [aA][vV][gG]                                     { return AVG; }
COUNT [cC][oO][uU][nN][tT]                           { return COUNT; }

/* Palabras reservadas (INTO, VALUES, FROM, SET, ASC, DESC) */
RESERVED {INTO}|{VALUES}|{FROM}|{SET}|{ASC}|{DESC}
INTO [iI][nN][tT][oO]                                { return INTO; }
VALUES [vV][aA][lL][uU][eE][sS]                      { return VALUES; }
FROM [fF][rR][oO][mM]                                { return FROM; }
SET [sS][eE][tT]                                     { return SET; }
ASC [aA][sS][cC]                                     { return ASC; }
DESC [dD][eE][sS][cC]                                { return DESC; }

/* Tipos de datos: INTEGER, DECIMAL, VARCHAR... */
TYPE {TYPE_INTEGER}|{TYPE_DECIMAL}|{TYPE_VARCHAR}
TYPE_INTEGER [iI][nN][tT][eE][gG][eE][rR]            { return TYPE_INTEGER; }
TYPE_DECIMAL [dD][eE][cC][iI][mM][aA][lL]            { return TYPE_DECIMAL; }
TYPE_VARCHAR [vV][aA][rR][cC][hH][aA][rR]            { return TYPE_VARCHAR; }

/* Operadores: 
- aritmeticos: suma (+), resta (-), multiplicación (*), división (/)
- relacionales: igualdad (=), diferencia (<>), mayor que (>), menor que (<), mayor o igual que (>=), menor o igual que (<=)
- logicos: conjunción (AND) y disyunción (OR)
*/
OP_ADD "+"                                            { return OP_ADD; }
OP_SUB "-"                                            { return OP_SUB; }
/*OP_MULT "*"*/
OP_DIV "/"                                            { return OP_DIV; }
OP_EQ "=="                                            { return OP_EQ; }  
OP_DIFF "<>"                                          { return OP_DIFF; }
OP_GT ">"                                             { return OP_GT; }
OP_LT "<"                                             { return OP_LT; }
OP_GE ">="                                            { return OP_GE; }
OP_LE "<="                                            { return OP_LE; }
OP_AND [aA][nN][dD]                                   { return OP_AND; }
OP_OR [oO][rR]                                        { return OP_OR; }

/* Separadores: Paréntesis que abre ( ( ), paréntesis que cierra( ) ), coma (,), punto y coma (;), asignación (=) */
PARAOPEN "("                                           { return PARAOPEN; }
PARACLOSE ")"                                          { return PARACLOSE; }
COMMAN ","                                             { return COMMAN; }
SEMICOLON ";"                                          { return SEMICOLON; }
ASIG "="                                               { return ASIG; }

/* Caracteres especiales: asterisco (*) */
AST "*"                                                { return AST; }

/* Identificadores: Nombres de tablas y columnas */
DIGIT [0-9]                                            
ACCENT [áéíóúÁÉÍÓÚñÑ]
ALPHA [a-zA-Z]|{ACCENT}
ID {ALPHA}({ALPHA}|{DIGIT})*                           { return ID; }

/* Números: entero o decimal */
INTEGER {DIGIT}+                                          { yylval.integer_value = atoi(yytext); return INTEGER; }
DECIMAL {INTEGER}?"\."{INTEGER}|{INTEGER}"\."{INTEGER}?   { yylval.integer_value = atoi(yytext); return DECIMAL; }

/* Cadenas: entre comillas ’ (no son variables o indetificadores) */
STRING \'[^\']*\'|\"[^\"]*\"                               { return STRING; }

ERROR {INTEGER_ERROR}|{DECIMAL_ERROR}
INTEGER_ERROR {INTEGER}{ALPHA}+({INTEGER}|{ALPHA})*
DECIMAL_ERROR {INTEGER_ERROR}"\."{INTEGER}|{INTEGER}"\."{INTEGER_ERROR}|{INTEGER_ERROR}"\."{INTEGER_ERROR}
%%
\n|" "|\t {printf("%s", yytext);}

{COMMAND}|{TYPE} {
    printf("%s", toUpper(yytext));
}

{OP_ADD} {printf(" suma=%s ", yytext);}
{OP_SUB} {printf(" resta=%s ", yytext);}
{OP_DIV} {printf(" div=%s ", yytext);}
{OP_EQ} {printf(" igual=%s ", yytext);}
{OP_DIFF} {printf(" dife=%s ", yytext);}
{OP_GT} {printf(" mayorq=%s ", yytext);}
{OP_LT} {printf(" menorq=%s ", yytext);}
{OP_GE} {printf(" mayoriq=%s ", yytext);}
{OP_LE} {printf(" menoriq=%s ", yytext);}
{OP_AND} {printf(" y=%s ", yytext);}
{OP_OR} {printf(" o=%s ", yytext);}

{PARAOPEN} {printf(" parabre=%s ", yytext);}
{PARACLOSE} {printf(" parcierr=%s ", yytext);}
{COMMAN} {printf(" coma=%s", yytext);}
{SEMICOLON} {printf(" puntcoma=%s", yytext);}
{ASIG} {printf(" asign=%s ", yytext);}

{AST} {printf(" asterisco=%s", yytext);}

{ERROR} {
    printf("ERROR=%s ", yytext);
    num_errors++;
}

{ID} {
    int index = search_id(yytext);

    if (index == -1) {
        add_id(yytext);
        index = search_id(yytext);
    }
    printf("id%d=%s", index + 1, yytext);
}

{STRING} {printf("cadena=%s", yytext);}

{INTEGER} {printf("entero=%s" yytext);}
{DECIMAL} {printf("decimal=%s", yytext);}


. {
    printf("ERROR: %s ", yytext);
    num_errors++;
}
%%

/**=================== CODE SECTION ===================**/

int yywrap(){return 1;}

int main( int argc, char **argv )
    {
    ++argv, --argc; /* skip over program name */
    if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
    else
        yyin = stdin;

    yylex();

    printf("\n\n\n");
    printf("%zu Identificadores\n", identifiers.size());

    for (int i = 0; i < identifiers.size(); i++) {
        printf("id%d=%s\n", i + 1, identifiers.at(i).c_str());
    }

    printf("\n%d Errores lexicos\n", num_errors);
}