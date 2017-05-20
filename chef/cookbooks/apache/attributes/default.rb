default["apache"]["sites"]["node1a"] = { "site_title" => "Node1A - Chef Node", "port" => 80, "domain" => "chefnode1a"}
default["apache"]["sites"]["node1b"] = { "site_title" => "Node1B - Ched Node", "port" => 80, "domain" => "chefnode1b"}
default["apache"]["sites"]["node1c"] = { "site_title" => "Node1C - Ched Node", "port" => 80, "domain" => "chefnode1C"}

case node["platform"]
when "centos"
    default["apache"]["package"] = "httpd"
when "ubuntu"
    default["apache"]["package"] = "apache2"
end

