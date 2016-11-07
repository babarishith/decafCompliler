%{
#include <cstdio>
#include <iostream>
#include <fstream>
using namespace std;

//Stuff from flex
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern "C" ofstream outflex;

ofstream outfile;
//ofstream outflex;
//int line_num=1;
//int flag = 0;

void yyerror(const char *s);
%}

%union {
	int ival;
	float fval;
	char *sval;}

%token <ival> NUMBER
%token <sval> ID ADDOP MULOP RELOP UNARYOP
%token INT VOID IF ELSE NEW NUL READ PRINT THIS WHILE RETURN CLASS
%token OPENB CLOSEB OPENC CLOSEC
%left RELOP
%left ADDOP
%left MULOP
%left UNARYOP
%%

//grammar

program : CLASS IDENTIFIER OPEN_CURLYBRACE field_decls method_decls CLOSE_CURLYBRACE { $$ = new ASTProgram(std::string($2), $4, $5); start = $$; }
				| CLASS IDENTIFIER OPEN_CURLYBRACE field_decls CLOSE_CURLYBRACE  { $$ = new ASTProgram(std::string($2), $4, NULL); start = $$; }
				| CLASS IDENTIFIER OPEN_CURLYBRACE method_decls CLOSE_CURLYBRACE { $$ = new ASTProgram(std::string($2), NULL, $4); start = $$; }
				| CLASS IDENTIFIER OPEN_CURLYBRACE CLOSE_CURLYBRACE { $$ = new ASTProgram(std::string($2), NULL, NULL); start = $$; }
				;

field_decls : field_decl { $$ = new std::vector<ASTFieldDecl *>(); $$->push_back($1); }
								| field_decls field_decl { $1->push_back($2); $$ = $1; }
								;

field_decl : type identifier_list SEMICOLON { $$ = new ASTFieldDecl($2, $1); }
					 | type identifier_array_list SEMICOLON { $$ = new ASTFieldDecl($2, $1); }
					 ;

identifier_list : IDENTIFIER { $$ = new std::vector<ASTVarIdentifier *>(); $$->push_back(new ASTVarIdentifier(std::string($1))); }
								| identifier_list COMMA IDENTIFIER { $1->push_back(new ASTVarIdentifier(std::string($3))); $$ = $1; }
								;

identifier_array_list : identifier_array { $$ = new std::vector<ASTArrayIdentifier *>(); $$->push_back($1); }
											| identifier_array_list COMMA identifier_array { $1->push_back($3); $$ = $1; }
											;

identifier_array : IDENTIFIER OPEN_SQUAREBRACKET INT_VALUE CLOSE_SQUAREBRACKET { $$ = new ASTArrayIdentifier(std::string($1), $3); }
								 ;

method_decls : method_decl { $$ = new std::vector<ASTMethodDecl *>(); $$->push_back($1); }
								 | method_decls method_decl { $1->push_back($2); $$ = $1; }
								 ;

method_decl : type IDENTIFIER OPEN_PARANTHESIS type_identifier_list CLOSE_PARANTHESIS block { $$ = new ASTMethodDecl(std::string($2), $1, $4, $6); }
						| type IDENTIFIER OPEN_PARANTHESIS CLOSE_PARANTHESIS block { $$ = new ASTMethodDecl(std::string($2), $1, NULL, $5); }
						| VOID IDENTIFIER OPEN_PARANTHESIS type_identifier_list CLOSE_PARANTHESIS block { $$ = new ASTMethodDecl(std::string($2), Datatype::void_type, $4, $6); }
						| VOID IDENTIFIER OPEN_PARANTHESIS CLOSE_PARANTHESIS block { $$ = new ASTMethodDecl(std::string($2), Datatype::void_type, NULL, $5); }
						;

type_identifier_list : type_identifier { $$ = new std::vector<ASTTypeIdentifier *>(); $$->push_back($1); }
										 | type_identifier_list COMMA type_identifier { $1->push_back($3); $$ = $1; }
										 ;

type_identifier : type IDENTIFIER { $$ = new ASTTypeIdentifier(std::string($2), $1); }
								;

block : OPEN_CURLYBRACE var_decl_list statement_list CLOSE_CURLYBRACE { $$ = new ASTBlockStatement($3, $2); } 
			| OPEN_CURLYBRACE var_decl_list CLOSE_CURLYBRACE { $$ = new ASTBlockStatement(NULL, $2); }
			| OPEN_CURLYBRACE statement_list CLOSE_CURLYBRACE { $$ = new ASTBlockStatement($2, NULL); }
			| OPEN_CURLYBRACE CLOSE_CURLYBRACE { $$ = new ASTBlockStatement(NULL, NULL); }
			;

statement_list : statement { $$ = new std::vector<ASTStatement *>(); $$->push_back($1); }
							 | statement_list statement { $1->push_back($2); $$ = $1; }
							 ;

var_decl_list : var_decl { $$ = new std::vector<ASTVarDecl *>(); $$->push_back($1); }
							| var_decl_list var_decl { $1->push_back($2); $$ = $1; }
							;

var_decl : type identifier_list SEMICOLON { $$ = new ASTVarDecl($2, $1); }
				 ;

type : INT { $$ = Datatype::int_type; }
		 | BOOLEAN { $$ = Datatype::bool_type; }
		 ;

statement : SEMICOLON { $$ = NULL; }
					| location assign_op expr SEMICOLON { $$ = new ASTAssignmentStatement($2, $1, $3); }
					| method_call SEMICOLON { $$ = $1; }
					| IF OPEN_PARANTHESIS expr CLOSE_PARANTHESIS block ELSE block { $$ = new ASTIfStatement($3, $5, $7); }
					| IF OPEN_PARANTHESIS expr CLOSE_PARANTHESIS block { $$ = new ASTIfStatement($3, $5, NULL); }
					| FOR IDENTIFIER EQUAL expr COMMA expr block { $$ = new ASTForStatement($4, $6, $7, std::string($2)); }
					| RETURN expr SEMICOLON { $$ = new ASTReturnStatement($2); }
					| RETURN SEMICOLON { $$ = new ASTReturnStatement(NULL); }
					| BREAK SEMICOLON { $$ = new ASTBreakStatement(); }
					| CONTINUE SEMICOLON { $$ = new ASTContinueStatement(); }
					| block { $$ = $1; }
					;

assign_op : EQUAL { $$ = AssignOp::equal; }
					| PLUSEQUAL { $$ = AssignOp::plus_equal; }
					| MINUSEQUAL { $$ = AssignOp::minus_equal; }
					;

method_call : IDENTIFIER OPEN_PARANTHESIS expr_list CLOSE_PARANTHESIS { $$ = new ASTNormalMethod(std::string($1), $3); }
						| IDENTIFIER OPEN_PARANTHESIS CLOSE_PARANTHESIS { $$ = new ASTNormalMethod(std::string($1), NULL); }
						| CALLOUT OPEN_PARANTHESIS STRING_VALUE COMMA callout_arg_list CLOSE_PARANTHESIS { $$ = new ASTCalloutMethod(std::string($3), $5); }
						| CALLOUT OPEN_PARANTHESIS STRING_VALUE CLOSE_PARANTHESIS { $$ = new ASTCalloutMethod(std::string($3), NULL); }
						;
	
expr_list : expr { $$ = new std::vector<ASTExpression *>(); $$->push_back($1); }
					| expr_list COMMA expr { $1->push_back($3); $$ = $1; }
					;

callout_arg_list : callout_arg { $$ = new std::vector<ASTCalloutArg *>(); $$->push_back($1); }
								 | callout_arg_list COMMA callout_arg { $1->push_back($3); $$ = $1; }
								 ;

location : IDENTIFIER { $$ = new ASTVarLocation(std::string($1)); }
				 | IDENTIFIER OPEN_SQUAREBRACKET expr CLOSE_SQUAREBRACKET { $$ = new ASTArrayLocation(std::string($1), $3); }
				 ;

expr : location { $$ = $1; }
		 | method_call { $$ = $1; }
		 | literal { $$ = $1; }
		 | expr OR expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::or_op); }
		 | expr AND expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::and_op); }
		 | expr EQUALEQUAL expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::equalequal_op); }
		 | expr NOTEQUAL expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::notequal_op); }
		 | expr LESSTHAN expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::lessthan_op); }
		 | expr LESSEQUAL expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::lessequal_op); }
		 | expr GREATEREQUAL expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::greaterequal_op); }
		 | expr GREATERTHAN expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::greaterthan_op); }
		 | expr PLUS expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::plus_op); }
		 | expr MINUS expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::minus_op); }
		 | expr MULTIPLY expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::multiply_op); }
		 | expr DIVIDE expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::divide_op); }
		 | expr MODULO expr { $$ = new ASTBinaryOperationExpression($1, $3, BinOp::modulo_op); }
		 | NOT expr { $$ = new ASTUnaryOperationExpression($2, UnOp::not_op); }
		 | MINUS expr %prec UMINUS { $$ = new ASTUnaryOperationExpression($2, UnOp::minus_op); }
		 | OPEN_PARANTHESIS expr CLOSE_PARANTHESIS { $$ = $2; }
		 ;

callout_arg : expr  { $$ = new ASTExpressionCalloutArg($1); }
						| STRING_VALUE { $$ = new ASTStringCalloutArg(std::string($1)); }
						;

literal : INT_VALUE { $$ = new ASTIntegerLiteralExpression($1); }
				| CHAR_VALUE { $$ = new ASTCharLiteralExpression($1); }
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
