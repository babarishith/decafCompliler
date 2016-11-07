%{
#include <iostream>
#include <fstream>
#include "decaf.tab.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
//extern "C" ofstream *outflex;
ofstream outflex;
int line_num=1;
int flag = 0;
%}

letter		[a-zA-Z]
digit		[0-9]
alpha		letter | digit | _
id			letter alpha*
number		digit+

%%
[ \t]				;
\n 					{ ++line_num; }
"//".*				;
"/*"([^*]|\*+[^*/])*\*+"/" 				; 
";"					{return ';'; }
","					{return ','; }
"."					{return '.'; }
[0-9]+				{ yylval.ival = atoi(yytext); outflex << "INT:" << yytext << endl ; return NUMBER; }
class				{ yylval.sval = strdup(yytext); outflex << "CLASS" << endl ; return CLASS; }
int					{ yylval.sval = strdup(yytext);outflex << "INT_DECLARATOIN" << endl ; return INT; }
void				{ yylval.sval = strdup(yytext); outflex << "VOID_DECLARATOIN"  << endl ; return VOID; }
id					{ yylval.sval = strdup(yytext); outflex << "ID:" << yytext << endl ; return ID; }
if					{ yylval.sval = strdup(yytext); outflex << "IF" << endl; return IF; }
else				{ yylval.sval = strdup(yytext);	outflex << "ELSE" << endl; return ELSE; }
new					{ yylval.sval = strdup(yytext); outflex << "NEW" << endl; return NEW; }
null				{ yylval.sval = strdup(yytext); outflex << "NULL" << endl;return NUL; }
print				{ yylval.sval = strdup(yytext); outflex << "PRINT" << endl; return PRINT; }
read				{ yylval.sval = strdup(yytext); outflex << "READ" << endl; return READ; }
return				{ yylval.sval = strdup(yytext); outflex << "RETURN" << endl; return RETURN; }
this				{ yylval.sval = strdup(yytext); outflex << "THIS" << endl; return THIS; }
while				{ yylval.sval = strdup(yytext); outflex << "WHILE" << endl; return WHILE; }
[a-zA-Z]+[a-zA-Z0-9\_]*		{ yylval.sval = strdup(yytext); outflex << "STRING:" << yytext << endl ;return ID; }
=					{ outflex << "ASSIGNMENT" << endl;return '='; }
"["|"]"				{ return yytext[0];}
"+"|"-"|"||"				{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return ADDOP; }
"+"|"-"|"!"				{ yylval.sval = strdup(yytext);outflex << "UNARY_OP:" << yytext << endl; return UNARYOP; }
"*"|"/"|"%"|"&&"			{ yylval.sval = strdup(yytext);outflex << "MUL_OP:" << yytext << endl; return MULOP; }
==|<|>|<=|>=|!=		{ yylval.sval = strdup(yytext);outflex << "RELATIONAL_OP:" << yytext << endl; return RELOP; }
"{" 					{outflex << "OPENB" << endl; return OPENB ;}
"}" 					{ outflex << "CLOSEB" << endl;return CLOSEB ;}
"(" 					{ outflex << "OPENC" << endl; return OPENC ;}
")" 					{ outflex << "CLOSEC" << endl; return CLOSEC ;}
%%	
