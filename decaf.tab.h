/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_DECAF_TAB_H_INCLUDED
# define YY_YY_DECAF_TAB_H_INCLUDED
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
    OPENC = 258,
    CLOSEC = 259,
    OPENB = 260,
    CLOSEB = 261,
    BOOL = 262,
    BREAK = 263,
    CALLOUT = 264,
    CLASS = 265,
    CONTINUE = 266,
    ELSE = 267,
    FALSE = 268,
    FOR = 269,
    IF = 270,
    INT = 271,
    RETURN = 272,
    TRUE = 273,
    VOID = 274,
    OR = 275,
    AND = 276,
    EQ = 277,
    PE = 278,
    ME = 279,
    EE = 280,
    NE = 281,
    LE = 282,
    LT = 283,
    GE = 284,
    GT = 285,
    PLUS = 286,
    MINUS = 287,
    MUL = 288,
    DIV = 289,
    MOD = 290,
    NOT = 291,
    UMINUS = 292,
    ID = 293,
    NUM = 294,
    STRING = 295,
    CHAR = 296
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 27 "decaf.y" /* yacc.c:1909  */

	char *sval;
	int ival;
	char cval;
	ASTProgram * program;
	std::vector<ASTFieldDecl *> * field_decls;
	ASTFieldDecl * field_decl;
	std::vector<ASTVarIdentifier *> * identifiers;
	std::vector<ASTArrayIdentifier *> * identifier_arrays;
	ASTArrayIdentifier * identifier_array;
	std::vector<ASTMethodDecl *> * method_decls;
	ASTMethodDecl * method_decl;
	std::vector<ASTTypeIdentifier *> * type_identifiers;
	ASTTypeIdentifier * type_identifier;
	ASTBlockStatement * block;
	std::vector<ASTStatement *> * statements;
	std::vector<ASTVarDecl *> * var_decls;
	ASTVarDecl * var_decl;
	Datatype type;
	ASTStatement * statement;
	AssignOp assign_op;
	ASTMethodCall * method_call;
	std::vector<ASTExpression *> * exprs;
	std::vector<ASTCalloutArg *> * callout_args;
	ASTLocation * location;
	ASTExpression * expr;
	ASTCalloutArg * callout_arg;
	ASTLiteralExpression * literal;

#line 126 "decaf.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_DECAF_TAB_H_INCLUDED  */
