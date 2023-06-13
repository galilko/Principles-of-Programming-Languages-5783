Module: project-11
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 

define constant <token-type>
    = one-of(#"KEYWORD", #"SYMBOL", #"IDENTIFIER",
        #"INT_CONST", #"STRING_CONST", #"NONE");



define constant $keywordReg =  "class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do |if|else|while|return" ;                 
define constant $symbolReg = "[-\\&\\*\\+\\(\\)\\.\\/\\,\\-\\]\\;\\~\\}\\|\\{\\>\\=\\[\\<]";
define constant $intReg = "[0-9]+";
define constant $strReg = "\"[^\"\n]*\"";
define constant $idReg = "[a-zA-Z_]\\w*";
define constant $patterns =  concatenate($symbolReg, "|" ,$intReg ,"|" ,$strReg ,"|",$idReg);
define constant $tokenPatterns  :: <regex> = compile-regex($patterns);



  define variable *keywordMap* = tabling(<string-table>, "class" => #"CLASS", "constructor" => #"CONSTRUCTOR", "function" => #"FUNCTION",
            "method" => #"METHOD", "field" => #"FIELD", "static" => #"STATIC", "var" => #"VAR",
            "int" => #"INT", "char" => #"CHAR", "boolean" => #"BOOLEAN", "void" => #"VOID", 
            "true" => #"TRUE", "false" => #"FALSE", "null" => #"NULL", "this" => #"THIS",
            "let" => #"LET", "do " => #"DO", "if" => #"IF", "else" => #"ELSE", 
            "while" => #"WHILE", "return" => #"RETURN");


