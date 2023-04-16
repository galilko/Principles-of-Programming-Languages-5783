Module: dylan-user

define library project-08
  use common-dylan;
  use io;
  use system;
  use strings;
  use collections;
end library project-08;

define module project-08
  use common-dylan;
  use streams;
  use locators;
  use format;
  use file-system;
  use format-out;
  use table-extensions, import: {<string-table>};
  use strings;
end module project-08;
