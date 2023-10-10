%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include"SymbolTable.h"
#ifndef YYSTYPE
#define YYSTYPE struct yType
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
struct SymbolTable st;
%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS
%token MULT DIV
%token LPAREN RPAREN
%token ASSIGN
%token UMINUS
%token NUMBER
%token ID
%left ADD MINUS
%left MULT DIV
%right UMINUS         

%%


lines   :       lines expr ';'              { printf("%f\n", $2.d); }
        |       lines ';'
        |       lines ID ASSIGN expr ';'    { insertSymbol(&st,$2.s,$4.d); free($2.s); $2.s=NULL; }       
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr               { $$.d=$1.d+$3.d; }
        |       expr MINUS expr             { $$.d=$1.d-$3.d; }
        |       expr MULT expr              { $$.d=$1.d*$3.d; }
        |       expr DIV expr               { $$.d=$1.d/$3.d; }
        |       LPAREN expr RPAREN          { $$.d=$2.d; }
        |       MINUS expr %prec UMINUS     { $$.d=-$2.d; }
        |       VALUE                       { $$.d=$1.d; }
        ;

VALUE   :       NUMBER                      { $$.d=$1.d; }
        |       ID                          { $$.d=lookupSymbol(&st,$1.s); free($1.s); $1.s=NULL; }
        ;
%%

// programs section

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
        }else if(isdigit(t)){
            //TODO:解析多位数字返回数字类型 
            yylval.d = t-'0';
            while(isdigit(t=getchar())){
                yylval.d = yylval.d*10+t-'0';
            }
            ungetc(t,yyin);
            return NUMBER;
        }else if(t=='+'){
            return ADD;
        }else if(t=='-'){
            return MINUS;
        }//TODO:识别其他符号
         else if(t=='*'){
            return MULT;
        }else if(t=='/'){
            return DIV;
        }else if(t=='('){
            return LPAREN;
        }else if(t==')'){
            return RPAREN;
        }else if(t=='='){
            return ASSIGN;
        }else if(t==';'){
            return t;
        }
        else{
            char* buffer = (char*)malloc(sizeof(char)*2);
            buffer[0] = t;
            buffer[1] = '\0';
            yylval.s = buffer;
            return ID;
        }
    }
}

int main(void)
{
    yyin=stdin;
    initSymbolTable(&st, 4);
    do{
        yyparse();
    }while(!feof(yyin));
    destroySymbolTable(&st);
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    destroySymbolTable(&st);
    exit(1);
}