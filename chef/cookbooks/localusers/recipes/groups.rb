#
# Cookbook:: localusers
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

search(:groups, "*.*").each do |data|
   user data["id"] do
        uid data["uid"]
        members data["members"]   
   end
end
