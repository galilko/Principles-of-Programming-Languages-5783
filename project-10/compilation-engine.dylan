Module: project-10
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 

/**
 * recursive top-down parser
 *
 * Effects the actual compilation output.
 * 1.Gets its input from a JackTokenizer and emits its parsed structure into an output file/stream.
 * 2.The output is generated by a series of compile_xxx ( ) routines, one for every syntactic element xxx of the Jack grammar.
 * 3.The contract between these routines is that each compile_xxx ( ) routine should read the syntactic construct xxx from the input,
 * advance ( ) the tokenizer exactly beyond xxx, and output the parsing of xxx.
 * Thus, compile_xxx ( ) may only be called if indeed xxx is the next syntactic element of the input.
 *
 * In the first version of the compiler, described in chapter 10, this module emits a structured printout of the code, wrapped in XML tags.
 * In the final version of the compiler, described in chapter 11, this module generates executable VM code.
 * In both cases, the parsing logic and module API are exactly the same.
 */
define class <compilation-engine> (<object>)
    slot printWriter :: <file-stream>;
    slot tokensPrintWriter :: <file-stream>;
    slot tokenizer :: <jack-tokenizer>;
    slot indentation :: <integer>, init-value: 0;
    slot width :: <string>, init-value: "  ";
end class;

/**
 * Creates a new compilation engine with the given input and output.
 * The next routine called must be compileClass()
 * @param inFile
 * @param outFile
 */
define function create-compilation-engine
(engine :: <compilation-engine>, in-file :: <file-stream>, out-file :: <file-stream>, out-tokens-file :: <file-stream>)
    engine.tokenizer := make(<jack-tokenizer>);
    generate-tokens(engine.tokenizer, in-file);
    engine.printWriter := out-file;
    engine.tokensPrintWriter := out-tokens-file;
end function;

    //-------------------compile_xxx ( ) routines - recursive descent-------------------//

    /**
     * Compiles a type
     */
define function compileType
(engine :: <compilation-engine>)
    block (return)
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        let key = getKeyword(engine.tokenizer);
        if ((type == #"KEYWORD" & (key == #"INT" | key == #"CHAR" | key == #"BOOLEAN")) | (type == #"IDENTIFIER"))
            writeXMLTag(engine, type);
            return();
        else
            throwError(engine, "int|char|boolean|className");
            return();
        end;
    end;
end function;

    /**
     * Complies a complete class
     * class: 'class' className "{" classVarDec* subroutineDec* "}"
     */
define function compileClass
(engine :: <compilation-engine>)
    //class
    block (return)
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        if (type ~= #"KEYWORD" | getKeyword(engine.tokenizer) ~= #"CLASS")
             throwError(engine, "class");
             return();
        end if;
        format(engine.printWriter, "<class>\n");
        format(engine.tokensPrintWriter,"<tokens>\n");
        engine.indentation := engine.indentation + 1;
        writeXMLTag(engine, type);
    
    
        //className
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        if (type ~= #"IDENTIFIER")
            throwError(engine, "className");
            return();
        end if;
        writeXMLTag(engine, type);
        
        //"{"
        requireSymbol(engine, "{");
        //classVarDec* subroutineDec*
        compileClassVarDec(engine);
        compileSubroutine(engine);
    
        //"}"
        requireSymbol(engine, "}");
        if (hasMoreTokens(engine.tokenizer))
            format-out("Unexpected tokens");
            return();
        end if;
        engine.indentation := engine.indentation + 1;
        format(engine.tokensPrintWriter,"</tokens>\n");
        format(engine.printWriter, "</class>\n");
        //save file
        close(engine.printWriter);
        close(engine.tokensPrintWriter);
    end block;
end function;


    /**
     * Compiles a static declaration or a field declaration
     * classVarDec ('static'|'field') type varName (','varName)* ';'
     */
define function compileClassVarDec
(engine :: <compilation-engine>)
    //first determine whether there is a classVarDec, nextToken is } or start subroutineDec
    block(return)
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        //next is a "}" or next is subroutineDec
        let key = getKeyword(engine.tokenizer);
        if (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), "}"))
            pointerBack(engine.tokenizer);
            return();
    
        //next is start subroutineDec or classVarDec, both start with keyword
        elseif (type ~= #"KEYWORD")
            throwError(engine, "keyword");
            return();

        //next is subroutineDec
        elseif (key == #"CONSTRUCTOR" | key == #"FUNCTION" | key == #"METHOD")
            pointerBack(engine.tokenizer);
            return();
        end;

        openTag(engine, "<classVarDec>\n");

        //classVarDec exists
        let key = getKeyword(engine.tokenizer);
        if (key ~= #"STATIC" & key ~= #"FIELD")
            throwError(engine, "static or field");
            return();
        end if;
        writeXMLTag(engine, type);
        //type
        compileType(engine);
        //at least one varName
        //boolean varNamesDone = false
        let flag = #t;
        while (flag)
            //varName
            advance(engine.tokenizer);
            let type :: <token-type> = engine.tokenizer.currentTokenType;

            if (type ~= #"IDENTIFIER")
                throwError(engine, "identifier");
                return();
            end if;
            writeXMLTag(engine, type);

            //',' or ';'
            advance(engine.tokenizer);
            let type :: <token-type> = engine.tokenizer.currentTokenType;
            let symbol = getSymbol(engine.tokenizer);
            if (type ~= #"SYMBOL" | (~string-equal?(symbol,",") & ~string-equal?(symbol,";")))
                throwError(engine, "',' or ';'");
                return();
            end if;
            writeXMLTag2(engine, type, getSymbol(engine.tokenizer));
            if (string-equal? (getSymbol(engine.tokenizer), ";"))
                flag := #f;
            end if;
        end while;

        closeTag(engine, "</classVarDec>\n");
        compileClassVarDec(engine);
    end block;
end function;


/**
 * Compiles a complete method function or constructor
 */
define function compileSubroutine
(engine :: <compilation-engine>)
    block (return)
      
        //determine whether there is a subroutine, next can be a "}"
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        
        //next is a "}"
        if (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), "}"))
            pointerBack(engine.tokenizer);
            return();
        end if;

        //start of a subroutine
        let key = getKeyword(engine.tokenizer);
        if (type ~= #"KEYWORD" | (key ~= #"CONSTRUCTOR" & key ~= #"FUNCTION" & key ~= #"METHOD"))
            throwError(engine, "constructor|function|method");
            return();
        end if;
        openTag(engine, "<subroutineDec>\n");
        writeXMLTag(engine, type);
        advance(engine.tokenizer);
        type := engine.tokenizer.currentTokenType;
        if (type == #"KEYWORD" & getKeyword(engine.tokenizer) == #"VOID")
            writeXMLTag2(engine, type, "void");
        else
            pointerBack(engine.tokenizer);
            compileType(engine);
        end;

        //subroutineName which is a identifier
        advance(engine.tokenizer);
        type := engine.tokenizer.currentTokenType;
        if (type ~= #"IDENTIFIER")
            throwError(engine, "subroutineName");
            return();
        end if;
        writeXMLTag(engine, type);

        //'('
        requireSymbol(engine, "(");
        //parameterList
        openTag(engine, "<parameterList>\n");
        compileParameterList(engine);

        closeTag(engine, "</parameterList>\n");
        //')'
        requireSymbol(engine, ")");
        //subroutineBody
        compileSubroutineBody(engine);
        
        closeTag(engine, "</subroutineDec>\n");
        compileSubroutine(engine);
    end;
end function;

    /**
     * Compiles the body of a subroutine
     * "{"  varDec* statements "}"
     */
    define function compileSubroutineBody(engine :: <compilation-engine>)
        openTag(engine, "<subroutineBody>\n");

        //"{"
        requireSymbol(engine, "{");
        //varDec*
        compileVarDec(engine);

        //statements
        openTag(engine, "<statements>\n");
        compileStatement(engine);
        
        closeTag(engine, "</statements>\n"); 
        //"}"
        requireSymbol(engine, "}");
        closeTag(engine, "</subroutineBody>\n"); 
    end function;

/**
 * Compiles a single statement
 *
 */
define function compileStatement
(engine :: <compilation-engine>)
    block (return)
      
        //determine whether there is a statement_next can be a "}"
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        //next is a "}"
        if (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), "}"))
            pointerBack(engine.tokenizer);
            return();
        end if;
        //next is 'let'|'if'|'while'|'do'|'return'
        if (type ~= #"KEYWORD")
            throwError(engine, "keyword");
            return();
        else
            select (getKeyword(engine.tokenizer))
                #"LET" => compileLet(engine);
                #"IF" => compileIf(engine);
                #"WHILE" => compilesWhile(engine);
                #"DO" => compileDo(engine);
                #"RETURN" => compileReturn(engine);
                otherwise => throwError(engine, "'let'|'if'|'while'|'do'|'return'"); return();
            end select;
        end;
        compileStatement(engine);
    end;
end function;


/**
 * Compiles a (possibly empty) parameter list
 * not including the enclosing "()"
 * ((type varName)(',' type varName)*)?
 */
define function compileParameterList
(engine :: <compilation-engine>)
    block (return)
      
        //check if there is parameterList, if next token is ')' than go back
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        if (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), ")"))
            pointerBack(engine.tokenizer);
            return();
        end if;
        //there is parameter, at least one varName
        pointerBack(engine.tokenizer);
        while (#t)
            //type
            compileType(engine);
            //varName
            advance(engine.tokenizer);
            type := engine.tokenizer.currentTokenType;
            if (type ~= #"IDENTIFIER")
                throwError(engine, "identifier");
                return();
            end if;
            writeXMLTag(engine, type);
            //',' or ')'
            advance(engine.tokenizer);
            type := engine.tokenizer.currentTokenType;
            let symbol = getSymbol(engine.tokenizer);
            if (type ~= #"SYMBOL" | (~string-equal?(symbol,",") & ~string-equal?(symbol,")")))
                throwError(engine, "',' or ')'");
                return();
            end if;
            if (type == #"SYMBOL" & string-equal?(getSymbol(engine.tokenizer), ","))
                writeXMLTag2(engine, type, ",");
            else 
                pointerBack(engine.tokenizer);
                return();
            end;
        end while;
    end;
end function;

/**
 * Compiles a var declaration
 * 'var' type varName (',' varName)*
 */
define function compileVarDec
(engine :: <compilation-engine>)
    block (return)
      
        //determine if there is a varDec
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        //no 'var' go back
        if (type ~= #"KEYWORD" | getKeyword(engine.tokenizer) ~= #"VAR")
            pointerBack(engine.tokenizer);
            return();
        end if;
        openTag(engine, "<varDec>\n");
        writeXMLTag2(engine, type, "var");
        //type
        compileType(engine);
        //at least one varName
        //boolean varNamesDone = false
        let flag = #t;
        while (flag)
            //varName
            advance(engine.tokenizer);
            type := engine.tokenizer.currentTokenType;
            if (type ~= #"IDENTIFIER")
                throwError(engine, "identifier");
                return();
            end if;
            writeXMLTag(engine, type);
            //',' or ';'
            advance(engine.tokenizer);
            type := engine.tokenizer.currentTokenType;
            let symbol = getSymbol(engine.tokenizer);
            if (type ~= #"SYMBOL" | (~string-equal?(symbol,",") & ~string-equal?(symbol,";")))
                throwError(engine, "',' or ';'");
                return();
            end if;
            writeXMLTag2(engine, type, getSymbol(engine.tokenizer));
            if (string-equal? (getSymbol(engine.tokenizer), ";"))
                flag := #f;
            end if;
        end while;
        
        closeTag(engine, "</varDec>\n");
        compileVarDec(engine);
    end;
end function;

    /**
     * Compiles a do statement
     * 'do' subroutineCall ';'
     */
    define function compileDo(engine :: <compilation-engine>)
        openTag(engine, "<doStatement>\n");


        writeXMLTag2(engine, #"KEYWORD", "do");
        //subroutineCall
        compileSubroutineCall(engine);
        //';'
        requireSymbol(engine, ";");

        closeTag(engine, "</doStatement>\n"); 
    end function;

/**
 * Compiles a let statement
 * 'let' varName ('[' ']')? '=' expression ';'
 */
define function compileLet
(engine :: <compilation-engine>)
    block (return)
      
        openTag(engine, "<letStatement>\n");
        writeXMLTag2(engine, #"KEYWORD", "let");
        //varName
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        if (type ~= #"IDENTIFIER")
            throwError(engine, "varName");
            return();
        end if;
        writeXMLTag(engine, type);
        //'[' or '='
        advance(engine.tokenizer);
        type := engine.tokenizer.currentTokenType;
        let symbol = getSymbol(engine.tokenizer);
        if (type ~= #"SYMBOL" | (~string-equal?(symbol,"[") & ~string-equal?(symbol,"=")))
            throwError(engine, "'['|'='");
            return();
        end if;
        //'[' expression ']'
        if (string-equal? (getSymbol(engine.tokenizer), "["))
            writeXMLTag2(engine, type, "[");
            compileExpression(engine);
            //']'
            advance(engine.tokenizer);
            type := engine.tokenizer.currentTokenType;
            if (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), "]"))
                writeXMLTag2(engine, type, "]")
            else
                throwError(engine, "']'");
                return();
            end;
            advance(engine.tokenizer);
        end if;
        //'='
        writeXMLTag2(engine, #"SYMBOL", "=");
        //expression
        compileExpression(engine);
        //';'
        requireSymbol(engine, ";");
                closeTag(engine, "</letStatement>\n");
    end;
end function;

    /**
     * Compiles a while statement
     * 'while' '(' expression ')' "{" statements "}"
     */
    define function compilesWhile(engine :: <compilation-engine>)
        openTag(engine, "<whileStatement>\n");
        writeXMLTag2(engine, #"KEYWORD", "while");
        //'('
        requireSymbol(engine, "(");
        //expression
        compileExpression(engine);
        //')'
        requireSymbol(engine, ")");
        //"{"
        requireSymbol(engine, "{");
        //statements
        openTag(engine, "<statements>\n");
        compileStatement(engine);
        closeTag(engine, "</statements>\n"); 
        //"}"
        requireSymbol(engine, "}");
        
        closeTag(engine, "</whileStatement>\n");
    end function;

/**
 * Compiles a return statement
 * ‘return’ expression? ';'
 */
define function compilereturn
(engine :: <compilation-engine>)
    block (return)
      
        openTag(engine, "<returnStatement>\n");
        writeXMLTag2(engine, #"KEYWORD", "return");
        //check if there is any expression
        advance(engine.tokenizer);
        //no expression
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        if (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), ";"))
            writeXMLTag2(engine, type, ";");
            engine.indentation := engine.indentation - 1;
            for (i from 1 to engine.indentation)
                format(engine.printWriter, engine.width);
            end for;
            format(engine.printWriter, "</returnStatement>\n"); 
            return();
        end if;

        pointerBack(engine.tokenizer);
        //expression
        compileExpression(engine);
        //';'
        requireSymbol(engine, ";");
        
        closeTag(engine, "</returnStatement>\n"); 
    end;
end function;

    /**
     * Compiles an if statement
     * possibly with a trailing else clause
     * 'if' '(' expression ')' "{" statements "}" ('else' "{" statements "}")?
     */
    define function compileIf(engine :: <compilation-engine>)
        openTag(engine, "<ifStatement>\n");
        writeXMLTag2(engine, #"KEYWORD", "if");
        //'('
        requireSymbol(engine, "(");
        //expression
        compileExpression(engine);
        //')'
        requireSymbol(engine, ")");
        //"{"
        requireSymbol(engine, "{");
        //statements
        openTag(engine, "<statements>\n");
        compileStatement(engine);
        
        closeTag(engine, "</statements>\n"); 
        //"}"
        requireSymbol(engine, "}");
        //check if there is 'else'
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        if (type == #"KEYWORD" & getKeyword(engine.tokenizer) == #"ELSE")
            writeXMLTag2(engine, type, "else");
            //"{"
            requireSymbol(engine, "{");
            //statements
            for (i from 1 to engine.indentation)
                format(engine.printWriter, engine.width);
            end for;
            engine.indentation := engine.indentation + 1;
            format(engine.printWriter, "<statements>\n");
            compileStatement(engine);
        
            engine.indentation := engine.indentation - 1;
            for (i from 1 to engine.indentation)
                format(engine.printWriter, engine.width);
            end for;
            format(engine.printWriter, "</statements>\n"); 
            //"}"
            requireSymbol(engine, "}");
        else
            pointerBack(engine.tokenizer);
        end;
        
        closeTag(engine, "</ifStatement>\n"); 
    end function;

/**
 * Compiles a term.
 * This routine is faced with a slight difficulty when trying to decide between some of the alternative parsing rules.
 * Specifically, if the current token is an identifier
 * the routine must distinguish between a variable, an array entry and a subroutine call
 * A single look-ahead token, which may be one of "[" "(" "." suffices to distinguish between the three possibilities
 * Any other token is not part of this term and should not be advanced over
 *
 * integerConstant|stringConstant|keywordConstant|varName|varName '[' expression ']'|subroutineCall|
 * '(' expression ')'|unaryOp term
 */
define function compileTerm
(engine :: <compilation-engine>)
    block (return)
        openTag(engine, "<term>\n");
        advance(engine.tokenizer);
        //check if it is an identifier
        let type1 = engine.tokenizer.currentTokenType;
        if (type1 == #"IDENTIFIER")
            //varName|varName '[' expression ']'|subroutineCall
            let token1 = engine.tokenizer.currentToken;
            advance(engine.tokenizer);
            let type2 = engine.tokenizer.currentTokenType;
            let token2 = engine.tokenizer.currentToken;
            if (type2 == #"SYMBOL" & (string-equal?(token2,"(") | string-equal?(token2,".")))
                //this is a subroutineCall
                pointerBack(engine.tokenizer);
                pointerBack(engine.tokenizer);
                compileSubroutineCall(engine);
            else
                writeXMLTag2(engine, type1, token1);
                if (type2 == #"SYMBOL" & string-equal? (token2, "["))
                    //this is an array entry
                    writeXMLTag2(engine, type2, "[");
                    //expression
                    compileExpression(engine);
                    //"]"
                    requireSymbol(engine, "]");
                else
                    pointerBack(engine.tokenizer); // this is varName
                end;
            end;
        else
            let symbol = getSymbol(engine.tokenizer);
            //integerConstant|stringConstant|keywordConstant|'(' expression ')'|unaryOp term
            if (type1 == #"INT_CONST")
                writeXMLTag2(engine, type1, integer-to-string(getIntVal(engine.tokenizer)));
            elseif (type1 == #"STRING_CONST")
                writeXMLTag2(engine, type1, getStringVal(engine.tokenizer));
            elseif (type1 == #"KEYWORD")
                select (getKeyword(engine.tokenizer))
                    #"TRUE", #"FALSE", #"NULL", #"THIS" => writeXMLTag(engine, type1);
                end select;
            elseif (type1 == #"SYMBOL" & string-equal? (symbol, "("))
                writeXMLTag2(engine, type1, "(");
                //expression
                compileExpression(engine);
                //")"
                requireSymbol(engine, ")");
            elseif (type1 == #"SYMBOL" & (string-equal?(symbol,"-") | string-equal?(symbol,"~")))
                writeXMLTag(engine, type1);
                //term
                compileTerm(engine);
            else
                throwError(engine, "integerConstant|stringConstant|keywordConstant|'(' expression ')'|unaryOp term");
                return();
            end;
            
        end;
        closeTag(engine, "</term>\n"); 
    end;
end function;

/**
 * Compiles a subroutine call
 * subroutineName '(' expressionList ')' | (className|varName) '.' subroutineName '(' expressionList ')'
 */
define function compileSubroutineCall
(engine :: <compilation-engine>)
    block (return)
      
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        if (type ~= #"IDENTIFIER")
            throwError(engine, "identifier");
            return();
        end if;
        writeXMLTag(engine, type);
        advance(engine.tokenizer);
        type := engine.tokenizer.currentTokenType;
        if (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), "("))
            //'(' expressionList ')'
            writeXMLTag2(engine, type, "(");
            //expressionList
            compileExpressionList(engine);
            //')'
            requireSymbol(engine, ")");
        elseif (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), "."))
            //(className|varName) '.' subroutineName '(' expressionList ')'
            writeXMLTag2(engine, type, ".");
            //subroutineName
            advance(engine.tokenizer);
            type := engine.tokenizer.currentTokenType;

            if (type ~= #"IDENTIFIER")
                throwError(engine, "identifier");
                return();
            end if;
            writeXMLTag(engine, type);
            //'('
            requireSymbol(engine, "(");
            //expressionList
            compileExpressionList(engine);
            //')'
            requireSymbol(engine, ")");
        else
            throwError(engine, "'('|'.'");
            return();
        end;
    end;
end function;
    

    /**
     * Compiles an expression
     * term (op term)*
     */
    define function compileExpression(engine :: <compilation-engine>)
        openTag(engine, "<expression>\n");
        //term
        compileTerm(engine);
        //(op term)*
        let flag = #t;
        while (flag)
            advance(engine.tokenizer);
            //op
            let type :: <token-type> = engine.tokenizer.currentTokenType;
            //format-out("fffffffffffff\n");
            //format-out(engine.tokenizer.currentToken);
            //format-out(as(<string>, type));
            //force-out();
            if (type == #"SYMBOL" & isOp(engine.tokenizer))
                select (getSymbol(engine.tokenizer) by \=)
                    ">" => writeXMLTag2(engine, type, "&gt;");
                    "<" => writeXMLTag2(engine, type, "&lt;");
                    "&" => writeXMLTag2(engine, type, "&amp;");
                    otherwise => writeXMLTag(engine, type);
                end select;

                //term
                compileTerm(engine);
            else
                pointerBack(engine.tokenizer);
                flag := #f;
            end;
        end while;
        
        closeTag(engine, "</expression>\n"); 
    end function;



    /**
     * Compiles a (possibly empty) comma-separated list of expressions
     * (expression(','expression)*)?
     */
    define function compileExpressionList(engine :: <compilation-engine>)
        openTag(engine, "<expressionList>\n");
        
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        //determine if there is any expression, if next is ')' then no
        pointerBack(engine.tokenizer);
        if (~(type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), ")")))
            //expression
            compileExpression(engine);
            //(','expression)*
            let flag = #t;
            while (flag)
                advance(engine.tokenizer);
                type := engine.tokenizer.currentTokenType;
                if (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer), ","))
                    writeXMLTag2(engine, type, ",");
                    //expression
                    compileExpression(engine);
                else
                    pointerBack(engine.tokenizer);
                    flag := #f;
                end;
            end while;
        end if;
        
        closeTag(engine, "</expressionList>\n"); 
    end function;

    //---------------------------------Auxiliary functions---------------------------------//

    /**
     * Writes the appropriate tag in a Tokens file and a Tree file
     */
    define function writeXMLTag(engine :: <compilation-engine>, type :: <token-type>)
        let bodyTag = engine.tokenizer.currentToken;
        let nameTag = *reverseMap*[type];
        let CurrentTag = concatenate("<", nameTag, "> ",bodyTag, " </",nameTag, ">");
        for (i from 1 to engine.indentation)
            format(engine.printWriter, engine.width);
        end for;
        format(engine.printWriter, concatenate(CurrentTag, "\n"));
        format(engine.tokensPrintWriter, concatenate(engine.width, CurrentTag, "\n"));
    end function;

    /**
     * Writes the appropriate tag in a Tokens file and a Tree file
     */
    define function writeXMLTag2(engine :: <compilation-engine>, type :: <token-type>, bodyTag)
        let nameTag = *reverseMap*[type];
        let CurrentTag = concatenate("<", nameTag, "> ",bodyTag, " </",nameTag, ">");
        for (i from 1 to engine.indentation)
            format(engine.printWriter, engine.width);
        end for;
        format(engine.printWriter, concatenate(CurrentTag, "\n"));
        format(engine.tokensPrintWriter, concatenate(engine.width, CurrentTag, "\n"));
    end function;



/**
 * require symbol when we know there must be such symbol
 * @param symbol
 */
define function requireSymbol
(engine :: <compilation-engine>, symbol :: <string>)
    block (return)
      
        advance(engine.tokenizer);
        let type :: <token-type> = engine.tokenizer.currentTokenType;
        if (type == #"SYMBOL" & string-equal? (getSymbol(engine.tokenizer),symbol))
            writeXMLTag2(engine, type, symbol);
        else 
            throwError(engine, symbol);
            return();
        end;
    end;
end function;


    /**
     * throw an exception to report throwErrors
     * @param val is expected token missing
     */
    define function throwError(engine :: <compilation-engine>, val :: <string>)
        format-out(concatenate("Expected token missing: ",val,". Current token: ", engine.tokenizer.currentToken));
        force-out();
    end function;

    define function openTag(engine :: <compilation-engine>, tag :: <string>)
        for (i from 1 to engine.indentation)
            format(engine.printWriter, engine.width);
        end for;
        engine.indentation := engine.indentation + 1;
        format(engine.printWriter, tag);
    end function;


    define function closeTag(engine :: <compilation-engine>, tag :: <string>)
        engine.indentation := engine.indentation - 1;
        for (i from 1 to engine.indentation)
            format(engine.printWriter, engine.width);
        end for;
        format(engine.printWriter, tag);
    end function;