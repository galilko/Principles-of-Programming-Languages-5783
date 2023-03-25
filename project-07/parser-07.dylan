Module: project-07
Synopsis: 
Author: 
Copyright: 

 define class <parser-07> (<object>)
  slot current-command :: <string>, init-value:"";
  slot file-input :: <file-stream>;
 end class;

 
 define function set-file-parser-07(parser :: <parser-07>, file-name :: <string>);
      parser.file-input := make(<file-stream>,locator: as(<file-locator>,file-name, direction: #"input"));
  end function;

 define function set-current-command(parser :: <parser-07>, cmd :: <string>);
      parser.current-command := first(split(as (<string>,cmd) ,"//" ));
  end function;

  define function get-current-command(parser :: <parser-07>)
      values(parser.current-command)
  end function;


  define function get-command-type(parser :: <parser-07>) => (cmd-type :: <command-type>)
        let cmd-type = make(<command-type>);
        select (first(split(as (<string>,parser.current-command) ," ")))
          "push" => cmd-type := #"PUSH";
          "pop" => cmd-type := #"POP";
          "add","sub","neg","eq","gt","lt","and","or","not" => cmd-type := #"ARITHMETIC";
        end select;
        values(cmd-type);
  end function;
  
  define function arg1() =>(parser :: <parser-07>, current :: <string>)
    let current = second(split(as (<string>,parser.current-command) ," " ));
    values(current);
  end function;

  define function arg2() =>(parser :: <parser-07>, current :: <string>)
    let current =  string-to-integer(third(split(as (<string>,parser.current-command) ," " )));
    values(current);
  end function;


    





   




