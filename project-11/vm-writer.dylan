Module: project-11
Synopsis: 
Author: Gal Gabay & Nerya Barkasa
Copyright: 



define class <vm-writer> (<object>)
  slot out :: <file-stream>;
end class;



  define function create-writer(writer :: <vm-writer>, out-file :: <file-stream>)
        writer.out := out-file;
  end function;



    /**
     * writes a VM push command
     * @param segment
     * @param index
     */
define function write-push
(vmWriter :: <vm-writer>, segment :: <string>, index :: <integer>)
      writeCommand(vmWriter, "push",arg1: segment, arg2: integer-to-string(index));
end function;

    /**
     * writes a VM pop command
     * @param segment
     * @param index
     */
define function write-pop
(vmWriter :: <vm-writer>, segment :: <string>, index :: <integer>)
      writeCommand(vmWriter, "pop", arg1: segment, arg2: integer-to-string(index));
end function;

    /**
     * writes a VM arithmetic command
     * @param command
     */
define function write-arithmetic
(vmWriter :: <vm-writer>, command :: <string>)
      writeCommand(vmWriter, command);
end function;
    

    /**
     * writes a VM label command
     * @param label
     */
define function write-label
(vmWriter :: <vm-writer>, label :: <string>)
      writeCommand(vmWriter, "label", arg1: label);
end function;


    /**
     * writes a VM goto command
     * @param label
     */
define function write-goto
(vmWriter :: <vm-writer>, label :: <string>)
      writeCommand(vmWriter, "goto", arg1: label);
end function;

    /**
     * writes a VM if-goto command
     * @param label
     */
define function write-if
(vmWriter :: <vm-writer>, label :: <string>)
      writeCommand(vmWriter, "if-goto", arg1: label);
end function;


    /**
     * writes a VM call command
     * @param name
     * @param nArgs
     */
define function write-call
(vmWriter :: <vm-writer>, name :: <string>, nArgs :: <integer>)
      writeCommand(vmWriter, "call", arg1: name, arg2: integer-to-string(nArgs));
end function;


    /**
     * writes a VM function command
     * @param name
     * @param nLocals
     */
define function write-function
(vmWriter :: <vm-writer>, name :: <string>, nLocals :: <integer>)
      writeCommand(vmWriter, "function", arg1: name, arg2: integer-to-string(nLocals));
end function;


    /**
     * writes a VM return command
     */
define function write-return
(vmWriter :: <vm-writer>)
        writeCommand(vmWriter, "return");
end function;

    /**
     * write a VM command
     * @param cmd
     * @param arg1
     * @param arg2
     */
    define function writeCommand
    (vmWriter :: <vm-writer>, cmd :: <string>, #key arg1 :: <string> = "", arg2 :: <string> = "")
        //format-out("${width*Indentation}-----{ $cmd $arg1 $arg2 }-----")
        format(vmWriter.out, concatenate(cmd, " ", arg1, " ", arg2, "\n"));
    end function;

    /**
     * close the output file
     */
define function close-file
(vmWriter :: <vm-writer>)
      close(vmWriter.out);
end function;