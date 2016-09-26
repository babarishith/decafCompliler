%{
#include <iostream>
#include "Assignment2.tab.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
int line_num=1;
int flag = 0;
%}
%%
[ \t]				;
\n 					{ ++line_num; }
"//".*				;
"/*"([^*]|\*+[^*/])*\*+"/" 				; 
";"					{return ';'; }
"int"" "*"main()"		{ return START; }
[0-9]+[a-zA-Z]+.*	{cout << "Syntax Error on line " << line_num << endl; flag =1; }
[0-9]+\..*[a-zA-Z]+.*	{cout << "Syntax Error on line " << line_num << endl; flag =1; }
[0-9]+\.[0-9]+\..*	{cout << "Syntax Error on line " << line_num << endl; flag = 1;}
[0-9]+\.[0-9]+		{ yylval.fval = atof(yytext); return FLOAT; }
[0-9]+				{ yylval.ival = atoi(yytext); return INT; }
true|false			{ yylval.sval = strdup(yytext); return BOOL; }
int|float			{ yytext[0] -= 32 ;yylval.sval = strdup(yytext); return TYPE; }
bool 				{ yylval.sval = strdup("Boolean"); return TYPE; }
if|else|while|for|int|float { cout  << "Keyword" << endl << yytext << endl; }
[a-zA-Z]+[a-zA-Z0-9\_]*		{ yylval.sval = strdup(yytext); return ID; }
=					{ return '='; }
"["|"]"				{ return yytext[0];}
"+"|"-"				{ yylval.sval = strdup(yytext); return ADDOP; }
"*"|"/"|"%"				{ yylval.sval = strdup(yytext); return MULOP; }
==|<|>|<=|>=		{ cout  << "Comparison" << endl << yytext << endl; }
"{" 					{ return OPENB ;}
"}" 					{ return CLOSEB ;}
"(" 					{ return OPENC ;}
")" 					{ return CLOSEB ;}
%%
