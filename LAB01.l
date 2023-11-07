/**=================== Definitions ===================**/
%{
    #include <stdio.h>
    #include <ctype.h>
    #include <iostream>
    #include "LAB02.tab.h"
%}

%option noyywrap
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

ERROR {INTEGER_ERROR}|{DECIMAL_ERROR}                      { return ERROR; }
INTEGER_ERROR {INTEGER}{ALPHA}+({INTEGER}|{ALPHA})*
DECIMAL_ERROR {INTEGER_ERROR}"\."{INTEGER}|{INTEGER}"\."{INTEGER_ERROR}|{INTEGER_ERROR}"\."{INTEGER_ERROR}
%%