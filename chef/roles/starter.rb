name "webserver"
description "An example Chef role"
run_list "recipe[apache]", "recipe[localusers]"
override_attributes({
  "starter_name" => "Dan Ghadge",
})
