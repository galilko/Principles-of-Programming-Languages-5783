Module: project-07
Synopsis: 
Author: 
Copyright: 

 define class <parser-07> (<object>)
  slot current-command :: <string>, init-value:"";
  //slot file-input :: <file-stream>;
 end class;

 /*
 define function set-file-parser-07(parser :: <parser-07>, file-name :: <string>)
      parser.file-input := make(<file-stream>,locator: as(<file-locator>,file-name), direction: #"input");
  end function;
*/

//Setter
 define function set-current-command(parser :: <parser-07>, cmd :: <string>)
      parser.current-command := first(split(as (<string>,cmd) ,"//" ));
  end function;

//Getter
  define function get-current-command(parser :: <parser-07>)
      values(parser.current-command);
  end function;

//COMMAND_TYPE - a constant representing the type of the current command
  define function get-command-type(parser :: <parser-07>) => (cmd-type :: <command-type>)
        let cmd-type :: <command-type> = #"NONE";
        let cmd = first(split(as (<string>, parser.current-command) ,' '));
        select (cmd by \=)
          "push" => cmd-type := #"PUSH";
          "pop" => cmd-type := #"POP";
          "add","sub","neg","eq","gt","lt","and","or","not" => cmd-type := #"ARITHMETIC";
        end select;
        values(cmd-type);
  end function;
  
  /**Return the first argument or current command.
      In the case of ARITHMETIC, the command itself (add, sub, etc.) is returned.
      Should not be called if the current command is RETURN.**/
  define function arg1(parser :: <parser-07>) => (current :: <string>)
    let current = second(split(as (<string>,parser.current-command) ,' '));
    values(current);
  end function;

/** 
    Return the second argument of current command.
    Should be called only if the current command is PUSH, POP, FUNCTION, or CALL.
**/
  define function arg2(parser :: <parser-07>) =>(current :: <integer>)
    
    let current = string-to-integer(third(split(parser.current-command, ' ')));
    values(current);
  end function;


    





   




