a.out: lex.yy.c Assignment2.tab.c Assignment2.tab.h
	g++ Assignment2.tab.c lex.yy.c -lfl 

Assignment2.tab.c Assignment2.tab.h: Assignment2.y
	bison -d Assignment2.y

lex.yy.c: Assignment2.l Assignment2.tab.h
	flex Assignment2.l


