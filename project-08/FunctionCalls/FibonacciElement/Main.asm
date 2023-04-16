// // This file is part of www.nand2tetris.org  (line 1)
// // and the book "The Elements of Computing Systems"  (line 2)
// // by Nisan and Schocken, MIT Press.  (line 3)
// // File name: projects/08/FunctionCalls/FibonacciElement/Main.vm  (line 4)
//   (line 5)
// // Computes the n'th element of the Fibonacci series, recursively.  (line 6)
// // n is given in argument[0].  Called by the Sys.init function   (line 7)
// // (part of the Sys.vm file), which also pushes the argument[0]   (line 8)
// // parameter before this code starts running.  (line 9)
//   (line 10)
// function Main.fibonacci 0  (line 11)

// ++++++++++++++ FUNCTION ++++++++++++++
  // *** label Main.fibonacci ***
(Main.fibonacci)
  // *** initialize local variables ***
  @0
  D=A              //  D = 0
  @Main.fibonacci_End
  D;JEQ            //  if (numberOfLocals == 0) jump to Main.fibonacci_End
(Main.fibonacci_Loop)
  @SP              //   A = 0
  A=M              //   A = ram[0]
  M=0              //   ram[ram[0]] = 0
  @SP              //   A = 0
  M=M+1            //   ram[0] = ram[0]+1
  @Main.fibonacci_Loop
  D=D-1;JNE        //   if (numberOfLocals != 0) jump to Main.fibonacci_Loop
(Main.fibonacci_End)
// ++++++++++++++ END FUNCTION ++++++++++++++

// push argument 0  (line 12)

  @0
  D=A               //   D = A (A=index=offset)
  @ARG
  A=M+D             //   A = ram[ARG]+D (D=index=offset)
  D=M               //   D = ram[A]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[A] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1

// push constant 2  (line 13)

  @2
  D=A               //   D = 2
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[A] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1

// lt                     // checks if n<2  (line 14)

  @SP               //   A = 0
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
  D=M               //   D = ram[A]
  @SP               //   A = 0
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
  D=M-D             //   D = ram[A]-D
  @LT.0_TRUE
  D;JLT             //   if D<0 jump to label of TRUE
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=0               //   ram[A] = 0
  @LT.0_END
  0;JMP             //   jump to label of END
(LT.0_TRUE)
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=-1              //   ram[A] = -1
(LT.0_END)
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1

// if-goto IF_TRUE  (line 15)

  @SP               //   A = 0
  M=M-1             //   ram[0] = ram[0]-1
  A=M               //   A = ram[0]
  D=M               //   D = ram[ram[0]]
  @C:\Users\Gal Gabay\AppData\Local\VirtualStore\Program Files (x86)\Open Dylan\bin\POPL\project-08\FunctionCalls\FibonacciElement\Main.IF_TRUE
  D;JNE             //   if (ram[ram[0]] != 0) jump to C:\Users\Gal Gabay\AppData\Local\VirtualStore\Program Files (x86)\Open Dylan\bin\POPL\project-08\FunctionCalls\FibonacciElement\Main.IF_TRUE

// goto IF_FALSE  (line 16)

  @C:\Users\Gal Gabay\AppData\Local\VirtualStore\Program Files (x86)\Open Dylan\bin\POPL\project-08\FunctionCalls\FibonacciElement\Main.IF_FALSE
  0; JMP            //   jump to C:\Users\Gal Gabay\AppData\Local\VirtualStore\Program Files (x86)\Open Dylan\bin\POPL\project-08\FunctionCalls\FibonacciElement\Main.IF_FALSE

// label IF_TRUE          // if n<2, return n  (line 17)

(C:\Users\Gal Gabay\AppData\Local\VirtualStore\Program Files (x86)\Open Dylan\bin\POPL\project-08\FunctionCalls\FibonacciElement\Main.IF_TRUE)

// push argument 0          (line 18)

  @0
  D=A               //   D = A (A=index=offset)
  @ARG
  A=M+D             //   A = ram[ARG]+D (D=index=offset)
  D=M               //   D = ram[A]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[A] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1

// return  (line 19)
// ++++++++++++++ RETURN ++++++++++++++
  // *** FRAME = LCL ***
  @LCL             //   A = LCL
  D=M              //   D = ram[LCL]

  // *** RET = *(FRAME-5) ***
  // *** RAM[13] = (LOCAL-5) ***
  @5               //   A = 5
  A=D-A            //   A = D-5
  D=M              //   D = ram[D-5]
  @13              //   A = 13
  M=D              //   ram[13] = D

  // ***[ *ARG = pop() ]***
  @SP//   A = 0
  M=M-1            //   ram[0] = ram[0]-1
  A=M              //   A = ram[0]
  D=M              //   D = ram[ram[0]]
  @ARG             //   A = ARG
  A=M              //   A = ram[ARG]
  M=D              //   ram[ram[ARG]] = ram[ram[0]]

  // *** SP = ARG+1 ***
  @ARG             //   A = ARG
  D=M              //   D = ram[ARG]
  @SP              //   A = 0
  M=D+1//   ram[SP] = ram[ARG]+1

  // *** THAT = *(FRAME-1) ***
  @LCL             //   A = LCL
  M=M-1            //   ram[LCL] = ram[LCL]-1
  A=M              //   A = ram[LCL]
  D=M              //   D = ram[ram[LCL]]
  @THAT            //   A = THAT
  M=D              //   A[THAT] = ram[ram[LCL]]

  // *** THIS = *(FRAME-2) ***
  @LCL             //   A = LCL
  M=M-1            //   ram[LCL] = ram[LCL]-1
  A=M              //   A = ram[LCL]
  D=M              //   D = ram[ram[LCL]]
  @THIS            //   A = THIS
  M=D              //   A[THIS] = ram[ram[LCL]]
  // *** ARG = *(FRAME-3) ***
  @LCL             //   A = LCL
  M=M-1            //   ram[LCL] = ram[LCL]-1
  A=M              //   A = ram[LCL]
  D=M              //   D = ram[ram[LCL]]
  @ARG             //   A = ARG
  M=D//   A[ARG] = ram[ram[LCL]]

  // *** LCL = *(FRAME-4) ***
  @LCL             //   A = LCL
  M=M-1            //   ram[LCL] = ram[LCL]-1
  A=M              //   A = ram[LCL]
  D=M              //   D = ram[ram[LCL]]
  @LCL             //   A = LCL
  M=D//   A[LCL] = ram[ram[LCL]]

  // *** goto RET ***
  @13              //   A = 13
  A=M              //   A = ram[13]
  0 JMP           //   jump to ram[ram[13]]
// ++++++++++++++ END RETURN ++++++++++++++

// label IF_FALSE         // if n>=2, returns fib(n-2)+fib(n-1)  (line 20)

(C:\Users\Gal Gabay\AppData\Local\VirtualStore\Program Files (x86)\Open Dylan\bin\POPL\project-08\FunctionCalls\FibonacciElement\Main.IF_FALSE)

// push argument 0  (line 21)

  @0
  D=A               //   D = A (A=index=offset)
  @ARG
  A=M+D             //   A = ram[ARG]+D (D=index=offset)
  D=M               //   D = ram[A]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[A] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1

// push constant 2  (line 22)

  @2
  D=A               //   D = 2
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[A] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1

// sub  (line 23)

@SP               //   A = 0
AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
D=M               //   D = ram[A]
@SP               //   A = 0
AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
D=M-D             //   D = ram[A]-D
M=D               //   ram[A] = D
@SP               //   A = 0
M=M+1             //   ram[0] = ram[0]+1

// call Main.fibonacci 1  // computes fib(n-2)  (line 24)

// ++++++++++++++ CALL ++++++++++++++

  // *** push return-address ***
  @Main.fibonacci$ReturnAddress0
  D=A               //   D = Main.fibonacci$ReturnAddress0
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = Main.fibonacci$ReturnAddress0
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** push LCL ***
  @LCL              //   A = LCL
  D=M               //   D = ram[LCL]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** push ARG ***
  @ARG              //   A = ARG
  D=M               //   D = ram[ARG]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** push THIS ***
  @THIS             //   A = THIS
  D=M               //   D = ram[THIS]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** push THAT ***
  @THAT             //   A = THAT
  D=M               //   D = ram[THAT]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** ARG = SP-n-5 ***
  @SP               //   A = 0
  D=M               //   D = ram[0]
  @1
  D=D-A             //   D = D-1
  @5                //   A = 5
  D=D-A             //   D = D-5
  @ARG              //   A = ARG
  M=D               //   ram[ARG] = D
  // *** LCL = SP ***
  @SP              //   A = 0
  D=M              //   D = ram[0]
  @LCL             //   A = LCL
  M=D              //   ram[LCL] = ram[SP]
  // *** goto g ***
  @Main.fibonacci
  0;JMP            //   jump to Main.fibonacci
  // *** label return-address ***
(Main.fibonacci$ReturnAddress0)
// ++++++++++++++ END CALL ++++++++++++++

// push argument 0  (line 25)

  @0
  D=A               //   D = A (A=index=offset)
  @ARG
  A=M+D             //   A = ram[ARG]+D (D=index=offset)
  D=M               //   D = ram[A]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[A] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1

// push constant 1  (line 26)

  @1
  D=A               //   D = 1
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[A] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1

// sub  (line 27)

@SP               //   A = 0
AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
D=M               //   D = ram[A]
@SP               //   A = 0
AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
D=M-D             //   D = ram[A]-D
M=D               //   ram[A] = D
@SP               //   A = 0
M=M+1             //   ram[0] = ram[0]+1

// call Main.fibonacci 1  // computes fib(n-1)  (line 28)

// ++++++++++++++ CALL ++++++++++++++

  // *** push return-address ***
  @Main.fibonacci$ReturnAddress1
  D=A               //   D = Main.fibonacci$ReturnAddress1
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = Main.fibonacci$ReturnAddress1
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** push LCL ***
  @LCL              //   A = LCL
  D=M               //   D = ram[LCL]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** push ARG ***
  @ARG              //   A = ARG
  D=M               //   D = ram[ARG]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** push THIS ***
  @THIS             //   A = THIS
  D=M               //   D = ram[THIS]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** push THAT ***
  @THAT             //   A = THAT
  D=M               //   D = ram[THAT]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[ram[0]] = D
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1
  // *** ARG = SP-n-5 ***
  @SP               //   A = 0
  D=M               //   D = ram[0]
  @1
  D=D-A             //   D = D-1
  @5                //   A = 5
  D=D-A             //   D = D-5
  @ARG              //   A = ARG
  M=D               //   ram[ARG] = D
  // *** LCL = SP ***
  @SP              //   A = 0
  D=M              //   D = ram[0]
  @LCL             //   A = LCL
  M=D              //   ram[LCL] = ram[SP]
  // *** goto g ***
  @Main.fibonacci
  0;JMP            //   jump to Main.fibonacci
  // *** label return-address ***
(Main.fibonacci$ReturnAddress1)
// ++++++++++++++ END CALL ++++++++++++++

// add                    // returns fib(n-1) + fib(n-2)  (line 29)

@SP               //   A = 0
AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
D=M               //   D = ram[A]
@SP               //   A = 0
AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
D=M+D             //   D = ram[A]+D
M=D               //   ram[A] = D
@SP               //   A = 0
M=M+1             //   ram[0] = ram[0]+1

// return  (line 30)
// ++++++++++++++ RETURN ++++++++++++++
  // *** FRAME = LCL ***
  @LCL             //   A = LCL
  D=M              //   D = ram[LCL]

  // *** RET = *(FRAME-5) ***
  // *** RAM[13] = (LOCAL-5) ***
  @5               //   A = 5
  A=D-A            //   A = D-5
  D=M              //   D = ram[D-5]
  @13              //   A = 13
  M=D              //   ram[13] = D

  // ***[ *ARG = pop() ]***
  @SP//   A = 0
  M=M-1            //   ram[0] = ram[0]-1
  A=M              //   A = ram[0]
  D=M              //   D = ram[ram[0]]
  @ARG             //   A = ARG
  A=M              //   A = ram[ARG]
  M=D              //   ram[ram[ARG]] = ram[ram[0]]

  // *** SP = ARG+1 ***
  @ARG             //   A = ARG
  D=M              //   D = ram[ARG]
  @SP              //   A = 0
  M=D+1//   ram[SP] = ram[ARG]+1

  // *** THAT = *(FRAME-1) ***
  @LCL             //   A = LCL
  M=M-1            //   ram[LCL] = ram[LCL]-1
  A=M              //   A = ram[LCL]
  D=M              //   D = ram[ram[LCL]]
  @THAT            //   A = THAT
  M=D              //   A[THAT] = ram[ram[LCL]]

  // *** THIS = *(FRAME-2) ***
  @LCL             //   A = LCL
  M=M-1            //   ram[LCL] = ram[LCL]-1
  A=M              //   A = ram[LCL]
  D=M              //   D = ram[ram[LCL]]
  @THIS            //   A = THIS
  M=D              //   A[THIS] = ram[ram[LCL]]
  // *** ARG = *(FRAME-3) ***
  @LCL             //   A = LCL
  M=M-1            //   ram[LCL] = ram[LCL]-1
  A=M              //   A = ram[LCL]
  D=M              //   D = ram[ram[LCL]]
  @ARG             //   A = ARG
  M=D//   A[ARG] = ram[ram[LCL]]

  // *** LCL = *(FRAME-4) ***
  @LCL             //   A = LCL
  M=M-1            //   ram[LCL] = ram[LCL]-1
  A=M              //   A = ram[LCL]
  D=M              //   D = ram[ram[LCL]]
  @LCL             //   A = LCL
  M=D//   A[LCL] = ram[ram[LCL]]

  // *** goto RET ***
  @13              //   A = 13
  A=M              //   A = ram[13]
  0 JMP           //   jump to ram[ram[13]]
// ++++++++++++++ END RETURN ++++++++++++++

