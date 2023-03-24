Module: parser-07
Synopsis: 
Author: 
Copyright: 

 define class <parser-07> (<object>)
  slot currentCommand :: <string>, init-value:"";
  slot file-input :: <file-stream>;
 end class;

 
 define function set-file-parser-07( file-name :: <string>);
        file-input := make(<file-stream>,locator: as(<file-locator>,file-name, direction: #"input"));
  end function;

 define function set-currentCommand( cmd :: <string>);
        currentCommand := first(split(as (<string>,cmd) ,"\\" ));
  end function;

  define function getCurrentCommand()=> (currentCommand :: <string>)
  end function;

  define function getCommandType() => (cmdType:: <command-type>)
        let cmdType = command-type.NONE;
         select (first(split(as (<string>,currentCommand) ," " )))
          "push" => cmdType = command-type.PUSH;
          "push" => cmdType = command-type.POP;
          "add","sub","neg","eq","gt","lt","and","or","not" => cmdType = command-type.ARITHMETIC;
  end function;
  
  define function arg1() =>(current :: <string>)
    let current = second(split(as (<string>,currentCommand) ," " ));
  end function;

  define function arg2() =>(current :: <string>)
    let current =  string-to-integer(third(split(as (<string>,currentCommand) ," " )));
  end function;


    





   




