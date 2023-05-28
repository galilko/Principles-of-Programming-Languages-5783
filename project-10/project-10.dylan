Module: project-10
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 


let compilationEngine = make(<compilation-engine>);

define function translate-jack-file
(jack-file :: <file-stream>, fileOut :: <file-stream>,  tokensFileOut :: <file-stream>)
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
            handle-single-file(jack-file, jack-path);
            close(jack-file);
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

    translate-jack-file(jack-file, fileOut, tokensFileOut);
    close(tokensFileOut);
    close(fileOut);  
end function;




define function main
    (name :: <string>, arguments :: <vector>)

    if(arguments.size = 0)
        format-out("Missing argument!!!");
    end if;
    
    let path = arguments[0];

    select (file-type(path))
        #"file" => 
            let jack-file = make(<file-stream>, locator: as(<file-locator>, path), direction: #"input");
            handle-single-file(jack-file, path);
            close(jack-file);
        #"directory" =>
            handle-directory(path);
    end select;
  exit-application(0);

end function main;

main(application-name(), application-arguments());
