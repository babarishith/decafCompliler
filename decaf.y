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

%token <ival> NUMBER
%token <sval> ID ADDOP MULOP RELOP
%token INT VOID IF ELSE NEW NUL READ PRINT THIS WHILE RETURN CLASS
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
		OPENB CLOSEB
		| OPENB Var_Declarations CLOSEB
		| OPENB Method_Declarations CLOSEB
		| OPENB Var_Declarations Method_Declarations CLOSEB
		;

Var_Declarations:
		Var_Declarations Var_Declaration
		| Var_Declaration
		;

Method_Declarations:
		Method_Declarations Method_Declaration
		| Method_Declaration
		;

Var_Declaration:
		Type ID ';'
		;

Type:
		Simple_Type
		| Simple_Type '[' ']'
		;

Simple_Type:
		INT
		| ID
		;

Method_Declaration:
		Result_Type ID OPENC Parameter_List CLOSEC Method_Body
		;

Result_Type:
		Type
		| VOID
		;

Parameter_List:
		/* empty */
		| Parameter_List ',' Parameter
		| Parameter
		;

Parameter:
		Type ID
		;

Local_Var_Declarations:
		Local_Var_Declarations Local_Var_Declaration
		| Local_Var_Declaration
		;

Simple_Statements:
		Simple_Statements Simple_Statement
		| Simple_Statement
		;

Method_Body:
		OPENB CLOSEB
		| OPENB Local_Var_Declarations CLOSEB
		| OPENB Simple_Statements CLOSEB
		| OPENB Local_Var_Declarations Simple_Statements CLOSEB
		;

Local_Var_Declaration:
		Type ID ';'
		;

Statement:
		Simple_Statement
		| OPENB Simple_Statements CLOSEB
		;

Simple_Statement:
		';'
		| Name '=' Expression ';'
		| Name OPENC Arg_List CLOSEC ';'
		| PRINT OPENC Arg_List CLOSEC ';'
		| Conditional_Statement
		| WHILE OPENC Expression CLOSEC Statement
		| RETURN Optional_Expression ';'
		;

Name:
		Variable_Access
		| Variable_Access'.'Field_Access
		;

Variable_Access:
		THIS
		| ID
		| ID '[' Expression ']'
		;

Field_Access:
		ID
		| ID '[' Expression ']'
		;

Arg_List:
		/* empty */
		| Arg_List ',' Expression
		| Expression
		;

Conditional_Statement:
		IF OPENC Expression CLOSEC Statement
		| IF OPENC Expression CLOSEC Statement ELSE Statement
		;

Optional_Expression:
		/* empty */
		| Expression
		;

Expression:
		Name
		| NUMBER
		| NUL
		| Name OPENC Arg_List CLOSEC
		| READ OPENC CLOSEC
		| New_Expression
		| ADDOP Expression
		| Expression RELOP Expression
		| Expression ADDOP Expression
		| Expression MULOP Expression
		| OPENC Expression CLOSEC
		;

New_Expression:
		NEW ID OPENC CLOSEC
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
