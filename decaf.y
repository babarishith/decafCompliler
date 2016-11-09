%{
#include <cstdio>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include "ast.h"
#include "visitor.h"
using namespace std;

//Stuff from flex
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern "C" ofstream outflex;
ASTProgram * start;

ofstream outfile;
//ofstream outflex;
//int line_num=1;
//int flag = 0;

void yyerror(const char *s);
%}

%union {
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
}

%token ','
%token ';'
%token OPENC
%token CLOSEC
%token '['
%token ']'
%token OPENB
%token CLOSEB
%token BOOL
%token BREAK
%token CALLOUT
%token CLASS
%token CONTINUE
%token ELSE
%token FALSE
%token FOR
%token IF
%token INT
%token RETURN
%token TRUE
%token VOID

%left OR
%left AND
%token EQ PE ME
%left EE NE
%nonassoc LE LT GE GT
%left PLUS MINUS
%left MUL DIV MOD
%precedence NOT UMINUS

%token <sval> ID
%token <ival> NUM
%token <sval> STRING
%token <cval> CHAR
%type <program> program
%type <field_decls> field_decls
%type <field_decl> field_decl
%type <identifiers> identifiers
%type <identifier_arrays> identifier_arrays
%type <identifier_array> identifier_array
%type <method_decls> method_decls
%type <method_decl> method_decl
%type <type_identifiers> type_identifiers
%type <type_identifier> type_identifier
%type <block> block
%type <statements> statements
%type <var_decls> var_decls
%type <var_decl> var_decl
%type <type> type
%type <statement> statement
%type <assign_op> assign_op
%type <method_call> method_call
%type <exprs> exprs
%type <callout_args> callout_args
%type <location> location
%type <expr> expr
%type <callout_arg> callout_arg
%type <literal> literal

%%

//grammar

program : CLASS ID OPENB field_decls method_decls CLOSEB { $$ = new ASTProgram(string($2), $4, $5); start = $$; }
				| CLASS ID OPENB field_decls CLOSEB  { $$ = new ASTProgram(string($2), $4, NULL); start = $$; }
				| CLASS ID OPENB method_decls CLOSEB { $$ = new ASTProgram(string($2), NULL, $4); start = $$; }
				| CLASS ID OPENB CLOSEB { $$ = new ASTProgram(string($2), NULL, NULL); start = $$; }
				;

field_decls : field_decl { $$ = new std::vector<ASTFieldDecl *>(); $$->push_back($1); }
								| field_decls field_decl { $1->push_back($2); $$ = $1; }
								;

field_decl : type identifiers ';' { $$ = new ASTFieldDecl($2, $1); }
					 | type identifier_arrays ';' { $$ = new ASTFieldDecl($2, $1); }
					 ;

identifiers : ID { $$ = new std::vector<ASTVarIdentifier *>(); $$->push_back(new ASTVarIdentifier(string($1))); }
								| identifiers ',' ID { $1->push_back(new ASTVarIdentifier(string($3))); $$ = $1; }
								;

identifier_arrays : identifier_array { $$ = new std::vector<ASTArrayIdentifier *>(); $$->push_back($1); }
											| identifier_arrays ',' identifier_array { $1->push_back($3); $$ = $1; }
											;

identifier_array : ID '[' NUM ']' { $$ = new ASTArrayIdentifier(string($1), $3); }
								 ;

method_decls : method_decl { $$ = new std::vector<ASTMethodDecl *>(); $$->push_back($1); }
								 | method_decls method_decl { $1->push_back($2); $$ = $1; }
								 ;

method_decl : type ID OPENC type_identifiers CLOSEC block { $$ = new ASTMethodDecl(string($2), $1, $4, $6); }
						| type ID OPENC CLOSEC block { $$ = new ASTMethodDecl(string($2), $1, NULL, $5); }
						| VOID ID OPENC type_identifiers CLOSEC block { $$ = new ASTMethodDecl(string($2), Datatype::void_type, $4, $6); }
						| VOID ID OPENC CLOSEC block { $$ = new ASTMethodDecl(string($2), Datatype::void_type, NULL, $5); }
						;

type_identifiers : type_identifier { $$ = new std::vector<ASTTypeIdentifier *>(); $$->push_back($1); }
										 | type_identifiers ',' type_identifier { $1->push_back($3); $$ = $1; }
										 ;

type_identifier : type ID { $$ = new ASTTypeIdentifier(string($2), $1); }
								;

block : OPENB var_decls statements CLOSEB { $$ = new ASTBlockStatement($3, $2); } 
			| OPENB var_decls CLOSEB { $$ = new ASTBlockStatement(NULL, $2); }
			| OPENB statements CLOSEB { $$ = new ASTBlockStatement($2, NULL); }
			| OPENB CLOSEB { $$ = new ASTBlockStatement(NULL, NULL); }
			;

statements : statement { $$ = new std::vector<ASTStatement *>(); $$->push_back($1); }
							 | statements statement { $1->push_back($2); $$ = $1; }
							 ;

var_decls : var_decl { $$ = new std::vector<ASTVarDecl *>(); $$->push_back($1); }
							| var_decls var_decl { $1->push_back($2); $$ = $1; }
							;

var_decl : type identifiers ';' { $$ = new ASTVarDecl($2, $1); }
				 ;

type : INT { $$ = Datatype::int_type; }
		 | BOOL { $$ = Datatype::bool_type; }
		 ;

statement : ';' { $$ = NULL; }
					| location assign_op expr ';' { $$ = new ASTAssignmentStatement($2, $1, $3); }
					| method_call ';' { $$ = $1; }
					| IF OPENC expr CLOSEC block ELSE block { $$ = new ASTIfStatement($3, $5, $7); }
					| IF OPENC expr CLOSEC block { $$ = new ASTIfStatement($3, $5, NULL); }
					| FOR ID EQ expr ',' expr block { $$ = new ASTForStatement($4, $6, $7, string($2)); }
					| RETURN expr ';' { $$ = new ASTReturnStatement($2); }
					| RETURN ';' { $$ = new ASTReturnStatement(NULL); }
					| BREAK ';' { $$ = new ASTBreakStatement(); }
					| CONTINUE ';' { $$ = new ASTContinueStatement(); }
					| block { $$ = $1; }
					;

assign_op : EQ { $$ = AssignOp::equal; }
					| PE { $$ = AssignOp::plus_equal; }
					| ME { $$ = AssignOp::minus_equal; }
					;

method_call : ID OPENC exprs CLOSEC { $$ = new ASTNormalMethod(string($1), $3); }
						| ID OPENC CLOSEC { $$ = new ASTNormalMethod(string($1), NULL); }
						| CALLOUT OPENC STRING ',' callout_args CLOSEC { $$ = new ASTCalloutMethod(string($3), $5); }
						| CALLOUT OPENC STRING CLOSEC { $$ = new ASTCalloutMethod(string($3), NULL); }
						;
	
exprs : expr { $$ = new std::vector<ASTExpression *>(); $$->push_back($1); }
					| exprs ',' expr { $1->push_back($3); $$ = $1; }
					;

callout_args : callout_arg { $$ = new std::vector<ASTCalloutArg *>(); $$->push_back($1); }
								 | callout_args ',' callout_arg { $1->push_back($3); $$ = $1; }
								 ;

location : ID { $$ = new ASTVarLocation(string($1)); }
				 | ID '[' expr ']' { $$ = new ASTArrayLocation(string($1), $3); }
				 ;

expr : location { $$ = $1; }
		 | method_call { $$ = $1; }
		 | literal { $$ = $1; }
		 | expr OR expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::or_op); }
		 | expr AND expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::and_op); }
		 | expr EE expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::equalequal_op); }
		 | expr NE expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::notequal_op); }
		 | expr LT expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::lessthan_op); }
		 | expr LE expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::lessequal_op); }
		 | expr GE expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::greaterequal_op); }
		 | expr GT expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::greaterthan_op); }
		 | expr PLUS expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::plus_op); }
		 | expr MINUS expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::minus_op); }
		 | expr MUL expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::multiply_op); }
		 | expr DIV expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::divide_op); }
		 | expr MOD expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::modulo_op); }
		 | NOT expr { $$ = new ASTUnaryOperationExpression($2, UnOp::not_op); }
		 | MINUS expr %prec UMINUS { $$ = new ASTUnaryOperationExpression($2, UnOp::minus_op); }
		 | OPENC expr CLOSEC { $$ = $2; }
		 ;

callout_arg : expr  { $$ = new ASTExpressionCalloutArg($1); }
						| STRING { $$ = new ASTStringCalloutArg(string($1)); }
						;

literal : NUM { $$ = new ASTIntegerLiteralExpression($1); }
				| CHAR { $$ = new ASTCharLiteralExpression($1); }
				| TRUE { $$ = new ASTTrueLiteralExpression(); }
				| FALSE { $$ = new ASTFalseLiteralExpression(); }
				;


%%

int main( int argc, char *argv[]) {
	if (argc == 2)
	{
		//outfile << "File expected as argument 2." << endl;
		//return 1;
		yyin = fopen(argv[1], "r");
	}
	outfile.open("bison_output.txt");
	outflex.open("flex_output.txt");
	//yylex();
	do 
	{
		yyparse();
	} while (!feof(yyin));

	cout << "Success" << endl;
	outflex.close();
	outfile.close();
}

void yyerror(const char *s) {
	cout << "Syntax error" << endl;
	exit(-1);
}
