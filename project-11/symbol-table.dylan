Module: project-11
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 



/**
 *  This module provides services for creating and using a symbol table.
 *  Recall that each symbol has a scope from which it is visible in the source code.
 *  The symbol table implements this abstraction by giving each symbol a running number (index) within the scope.
 *  The index starts at 0, increments by 1 each time an identifier is added to the table, and resets to 0 when starting a new scope.
 *  The following kinds of identifiers may appear in the symbol table:
 *  Static: Scope: class.
 *  Field: Scope: class.
 *  Argument: Scope: subroutine (method/function/constructor).
 *  Var: Scope: subroutine (method/function/constructor).
 *
 *  When compiling error-free Jack code, any identifier not found in the symbol table may be assumed to be a subroutine name or a class name.
 *  Since the Jack language syntax rules suffice for distinguishing between these two possibilities, and since no “linking” needs to be done by the compiler,
 *  there is no need to keep these identifiers in the symbol table.
 *
 *  Provides a symbol table abstraction.
 *  The symbol table associates the identifier names found in the program with identifier properties needed for compilation:
 *  type, kind, and running index. The symbol table for Jack programs has two nested scopes (class/subroutine).
 */

define class <symbol-table> (<object>)
    slot classSymbols :: <string-table> =  make(<string-table>);
    slot subroutineSymbols :: <string-table> =  make(<string-table>);
    slot indices = make(<string-table>);
end class;


    /**
     * constructor
     * starts a new class scope
     * resets the class's symbol table
     */
     define function init-symbol-table(symbolTable :: <symbol-table>)
        remove-all-keys!(symbolTable.classSymbols);
        symbolTable.indices := tabling(#"ARG" => 0, #"FIELD" => 0, #"STATIC" => 0, #"VAR" => 0);
    end function;

    /**
     * starts a new subroutine scope
     * resets the subroutine's symbol table
     */
    define function startSubroutine(symbolTable :: <symbol-table>)
        remove-all-keys!(symbolTable.subroutineSymbols);
        symbolTable.indices[#"VAR"] := 0;
        symbolTable.indices[#"ARG"] := 0;
    end function;

    /**
     * Defines a new identifier of a given name,type and kind
     * and assigns it a running index, STATIC and FIELD identifiers have a class scope,
     * while ARG and VAR identifiers have a subroutine scope
     * @param name of symbol - entry (key) in symbol table
     * @param type of symbol - int, char, boolean or class name
     * @param kind of symbol - ARG, VAR, STATIC and FIELD
     */
    define function defineId(symbolTable :: <symbol-table>, name :: <string>, type, kind :: <kind>)
        if (member? (kind, #[#"ARG", #"VAR", #"STATIC", #"FIELD"]))
            let index = symbolTable.indices[kind];
            let type-str = as(<string>, type); 
            let symbol = make(<my-symbol>);
            create-symbol(symbol, type-str,kind,index);
            symbolTable.indices[kind] := index + 1;
            if (kind == #"ARG" | kind == #"VAR")
                symbolTable.subroutineSymbols[name] := symbol;
            else
                symbolTable.classSymbols[name] := symbol;
            end;
        end;
    end function;
        

    /**
     * returns the number of variables of the given kind already defined in the current scope
     * @param kind
     * @return
     */
    define function varCount(symbolTable :: <symbol-table>, kind :: <kind>)
        values(symbolTable.indices[kind]);
    end function;

    /**
     * returns the kind of the named identifier in the current scope
     * if the identifier is unknown in the current scope returns NONE
     * @param name
     * @return
     */
    define function kindOf(symbolTable :: <symbol-table>, name :: <string>)
        let symbol = lookUp(symbolTable, name);
        if (~symbol)
            values(#"NONE")
        end if;
        values(getKind(symbol));
    end function;

    /**
     * returns the type of the named identifier in the current scope
     * @param name
     * @return
     */
define function typeOf
(symbolTable :: <symbol-table>, name :: <string>)
        let symbol = lookUp(symbolTable, name);
        if (~symbol) 
            #f;
        else
            getType(symbol);
        end;
end function;

    /**
     * returns the index assigned to the named identifier
     * @param name
     * @return
     */
define function indexOf
(symbolTable :: <symbol-table>, name :: <string>)
        let symbol = lookUp(symbolTable, name);
        if (symbol) 
            values(-1);
        end if;
        values(getIndex(symbol));
end function;



    /**
     * check if target symbol is exist
     * @param name
     * @return
     */
    define function lookUp(symbolTable :: <symbol-table>, name :: <string>)
        /**
         * Note! It is necessary to look in the symbol table of the function before the table of symbols of the class,
         * because the inner scoop should precede the outer scoop
         * (in case there is a variable in the class and a variable in the function that has the same name).
         */

        let value = #f;
        if (found?(element(symbolTable.subroutineSymbols, name, default: $unfound)))
            value := symbolTable.subroutineSymbols[name];
        elseif (found?(element(symbolTable.classSymbols, name, default: $unfound)))
            value := symbolTable.classSymbols[name];
        values(value);
            //throw new IllegalStateException("The name '$name' a is not in the table of symbols")
        end;
    end function;
