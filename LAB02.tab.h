/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_LAB02_TAB_H_INCLUDED
# define YY_YY_LAB02_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TABLE = 258,
    CREATE = 259,
    DROP = 260,
    SELECT = 261,
    WHERE = 262,
    BY = 263,
    GROUP = 264,
    ORDER = 265,
    INSERT = 266,
    DELETE = 267,
    UPDATE = 268,
    MAX = 269,
    MIN = 270,
    AVG = 271,
    COUNT = 272,
    INTO = 273,
    VALUES = 274,
    FROM = 275,
    SET = 276,
    ASC = 277,
    DESC = 278,
    TYPE_INTEGER = 279,
    TYPE_DECIMAL = 280,
    TYPE_VARCHAR = 281,
    ID = 282,
    OP_ADD = 283,
    OP_SUB = 284,
    OP_DIV = 285,
    OP_EQ = 286,
    OP_DIFF = 287,
    OP_GT = 288,
    OP_LT = 289,
    OP_GE = 290,
    OP_LE = 291,
    OP_AND = 292,
    OP_OR = 293,
    PARAOPEN = 294,
    PARACLOSE = 295,
    COMMAN = 296,
    SEMICOLON = 297,
    ASIG = 298,
    AST = 299,
    INTEGER = 300,
    DECIMAL = 301,
    STRING = 302
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_LAB02_TAB_H_INCLUDED  */
