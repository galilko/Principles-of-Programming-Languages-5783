Module: project-07
Synopsis: 
Author: 
Copyright: 




define function foo 
    (cmd :: <command-type>)
    select (cmd)
    #"ARITHMETIC"  => format-out(*lt*);
    #"PUSH" => format-out(*push-temp*);
    #"POP"  => format-out(*pop-temp*);
    end;
end;

define function foo2
    (cmd)
    let writer = make(<code-writer-07>);
    //write-push-pop(writer, #"POP", "temp", 5);
    write-arithmetic(writer, cmd);
end;




define function main
    (name :: <string>, arguments :: <vector>)
    let cmd = "eq";
    foo2(cmd);

  exit-application(0);
end function main;

main(application-name(), application-arguments());
