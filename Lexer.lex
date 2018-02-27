import java_cup.runtime.*;

%%

%class Lexer
%unicode
%line
%column
%cup


%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

Letter = [A-Za-z]
Digit = [0-9]
Punctuation = [!\"#\$%&\'()\*\+\,\-\.\/:;<=>\?@\[\]\\\^_`{}\~¦]
Character = '{Letter}' | '{Punctuation}' | '{Digit}'

Integer = 0|[1-9]{Digit}*
Float = {Integer}(\.{Digit}*)?
Rational = ({Integer}_){Digit}"/"{Digit}{Digit}* | {Integer}"/"{Digit}{Digit}*
Number = {Integer} | {Rational} | {Float}

Boolean = T | F

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f] //line terminator, space, tab, or line feed.

Comment = {MultilineComment} | {EndOfLineComment}
MultilineComment = "/#" [^#] ~"#/" | "/#" "#" + "/"
EndOfLineComment = "#" {InputCharacter}* {LineTerminator}?

AlphanumericUnderscore = {Letter} | "_" | {Digit}
Dot = "."
Identifier = {Letter}{AlphanumericUnderscore}*

String = \"(\\.|[^\"])*\"

%%

<YYINITIAL> {

    //End statement
    ";"                { return symbol(sym.SEMI); }

    //Operators

    ":="               { return symbol(sym.EQ); }
    "::"               { return symbol(sym.CONCAT); }
    ":"                { return symbol(sym.COLON); }
    "="                { return symbol(sym.EQEQ); }
    "!="               { return symbol(sym.NOT_EQ); }
    "&&"               { return symbol(sym.AND); }
    "||"               { return symbol(sym.OR); }
    "!"                { return symbol(sym.NOT); }
    "+"                { return symbol(sym.PLUS); }
    "-"                { return symbol(sym.MINUS); }
    "*"                { return symbol(sym.TIMES); }
    "/"                { return symbol(sym.DIVIDE); }
    "("                { return symbol(sym.L_ROUND); }
    ")"                { return symbol(sym.R_ROUND); }
    "{"                { return symbol(sym.L_CURLY); }
    "}"                { return symbol(sym.R_CURLY); }
    "["                { return symbol(sym.L_SQUARE); }
    "]"                { return symbol(sym.R_SQUARE); }
    "=>"               { return symbol(sym.IMPLY); }
    "<="               { return symbol(sym.L_ANGLE_EQ); }
    ">="               { return symbol(sym.R_ANGLE_EQ); }
    "=="               { return symbol(sym.DOUBLE_EQ); }
    "<"                { return symbol(sym.L_ANGLE); }
    ">"                { return symbol(sym.R_ANGLE); }
    ","                { return symbol(sym.COMMA); }
    "^"                { return symbol(sym.CARET); }
    "."                { return symbol(sym.DOT); }
    "|"                { return symbol(sym.BAR); }
    "->"               { return symbol(sym.ARROW); }
    "&"                { return symbol(sym.INTERSECTION); }
    "\\"                { return symbol(sym.DIFFERENCE); }

    //hmm

    //Types
    "int"              { return symbol(sym.INTEGER); }
    "char"             { return symbol(sym.CHARACTER); }
    "rat"              { return symbol(sym.RATIONAL); }
    "float"            { return symbol(sym.FLOAT); }
    "dict"             { return symbol(sym.DICT); }
    "seq"              { return symbol(sym.SEQ); }
    "set"              { return symbol(sym.SET); }
    "function"         { return symbol(sym.FUNCTION); }
    "thread"           { return symbol(sym.THREAD); }

    //Special words
    "main"             { return symbol(sym.MAIN); }
    "tdef"             { return symbol(sym.TYPEDEF); }
    "fdef"             { return symbol(sym.FUNCTION_DEF); }
    "top"              { return symbol(sym.TOP); }
    "in"               { return symbol(sym.IN); }
    "alias"            { return symbol(sym.ALIAS); }
    "if"               { return symbol(sym.IF); }
    "fi"               { return symbol(sym.FI); }
    "then"             { return symbol(sym.THEN); }
    "else"             { return symbol(sym.ELSE); }
    "read"             { return symbol(sym.READ); }
    "print"            { return symbol(sym.PRINT); }
    "return"           { return symbol(sym.RETURN); }
    "break"            { return symbol(sym.BREAK); }
    "elif"             { return symbol(sym.ELIF); }
    "do"               { return symbol(sym.DO); }
    "od"               { return symbol(sym.OD); }
    "while"            { return symbol(sym.WHILE); }
    "forall"            { return symbol(sym.FORALL); }

    //Literals
    {Boolean}          { return symbol(sym.BOOLEAN); }
    {String}           { return symbol(sym.STRING); }
    {Number}           { return symbol(sym.NUMBER); }
    {Character}        { return symbol(sym.CHARACTER); }
    {Identifier}       { return symbol(sym.IDENTIFIER);}
    {Comment}          { /* just skip what was found, do nothing */ }
    {WhiteSpace}       { /* just skip what was found, do nothing */ }
}

[^]                    { throw new Error("Illegal character <"+yytext()+">"); }
