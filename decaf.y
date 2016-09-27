%{
#include <cstdio>
#include <iostream>
#include <fstream>
using namespace std;

//Stuff from flex
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

ofstream outfile;
//int line_num=1;
//int flag = 0;

void yyerror(const char *s);
%}

%union {
	int ival;
	float fval;
	char *sval;}

%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING ID TYPE BOOL ADDOP MULOP
%token START 
%token OPENB CLOSEB OPENC CLOSEC
%%

//grammar

Program:
		Program Class_Declaration
		| Class_Declaration
		;

Class_Declaration:
		CLASS ID Class_Body
		;

Class_Body:
		'{' '}'
		| '{' Var_Declaration '}'
		| '{' Method_Declaration '}'
		| '{' Var_Declaration Method_Declaration '}'
		;

Var_Declaration:
		Type ID ';'
		;

Type:
		Simple_Type
		| Siple_Type '[' ']'
		;

Simple_Type:
		INT
		;

Method_Declaration:
		Result_Type ID '{' Parameter_List '}'
		| Method_Body
		;

Result_Type:
		Type
		| VOID
		;

Parameter_List:
		epsilon
		| Parameter_List ',' Parameter
		| Parameter
		;

Parameter:
		Type ID
		;

Method_Body:
		'{' '}'
		| '{' Local_Var_Declaration '}'
		| '{' Simple_Statement '}'
		| '{' Local_Var_Declaration Simple_Satement '}'
		;

Local_Var_Declaration:
		Type ID ';'
		;

Statement:
		Simple_Statement
		| '{' Statement Simple_Statement '}'
		;

Simple_Staement:
		';'
		| Name = Expression ';'
		| Name '(' Arg_List ')' ';'
		| PRINT '(' Arg_List ')' ';'
		| Conditional_Statement
		| WHILE '(' Expression ')' Statement
		| RETURN Optional_Expression ';'
		;

Name:
		Variable_Access
		| Variable_Acess'.'Field_Access
		;

Variable_Acess:
		THIS
		| ID
		| ID '[' Expression ']'
		;

Field_Access:
		ID
		| ID '[' Expression ']'
		;

Arg_List:
		epsilon
		| Arg_List ',' Expression
		| Expression
		;

Conditional_Statement:
		IF '(' Expression ')' Statement
		| IF '(' Expressoin ')' Statement ELSE Satement
		;

Optional_Expression:
		epsilon
		| Expression
		;

Expression:
		Name
		| NUMBER
		| NULL
		| Name '(' Arg_List ')'
		| READ '(' ')'
		| New_Expression
		| ADDOP Expression
		| Expression RELOP Expression
		| Expression Sum_Op Expression
		| Expression MULOP Expression
		| '(' Expression ')'
		;

New_Expression:
		NEW ID '(' ')'
		| NEW INT '[' Expression ']'
		| NEW ID '[' Expression ']'
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
	//yylex();
	do 
	{
		yyparse();
	} while (!feof(yyin));

	cout << "Success" << endl;
	outfile.close();
}

void yyerror(const char *s) {
	cout << "Syntax error" << endl;
	exit(-1);
}
