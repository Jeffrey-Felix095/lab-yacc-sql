/**=================== Definitions ===================**/
%{
    #include <stdio.h>
    #include <ctype.h>
    #include <iostream>
    #include "LAB02.tab.h"
    int linea = 0;
%}

%option noyywrap
/** GRAMATICA **/

/*----- COMANDOS -------*/
COMMAND {CREATE}|{DROP}|{SEARCH}|{MANIPULATION}|{FUNCTION}|{RESERVED}|{TABLE}

/* Creación y eliminación (CREATE TABLE, DROP TABLE) */
TABLE [tT][aA][bB][lL][eE]               
CREATE [cC][rR][eE][aA][tT][eE]          
DROP [dD][rR][oO][pP]

/* Busqueda (SELECT, WHERE, GROUP BY, ORDER BY) */
SEARCH {SELECT}|{WHERE}|{GROUP}|{BY}|{ORDER}        
SELECT [sS][eE][lL][eE][cC][tT]                     
WHERE [wW][hH][eE][rR][eE]                         
BY [bB][yY]                                        
GROUP [gG][rR][oO][uU][pP]                          
ORDER [oO][rR][dD][eE][rR]                          

/* Manipulación (INSERT, DELETE, UPDATE)*/
MANIPULATION {INSERT}|{DELETE}|{UPDATE}
INSERT [iI][nN][sS][eE][rR][tT]                     
DELETE [dD][eE][lL][eE][tT][eE]                      
UPDATE [uU][pP][dD][aA][tT][eE]                      

/* Funciones (MAX, MIN, AVG, COUNT) */
FUNCTION {MAX}|{MIN}|{AVG}|{COUNT}                  
MAX [mM][aA][xX]                                      
MIN [mM][iI][nN]                                     
AVG [aA][vV][gG]                                  
COUNT [cC][oO][uU][nN][tT]                          

/* Palabras reservadas (INTO, VALUES, FROM, SET, ASC, DESC) */
RESERVED {INTO}|{VALUES}|{FROM}|{SET}|{ASC}|{DESC}
INTO [iI][nN][tT][oO]                             
VALUES [vV][aA][lL][uU][eE][sS]                      
FROM [fF][rR][oO][mM]                               
SET [sS][eE][tT]                                   
ASC [aA][sS][cC]                                     
DESC [dD][eE][sS][cC]                              

/* Tipos de datos: INTEGER, DECIMAL, VARCHAR... */
TYPE {TYPE_INTEGER}|{TYPE_DECIMAL}|{TYPE_VARCHAR}
TYPE_INTEGER [iI][nN][tT][eE][gG][eE][rR]            
TYPE_DECIMAL [dD][eE][cC][iI][mM][aA][lL]           
TYPE_VARCHAR [vV][aA][rR][cC][hH][aA][rR]         

/* Operadores: 
- aritmeticos: suma (+), resta (-), multiplicación (*), división (/)
- relacionales: igualdad (=), diferencia (<>), mayor que (>), menor que (<), mayor o igual que (>=), menor o igual que (<=)
- logicos: conjunción (AND) y disyunción (OR)
*/
OP_ADD "+"                                           
OP_SUB "-"
OP_DIV "/"                                            
OP_EQ "=="                                           
OP_DIFF "<>"                                        
OP_GT ">"                                        
OP_LT "<"                                             
OP_GE ">="                                            
OP_LE "<="                                     
OP_AND [aA][nN][dD]                                   
OP_OR [oO][rR]                                     

/* Separadores: Paréntesis que abre ( ( ), paréntesis que cierra( ) ), coma (,), punto y coma (;), asignación (=) */
PARAOPEN "("                                     
PARACLOSE ")"                                  
COMMAN ","                                            
SEMICOLON ";"                                           
ASIG "="                                              

/* Caracteres especiales: asterisco (*) */
AST "*"                                               

/* Identificadores: Nombres de tablas y columnas */
DIGIT [0-9]                                            
ACCENT [áéíóúÁÉÍÓÚñÑ]
ALPHA [a-zA-Z]|{ACCENT}
ID {ALPHA}({ALPHA}|{DIGIT})*                          

/* Números: entero o decimal */
INTEGER {DIGIT}+                                          
DECIMAL {INTEGER}?"\."{INTEGER}|{INTEGER}"\."{INTEGER}?   

/* Cadenas: entre comillas ’ (no son variables o indetificadores) */
STRING \'[^\']*\'|\"[^\"]*\"                               

ERROR {INTEGER_ERROR}|{DECIMAL_ERROR}                     
INTEGER_ERROR {INTEGER}{ALPHA}+({INTEGER}|{ALPHA})*
DECIMAL_ERROR {INTEGER_ERROR}"\."{INTEGER}|{INTEGER}"\."{INTEGER_ERROR}|{INTEGER_ERROR}"\."{INTEGER_ERROR}

%%
{TABLE}       { return TABLE; }
{CREATE}      { return CREATE; }
{DROP}        { return DROP; }

{SELECT}      { return SELECT; }
{WHERE}       { return WHERE; }
{BY}          { return BY; }
{GROUP}       { return GROUP; }
{ORDER}       { return ORDER; }

{INSERT}      { return INSERT; }
{DELETE}      { return DELETE; }
{UPDATE}      { return UPDATE; }

{MAX}         { return MAX; }
{MIN}         { return MIN; }
{AVG}         { return AVG; }
{COUNT}       { return COUNT; }

{INTO}        { return INTO; }
{VALUES}      { return VALUES; }
{FROM}        { return FROM; }
{SET}         { return SET; }
{ASC}         { return ASC; }
{DESC}        { return DESC; }

{TYPE_INTEGER} { return TYPE_INTEGER; }
{TYPE_DECIMAL} { return TYPE_DECIMAL; }
{TYPE_VARCHAR} { return TYPE_VARCHAR; }

{OP_ADD} { return OP_ADD; }
{OP_SUB} { return OP_SUB; }
{OP_DIV} { return OP_DIV; }
{OP_EQ} { return OP_EQ; }
{OP_DIFF} { return OP_DIFF; }
{OP_GT} { return OP_GT; }
{OP_LT} { return OP_LT; }
{OP_GE} { return OP_GE; }
{OP_LE} { return OP_LE; }
{OP_AND} { return OP_AND; }
{OP_OR} { return OP_OR; }

{PARAOPEN}    { return PARAOPEN; }
{PARACLOSE}   { return PARACLOSE; }
{COMMAN}      { return COMMAN; }
{SEMICOLON}   { linea++; return SEMICOLON; }
{ASIG}        { return ASIG; }

{AST}         { return AST; }

{DIGIT}          { return DIGIT; }
{ACCENT}          { return ACCENT; }
{ALPHA}          { return ALPHA; }
{ID}          { return ID; }

{INTEGER}     { return INTEGER; }
{DECIMAL}     { return DECIMAL; }

{STRING}      { return STRING; }

{ERROR} {return ERROR;}

"."  {return ERROR;}

\n						{ return NEWLINE; }
%%