Module: code-writer-07
Synopsis: 
Author: 
Copyright: 

define function main
    (name :: <string>, arguments :: <vector>)
  format-out("Hello, world!\n");
  exit-application(0);
end function main;

main(application-name(), application-arguments());
