%{
#include <stdio.h>
#include "LAB02.tab.h"
#include <string>
#include <vector>

extern int yylex();
extern int yylineno;

int has_syntax_error = 0; // Variable para indicar si hay errores sintácticos
int num_syntax_errors = 0;
int num_lexical_errors = 0; // Variable para contar errores léxicos
int num_identifiers = 0; // Variable para contar identificadores

// Declaración de un vector para almacenar identificadores
std::vector<std::string> identifiers;

int yyerror(const char *s) {
    fprintf(stderr, "Error en la línea %d: %s\n", yylineno, s);
    has_syntax_error = 1;
    num_syntax_errors++; // Incrementa el contador de errores sintácticos
    return 1;  // Retorna un valor no cero para indicar un error
}


%}

%token TABLE CREATE DROP
%token SELECT WHERE BY GROUP ORDER
%token INSERT DELETE UPDATE
%token MAX MIN AVG COUNT
%token INTO VALUES FROM SET ASC DESC
%token TYPE_INTEGER TYPE_DECIMAL TYPE_VARCHAR ID
%token OP_ADD OP_SUB OP_DIV OP_EQ OP_DIFF OP_GT OP_LT OP_GE OP_LE OP_AND OP_OR
%token PARAOPEN PARACLOSE COMMAN SEMICOLON ASIG AST
%token INTEGER DECIMAL STRING
%token ERROR

%start program

%%

program: statements
       ;

statements: statement SEMICOLON
          | error { has_syntax_error = 1; } SEMICOLON
          | statements statement SEMICOLON
          | statements error { has_syntax_error = 1; } SEMICOLON
          ;

statement: create_table
         | drop_table
         | insert_into
         | delete_from
         | update_set
         | select
         ;

create_table: CREATE TABLE ID PARAOPEN columns PARACLOSE
            ;

columns: column
        | columns COMMAN column
        ;

column: ID type PARAOPEN TYPE_INTEGER PARACLOSE
      ;

drop_table: DROP TABLE ID
          ;

insert_into: INSERT INTO ID PARAOPEN values PARACLOSE
           ;

type: TYPE_DECIMAL
    | TYPE_INTEGER
    | TYPE_VARCHAR
    ;

values: value
      | values COMMAN value
      ;

value: INTEGER
     | DECIMAL
     | STRING
     ;

delete_from: DELETE FROM ID WHERE conditions
           ;

conditions: condition
          | conditions OP_AND condition
          | conditions OP_OR condition
          ;

condition: ID OP_EQ value
         ;

update_set: UPDATE ID SET ID OP_EQ value WHERE conditions
          ;

select: SELECT select_list FROM ID where_clause group_by order_by
      ;

select_list: AST
           | identifiers
           | funtions
           ;

funtions: funtion_structure
        | funtion_structure COMMAN funtions
        ;

funtion_structure: funtion PARAOPEN ID PARACLOSE
                 ;

funtion: MAX
       | MIN
       | AVG
       | COUNT
       ;

identifiers: ID
           | identifiers COMMAN ID
           ;

where_clause: WHERE conditions
            ;

group_by: GROUP BY ID
         ;

order_by: ORDER BY order_columns ordering
        ;

order_columns: ID
             | order_columns COMMAN ID
             ;

ordering: ASC
        | DESC
        ;

%%

int main() {
    yyparse(); // Iniciar el análisis sintáctico

    // Imprimir la información recopilada
    printf("%zu Identificadores\n", identifiers.size());
    printf("%d Errores léxicos\n", num_lexical_errors);
    printf("%d Errores sintácticos\n", num_syntax_errors); // Imprime el número de errores sintácticos

    return 0;
}
