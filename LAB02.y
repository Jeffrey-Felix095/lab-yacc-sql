%{
#include <stdio.h>
#include <stdlib.h>


extern int yylex();
extern FILE * yyin;
extern FILE * yyout;
extern int linea;
extern char *yytext;

int has_syntax_error = 0; // Variable para indicar si hay errores sintácticos
int num_syntax_errors = 0;

void yyerror(const char *s);
%}

%token TABLE CREATE DROP 

%token SELECT WHERE BY GROUP ORDER

%token INSERT DELETE UPDATE 

%token MAX MIN AVG COUNT

%token INTO VALUES FROM SET ASC DESC

%token TYPE_INTEGER TYPE_DECIMAL TYPE_VARCHAR

%token OP_ADD OP_SUB OP_DIV OP_EQ OP_DIFF
%token OP_GT OP_LT OP_GE OP_LE OP_AND OP_OR

%token PARAOPEN PARACLOSE COMMAN SEMICOLON ASIG 

%token AST

%token DIGIT ACCENT ALPHA ID 

%token INTEGER DECIMAL 

%token STRING

%token ERROR NEWLINE


%start program

%%

program: statements
       ;

statements: statement 
          | statements statement 
          ;

statement: create_table SEMICOLON {linea++;}
         | drop_table SEMICOLON {linea++;}
         | insert_into SEMICOLON {linea++;}
         | delete_from SEMICOLON {linea++;}
         | update_set SEMICOLON {linea++;}
         | select SEMICOLON {linea++;}
         | error SEMICOLON {linea++;} 
         ;

create_table: CREATE TABLE ID PARAOPEN columns PARACLOSE
            ;

columns: column
       | columns COMMAN column
       ;

column: ID type limit
      ;

limit:
     | PARAOPEN INTEGER PARACLOSE
     | PARAOPEN DIGIT PARACLOSE 
     ;

drop_table: DROP TABLE ID
          ;

insert_into: INSERT INTO ID VALUES PARAOPEN values PARACLOSE
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

condition: ID ASIG value
         | ID OP_DIFF value
         | ID OP_GT value
         | ID OP_LT value
         | ID OP_GE value
         | ID OP_LE value
         | ID OP_EQ value
         ;

update_set: UPDATE ID SET ID ASIG value WHERE conditions
          | UPDATE ID SET ID OP_EQ value WHERE conditions
          ;

select: SELECT select_list FROM ID group_by order_by where_clause
      ;

select_list: AST
           | select_items
           ;

select_items: select_item
            | select_items COMMAN select_item
            ;

select_item: ID
           | funtion_structure
           ;
funtion_structure: funtion PARAOPEN ID PARACLOSE
                 ;

funtion: MAX
       | MIN
       | AVG
       | COUNT
       ;


where_clause:
            | WHERE conditions
            ;

group_by: 
        |GROUP BY ID
         ;

order_by: 
        |ORDER BY order_columns ordering
        ;

order_columns: ID
             | order_columns COMMAN ID
             ;

ordering:
        | ASC
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
