Module: dylan-user

define library project-11
  use common-dylan;
  use io;
  use system;
  use strings;
  use collections;
  use regular-expressions;
end library project-11;

define module project-11
  use common-dylan;
  use format-out;
  use streams;
  use locators;
  use format;
  use file-system;
  use table-extensions, import: {<string-table>, tabling};
  use strings;
  use regular-expressions;
end module project-11;
