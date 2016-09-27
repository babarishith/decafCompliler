%{
#include <iostream>
#include "decaf.tab.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
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
"int"" "*"main()"		{ return START; }
[0-9]+				{ yylval.ival = atoi(yytext); return NUMBER; }
class				{ yylval.sval = strdup(yytext); return CLASS; }
int					{ yylval.sval = strdup(yytext); return INT; }
void				{ yylval.sval = strdup(yytext); return VOID; }
id					{ yylval.sval = strdup(yytext); return ID; }
if					{ yylval.sval = strdup(yytext); return IF; }
else				{ yylval.sval = strdup(yytext); return ELSE; }
new					{ yylval.sval = strdup(yytext); return NEW; }
null				{ yylval.sval = strdup(yytext); return NULL; }
print				{ yylval.sval = strdup(yytext); return PRINT; }
read				{ yylval.sval = strdup(yytext); return READ; }
return				{ yylval.sval = strdup(yytext); return RETURN; }
this				{ yylval.sval = strdup(yytext); return THIS; }
while				{ yylval.sval = strdup(yytext); return WHILE; }
[a-zA-Z]+[a-zA-Z0-9\_]*		{ yylval.sval = strdup(yytext); return ID; }
=					{ return '='; }
"["|"]"				{ return yytext[0];}
"+"|"-"|"!"|"||"				{ yylval.sval = strdup(yytext); return ADDOP; }
"*"|"/"|"%"|"&&"			{ yylval.sval = strdup(yytext); return RELOP; }
"{" 					{ return OPENB ;}
"}" 					{ return CLOSEB ;}
"(" 					{ return OPENC ;}
")" 					{ return CLOSEC ;}
%%
