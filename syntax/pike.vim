" $Id: pike.vim,v 1.13 2005/04/11 14:39:04 jettero Exp $

" Vim syntax file
" Language:     Pike
" Maintainer:   Francesco Chemolli <kinkie@kame.usr.dsi.unimi.it>
" Updater:      Paul Miller <vimfan@voltar-confed.org>
" Last Change:  2005 Apr 08

" see also: /usr/share/vim/vim63/syntax/pike.vim

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" A bunch of useful C keywords
syn keyword pikeStatement	goto break return continue
syn keyword pikeLabel		case default
syn keyword pikeConditional	if else switch
syn keyword pikeRepeat		while for foreach do
syn keyword pikeStatement	gauge lambda inherit import typeof sizeof sscanf
syn keyword pikeException	catch throw
syn keyword pikeType		inline nomask private protected public static

syn keyword pikeTodo contained	TODO FIXME XXX

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match  pikeSpecial contained	"\\[0-7][0-7][0-7]\=\|\\."
syn match  pikeFormat  display "%\(\d\+\)\=[-+ |=#@:.]*\(\d\+\)\=\('\I\+'\|'\I*\\'\I*'\)\=[OsdicoxXf]" contained
syn match  pikeFormat  display "%%" contained
syn region pikeString   start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=pikeSpecial,pikeFormat
syn match  pikeCharacter		"'[^\\]'"
syn match  pikeSpecialCharacter	"'\\.'"
syn match  pikeSpecialCharacter	"'\\[0-7][0-7]'"
syn match  pikeSpecialCharacter	"'\\[0-7][0-7][0-7]'"

" Stolen verbatim from perl.vim
syn match pikeNumber "[+-]\=\(\<\d[[:digit:]_]*L\=\>\|0[xX]\x[[:xdigit:]_]*\>\)"
syn match pikeFloat  "[+-]\=\<\d[[:digit:]_]*[eE][\-+]\=\d\+"
syn match pikeFloat  "[+-]\=\<\d[[:digit:]_]*\.[[:digit:]_]*\([eE][\-+]\=\d\+\)\="
syn match pikeFloat  "[+-]\=\<\.[[:digit:]_]\+\([eE][\-+]\=\d\+\)\="

syn match pikeFloatError "[.]\d\+" " curiously, this only matches trailing stupid extra float characters if the floats were already matched
syn match pikeOctalError "0\o*[89]\d*"     " even though this one appears to know to highlight bad octal in any case

syn match pikeRange    "\d\+\s*[.][.]\s*\d\+"

"!" stolen from lpc.vim directly
" catch errors caused by wrong parenthesis and brackets
syn cluster	pikeParenGroup	contains=pikeParenError,pikeIncluded,pikeSpecial,pikeCommentSkip,pikeCommentString,pikeComment2String,@pikeCommentGroup,pikeCommentStartError,pikeUserCont,pikeUserLabel,pikeBitField,pikeCommentSkip,pikeOctalZero,pikeCppOut,pikeCppOut2,pikeCppSkip
syn region	pikeParen	transparent start='(' end=')' contains=ALLBUT,@pikeParenGroup,pikeCppParen,pikeErrInBracket,pikeCppBracket,pikeCppString,@pikeEfunGroup,pikeApplies,pikeKeywdError
" pikeCppParen: same as pikeParen but ends at end-of-line; used in pikeDefine
syn region	pikeCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@pikeParenGroup,pikeErrInBracket,pikeParen,pikeBracket,pikeString,@pikeEfunGroup,pikeApplies,pikeKeywdError
syn match	pikeParenError	display ")"
syn match	pikeParenError	display "\]"
" for LPC:
" Here we should consider the array ({ }) parenthesis and mapping ([ ])
" parenthesis and multiset (< >) parenthesis.
syn match	pikeErrInParen	display contained "[^^]{"ms=s+1
syn match	pikeErrInParen	display contained "\(}\|\]\)[^)]"me=e-1
syn region	pikeBracket	transparent start='\[' end=']' contains=ALLBUT,@pikeParenGroup,pikeErrInParen,pikeCppParen,pikeCppBracket,pikeCppString,@pikeEfunGroup,pikeApplies,pikeFuncName,pikeKeywdError
" pikeCppBracket: same as pikeParen but ends at end-of-line; used in pikeDefine
syn region	pikeCppBracket	transparent start='\[' skip='\\$' excludenl end=']' end='$' contained contains=ALLBUT,@pikeParenGroup,pikeErrInParen,pikeParen,pikeBracket,pikeString,@pikeEfunGroup,pikeApplies,pikeFuncName,pikeKeywdError
syn match	pikeErrInBracket	display contained "[);{}]"

"!" end stealing lpc.vim directly

if exists("c_comment_strings")
  " A comment can contain pikeString, pikeCharacter and pikeNumber.
  " But a "*/" inside a pikeString in a pikeComment DOES end the comment!  So we
  " need to use a special type of pikeString: pikeCommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syntax match pikeCommentSkip	contained "^\s*\*\($\|\s\+\)"
  syntax region pikeCommentString	contained start=+"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=pikeSpecial,pikeCommentSkip
  syntax region pikeComment2String	contained start=+"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=pikeSpecial
  syntax region pikeComment	start="/\*" end="\*/" contains=pikeTodo,pikeCommentString,pikeCharacter,pikeNumber,pikeFloat
  syntax match  pikeComment	"//.*" contains=pikeTodo,pikeComment2String,pikeCharacter,pikeNumber
  syntax match  pikeComment	"#\!.*" contains=pikeTodo,pikeComment2String,pikeCharacter,pikeNumber
else
  syn region pikeComment		start="/\*" end="\*/" contains=pikeTodo
  syn match pikeComment		"//.*" contains=pikeTodo
  syn match pikeComment		"#!.*" contains=pikeTodo
endif
syntax match pikeCommentError	"\*/"

syn match pikepredef "[>.]\@<!\<\(__empty_program\|__parse_pike_type\|_disable_threads\|_do_call_outs\|_exit\|_next\|_prev\)\>"
syn match pikepredef "[>.]\@<!\<\(_refs\|_typeof\|abs\|acos\|acosh\|add_constant\|aggregate\|aggregate_mapping\|alarm\)\>"
syn match pikepredef "[>.]\@<!\<\(all_constants\|allocate\|array_sscanf\|arrayp\|asin\|asinh\|atan\|atan2\|atanh\|atexit\)\>"
syn match pikepredef "[>.]\@<!\<\(backtrace\|basename\|basetype\|call_function\|call_out\|call_out_info\|callablep\|cd\|ceil\)\>"
syn match pikepredef "[>.]\@<!\<\(column\|combine_path\|combine_path_amigaos\|combine_path_nt\|combine_path_unix\|compile\)\>"
syn match pikepredef "[>.]\@<!\<\(compile_file\|compile_string\|copy_value\|cos\|cosh\|cpp\|crypt\|ctime\|decode_value\|delay\)\>"
syn match pikepredef "[>.]\@<!\<\(describe_backtrace\|describe_error\|destruct\|dirname\|encode_value\|encode_value_canonic\)\>"
syn match pikepredef "[>.]\@<!\<\(enumerate\|equal\|errno\|error\|exece\|exit\|exp\|explode_path\|file_stat\|file_truncate\)\>"
syn match pikepredef "[>.]\@<!\<\(filesystem_stat\|filter\|find_call_out\|floatp\|floor\|fork\|function_name\|function_object\)\>"
syn match pikepredef "[>.]\@<!\<\(function_program\|functionp\|gc\|get_all_groups\|get_all_users\|get_backtrace\|get_dir\)\>"
syn match pikepredef "[>.]\@<!\<\(get_groups_for_user\|get_iterator\|get_profiling_info\|get_weak_flag\|getcwd\|getenv\)\>"
syn match pikepredef "[>.]\@<!\<\(getgrgid\|getgrnam\|gethrtime\|gethrvtime\|getpid\|getpwnam\|getpwuid\|glob\|gmtime\|has_index\)\>"
syn match pikepredef "[>.]\@<!\<\(has_prefix\|has_suffix\|has_value\|hash\|hash_7_0\|hash_7_4\|hash_value\|indices\|intp\)\>"
syn match pikepredef "[>.]\@<!\<\(is_absolute_path\|kill\|load_module\|localtime\|log\|lower_case\|m_delete\|map\|mappingp\)\>"
syn match pikepredef "[>.]\@<!\<\(master\|max\|min\|mkdir\|mkmapping\|mkmultiset\|mktime\|multisetp\|mv\|next_object\)\>"
syn match pikepredef "[>.]\@<!\<\(normalize_path\|object_program\|object_variablep\|objectp\|pow\|programp\|putenv\)\>"
syn match pikepredef "[>.]\@<!\<\(query_num_arg\|random\|random_seed\|random_string\|remove_call_out\|replace\|replace_master\)\>"
syn match pikepredef "[>.]\@<!\<\(reverse\|rm\|round\|rows\|search\|set_priority\|set_weak_flag\|sgn\|signal\|signame\|signum\|sin\)\>"
syn match pikepredef "[>.]\@<!\<\(sinh\|sleep\|sort\|sprintf\|sqrt\|strerror\|string_to_unicode\|string_to_utf8\)\>"
syn match pikepredef "[>.]\@<!\<\(stringp\|strlen\|tan\|tanh\|this\|this_object\|time\|trace\|ualarm\|unicode_to_string\)\>"
syn match pikepredef "[>.]\@<!\<\(upper_case\|utf8_to_string\|values\|version\|werror\|write\|zero_type\)\>"

syn keyword pikeType		int string void float mapping array multiset mixed
syn keyword pikeType		program object function class

syn region pikePreCondit	start="^\s*#\s*\(if\>\|ifdef\>\|ifndef\>\|elif\>\|else\>\|endif\>\)" skip="\\$" end="$" contains=pikeComment,pikeString,pikeCharacter,pikeNumber,pikeCommentError
syn region pikeIncluded contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match pikeIncluded contained "<[^>]*>"
syn match pikeInclude		"^\s*#\s*include\>\s*["<]" contains=pikeIncluded
"syn match pikeLineSkip	"\\$"
syn region pikeDefine		start="^\s*#\s*\(define\>\|undef\>\)" skip="\\$" end="$" contains=ALLBUT,pikePreCondit,pikeIncluded,pikeInclude,pikeDefine,pikeInParen
syn region pikePreProc		start="^\s*#\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" contains=ALLBUT,pikePreCondit,pikeIncluded,pikeInclude,pikeDefine,pikeInParen

" Highlight User Labels
" syn region	pikeMulti		transparent start='?' end=':' contains=ALLBUT,pikeIncluded,pikeSpecial,pikeTodo,pikeUserLabel,pikeBitField
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
" syn match	pikeUserLabel	"^\s*\I\i*\s*:$"
" syn match	pikeUserLabel	";\s*\I\i*\s*:$"ms=s+1
" syn match	pikeUserLabel	"^\s*\I\i*\s*:[^:]"me=e-1
" syn match	pikeUserLabel	";\s*\I\i*\s*:[^:]"ms=s+1,me=e-1

" Avoid recognizing most bitfields as labels
" syn match	pikeBitField	"^\s*\I\i*\s*:\s*[1-9]"me=e-1
" syn match	pikeBitField	";\s*\I\i*\s*:\s*[1-9]"me=e-1

syn sync ccomment pikeComment minlines=10

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_pike_syntax_inits")
  if version < 508
    let did_pike_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink pikeLabel		Label
  HiLink pikeUserLabel		Label
  HiLink pikeConditional	Conditional
  HiLink pikeRepeat		Repeat
  HiLink pikeCharacter		Character
  HiLink pikeSpecialCharacter pikeSpecial
  HiLink pikeNumber		Number
  HiLink pikeFloat		Float
  HiLink pikeRange  	Number
  HiLink pikeOctalError		pikeError
  HiLink pikeFloatError		pikeError
  HiLink pikeParenError		pikeError
  HiLink pikeInParen		pikeError
  HiLink pikeCommentError	pikeError
  HiLink pikeOperator		Operator
  HiLink pikeInclude		Include
  HiLink pikePreProc		PreProc
  HiLink pikeDefine		Macro
  HiLink pikeIncluded		pikeString
  HiLink pikeError		Error
  HiLink pikeStatement		Statement
  HiLink pikePreCondit		PreCondit
  HiLink pikeType		Type
  HiLink pikeCommentError	pikeError
  HiLink pikeCommentString	pikeString
  HiLink pikeComment2String	pikeString
  HiLink pikeCommentSkip	pikeComment
  HiLink pikeString		String
  HiLink pikeComment		Comment
  HiLink pikeFormat  	    PreProc
  HiLink pikeSpecial		SpecialChar
  HiLink pikeTodo		Todo
  HiLink pikeException		pikeStatement
  HiLink pikepredef         Function
  HiLink pikeCompoundType	Constant
  "HiLink pikeIdentifier	Identifier

  delcommand HiLink
endif

let b:current_syntax = "pike"

" vim: ts=4
