%{
#include "y.tab.h"	/* この中で NUM が定義されている．	*/

extern int yylval;	/* ycalc.y (y.tab.c) で定義される変数．	*/
			/* トークンの「値」を代入して，呼出し側	*/
			/* (ycalc.y (y.tab.c)) に引き渡す．	*/
%}

%option noyywrap

%%
[ \t\r]+	{ /* 空白文字では何もしない．return が無いので	*/
		  /* 次のトークンを切り出しに行く．結果として	*/
		  /* 空白文字は読み飛ばされることになる．	*/
		}
[0-9]+		{ /* 整数を表わすトークン (戻り値: NUM)．	*/
		  /* その値を yylval に代入して呼出し側に渡す．	*/
		  sscanf(yytext, "%d", &yylval); return NUM;
		}
[$] { /* 最後の計算結果を使えるようにする（戻り値: DOLLAR). */
      return DOLLAR;
    }
[-+*/()\n]	{ /* 演算子と括弧と改行文字は，1文字ずつ，	*/
		  /* その文字コードそのものを戻り値とする．	*/
		  return yytext[0];
		}
.		{ /* その他の文字はエラーとして読み飛ばす．	*/
		  fprintf(stderr, "'%s' is ignored.\n", yytext);
		}
%%
