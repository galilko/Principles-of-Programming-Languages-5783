Module: project-10
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 


define function translate-jack-file
(jack-file :: <file-stream>, fileOut :: <file-stream>,  tokensFileOut :: <file-stream>)
    let compilationEngine = make(<compilation-engine>);
    create-compilation-engine(compilationEngine, jack-file, fileOut,  tokensFileOut);
    compileClass(compilationEngine);
end function;


define function handle-directory 
    (dir-path :: <string>)
    let files = directory-contents(dir-path);
    for (file in files)
        let jack-path = as(<string>, file);
        if (ends-with?(jack-path,".jack"))
            let jack-file = make(<file-stream>, locator: as(<file-locator>, jack-path), direction: #"input");
            //handle-single-file(tokensFileOut,fileOut, jack-file);
        end if;
    end for;
end function;


define function handle-single-file
    (jack-file :: <file-stream>, jack-path :: <string>)
    let file-name :: <string> = first(split(last(split(as (<string>,jack-path), "\\")),".jack"));
    let parent :: <string> = first(split(jack-path, concatenate(file-name,".jack")));

    let fileOutName = concatenate("My_",file-name,".xml");
    let tokensFileOutName = concatenate("My_",file-name,"T.xml");
    
    let fileOutPath = concatenate(parent, "\\", fileOutName);
    let tokensFileOutPath = concatenate(parent, "\\", tokensFileOutName);


    let fileOut = make(<file-stream>, locator: as(<file-locator>, fileOutPath) , direction: #"output");
    let tokensFileOut = make(<file-stream>, locator: as(<file-locator>, tokensFileOutPath), direction: #"output");


    //set-current-files-name(tokensFileOut , fileOut , file-name);
    translate-jack-file(jack-file, fileOut, tokensFileOut);
    close(tokensFileOut);
    close(fileOut);  
end function;

/*define function set-current-files-name(tokensFileOut :: <JackTokenizer>,fileOut :: <CompilationEngine>, file-name :: <string>)
        //writer.out := make(<file-stream>, locator: as(<file-locator>, concatenate(file-path, ".asm")), direction: #"output");
        //tokensFileOut.current-file-name := first(split(file-name,"."));
        format(tokensFileOut.out, concatenate("// ",concatenate(file-name,"T"),".xml\n\n"));
        
        //fileOut.current-file-name := first(split(file-name,"."));
        format(fileOut.out, concatenate("// ",file-name,".xml\n\n"));
  end function;
*/





define function main
    (name :: <string>, arguments :: <vector>)
    //C:/Users/Gal Gabay/AppData/Local/VirtualStore/Program Files (x86)/Open Dylan/bin/POPL/project-10/Main.jack
    /*if(arguments.size = 0)
        format-out("Missing argument!!!");
    end if;
    
    let path = arguments[0];*/
    let path = "C:\\Users\\Gal Gabay\\AppData\\Local\\VirtualStore\\Program Files (x86)\\Open Dylan\\bin\\POPL\\project-10\\Main.jack";
    //format-out(path);
    select (file-type(path))
        #"file" => 
            let jack-file = make(<file-stream>, locator: as(<file-locator>, path), direction: #"input");
            handle-single-file(jack-file, path);
        #"directory" =>
            handle-directory(path);
    end select;
  exit-application(0);

end function main;

main(application-name(), application-arguments());
