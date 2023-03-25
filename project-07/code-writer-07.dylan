Module: project-07
Synopsis: 
Author: 
Copyright: 


  define variable *segment-table* = make(<string-table>);
  *segment-table*["local"] := "LCL"; 
  *segment-table*["argument"] := "ARG";
  *segment-table*["this"] := "THIS";
  *segment-table*["that"] := "THAT";
  *segment-table*["temp"] := "5";

define class <code-writer-07> (<object>)
  slot eq-counter :: <integer>, init-value: 0;
  slot gt-counter :: <integer>, init-value: 0;
  slot lt-counter :: <integer>, init-value: 0;
  //slot file-name :: <string>, init-value: "inputA.vm";
  slot out :: <file-stream>;
end class;



  define function set-current-file-name(writer :: <code-writer-07>, file-name :: <string>);
        writer.out := make(<file-stream>,locator: as(<file-locator>, concatenate(file-name, ".asm")), direction: #"output");
  end function;

  define function write-arithmetic(writer :: <code-writer-07>, command :: <string>)
        select (command by \=)
           "add" => format(writer.out, *add*);
           "sub" => format(writer.out, *sub*);
           "neg" => format(writer.out, *neg*);
           "eq"  => 
              format(writer.out, replace-substrings(*eq*, "{index}", integer-to-string(writer.eq-counter)));
              writer.eq-counter := writer.eq-counter + 1;
           "gt"  => 
             format(writer.out, replace-substrings(*gt*, "{index}", integer-to-string(writer.gt-counter)));
             writer.gt-counter := writer.gt-counter + 1;
           "lt"  => 
             format(writer.out, replace-substrings(*lt*, "{index}", integer-to-string(writer.lt-counter)));
             writer.lt-counter := writer.lt-counter + 1;
           "and" => format(writer.out, *and*);
           "or"  => format(writer.out, *or*);
           "not" => format(writer.out, *not*);
        end select;
  end function;


  define function write-push-pop(writer :: <code-writer-07>, command :: <command-type>, segment :: <string>, index :: <integer>)

  let file-name = "ddd";
        select (command)
           #"PUSH" => 
                select (segment by \=)
                    "constant" => format(writer.out, replace-substrings(*push-constant*, "{value}", integer-to-string(index)));
                    "local", "argument", "this", "that" => format(writer.out, replace-substrings(replace-substrings(*push-lcl-arg-this-that*, "{index}", integer-to-string(index)), "{segment}", *segment-table*[segment]));
                    "temp" => format(writer.out, replace-substrings(*push-temp*, "{index}", integer-to-string(index)));
                    "pointer" => 
                          select (index)
                              0 => format(writer.out, replace-substrings(*push-pointer*, "{index}", "THIS"));
                              1 => format(writer.out, replace-substrings(*push-pointer*, "{index}", "THAT"));
                          end select;
                    "static" => format(writer.out, replace-substrings(*push-static*, "{index}", concatenate(file-name, ".", integer-to-string(index))));
                end select;
           #"POP" => 
                select (segment by \=)
                    "local", "argument", "this", "that" => 
                        let s = "";
                        for (i from 0 to index)
                            s := concatenate(s, "A=A+1\n  ");
                        end for;
                        format(writer.out, replace-substrings(replace-substrings(*pop-lcl-arg-this-that*, "{index}", s), "{segment}", *segment-table*[segment]));
                    "temp" => format(writer.out, replace-substrings(*pop-temp*, "{index}", integer-to-string(index)));
                    "pointer" => 
                          select (index)
                              0 => format(writer.out, replace-substrings(*pop-pointer*, "{index}", "THIS"));
                              1 => format(writer.out, replace-substrings(*pop-pointer*, "{index}", "THAT"));
                          end select;
                    "static" => format(writer.out, replace-substrings(*pop-static*, "{index}", concatenate(file-name, ".", integer-to-string(index))));
                end select;
        end select;
  end function;


 define function emit-comment(writer :: <code-writer-07>, command :: <string>, number-line :: <integer>)
        format(writer.out, concatenate("// ", command, "  (line ", number-line, ")\n"));
  end function;

    /**
     * Closes the output file.
     */
    define function close-file(writer :: <code-writer-07>)
        close(writer.out);
    end function;
