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
#include<string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
char* strcatall(const char* str1,const char* str2,const char* str3);
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


lines   :       lines expr ';' { printf("%s\n", $2); free($2); $2=NULL; }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr               { $$=strcatall("+",$1,$3); free($1); free($3); $1=$3=NULL; }
        |       expr MINUS expr             { $$=strcatall("-",$1,$3); free($1); free($3); $1=$3=NULL; }
        |       expr MULT expr              { $$=strcatall("*",$1,$3); free($1); free($3); $1=$3=NULL; }
        |       expr DIV expr               { $$=strcatall("/",$1,$3); free($1); free($3); $1=$3=NULL; }
        |       LPAREN expr RPAREN          { $$=$2; $2=NULL; }
        |       MINUS expr %prec UMINUS     { $$=strcatall("-",$2,""); free($2); $2=NULL; }
        |       NUMBER                      { $$=$1; $1=NULL; }
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
            char buffer[100];
            int i=0;
            buffer[i++]=(char)t;
            while(isdigit(t=getchar())){
                buffer[i++]=(char)t;
            }
            ungetc(t,yyin);
            yylval = (char*)malloc((i+1)*sizeof(char));
            memcpy(yylval,buffer,i);
            yylval[i]='\0';
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

char* strcatall(const char* str1,const char* str2,const char* str3)
{
    int len = strlen(str1)+strlen(str2)+strlen(str3);
    char* str = (char*)malloc((len+3)*sizeof(char));
    memset(str,'\0',len+3);
    strcat(str,str1);
    strcat(str," ");
    strcat(str,str2);
    strcat(str," ");
    strcat(str,str3);
    return str;
}
