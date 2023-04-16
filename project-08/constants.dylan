Module: project-08
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

define variable *label* = "\n({label})\n\n";
define variable *goto* = "\n  @{label}\n  0; JMP            //   jump to {label}\n\n";
define variable *if-goto* = "\n  @SP               //   A = 0\n  M=M-1             //   ram[0] = ram[0]-1\n  A=M               //   A = ram[0]\n  D=M               //   D = ram[ram[0]]\n  @{label}\n  D;JNE             //   if (ram[ram[0]] != 0) jump to {label}\n\n";
define variable *call* = "\n// ++++++++++++++ CALL ++++++++++++++\n\n  // *** push return-address ***\n  @{nameOfFunction}$ReturnAddress{index}\n  D=A               //   D = {nameOfFunction}$ReturnAddress{index}\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[ram[0]] = {nameOfFunction}$ReturnAddress{index}\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n  // *** push LCL ***\n  @LCL              //   A = LCL\n  D=M               //   D = ram[LCL]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[ram[0]] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n  // *** push ARG ***\n  @ARG              //   A = ARG\n  D=M               //   D = ram[ARG]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[ram[0]] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n  // *** push THIS ***\n  @THIS             //   A = THIS\n  D=M               //   D = ram[THIS]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[ram[0]] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n  // *** push THAT ***\n  @THAT             //   A = THAT\n  D=M               //   D = ram[THAT]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[ram[0]] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n  // *** ARG = SP-n-5 ***\n  @SP               //   A = 0\n  D=M               //   D = ram[0]\n  @{numARG}\n  D=D-A             //   D = D-{numARG}\n  @5                //   A = 5\n  D=D-A             //   D = D-5\n  @ARG              //   A = ARG\n  M=D               //   ram[ARG] = D\n  // *** LCL = SP ***\n  @SP              //   A = 0\n  D=M              //   D = ram[0]\n  @LCL             //   A = LCL\n  M=D              //   ram[LCL] = ram[SP]\n  // *** goto g ***\n  @{nameOfFunction}\n  0;JMP            //   jump to {nameOfFunction}\n  // *** label return-address ***\n({nameOfFunction}$ReturnAddress{index})\n// ++++++++++++++ END CALL ++++++++++++++\n\n";
define variable *bootstrapping* = "\n// ++++++++++++++ BOOTSTRAPPING ++++++++++++++\n  // *** SP = 256 ***\n\n  @256\n  D=A\n  @SP\n  M=D\n  // *** call Sys.init ***\n\n  // push return-address\n  @Sys.init$RETURN0\n  D=A\n  @SP\n  A=M\n  M=D\n  @SP\n  M=M+1\n  // push LCL\n  @LCL\n  D=M\n  @SP\n  A=M\n  M=D\n  @SP\n  M=M+1\n\n  // push ARG\n  @ARG\n  D=M\n  @SP\n  A=M\n  M=D\n  @SP\n  M=M+1\n  // push THIS\n  @THIS\n  D=M\n  @SP\n  A=M\n  M=D\n  @SP\n  M=M+1\n  // push THAT\n  @THAT\n  D=M\n  @SP\n  A=M\n  M=D\n  @SP\n  M=M+1\n  // ARG = SP-n-5\n  @SP\n  D=M\n  @0\n  D=D-A\n  @5\n  D=D-A\n  @ARG\n  M=D\n  // LCL = SP\n  @SP\n  D=M\n  @LCL\n  M=D\n  @Sys.init\n  0;JMP\n(Sys.init$RETURN0)\n// ++++++++++++++ END BOOTSTRAPPING ++++++++++++++\n\n";
define variable *function* = "\n// ++++++++++++++ FUNCTION ++++++++++++++\n  // *** label {nameOfFunction} ***\n({nameOfFunction})\n  // *** initialize local variables ***\n  @{numberOfLocals}\n  D=A              //  D = {numberOfLocals}\n  @{nameOfFunction}_End\n  D;JEQ            //  if (numberOfLocals == 0) jump to {nameOfFunction}_End\n({nameOfFunction}_Loop)\n  @SP              //   A = 0\n  A=M              //   A = ram[0]\n  M=0              //   ram[ram[0]] = 0\n  @SP              //   A = 0\n  M=M+1            //   ram[0] = ram[0]+1\n  @{nameOfFunction}_Loop\n  D=D-1;JNE        //   if (numberOfLocals != 0) jump to {nameOfFunction}_Loop\n({nameOfFunction}_End)\n// ++++++++++++++ END FUNCTION ++++++++++++++\n\n";
define variable *return*
  = "\n"
  "// ++++++++++++++ RETURN ++++++++++++++\n"
  "// *** FRAME = LCL ***\n"
  "@LCL             //   A = LCL\n"
  "D=M              //   D = ram[LCL]\n"
  "\n"
  "// *** RET = *(FRAME-5) ***\n"
  "// *** RAM[13] = (LOCAL-5) ***\n"
  "@5               //   A = 5\n"
  "A=D-A            //   A = D-5\n"
  "D=M              //   D = ram[D-5]\n"
  "@13              //   A = 13\n"
  "M=D              //   ram[13] = D\n"
  "\n"
  "// ***[ *ARG = pop() ]***\n"
  "@SP              //   A = 0\n"
  "M=M-1            //   ram[0] = ram[0]-1\n"
  "A=M              //   A = ram[0]\n"
  "D=M              //   D = ram[ram[0]]\n"
  "@ARG             //   A = ARG\n"
  "A=M              //   A = ram[ARG]\n"
  "M=D              //   ram[ram[ARG]] = ram[ram[0]]\n"
  "\n"
  "// *** SP = ARG+1 ***\n"
  "@ARG             //   A = ARG\n"
  "D=M              //   D = ram[ARG]\n"
  "@SP              //   A = 0\n"
  "M=D+1            //   ram[SP] = ram[ARG]+1\n"
  "\n"
  "// *** THAT = *(FRAME-1) ***\n"
  "@LCL             //   A = LCL\n"
  "M=M-1            //   ram[LCL] = ram[LCL]-1\n"
  "A=M              //   A = ram[LCL]\n"
  "D=M              //   D = ram[ram[LCL]]\n"
  "@THAT            //   A = THAT\n"
  "M=D              //   A[THAT] = ram[ram[LCL]]\n"
  "\n"
  "// *** THIS = *(FRAME-2) ***\n"
  "@LCL             //   A = LCL\n"
  "M=M-1            //   ram[LCL] = ram[LCL]-1\n"
  "A=M              //   A = ram[LCL]\n"
  "D=M              //   D = ram[ram[LCL]]\n"
  "@THIS            //   A = THIS\n"
  "M=D              //   A[THIS] = ram[ram[LCL]]\n"
  "// *** ARG = *(FRAME-3) ***\n"
  "@LCL             //   A = LCL\n"
  "M=M-1            //   ram[LCL] = ram[LCL]-1\n"
  "A=M              //   A = ram[LCL]\n"
  "D=M              //   D = ram[ram[LCL]]\n"
  "@ARG             //   A = ARG\n"
  "M=D              //   A[ARG] = ram[ram[LCL]]\n"
  "\n"
  "// *** LCL = *(FRAME-4) ***\n"
  "@LCL             //   A = LCL\n"
  "M=M-1            //   ram[LCL] = ram[LCL]-1\n"
  "A=M              //   A = ram[LCL]\n"
  "D=M              //   D = ram[ram[LCL]]\n"
  "@LCL             //   A = LCL\n"
  "M=D              //   A[LCL] = ram[ram[LCL]]\n"
  "\n"
  "// *** goto RET ***\n"
  "@13              //   A = 13\n"
  "A=M              //   A = ram[13]\n"
  "0; JMP           //   jump to ram[ram[13]]\n"
  "// ++++++++++++++ END RETURN ++++++++++++++\n"
  "\n";

define constant <command-type>
    = one-of(#"ARITHMETIC", #"PUSH", #"POP",
        #"LABEL",
        #"GOTO",
        #"IF",
        #"FUNCTION",
        #"RETURN",
        #"CALL",
        #"NONE");
    
