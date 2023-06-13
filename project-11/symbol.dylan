Module: project-11
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 


define constant <kind>
    = one-of(#"STATIC", #"FIELD", #"ARG", #"VAR", #"NONE");


define class <my-symbol>(<object>)
    slot type :: <string>, init-value: "";
    slot kind :: <kind>, init-value: #"NONE";
    slot index :: <integer>, init-value: 0;
end class;
    /**
     * Constructor
     * @param type
     * @param kind
     * @param index
     */
define function create-symbol
(symbol :: <my-symbol>, type, kind, index)
        symbol.type := type;
        symbol.kind := kind;
        symbol.index := index;
end function;

    /**
     * Getter
     * @return type of Symbol
     */
define function getType
(symbol :: <my-symbol>) 
    values(symbol.type);
end function;    

    /**
     * Getter
     * @return kind of Symbol
     */
define function getKind
(symbol :: <my-symbol>) 
    values(symbol.kind);
end function;

    /**
     * Getter
     * @return index of Symbol
     */
define function getIndex
(symbol :: <my-symbol>)
     values(symbol.index);
end function;

define function toString
(symbol :: <my-symbol>) 
        values(concatenate("Symbol{type=", symbol.type, " kind=", symbol.kind, " index=", symbol.index,"}"));
end function;
