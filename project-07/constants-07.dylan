Module: project-07
Synopsis: 
Author: 
Copyright: 


define variable *add* = "\n@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=M               //   D = ram[A]\n@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=M+D             //   D = ram[A]+D\nM=D               //   ram[A] = D\n@SP               //   A = 0\nM=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *sub* = "\n@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=M               //   D = ram[A]\n@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=M-D             //   D = ram[A]-D\nM=D               //   ram[A] = D\n@SP               //   A = 0\nM=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *neg* = "\n@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=-M              //   D = -ram[A]\nM=D               //   ram[A] = D\n@SP               //   A = 0\nM=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *eq* = "\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M-D             //   D = ram[A]-D\n  @EQ.{index}_TRUE\n  D;JEQ             //   if D==0 jump to label of TRUE\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=0               //   ram[A] = 0\n  @EQ.{index}_END\n  0;JMP             //   jump to label of END\n(EQ.{index}_TRUE)\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=-1              //   ram[A] = -1\n(EQ.{index}_END)\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *gt* = "\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M-D             //   D = ram[A]-D\n  @GT.{index}_TRUE\n  D;JGT             //   if D>0 jump to label of TRUE\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=0               //   ram[A] = 0\n  @GT.{index}_END\n  0;JMP             //   jump to label of END\n(GT.{index}_TRUE)\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=-1              //   ram[A] = -1\n(GT.{index}_END)\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *lt* = "\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M-D             //   D = ram[A]-D\n  @LT.{index}_TRUE\n  D;JLT             //   if D<0 jump to label of TRUE\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=0               //   ram[A] = 0\n  @LT.{index}_END\n  0;JMP             //   jump to label of END\n(LT.{index}_TRUE)\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=-1              //   ram[A] = -1\n(LT.{index}_END)\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *and* = "\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=D&M             //   D = D&&ram[A]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *or* = "\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=D|M             //   D = D||ram[A]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *not* = "\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=!M              //   D = !ram[A]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *push-constant* = "\n  @{value}\n  D=A               //   D = {value}\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *push-lcl-arg-this-that* = "\n  @{index}\n  D=A               //   D = A (A=index=offset)\n  @{segment}\n  A=M+D             //   A = ram[{segment}]+D (D=index=offset)\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *pop-lcl-arg-this-that* = "\n  @SP               //   A = 0\n  A=M-1             //   A = ram[0]-1\n  D=M               //   D = ram[A]\n  @{segment}\n  A=M               //   A = ram[{segment}]\n  {index}M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M-1             //   ram[0] = ram[0]-1\n\n";
define variable *push-temp* = "\n  @{index}\n  A=A+1\n  A=A+1\n  A=A+1\n  A=A+1\n  A=A+1             //   A = index+5\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *pop-temp* = "\n  @SP               //   A = 0\n  A=M-1             //   A = ram[0]-1\n  D=M               //   D = ram[A]\n  @{index}\n  A=A+1\n  A=A+1\n  A=A+1\n  A=A+1\n  A=A+1             //   A = index+5\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M-1             //   ram[0] = ram[0]-1\n\n";
define variable *push-static* = "\n  @{index}\n  D=M               //   D = ram[{index}]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *pop-static* = "\n  @SP               //   A = 0\n  M=M-1             //   ram[0] = ram[0]-1\n  A=M               //   A = ram[0]\n  D=M               //   D = ram[A]\n  @{index}\n  M=D               //   ram[{index}] = D\n\n";
define variable *push-pointer* = "\n  @{index}\n  D=M               //   D = A[{index}]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n\n";
define variable *pop-pointer* = "\n  @SP               //   A = 0\n  A=M-1             //   A = ram[0]-1\n  D=M               //   D = ram[A]\n  @{index}\n  M=D               //   ram[{index}] = D\n  @SP               //   A = 0\n  M=M-1             //   ram[0] = ram[0]-1\n\n";

define constant <command-type>
    = one-of(#"ARITHMETIC", #"PUSH", #"POP", #"NONE");
        /*
        ,
        #"LABEL",
        #"GOTO",
        #"IF",
        #"FUNCTION",
        #"RETURN",
        #"CALL",
        #"NONE");*/
    






