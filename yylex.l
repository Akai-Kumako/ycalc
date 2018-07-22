%{
#include "y.tab.h"	/* この中で NUM が定義されている．	*/
#include <stdio.h>
#include <stdlib.h>

//extern int yylval;	/* ycalc.y (y.tab.c) で定義される変数．	*/
			/* トークンの「値」を代入して，呼出し側	*/
			/* (ycalc.y (y.tab.c)) に引き渡す．	*/
int c;
%}

%option noyywrap
DIGIT	[0-9]

%%
[ \t\r]+	{ /* 空白文字では何もしない．return が無いので	*/
		  /* 次のトークンを切り出しに行く．結果として	*/
		  /* 空白文字は読み飛ばされることになる．	*/
		}
({DIGIT}+("."{DIGIT}*)?)|("."{DIGIT}+)		{
		  sscanf(yytext, "%lf", &(yylval.num)); return NUM;
}
[$] { /* 最後の計算結果を使えるようにする（戻り値: DOLLAR). */
      return DOLLAR;
    }
[a-z]     { /* 大文字英字1文字の変数を使えるように. */
      c = yytext[0];
      yylval.num = c - 'a';
      return(LETTER);
    }
[^a-z0-9¥b]     { /* 大文字英字1文字の変数を使えるように. */
      c = yytext[0];
      return(c);
    }
[-+*/()\n]	{ /* 演算子と括弧と改行文字は，1文字ずつ，	*/
		  /* その文字コードそのものを戻り値とする．	*/
		  return yytext[0];
		}
clear {
      return CLEAR;
    }
.		{ /* その他の文字はエラーとして読み飛ばす．	*/
		  fprintf(stderr, "'%s' is ignored.\n", yytext);
		}
%%
