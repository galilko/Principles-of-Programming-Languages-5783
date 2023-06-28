Module: project-11
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 






    define class <jack-tokenizer> (<object>)
        slot currentToken :: <string>, init-value: "";
        slot currentTokenType  :: <token-type> , init-value: #"NONE";
        slot pointer  :: <integer>, init-value: 0;
        slot tokens  :: <stretchy-vector>, init-value: make(<stretchy-vector>);
    end class;

    


            
    define function generate-tokens(jack-tokenizer :: <jack-tokenizer>, jack-file :: <file-stream>)
        jack-tokenizer.pointer := 0;
        jack-tokenizer.tokens := make(<stretchy-vector>);
        let content = "";
        let line = #f;
        while ((line := read-line(jack-file, on-end-of-stream: #f)))
            if (~(starts-with? (strip(line), "/*") | starts-with? (strip(line), "*")))
                content := concatenate(content, line, "\n");
            end if;
        end;
        let preProcessed = as(<string>, content);
        preProcessed := noComments(preProcessed);
        // preProcessed := noBlockComments(preProcessed);
        preProcessed := strip(preProcessed);
        //format-out(preProcessed);

        let match :: false-or(<regex-match>) = regex-search($tokenPatterns, preProcessed);
        let i = 0;
        while (match)
            let token = match-group(match, 0);
            if (string-equal? (token, "do"))
                token := "do ";
            end if;
            add!(jack-tokenizer.tokens,token);
            preProcessed := replace-substrings(preProcessed, token, "",count: 1);
            match := regex-search($tokenPatterns, preProcessed);
        end;

       /*for (token in jack-tokenizer.tokens)
            format-out(token);
            format-out("\n");
            force-out();
        end;*/
    end function;


    /**
     * Do we have more tokens in the input?
     * @return
     */
    define function hasMoreTokens(tokenizer :: <jack-tokenizer>)
        tokenizer.pointer < tokenizer.tokens.size;
    end function;
   



    define function advance(tokenizer :: <jack-tokenizer>)
            //format-out(tokenizer.currentToken);
            //format-out(as(<string>, type));
            //force-out();
        if (hasMoreTokens(tokenizer))
            tokenizer.currentToken := tokenizer.tokens[tokenizer.pointer];
            tokenizer.pointer := tokenizer.pointer + 1;
        else
            format-out("No more tokens");
        end;

        if (regex-search(compile-regex($keywordReg), tokenizer.currentToken) & ~starts-with? (tokenizer.currentToken,"print"))
            tokenizer.currentTokenType := #"KEYWORD";
        elseif (regex-search(compile-regex($strReg), tokenizer.currentToken))
            tokenizer.currentTokenType := #"STRING_CONST";
        elseif (regex-search(compile-regex($symbolReg), tokenizer.currentToken))
            tokenizer.currentTokenType := #"SYMBOL";
        elseif (regex-search(compile-regex($idReg), tokenizer.currentToken))
            tokenizer.currentTokenType := #"IDENTIFIER";
        elseif (regex-search(compile-regex($intReg), tokenizer.currentToken))
            tokenizer.currentTokenType := #"INT_CONST";
        else
            format-out(concatenate("Unknown token:", tokenizer.currentToken));
        end;
    end function;


    /**
     * Returns the keyword which is the current token
     * Should be called only when tokenType() is KEYWORD
     * @return
     */
    define function getKeyword(tokenizer :: <jack-tokenizer>)
        if(tokenizer.currentTokenType == #"KEYWORD")
            values(*keywordMap*[tokenizer.currentToken]);
        else
            //format-out("Current token is not a keyword!");
            format-out("");
        end;
    end function;


    define function getSymbol(tokenizer :: <jack-tokenizer>)
        if(tokenizer.currentTokenType == #"SYMBOL")
            values(tokenizer.currentToken);
        else
            //format-out("Current token is not a symbol!");
            format-out("");
        end;
    end function;
    

    /**
     * Return the identifier which is the current token
     * should be called only when tokenType() is IDENTIFIER
     * @return
     */
    define function getIdentifier(tokenizer :: <jack-tokenizer>)
        if(tokenizer.currentTokenType == #"IDENTIFIER")
            values(tokenizer.currentToken);
        else
            format-out("Current token is not an identifier!");
        end;
    end function;


        /**
     * Returns the integer value of the current token
     * should be called only when tokenType() is INT_CONST
     * @return
     */
    define function getIntVal(tokenizer :: <jack-tokenizer>)
        if(tokenizer.currentTokenType == #"INT_CONST")
            values(string-to-integer(tokenizer.currentToken));
        else
            format-out("Current token is not an integer constant!");
        end;
    end function;


    /**
     * Returns the string value of the current token
     * without the double quotes
     * should be called only when tokenType() is STRING_CONST
     * @return
     */
    define function getStringVal(tokenizer :: <jack-tokenizer>)
        if(tokenizer.currentTokenType == #"STRING_CONST")
            strip(tokenizer.currentToken, test: curry(\=, '"'));
            //tokenizer.currentToken;
        else
            format-out("Current token is not a string constant!");
        end;
    end function;



    /**
     * move pointer back
     */
    define function pointerBack(tokenizer :: <jack-tokenizer>)
        if (tokenizer.pointer > 0)
            tokenizer.pointer := tokenizer.pointer - 1;
        else
            tokenizer.pointer := 0;
        end;
    end function;


    /**
     * return if current symbol is a op
     * @return
     */
    define function isOp(tokenizer :: <jack-tokenizer>)
       let ops :: <simple-vector> = #["+","-","*","/","|","<",">","=","&"];
        if (position(ops, getSymbol(tokenizer), test: \=))
            #t;
        else
            #f;
        end;
    end function;


    /**
     * Delete all block comment
     * @param strIn
     * @return
     */
    define function noBlockComments(strIn :: <string>)
        regex-replace(strIn, compile-regex("/\\*.*\\*/", dot-matches-all:#t), "");
    end function;


    /**
     * Delete all comments (String after "//" and "//" itself) from a String
     * @param strIn
     * @return
     */
    define function noComments(strIn :: <string>)
        regex-replace(strIn, compile-regex("//.*"), "");
    end function;






            
                   

