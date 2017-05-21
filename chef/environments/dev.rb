name "dev"
description "dev environment"
cookbook "apache", "= 0.1.5"
override_attributes({
    "author" => {
        "name" => "dan ghadge"
    }
})
