Module: project-08
Synopsis: 
Author: 
Copyright: 


  define variable *segment-table* = make(<string-table>);
  *segment-table*["local"] := "LCL"; 
  *segment-table*["argument"] := "ARG";
  *segment-table*["this"] := "THIS";
  *segment-table*["that"] := "THAT";
  *segment-table*["temp"] := "5";

define class <code-writer> (<object>)
  slot eq-counter :: <integer>, init-value: 0;
  slot gt-counter :: <integer>, init-value: 0;
  slot lt-counter :: <integer>, init-value: 0;
  slot call-counter :: <integer>, init-value: 0;
  slot out :: <file-stream>;
  slot current-file-name :: <string>;
end class;



  define function create-writer(writer :: <code-writer>, file-path :: <string>)
        writer.out := make(<file-stream>, locator: as(<file-locator>, concatenate(file-path, ".asm")), direction: #"output");
        //writer.current-file-name := last(split(file-path, "/"));
  end function;

  define function set-current-file-name(writer :: <code-writer>, file-name :: <string>)
        //writer.out := make(<file-stream>, locator: as(<file-locator>, concatenate(file-path, ".asm")), direction: #"output");
        writer.current-file-name := first(split(file-name,"."));
        format(writer.out, concatenate("// ",file-name,".vm\n\n"));
  end function;

  define function write-arithmetic(writer :: <code-writer>, command :: <string>)
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


  define function write-push-pop(writer :: <code-writer>, command :: <command-type>, segment :: <string>, index :: <integer>)

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
                    "static" => format(writer.out, replace-substrings(*push-static*, "{index}", concatenate(writer.current-file-name, ".", integer-to-string(index))));
                end select;
           #"POP" => 
                select (segment by \=)
                    "local", "argument", "this", "that" => 
                        let s = "";
                        for (i from 1 to index)
                            s := concatenate(s, "A=A+1\n  ");
                        end for;
                        format(writer.out, replace-substrings(replace-substrings(*pop-lcl-arg-this-that*, "{index}", s), "{segment}", *segment-table*[segment]));
                    "temp" => format(writer.out, replace-substrings(*pop-temp*, "{index}", integer-to-string(index)));
                    "pointer" => 
                          select (index)
                              0 => format(writer.out, replace-substrings(*pop-pointer*, "{index}", "THIS"));
                              1 => format(writer.out, replace-substrings(*pop-pointer*, "{index}", "THAT"));
                          end select;
                    "static" => format(writer.out, replace-substrings(*pop-static*, "{index}", concatenate(writer.current-file-name, ".", integer-to-string(index))));
                end select;
        end select;
  end function;

  define function write-init(writer :: <code-writer>)
        format(writer.out, *bootstrapping*);
  end function;

  define function write-label(writer :: <code-writer>, label :: <string>)
        format(writer.out, replace-substrings(*label*, "{label}", concatenate(writer.current-file-name, ".", label)));
  end function;

  define function write-goto(writer :: <code-writer>, label :: <string>)
        format(writer.out, replace-substrings(*goto*, "{label}", concatenate(writer.current-file-name, ".", label)));
  end function;

  define function write-if-goto(writer :: <code-writer>, label :: <string>)
        format(writer.out, replace-substrings(*if-goto*, "{label}", concatenate(writer.current-file-name, ".", label)));
  end function;

  define function write-call(writer :: <code-writer>, function-name :: <string>, num-of-args :: <integer>)
        let call-cmd = *call*;
        call-cmd := replace-substrings(call-cmd, "{nameOfFunction}", function-name);
        call-cmd := replace-substrings(call-cmd, "{numARG}", integer-to-string(num-of-args));
        call-cmd := replace-substrings(call-cmd, "{index}", integer-to-string(writer.call-counter));
        writer.call-counter := writer.call-counter + 1;
        format(writer.out, call-cmd);
  end function;

  define function write-return(writer :: <code-writer>)
        format(writer.out, *return*);
  end function;

  define function write-function(writer :: <code-writer>, function-name :: <string>, num-of-locals :: <integer>)
        let function-cmd = *function*;
        function-cmd := replace-substrings(function-cmd, "{nameOfFunction}", function-name);
        function-cmd := replace-substrings(function-cmd, "{numberOfLocals}", integer-to-string(num-of-locals));
        format(writer.out, function-cmd);
  end function;

  define function emit-comment(writer :: <code-writer>, command :: <string>, number-line :: <integer>)
        format(writer.out, concatenate("// ", command, "  (line ", integer-to-string(number-line), ")\n"));
  end function;

  /**
   * Closes the output file.
   */
  define function close-file(writer :: <code-writer>)
        close(writer.out);
  end function;
