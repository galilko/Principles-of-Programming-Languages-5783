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
define function foo2
    ()

    let writer = make(<code-writer-07>);
    write-push-pop(writer, #"POP", "static", 5);
    write-arithmetic(writer, "add");
end;



  define variable *segment-table* = make(<string-table>);
  *segment-table*["local"] := "LCL"; 
  *segment-table*["argument"] := "ARG";
  *segment-table*["this"] := "THIS";
  *segment-table*["that"] := "THAT";
  *segment-table*["temp"] := "5";

define function main
    (name :: <string>, arguments :: <vector>)
    foo2();


  exit-application(0);
end function main;

main(application-name(), application-arguments());
