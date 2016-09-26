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
		START OPENB Declarations Statements CLOSEB { outfile << "Program encountered" << endl;}
		;

Declarations:
		Declarations Declaration 
		| Declaration
		;

Declaration:
		TYPE ID ';' { outfile << $1 << " declaration encountered" << endl << "Id=" << $2 << endl;}
		| TYPE ID '[' INT ']' ';' { outfile << $1 << " declaration encountered" << endl << "Id=" << $2 << endl << "Size=" << $4 << endl;}
		;

Statements:
		Statements Statement
		| Statement
		;

Statement:
		';'
		| Assignment
		;

Assignment:
		ID '=' Expression ';' { outfile << "Assignment operation encountered" << endl;}
		| ID '[' Expression ']' '=' Expression ';' { outfile << "Assignment operation encountered" << endl;}
		;

Expression:
		Expression ADDOP Term { 
			char c = *$2;
			switch(c) {
				case '+':
					outfile << "Addition expression encountered" << endl;
					break;
					
				case '-':
					outfile << "Subtraction expression encountered" << endl;
					break;
			}
		}
		| Term
		;

Term:
		Term MULOP Factor {
			char c = *$2;
			switch(c) {
				case '*':
					outfile << "Multiplication expression encountered" << endl;
					break;
					
				case '/':
					outfile << "Division expression encountered" << endl;
					break;
					
				case '%':
					outfile << "Modulus expression enoutfileered" << endl;
					break;
			}
		}
		| Factor
		;

Factor:
		ID
		| ID '[' Expression ']'
		| Literal
		| OPENC Expression CLOSEC
		;

Literal:
		INT {outfile << "Integer literal encountered" << endl << "Value=" << $1 << endl;}
		| BOOL {outfile << "Boolean literal encountered" << endl << "Value=" << $1 << endl;}
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
