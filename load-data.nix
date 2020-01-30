override:

(if builtins.pathExists <private/data>
 then import <private/data>
else {
  username = "another";
  name = "A. N. Other";
  email = "another@example.com";
  keys = {
    gpg = "";
  };
}) // override
