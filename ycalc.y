%{
#include <stdio.h>
int var = 0;
int alph[26];
%}

/* トークンの定義 (NUM:整数) */
/*  この内容は，y.tab.h に書き出され，yylex で利用される．*/
%token NUM LETTER DOLLAR

/* 演算子の結合性．後に書いたものほど結合度が強い．*/
%left '+' '-'	/* 結合度 弱 */
%left '*' '/'	/* 結合度 中 */
%right UMINUS	/* 結合度 強 (単項演算子の - の結合度) */

%start	S	/* 出発記号は S */

%%

/* S → SE<LF> | S<LF> | ε ，(<LF> は改行文字) */
S:    S E '\n'	{ printf("%d\n> ", $2); var = $2; }	/* 還元でEを消すとき */
    | S '\n'	{ printf("> "); }		/* 空行入力の場合    */
    | /* ε */	{ printf("> "); }		/* 実行開始時        */
;

/* E → E+E | E-E | E*E | E/E | -E | (E) | <NUM> ，(<NUM> は整数) */ 
E:    E '+' E	{ $$ = $1 + $3; }
    | E '-' E	{ $$ = $1 - $3; }
    | E '*' E	{ $$ = $1 * $3; }
    | E '/' E	{ $$ = $1 / $3; }
    | LETTER '=' E { alph[$1] = $3; $$ = alph[$1]; }
    | '-' E	%prec UMINUS	/* 結合度の強さはUMINUSと同じ．*/
		{ $$ = -$2; }
    | '(' E ')' { $$ = $2; }
    | NUM	{ $$ = $1; }	/* $1 の値は yylval の値 */
    | DOLLAR { $$ = var; }
    | LETTER { $$ = alph[$1]; }
;
%%
main() {
  while(!feof(stdin)){	/* error が発生しても EOF まで実行を続ける */
    yyparse();		/* yacc が生成する yyparse() を呼び出す．  */
  }
}

/* エラー処理．yyparse() の中から呼び出される．*/
yyerror(char *str) { fprintf(stderr,"%s\n", str); }
