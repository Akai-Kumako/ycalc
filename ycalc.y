%{
#include <stdio.h>
double var = 0;
double alph[26];
int flag = 0;
%}
/* トークンの定義 (NUM:整数) */
/*  この内容は，y.tab.h に書き出され，yylex で利用される．*/
%union{
  double num;
}
%token <num>NUM
%token LETTER CLEAR DOLLAR

/* 演算子の結合性．後に書いたものほど結合度が強い．*/
%left '+' '-'	/* 結合度 弱 */
%left '*' '/'	/* 結合度 中 */
%right UMINUS	/* 結合度 強 (単項演算子の - の結合度) */

%start	S	/* 出発記号は S */

%%

/* S → SE<LF> | S<LF> | ε ，(<LF> は改行文字) */
S:    S E '\n'	{ if(flag == 0){
                    printf("%f\n> ", $<num>2); var = $<num>2;
                  }else if(flag == 1){
                    printf("> ");
                  }else if(flag == 2){
                    printf("variable is cleared\n> ");
                  } flag = 0; }	/* 還元でEを消すとき */
    | S '\n'	{ printf("> "); }		/* 空行入力の場合    */
    | /* ε */	{ printf("> "); }		/* 実行開始時        */
;

/* E → E+E | E-E | E*E | E/E | -E | (E) | <NUM> ，(<NUM> は整数) */ 
E:    E '+' E	{ $<num>$ = $<num>1 + $<num>3; }
    | E '-' E	{ $<num>$ = $<num>1 - $<num>3; }
    | E '*' E	{ $<num>$ = $<num>1 * $<num>3; }
    | E '/' E	{ $<num>$ = $<num>1 / $<num>3; }
    | LETTER '=' E { alph[(int)$<num>1] = $<num>3; $<num>$ = alph[(int)$<num>1]; flag = 1; }
    | '-' E	%prec UMINUS	/* 結合度の強さはUMINUSと同じ．*/
		{ $<num>$ = -$<num>2; }
    | '(' E ')' { $<num>$ = $<num>2; }
    | NUM	{ $<num>$ = $<num>1; }	/* $1 の値は yylval の値 */
    | DOLLAR { $<num>$ = var; }
    | LETTER { $<num>$ = alph[(int)$<num>1]; }
    | CLEAR { for(int i = 0; i < 26; i++){
                alph[i] = 0;
              } flag = 2;
     }
;
%%
main() {
  while(!feof(stdin)){	/* error が発生しても EOF まで実行を続ける */
    yyparse();		/* yacc が生成する yyparse() を呼び出す．  */
  }
}

/* エラー処理．yyparse() の中から呼び出される．*/
yyerror(char *str) { fprintf(stderr,"%s\n", str); }
