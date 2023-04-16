Module: project-07
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 







define function translate-vm-file
    (writer :: <code-writer-07>, vm-file :: <file-stream>, vm-path :: <string>)
    let parser = make(<parser-07>);
    with-open-file (s = as (<file-locator>, vm-path), direction: #"input")
        let line-number = 1;
        let line = #f;
        let asm-path = first(split(as (<string>,vm-path),"."));
        set-current-file-name(writer, asm-path);
        while ((line := read-line(s,on-end-of-stream: #f)))
            emit-comment(writer, line, line-number);
            // check if line is not comment
            if (line.size > 0 & ~(starts-with?(line, "//")))
                set-current-command(parser, line);
                let command-type :: <command-type> = get-command-type(parser);
                select (command-type)
                    #"ARITHMETIC" => write-arithmetic(writer, get-current-command(parser));
                    #"PUSH", #"POP" => write-push-pop(writer, command-type, arg1(parser), arg2(parser));
                end select;
            end if;
            line-number := line-number + 1;
        end while;
    end;
end function;



define function handle-directory 
    (writer :: <code-writer-07>, dir-path :: <string>)
    let files = directory-contents(dir-path);
    for (file in files)
        let vm-path = as(<string>, file);
        if (ends-with?(vm-path,".vm"))
            let vm-file = make(<file-stream>, locator: as(<file-locator>, vm-path), direction: #"input");
            handle-single-file(writer, vm-file, vm-path);
        end if;
    end for;
end function;


define function handle-single-file
    (writer :: <code-writer-07>, vm-file :: <file-stream>, vm-path :: <string>)
    let file-name = first(split(last(split(as (<string>,vm-path), "\\")),"."));
    set-current-file-name(writer, file-name);
    translate-vm-file(writer, vm-file, vm-path);
    close-file(writer);
end function;


define function main
    (name :: <string>, arguments :: <vector>)

    if(arguments.size = 0)
        format-out("Missing argument!!!");
    end if;
    let writer = make(<code-writer-07>);
    let path = arguments[0];
    select (file-type(path))
        #"file" => 
            let file = make(<file-stream>, locator: as(<file-locator>, path), direction: #"input");
            handle-single-file(writer, file, path);
        #"directory" =>
            handle-directory(writer, path);
    end select;
  exit-application(0);

end function main;

main(application-name(), application-arguments());
