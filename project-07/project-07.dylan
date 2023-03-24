Module: project-07
Synopsis: 
Author: 
Copyright: 



/*
define function foo 
    (cmd :: <command-type>)
    select (cmd)
    #"ARITHMETIC"  => format-out(*lt*);
    #"PUSH" => format-out(*push-temp*);
    #"POP"  => format-out(*pop-temp*);
    end;
end;

*/
define function foo2()
    let writer = make(<code-writer-07>);
    write-push-pop(writer, #"POP", "static", 5);
    write-arithmetic(writer, "add");
end;

let writer = make(<code-writer-07>);



define function handle-single-file
    (vm-file :: <file-stream>)
    
    set-current-file-name(writer, name);

end function;


define function main
    (name :: <string>, arguments :: <vector>)
    if(arguments.size = 0)
        format-out("Missing argument!!!");
    end if;
    let path = arguments[0];
    let file = make(<file-stream>, locator: as(<file-locator>, path), direction: #"input");    
    format-out(arguments.size);
    foo2();


  exit-application(0);
end function main;

main(application-name(), application-arguments());
