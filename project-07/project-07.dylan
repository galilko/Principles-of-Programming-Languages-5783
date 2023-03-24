Module: project-07
Synopsis: 
Author: 
Copyright: 





let writer = make(<code-writer-07>);
let parser = make(<parser-07>);


define function translate-vm-file
    (vm-file :: <file-stream>)
    let line-number = 0;
    let line = #f;
    while ((line := read-line(s,on-end-of-stream: #f)))
        emitComment(writer, line, numberLine);
        // check if line is not comment
        if (~(starts-with?(line, "//")))
            set-current-command(parser, line);
            let command-type :: <command-type> = get-command-type(parser);
            select (command-type)
                #"ARITHMETIC" => write-arithmetic(writer, get-current-command(parser));
                #"PUSH", #"POP" => write-push-pop(writer, command-type, arg1(parser), arg2(parser));
            end select;
        end if;
    end while;
end function;


define function handle-single-file
    (vm-file :: <file-stream>)
    let file-name = first(split(last(split(as (<string>,file), "\\")),"."));
    set-current-file-name(writer, file-name);
    translateVmFile(vm-file);
    close(writer);
end function;


define function main
    (name :: <string>, arguments :: <vector>)

    if(arguments.size = 0)
        format-out("Missing argument!!!");
    end if;
    let path = arguments[0];
    let file = make(<file-stream>, locator: as(<file-locator>, path), direction: #"input");    
    handle-single-file(file);
  exit-application(0);

end function main;

main(application-name(), application-arguments());
