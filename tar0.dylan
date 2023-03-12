Module: tar0
Synopsis: 
Author: 
Copyright: 

define constant $max-mantissa-digits = 18;
define method atof
    (string :: <byte-string>,
     #key start :: <integer> = 0,
          end: finish :: <integer> = string.size)
 => (value :: <float>);
  let class = #f;
  let posn = start;
  let sign = 1;
  let mantissa = 0;
  let scale = #f;
  let exponent-sign = 1;
  let exponent = 0;
  let exponent-shift = 0;
  let digits = 0;

  // Parse the optional sign.
  if (posn < finish)
    let char = string[posn];
    if (char == '-')
      posn := posn + 1;
      sign := -1;
    elseif (char == '+')
      posn := posn + 1;
    end if;
  end if;

  block (return)
    block (parse-exponent)
      // Parse the mantissa.
      while (posn < finish)
        let char = string[posn];
        posn := posn + 1;
        if (char >= '0' & char <= '9')
          if (digits < $max-mantissa-digits)
            let digit = as(<integer>, char) - as(<integer>, '0');
            mantissa := generic-+(generic-*(mantissa, 10), digit);
            if (scale)
              scale := generic-*(scale, 10);
            end if;
          else
            // If we're after the decimal point, we can just ignore
            // the digit. If before, we have to remember that we've
            // been multiplied.
            if (~scale)
              exponent-shift := generic-+(exponent-shift, 1);
            end;
          end;
          digits := digits + 1;
        elseif (char == '.')
          if (scale)
            error("bogus float.");
          end if;
          scale := 1;
        elseif (char == 'e' | char == 'E')
          parse-exponent();
        elseif (char == 'd' | char == 'D')
          class := #"double";
          parse-exponent();
        elseif (char == 's' | char == 'S')
          class := #"single";
          parse-exponent();
        elseif (char == 'x' | char == 'X')
          class := #"extended";
          parse-exponent();
        else
          error("bogus float.");
        end if;
      end while;
      return();
    end block;

    // Parse the exponent.
    if (posn < finish)
      let char = string[posn];
      if (char == '-')
        exponent-sign := -1;
        posn := posn + 1;
      elseif (char == '+')
        posn := posn + 1;
      end if;

      while (posn < finish)
        let char = string[posn];
        if (char >= '0' & char <= '9')
          let digit = as(<integer>, char) - as(<integer>, '0');
          exponent := generic-+(generic-*(exponent, 10), digit);
        else
          error("bogus float");
        end if;
        posn := posn + 1;
      end while;
    end if;
  end block;

  exponent := generic-+(exponent, exponent-shift);

  // TODO: CORRECTNESS: Decide how to maintain precision and representation,
  // since we lose it here. (CMU used a ratio representation).
  // TODO: CORRECTNESS: Handle overflows reasonably gracefully.
  // TODO: CORRECTNESS: Note that we don't have extended floats.

  let (mantissa, base, scale)
    = select (class)
        #f          => values(as(<double-float>, mantissa),
                              as(<double-float>, 10),
                              as(<double-float>, scale | 1));
        #"single"   => values(as(<single-float>, mantissa),
                              as(<single-float>, 10),
                              as(<single-float>, scale | 1));
        #"double"   => values(as(<double-float>, mantissa),
                              as(<double-float>, 10),
                              as(<double-float>, scale | 1));
        #"extended" => values(as(<extended-float>, mantissa),
                              as(<extended-float>, 10),
                              as(<extended-float>, scale | 1));
      end;

  let result
    = if (exponent = 0)
        generic-/(mantissa, scale)
      else
        let scaled-mantissa = generic-/(mantissa, scale);
        // NOTE: Floating point exponentiation loses precision for some
        // surprisingly small exponents so we'll use successive multiplications.
        //---*** NOTE: Revisit this as it may be costly w.r.t. consing and
        //---*** there must be a better way (rationals?).
        local
          method power-of-10 () => (power :: <float>);
            let iterate?
              = select (base by instance?)
                  <single-float> => exponent > 15;
                  // Yes, <double-float> exponentiation is never accurate!
                  <double-float> => #t;
                  //---*** NOTE: We don't have <extended-float>s yet ...
                  <extended-float> => #t;
                end;
            if (iterate?)
              for (i from 1 below exponent)
                base := generic-*(base, 10.0)
              end;
              base
            else
              generic-^(base, exponent)
            end
          end method power-of-10;
        if (exponent-sign = 1)
          generic-*(scaled-mantissa, power-of-10())
        else
          generic-/(scaled-mantissa, power-of-10())
        end
      end;
  if (sign = -1)
    -result
  else
    result
  end if
end method atof;

define function HandleBuy  (ProductName :: <string>, Amount :: <integer>, Price :: <float>) => (string :: <string>)
concatenate("### BUY ", ProductName, " ###\n", float-to-string(Price * as(<single-float>,Amount)), "\n");
end function HandleBuy;

define function HandleSell  (ProductName :: <string>, Amount :: <integer>, Price :: <float>) => (string :: <string>)
concatenate("$$$ SELL ", ProductName, " $$$\n", float-to-string(Price * as(<single-float>,Amount)), "\n");
end function HandleSell;

define function analyze-file  (a :: <file-locator>, stream :: <stream>)
let totalBuy = 0;
let totalSell = 0;
with-open-file (s = a, direction: #"input")
        let line = #f;
        while ( (line := read-line(s,on-end-of-stream: #f)))
          if (starts-with?(line, "buy") | starts-with?(line, "sell"))
            let ProductName = second(split(line,' '));
            let Amount = string-to-integer(third(split(line,' ')));
            let Price = atof(last(split(line,' ')));
            if (starts-with?(line, "buy"))
              format(stream, HandleBuy(ProductName,Amount,Price));
              totalBuy := totalBuy + Price * as(<single-float>,Amount)
            end if;

            if (starts-with?(line, "sell"))
              format(stream,HandleSell(ProductName,Amount,Price));
              totalSell := totalSell + Price * as(<single-float>,Amount)
            end if;
          end if;  
        end while;
end;
values(totalBuy,totalSell);
end function analyze-file;

define function main () => ()
    format-out("Enter the path:\n");
    force-out();
    let path = read-line(*standard-input*);
    //"C:/Users/Gal Gabay/AppData/Local/VirtualStore/Program Files (x86)/Open Dylan/bin/tar0/file.txt";
    let inputA = concatenate(path, "/inputA.vm");
    let inputB = concatenate(path, "/inputB.vm");
    let dirs = split(path, '/');
    let workDir = last(dirs);
    let output = concatenate(path, concatenate("/", workDir ,".asm"));
    with-open-file(stream = output, direction: #"output")
      let a = as(<file-locator>, inputA);
      let b = as(<file-locator>, inputB);
      format(stream, "inputA\n");
      let (totalBuyA,totalSellA) = analyze-file(a, stream);
      format(stream, "inputB\n");
      let (totalBuyB,totalSellB) = analyze-file(b, stream);
      let totalBuy = float-to-string(totalBuyA + totalBuyB);
      let totalSell = float-to-string(totalSellA + totalSellB);
      format-out(concatenate("TOTAL BUY: ",totalBuy,"\n"));
      format-out(concatenate("TOTAL SELL: ",totalSell,"\n"));
      format(stream, concatenate("TOTAL BUY: ",totalBuy,"\n"));
      format(stream, concatenate("TOTAL SELL: ",totalSell,"\n"));
    end;
  
end function main;

begin
  main();
end
