/* rp:  rp is a php compiler */

%{
	const args = require('args')
	parser.args = args
%}

/* lexical grammar */
%lex

id [a-zA-Z_][a-zA-Z0-9_]*

%%

\s+                     /* skip whitespace */
\/\*[\s\S]*?\*\/|\/\/.*	return 'COMMENT'
[0-9]+("."[0-9]+)?\b	return 'NUMBER'
"true"					return 'TRUE'
"false"					return 'FALSE'

/* reserved words */
":"						return 'COLON'
"#"						return 'HASH'
"?"						return 'QUESTION'
"~"						return 'TILDE'
"_"						return 'UNDERSCORE'
"def"					return 'DEF'
"end"					return 'END'
"not"					return 'NOT'

/* types */
"string"				return 'TYPE_STRING'
"integer"				return 'TYPE_NUMBER'
"number"				return 'TYPE_NUMBER'
"array"					return 'TYPE_ARRAY'
"bool"					return 'TYPE_BOOL'
"float"					return 'TYPE_FLOAT'
[Uu]sage				return 'USAGE_WORD'
[Cc]ommands				return 'COMMAND_WORD'
[O]ptions				return 'OPTIONS_WORD'

/* Logic operators */
"and"					return 'AND'
"&&"					return 'AND'
"or"					return 'OR'
"||"					return 'OR'

/* any */
"%"						return '%'
"="						return 'ASSIGN'
"=="					return 'EQUAL'
"==="					return 'IDENTICAL'
"->"					return '->'
"*"						return '*'
"/"						return '/'
"-"						return '-'
"+"						return '+'
">"						return '>'
"<"						return '<'
"!="					return '!='
"^"						return '^'
"("						return 'PAR_OPEN'
")"						return 'PAR_CLOSE'
"["						return '['
"]"						return ']'
"PI"					return 'PI'
"E"						return 'E'
";"						return 'SEMICOL'
'..'					return 'DOT2'
'.'						return 'DOT'
','						return 'COMMA'
{id}					return 'ID'
@{id}					return 'ATTR'
\"(?:\"\"|[^"])*\"		return 'STRING'
\n						return 'BREAKLINE'

<<EOF>>					return 'EOF'
.						return 'INVALID'

/lex

%ebnf
%options flex

/* operator associations and precedence */

%left '%'
%left '+' '-'
%left '*' '/'
%left '^'
%left NOT
%left '>' '<' '>=' '<=' '<>' EQUAL '!='
%left 'NOT'
%left 'AND' 'OR'
%left '=' IDENTICAL
%left UMINUS
%left IF
%left DOT
%left DOT2
%left AND
%left COMMA

%start syntax

%% /* language grammar */

syntax
	: MENU* EOF
		{ return $1; }
;

MENU
	: USAGE
	| OPTIONS
	| COMMANDS
;

USAGE
	: USAGE_WORD STRING
		{ $$ = 'Usage: ' + $2 }
;

COMMANDS
	: COMMAND_WORD COMMAND*
		{ $$ = $2 }
;

COMMAND
	: ID COMMA ID STRING?
		{ parser.args.command(`${$1}`, $4 ? $4 : '', [`${$3}`]); }
	| ID STRING?
		{ parser.args.command(`${$1}`, `${$2}`); }
;


OPTIONS
	: OPTIONS_WORD OPTION*
;

OPTION
	: ID STRING?
		{ parser.args.option(`${$1}`, `${$2 ? $2 : ''}`) }
	| ID PAR_OPEN VALUE PAR_CLOSE STRING?
		{ parser.args.option(`${$1}`, `${$5 ? $5 : ''}`, $VALUE) }
;

VALUE
	: STRING
	| NUMBER
	| TRUE
	| FALSE
;