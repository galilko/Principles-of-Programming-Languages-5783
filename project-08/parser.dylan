Module: project-08
Synopsis: 
Author: 
Copyright: 

 define class <parser> (<object>)
  slot current-command :: <string>, init-value:"";
  //slot file-input :: <file-stream>;
 end class;

 /*
 define function set-file-parser(parser :: <parser>, file-name :: <string>)
      parser.file-input := make(<file-stream>,locator: as(<file-locator>,file-name), direction: #"input");
  end function;
*/
 define function set-current-command(parser :: <parser>, cmd :: <string>)
      parser.current-command := strip(first(split(as (<string>,cmd) ,"//" )));
  end function;

  define function get-current-command(parser :: <parser>)
      values(parser.current-command);
  end function;


  define function get-command-type(parser :: <parser>) => (cmd-type :: <command-type>)
        let cmd-type :: <command-type> = #"NONE";
        let cmd = first(split(as (<string>, parser.current-command) ,' '));
        select (cmd by \=)
          "push" => cmd-type := #"PUSH";
          "pop" => cmd-type := #"POP";
          "add","sub","neg","eq","gt","lt","and","or","not" => cmd-type := #"ARITHMETIC";
          "label" => cmd-type := #"LABEL";
          "goto" => cmd-type := #"GOTO";
          "if-goto" => cmd-type := #"IF";
          "call" => cmd-type := #"CALL";
          "return" => cmd-type := #"RETURN";
          "function" => cmd-type := #"FUNCTION";
        end select;
        values(cmd-type);
  end function;
  
  define function arg1(parser :: <parser>) => (current :: <string>)
    let current = second(split(as (<string>,parser.current-command) ,' '));
    values(strip(current));
  end function;

  define function arg2(parser :: <parser>) =>(current :: <integer>)
    
    let current = string-to-integer(strip(third(split(parser.current-command, ' '))));
    values(current);
  end function;


    





   




