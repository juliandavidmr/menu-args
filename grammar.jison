/* rp:  rp is a php compiler */

%{
	const args = require('args')
	parser.args = args

	function remove_colons(val) {
		if (val && val.length > 2) {
			return val.slice(1, val.length - 1)
		}
	}
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

/* types */
"string"				return 'TYPE_STRING'
"integer"				return 'TYPE_NUMBER'
"number"				return 'TYPE_NUMBER'
"array"					return 'TYPE_ARRAY'
"bool"					return 'TYPE_BOOL'
"float"					return 'TYPE_FLOAT'
[Uu]sage				return 'USAGE_WORD'
[Cc]ommands				return 'COMMAND_WORD'
[Oo]ptions				return 'OPTIONS_WORD'

/* any */
"="						return 'ASSIGN'
"=="					return 'EQUAL'
"->"					return '->'
"*"						return '*'
"("						return 'PAR_OPEN'
")"						return 'PAR_CLOSE'
"["						return '['
"]"						return ']'
"PI"					return 'PI'
"E"						return 'E'
";"						return 'SEMICOL'
'.'						return 'DOT'
','						return 'COMMA'
{id}					return 'ID'
\"(?:\"\"|[^"])*\"		return 'STRING'
\n						return 'BREAKLINE'

<<EOF>>					return 'EOF'
.							return 'INVALID'

/lex

%ebnf
%options flex

/* operator associations and precedence */

%left '^'
%left UMINUS
%left DOT
%left DOT2

%start syntax

%% /* language grammar */

syntax
	: MENU* EOF
;

MENU
	: USAGE
	| OPTIONS
	| COMMANDS
;

USAGE
	: USAGE_WORD STRING
;

COMMANDS
	: COMMAND_WORD COMMAND*
;

COMMAND
	: ID COMMA ID STRING?
		{ parser.args.command(`${$1}`, $4 ? remove_colons($4) : '', [`${$3}`]); }
	| ID STRING?
		{ parser.args.command(`${$1}`, `${$2 ? remove_colons($2) : ''}`); }
;

OPTIONS
	: OPTIONS_WORD OPTION*
;

OPTION
	: ID STRING?
		{ parser.args.option(`${$1}`, `${$2 ? remove_colons($2) : ''}`) }
	| ID PAR_OPEN VALUE PAR_CLOSE STRING?
		{ parser.args.option(`${$1}`, `${$5 ? remove_colons($5) : ''}`, $VALUE) }
;

VALUE
	: STRING
	| NUMBER
	| TRUE
	| FALSE
;