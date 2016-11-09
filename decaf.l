%{
#include <iostream>
#include <fstream>
#include "ast.h"
#include "visitor.h"
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
NUM		digit+
hex			[0-9a-fA-F]
char ([\40-\176]{-}['"\\])|\\n|\\t|\\\\|\\\"|\\\'

%%
[ \t]				;
\n 					{ ++line_num; }
"//".*				;
"/*"([^*]|\*+[^*/])*\*+"/" 				; 
";"					{return ';'; }
","					{return ','; }
"."					{return '.'; }
[0-9]+				{ yylval.ival = atoi(yytext); outflex << "INT:" << yytext << endl ; return NUM; }
0x{hex}+			{ yylval.ival = atoi(yytext); outflex << "INT:" << yytext << endl ; return NUM; }
class				{ yylval.sval = strdup(yytext); outflex << "CLASS" << endl ; return CLASS; }
"\"{char}*\""		{ yylval.sval = strdup(yytext); outflex << "CLASS" << endl ; return STRING; } 
"\'{char}\'"		{ yylval.cval = yytext[1]; outflex << "CLASS" << endl ; return CHAR; } 
int					{ yylval.sval = strdup(yytext);outflex << "INT_DECLARATOIN" << endl ; return INT; }
void				{ yylval.sval = strdup(yytext); outflex << "VOID_DECLARATOIN"  << endl ; return VOID; }
boolean				{ yylval.sval = strdup(yytext); outflex << "VOID_DECLARATOIN"  << endl ; return BOOL; }
break				{ yylval.sval = strdup(yytext); outflex << "VOID_DECLARATOIN"  << endl ; return BREAK; }
continue			{ yylval.sval = strdup(yytext); outflex << "VOID_DECLARATOIN"  << endl ; return CONTINUE; }
callout				{ yylval.sval = strdup(yytext); outflex << "VOID_DECLARATOIN"  << endl ; return CALLOUT; }
id					{ yylval.sval = strdup(yytext); outflex << "ID:" << yytext << endl ; return ID; }
if					{ yylval.sval = strdup(yytext); outflex << "IF" << endl; return IF; }
else				{ yylval.sval = strdup(yytext);	outflex << "ELSE" << endl; return ELSE; }
false				{ yylval.sval = strdup(yytext); outflex << "VOID_DECLARATOIN"  << endl ; return FALSE; }
true				{ yylval.sval = strdup(yytext); outflex << "VOID_DECLARATOIN"  << endl ; return TRUE; }
for					{ yylval.sval = strdup(yytext); outflex << "VOID_DECLARATOIN"  << endl ; return FOR; }
return				{ yylval.sval = strdup(yytext); outflex << "RETURN" << endl; return RETURN; }
[a-zA-Z]+[a-zA-Z0-9\_]*		{ yylval.sval = strdup(yytext); outflex << "STRING:" << yytext << endl ;return ID; }
=					{ yylval.sval = strdup(yytext); outflex << "ASSIGNMENT" << endl;return EQ; }
-=					{ yylval.sval = strdup(yytext); outflex << "ASSIGNMENT" << endl;return ME; }
"+="				{ yylval.sval = strdup(yytext); outflex << "ASSIGNMENT" << endl;return PE; }
"["|"]"				{ return yytext[0];}
"+"					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return PLUS; }
"-"					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return MINUS; }
"*"					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return MUL; }
"/"					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return DIV; }
"!"					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return NOT; }
"!="					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return NE; }
"<="					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return LE; }
"<"					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return LT; }
">"					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return GT; }
">="					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return GE; }
"=="					{ yylval.sval = strdup(yytext);outflex << "SUM_OP:" << yytext << endl; return EE; }
"{" 					{outflex << "OPENB" << endl; return OPENB ;}
"}" 					{ outflex << "CLOSEB" << endl;return CLOSEB ;}
"(" 					{ outflex << "OPENC" << endl; return OPENC ;}
")" 					{ outflex << "CLOSEC" << endl; return CLOSEC ;}
%%	
