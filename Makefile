ycalc: y.tab.c lex.yy.c
	cc y.tab.c lex.yy.c -o $@
y.tab.c: ycalc.y
	yacc -d $<
lex.yy.c: yylex.l y.tab.h
	flex $<
clean:
	/bin/rm -f *~
distclean: clean
	/bin/rm -f y.tab.? lex.yy.c ycalc
