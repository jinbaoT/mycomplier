%option noyywrap
%{
#include "./common.h"  //nounput
#include "./main.tab.h"  // yacc header
int lineno=1;
%}
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+
NUMBER [0-9]+(\.[0-9]+)?
CHAR \'.?\'
STRING \".+\"
LB \{
RB \}
LP \(
RP \) 
EQU ==
GTR \>
LSS \< 
GEQ \>= 
LEQ \<=
NEQ !=
LOGICAL_AND &&
LOGICAL_OR \|\|
LOGICAL_NOT !
WHILE while
IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
commentbegin "/*"
commentelement .|\n|\"\*\/\"
commentend "*/"
commentbegin2 "//"
commentelement2 .
commentend2 \n
%x COMMENT
%x COMMENT2
%%

{commentbegin} {BEGIN COMMENT;}
<COMMENT>{commentelement} {}
<COMMENT>{commentend} {BEGIN INITIAL;}
{commentbegin2} {BEGIN COMMENT2;}
<COMMENT2>{commentelement2} {}
<COMMENT2>{commentend2} {BEGIN INITIAL;}


"if" return IF;
"else" return ELSE;
"for" return FOR;
"=" return ASS;
"int" {return T_INT;}
"bool" {return T_BOOL;}
"char" {return T_CHAR;}
"double" {return T_DOUBLE;}
"void" { return T_VOID;}
";" return  SEMICOLON;
"," return COMMA;
"main" {    
    TreeNode* node = new TreeNode(lineno, NODE_MAIN);
    yylval = node;
    return MAIN;
    }
"return" {    
    TreeNode* node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_RETURN;
    yylval = node;
    return RETURN;
    }
"printf" {
    TreeNode* node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_PRINTF;
    yylval = node;
    return PRINTF;
}
"scanf" {
    TreeNode* node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_SCANF;
    yylval = node;
    return SCANF;
}
{WHILE} {return WHILE;}

{EQU} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_EQU;
    yylval = node;
    return EQU;
    }
{GTR} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_GTR;
    yylval = node;
    return GTR;
}
{LSS} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LSS;
    yylval = node;
    return LSS;
}
{GEQ} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_GEQ;
    yylval = node;
    return GEQ;
}
{LEQ} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LEQ;
    yylval = node;
    return LEQ;
}
{NEQ} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_NEQ;
    yylval = node;
    return NEQ;
}
{LOGICAL_AND} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LOGICAL_AND;
    yylval = node;
    return LOGICAL_AND;
}
{LOGICAL_OR} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LOGICAL_OR;
    yylval = node;
    return LOGICAL_OR;
}
{LOGICAL_NOT} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LOGICAL_NOT;
    yylval = node;
    return LOGICAL_NOT;
}


"+" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_PLUS;
    yylval = node;
    return PLUS;
    }
"-" {    
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_MINUS;
    yylval = node;
    return MINUS;
    }
"*" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_TIMES;
    yylval = node;
    return TIMES;
}
"/" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_DIVIDE;
    yylval = node;
    return DIVIDE;
}
"%" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_MOD;
    yylval = node;
    return MOD;
}
"&" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_AND;
    yylval = node;
    return AND;
}
"|" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_OR;
    yylval = node;
    return OR;
}
"~" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_NOT;
    yylval = node;
    return NOT;
}
"++" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_PPLUS;
    yylval = node;
    return PPLUS;
}
"--" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_MMINUS;
    yylval = node;
    return MMINUS;
    
}
"+=" {
    return PLUS_ASSIGN;
}
"-=" {
    return MIN_ASSIGN;
}
"/=" {
    return DIV_ASSIGN;
}
"%=" {
    return MOD_ASSIGN;
}
"*=" {
    return TIM_ASSIGN;
}
{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    // atoi将string类型的数字转化为int类型
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}
{STRING} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    node->str_val = string(yytext);
    yylval = node;
    return STRING;
}
{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->int_val = yytext[1];
    yylval = node;
    return CHAR;
}
{NUMBER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_DOUBLE;
    node->d_val = atof(yytext);
    yylval = node;
    return NUMBER;
}
{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}
{LB}        { return LB; }
{RB}        { return RB; }
{LP}        { return LP; }
{RP}        { return RP; }
{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%