Module: project-07
Synopsis: 
Author: 
Copyright: 


define variable *add* = "@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=M               //   D = ram[A]\n@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=M+D             //   D = ram[A]+D\nM=D               //   ram[A] = D\n@SP               //   A = 0\nM=M+1             //   ram[0] = ram[0]+1\n";
define variable *sub* = "@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=M               //   D = ram[A]\n@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=M-D             //   D = ram[A]-D\nM=D               //   ram[A] = D\n@SP               //   A = 0\nM=M+1             //   ram[0] = ram[0]+1\n";
define variable *neg* = "@SP               //   A = 0\nAM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\nD=-M              //   D = -ram[A]\nM=D               //   ram[A] = D\n@SP               //   A = 0\nM=M+1             //   ram[0] = ram[0]+1\n";
define variable *eq* = "  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M-D             //   D = ram[A]-D\n  @EQ.{index}_TRUE\n  D;JEQ             //   if D==0 jump to label of TRUE\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=0               //   ram[A] = 0\n  @EQ.{index}_END\n  0;JMP             //   jump to label of END\n(EQ.{index}_TRUE)\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=-1              //   ram[A] = -1\n(EQ.{index}_END)\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *gt* = "  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M-D             //   D = ram[A]-D\n  @GT.{index}_TRUE\n  D;JGT             //   if D>0 jump to label of TRUE\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=0               //   ram[A] = 0\n  @GT.{index}_END\n  0;JMP             //   jump to label of END\n(GT.{index}_TRUE)\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=-1              //   ram[A] = -1\n(GT.{index}_END)\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *lt* = "  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M-D             //   D = ram[A]-D\n  @LT.{index}_TRUE\n  D;JLT             //   if D<0 jump to label of TRUE\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=0               //   ram[A] = 0\n  @LT.{index}_END\n  0;JMP             //   jump to label of END\n(LT.{index}_TRUE)\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=-1              //   ram[A] = -1\n(LT.{index}_END)\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *and* = "  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=D&M             //   D = D&&ram[A]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *or* = "  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=D|M             //   D = D||ram[A]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *not* = "  @SP               //   A = 0\n  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1\n  D=!M              //   D = !ram[A]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *push-constant* = "  @{value}\n  D=A               //   D = {value}\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *push-lcl-arg-this-that* = "  @{index}\n  D=A               //   D = A (A=index=offset)\n  @{segment}\n  A=M+D             //   A = ram[{segment}]+D (D=index=offset)\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *pop-lcl-arg-this-that* = "  @SP               //   A = 0\n  A=M-1             //   A = ram[0]-1\n  D=M               //   D = ram[A]\n  @{segment}\n  A=M               //   A = ram[{segment}]\n  {index}M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M-1             //   ram[0] = ram[0]-1\n";
define variable *push-temp* = "  @{index}\n  A=A+1\n  A=A+1\n  A=A+1\n  A=A+1\n  A=A+1             //   A = index+5\n  D=M               //   D = ram[A]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *pop-temp* = "  @SP               //   A = 0\n  A=M-1             //   A = ram[0]-1\n  D=M               //   D = ram[A]\n  @{index}\n  A=A+1\n  A=A+1\n  A=A+1\n  A=A+1\n  A=A+1             //   A = index+5\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M-1             //   ram[0] = ram[0]-1\n";
define variable *push-static* = "  @{index}\n  D=M               //   D = ram[{index}]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *pop-static* = "  @SP               //   A = 0\n  M=M-1             //   ram[0] = ram[0]-1\n  A=M               //   A = ram[0]\n  D=M               //   D = ram[A]\n  @{index}\n  M=D               //   ram[{index}] = D\n";
define variable *push-pointer* = "  @{index}\n  D=M               //   D = A[{index}]\n  @SP               //   A = 0\n  A=M               //   A = ram[0]\n  M=D               //   ram[A] = D\n  @SP               //   A = 0\n  M=M+1             //   ram[0] = ram[0]+1\n";
define variable *pop-pointer* = "  @SP               //   A = 0\n  A=M-1             //   A = ram[0]-1\n  D=M               //   D = ram[A]\n  @{index}\n  M=D               //   ram[{index}] = D\n  @SP               //   A = 0\n  M=M-1             //   ram[0] = ram[0]-1\n";

define constant <command-type>
    = one-of(#"ARITHMETIC", #"PUSH", #"POP");
        /*
        ,
        #"LABEL",
        #"GOTO",
        #"IF",
        #"FUNCTION",
        #"RETURN",
        #"CALL",
        #"NONE");*/
    





/*
define variable *sub* = """
  @SP               //   A = 0                           
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
  D=M               //   D = ram[A]                      
  @SP               //   A = 0                           
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1 
  D=M-D             //   D = ram[A]-D                    
  M=D               //   ram[A] = D                      
  @SP               //   A = 0                           
  M=M+1             //   ram[0] = ram[0]+1               

"""

 define variable *neg* = """
  @SP               //   A = 0                           
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1  
  D=-M              //   D = -ram[A]                      
  M=D               //   ram[A] = D                           
  @SP               //   A = 0  
  M=M+1             //   ram[0] = ram[0]+1                    

"""

define variable *eq* = """
  @SP               //   A = 0                          
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
  D=M               //   D = ram[A]                    
  @SP               //   A = 0                     
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1                          
  D=M-D             //   D = ram[A]-D              
  @EQ.{index}_TRUE  
  D;JEQ             //   if D==0 jump to label of TRUE
  @SP               //   A = 0                          
  A=M               //   A = ram[0]
  M=0               //   ram[A] = 0                     
  @EQ.{index}_END                             
  0;JMP             //   jump to label of END
(EQ.{index}_TRUE)                      
  @SP               //   A = 0                               
  A=M               //   A = ram[0]  
  M=-1              //   ram[A] = -1
(EQ.{index}_END)    
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1

"""

define variable *gt* = """
  @SP               //   A = 0                            
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1  
  D=M               //   D = ram[A]                       
  @SP               //   A = 0                            
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1  
  D=M-D             //   D = ram[A]-D                     
  @GT.{index}_TRUE          
  D;JGT             //   if D>0 jump to label of TRUE    
  @SP               //   A = 0                            
  A=M               //   A = ram[0]                       
  M=0               //   ram[A] = 0                       
  @GT.{index}_END         
  0;JMP             //   jump to label of END             
(GT.{index}_TRUE)                            
  @SP               //   A = 0                            
  A=M               //   A = ram[0]                       
  M=-1              //   ram[A] = -1                      
(GT.{index}_END)                              
  @SP               //   A = 0                            
  M=M+1             //   ram[0] = ram[0]+1                

"""

define variable *lt* = """
  @SP               //   A = 0                          
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
  D=M               //   D = ram[A]                     
  @SP               //   A = 0                          
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
  D=M-D             //   D = ram[A]-D                   
  @LT.{index}_TRUE        
  D;JLT             //   if D<0 jump to label of TRUE   
  @SP               //   A = 0                          
  A=M               //   A = ram[0]                     
  M=0               //   ram[A] = 0                     
  @LT.{index}_END        
  0;JMP             //   jump to label of END           
(LT.{index}_TRUE)                          
  @SP               //   A = 0                          
  A=M               //   A = ram[0]                     
  M=-1              //   ram[A] = -1                    
(LT.{index}_END)                            
  @SP               //   A = 0                          
  M=M+1             //   ram[0] = ram[0]+1              

"""

define variable *and* = """
  @SP               //   A = 0                            
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1  
  D=M               //   D = ram[A]                       
  @SP               //   A = 0                            
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1  
  D=D&M             //   D = D&&ram[A]                     
  M=D               //   ram[A] = D        
  @SP               //   A = 0     
  M=M+1             //   ram[0] = ram[0]+1

"""

define variable *or* = """
  @SP               //   A = 0                           
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1 
  D=M               //   D = ram[A]                      
  @SP               //   A = 0                           
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1 
  D=D|M             //   D = D||ram[A]                   
  M=D               //   ram[A] = D                      
  @SP               //   A = 0                           
  M=M+1             //   ram[0] = ram[0]+1               

"""

define variable *not* = """
  @SP               //   A = 0                          
  AM=M-1            //   A = ram[0]-1, ram[0] = ram[0]-1
  D=!M              //   D = !ram[A]                     
  M=D               //   ram[A] = D                          
  @SP               //   A = 0
  M=M+1             //   ram[0] = ram[0]+1                 

"""

define variable *push-constant* = """
  @{value}                                   
  D=A               //   D = {value}
  @SP               //   A = 0                     
  A=M               //   A = ram[0]                          
  M=D               //   ram[A] = D
  @SP               //   A = 0                  
  M=M+1             //   ram[0] = ram[0]+1                     
                                             
"""

define variable *push-lcl-arg-this-that* = """
  @{index}                        
  D=A               //   D = A (A=index=offset)  
  @{segment}                               
  A=M+D             //   A = ram[{segment}]+D (D=index=offset)                          
  D=M               //   D = ram[A]  
  @SP               //   A = 0                    
  A=M               //   A = ram[0]                       
  M=D               //   ram[A] = D                            
  @SP               //   A = 0               
  M=M+1             //   ram[0] = ram[0]+1 

"""

define variable *pop-lcl-arg-this-that* = """
  @SP               //   A = 0              
  A=M-1             //   A = ram[0]-1           
  D=M               //   D = ram[A]  
  @{segment}        
  A=M               //   A = ram[{segment}]             
  {index}M=D               //   ram[A] = D      
  @SP               //   A = 0             
  M=M-1             //   ram[0] = ram[0]-1

"""

define variable *push-temp* = """
  @{index}
  A=A+1
  A=A+1
  A=A+1
  A=A+1
  A=A+1             //   A = index+5
  D=M               //   D = ram[A]
  @SP               //   A = 0             
  A=M               //   A = ram[0]        
  M=D               //   ram[A] = D        
  @SP               //   A = 0             
  M=M+1             //   ram[0] = ram[0]+1 

"""

define variable *pop-temp* = """
  @SP               //   A = 0
  A=M-1             //   A = ram[0]-1  
  D=M               //   D = ram[A]    
  @{index}
  A=A+1
  A=A+1
  A=A+1
  A=A+1
  A=A+1             //   A = index+5
  M=D               //   ram[A] = D
  @SP               //   A = 0
  M=M-1             //   ram[0] = ram[0]-1

"""

define variable *push-static* = """
  @{index}
  D=M               //   D = ram[{index}]
  @SP               //   A = 0
  A=M               //   A = ram[0]
  M=D               //   ram[A] = D
  @SP               //   A = 0  
  M=M+1             //   ram[0] = ram[0]+1

"""

 define variable *pop-static* = """
  @SP               //   A = 0         
  M=M-1             //   ram[0] = ram[0]-1              
  A=M               //   A = ram[0]         
  D=M               //   D = ram[A]         
  @{index}                     
  M=D               //   ram[{index}] = D  

"""

 define variable *push-pointer* = """
  @{index}
  D=M               //   D = A[{index}]
  @SP               //   A = 0            
  A=M               //   A = ram[0]
  M=D               //   ram[A] = D       
  @SP               //   A = 0                      
  M=M+1             //   ram[0] = ram[0]+1         

"""

 define variable *pop-pointer* = """
  @SP               //   A = 0            
  A=M-1             //   A = ram[0]-1       
  D=M               //   D = ram[A]       
  @{index}                
  M=D               //   ram[{index}] = D            
  @SP               //   A = 0 
  M=M-1             //   ram[0] = ram[0]-1

"""
*/
