Module: project-10
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 

define constant <token-type>
    = one-of(#"KEYWORD", #"SYMBOL", #"IDENTIFIER",
        #"INT_CONST", #"STRING_CONST", #"NONE");

define constant <keyword>
    = one-of(#"CLASS", #"METHOD", #"FUNCTION",
        #"CONSTRUCTOR", #"INT", #"BOOLEAN",
         #"CHAR", #"VOID", #"VAR",#"STATIC", #"FIELD", #"LET",
          #"DO", #"IF", #"ELSE", #"WHILE", #"RETURN", #"TRUE",
           #"FALSE", #"NULL", #"THIS", #"NONE");


define constant $keywordReg =  "class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return" ;                 
define constant $symbolReg = "[-\\&\\*\\+\\(\\)\\.\\/\\,\\-\\]\\;\\~\\}\\|\\{\\>\\=\\[\\<]";
define constant $intReg = "[0-9]+";
define constant $strReg = "\"[^\"\n]*\"";
define constant $idReg = "[a-zA-Z_]\\w*";
define constant $patterns =  concatenate($symbolReg, "|" ,$intReg ,"|" ,$strReg ,"|",$idReg);
define constant $tokenPatterns  :: <regex> = compile-regex($patterns);


/*define variable *keywordMap* = make(<string-table>);
  *keywordMap*["class"] := #"CLASS"; 
  *keywordMap*["constructor"] := #"CONSTRUCTOR";
  *keywordMap*["function"] := #"FUNCTION";
  *keywordMap*["method"] := #"METHOD";
  *keywordMap*["field"] := #"FIELD";
  *keywordMap*["static"] := #"STATIC"; 
  *keywordMap*["var"] := #"VAR";
  *keywordMap*["int"] := #"INT";
  *keywordMap*["char"] := #"CHAR";
  *keywordMap*["boolean"] := #"BOOLEAN";
  *keywordMap*["void"] := #"VOID"; 
  *keywordMap*["true"] := #"TRUE";
  *keywordMap*["false"] := #"FALSE";
  *keywordMap*["null"] := #"NULL";
  *keywordMap*["this"] := #"THIS";
  *keywordMap*["let"] := #"LET"; 
  *keywordMap*["do"] := #"DO";
  *keywordMap*["if"] := #"IF";
  *keywordMap*["else"] := #"ELSE";
  *keywordMap*["while"] := #"WHILE";
  *keywordMap*["return"] := #"RETURN";*/

  define variable *keywordMap* = tabling(<string-table>, "class" => #"CLASS", "constructor" => #"CONSTRUCTOR", "function" => #"FUNCTION",
            "method" => #"METHOD", "field" => #"FIELD", "static" => #"STATIC", "var" => #"VAR",
            "int" => #"INT", "char" => #"CHAR", "boolean" => #"BOOLEAN", "void" => #"VOID", 
            "true" => #"TRUE", "false" => #"FALSE", "null" => #"NULL", "this" => #"THIS",
            "let" => #"LET", "do" => #"DO", "if" => #"IF", "else" => #"ELSE", 
            "while" => #"WHILE", "return" => #"RETURN");

  define variable *reverseMap* = tabling(
            #"KEYWORD" => "keyword", #"SYMBOL" => "symbol", #"IDENTIFIER" => "identifier",
            #"INT_CONST" => "integerConstant", #"STRING_CONST" => "stringConstant",
            #"CLASS" =>"class", #"CONSTRUCTOR" => "constructor", #"FUNCTION" => "function",
            #"METHOD" => "method", #"FIELD" => "field", #"STATIC" => "static",
            #"VAR" => "var", #"INT" => "int", #"CHAR" => "char", #"BOOLEAN" => "boolean",
            #"VOID" => "void", #"TRUE" => "true", #"FALSE" => "false", #"NULL" => "null",
            #"THIS" => "this", #"LET" => "let", #"DO" => "do", #"IF" => "if",
            #"ELSE" => "else", #"WHILE" => "while", #"RETURN" => "return");

