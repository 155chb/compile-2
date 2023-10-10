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
#ifndef YYSTYPE
#define YYSTYPE int
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS
%token MULT DIV
%token LPAREN RPAREN
%token UMINUS
%token NUMBER
%left ADD MINUS
%left MULT DIV
%right UMINUS         

%%


lines   :       lines expr ';' { printf("mov      pc, lr\n"); }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr               { printf("str     r0, [sp, #4]!\nadd     r0, r1, r0\nldr     r1, [sp], -4\n"); }
        |       expr MINUS expr             { printf("str     r0, [sp, #4]!\nsub     r0, r1, r0\nldr     r1, [sp], -4\n"); }
        |       expr MULT expr              { printf("str     r0, [sp, #4]!\nmul     r0, r1, r0\nldr     r1, [sp], -4\n"); }
        |       expr DIV expr               { printf("str     r0, [sp, #4]!\ndiv     r0, r1, r0\nldr     r1, [sp], -4\n"); }
        |       LPAREN expr RPAREN          
        |       MINUS expr %prec UMINUS     { printf("str     r0, [sp, #4]!\nsub     r0, #0, r0\nldr     r0, [sp], -4\n"); }
        |       NUMBER                      { printf("mov     r1, r0\nmov     r0, #%d\n", $1); }
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
            yylval = t-'0';
            while(isdigit(t=getchar())){
                yylval = yylval*10+t-'0';
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
        }
        else{
            return t;
        }
    }
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}

void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}