Module: dylan-user

define library tar0
  use common-dylan;
  use io;
  use system;
  use strings;
  use big-integers;
  use generic-arithmetic;

end library tar0;

define module tar0
  use common-dylan;
  use format-out;
  use format;
  use strings;
  use standard-io;
  use streams;
  use locators;
  use file-system;
  use big-integers, prefix: "generic-", export: all;
end module tar0;
