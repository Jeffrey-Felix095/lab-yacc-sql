%{
#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include "LAB02.tab.h"
#include <string>
#include <vector>

extern int yylex();
extern FILE * yyin;
extern FILE * yyout;
extern int yylineno;
extern int linea;
extern char *yytext;

int has_syntax_error = 0; // Variable para indicar si hay errores sintácticos
int num_syntax_errors = 0;

void yyerror(const char *s);
%}

%token TABLE CREATE DROP SELECT WHERE BY GROUP ORDER
%token INSERT DELETE UPDATE MAX MIN AVG COUNT
%token INTO VALUES FROM SET ASC DESC
%token TYPE_INTEGER TYPE_DECIMAL TYPE_VARCHAR
%token PARAOPEN PARACLOSE COMMAN SEMICOLON ASIG AST
%token ID INTEGER DECIMAL STRING ERROR
%token OP_ADD OP_SUB OP_DIV OP_EQ OP_DIFF
%token OP_GT OP_LT OP_GE OP_LE OP_AND OP_OR


%start program

%%

program: statements
       ;

statements: statement SEMICOLON
          | error SEMICOLON
          | statements statement SEMICOLON
          | statements error SEMICOLON
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

void yyerror(const char *s){
    fprintf(yyout, "\nError sintactico en la linea numero: %d", linea+1);
    
    num_syntax_errors++;
}

int main(int argc, char *argv[]){    
    if (argc==2) {
        yyin = fopen(argv[1], "r");
        yyout = fopen("salida.txt", "w");
        
        if (yyin == NULL) {
            printf("No se pudo abrir el archivo %s \n", argv[1]);
            exit(-1);
        }else{            
                           
            yyparse(); 

            
            if(num_syntax_errors == 0 ){
                fprintf(yyout, "Correcto");
                
            }else{
                fprintf(yyout, "\nIncorrecto \nEl archivo de entrada tiene %d errores sintacticos. \n",num_syntax_errors);
                
            }
        }
    }else{
        printf("Debe escribir el nombre del archivo que quiere analizar");
        exit(-1);

    }
    
}
