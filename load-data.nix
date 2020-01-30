override:

(if builtins.pathExists <private/data>
 then import <private/data>
else {
  username = "jdoe";
  name = "John Doe";
  email = "john.doe@example.com";
  keys = {
    gpg = "";
  };
}) // override
