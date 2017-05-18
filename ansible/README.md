###  Technical Components
     Vagrant     : environment creation & control  https://www.vagrantup.com & https://www.vagrantcloud.com
     Virtual Box : hypervisor                      https://www.virtualbox.org
     Ansible     : change mgmt, provisioning, automation & orchestration  http://docs.ansible.com

### Create VM(s) and install Ansible
     From command prompt run the following commands
     1. git clone https://github.com/dghadge/AutoNTier.git
     2. Create a new "Vagrantfile" or make changes to existing one depending on your needs
     3. Run : vagrant up     #this will start VM(s) in Vagrant file
     4. Run : vboxmanage list runningvms   #to list running VM(s)
     5. Run : vagrant ssh <vm>  #vm=acs,web,db in our case
     6. Run : sudo apt-get install ansible  #On Debian systems
     7. Run : sudo yum install epel-release; sudo yum install ansible #On CentOS systems

     Virtualbox VM(s) created using Vagrant
     acs : 192.168.33.10  ##Ansible Control Server
     web : 192.168.33.20  ##web server
     db  : 192.168.33.30  ##database host

### Setup Ansible on the VM(s) created in previous steps
     From command prompt run the following commands
     1. ssh vagrant acs  #to login to Ansible control server
     2. ssh vagrant@ip-address-of-web-server #this will add this host fingerprint to list of know hosts
     3. sudo apt-get install sshpass
     4. ansible 192.168.33.20 -i inventory -u vagrant -m ping -k      #ping remote system
     5. ansible all  -i inventory -u vagrant -m ping -k               #ping all remote systems
     6. ansible 192.168.33.20 -i inventory -u vagrant -m ping -k -vvv #verbose mode
     7. ansible 192.168.33.20 -i inventory -u vagrant -m command -a "/usr/sbin/yum/update -y"  #use command module to update 

### Use Ansible group and host variables to manage changes to VM(s)
     Ansible order of precedence for variables 
          1. (group_vars)all  
          2. (group_vars)GroupName
          3. (host_vars)HostName    # highest preference
     
     From command prompt run the following commands
     1. create inventory file "inventory-prod" consisting of hosts, groups and group variables of your system
     2. Run : ansible web1 -i inventory-prod -m ping           #ping individual server
     3. Run : ansible webservers -i inventory-prod -m ping     #ping group of servers
     4. Run : ansible datacenter -i inventory-prod -m ping     #ping entire datacenter
     5. Create directory structure and following files within those directories 
          ├── ansible.cfg
          ├── group_vars           #directory to hold group level variables
          │   ├── all
          │   ├── db
          │   └── webservers
          ├── host_vars            #directory to hold host level files
          │   └── web1
          └── inventory_prod
     6.  Create a varibale to entire group in groups_vars/all. To create username in all webservers run :
         ansible webservers -i inventory_prod -m user -a "name={{username}} password=12345" --sudo  
     7.  Create a varibale for specific host in host_vars/web1. To create username in that specific host run :
         ansible webservers -i inventory_prod -m user -a "name={{username}} password=12345" --sudo  

### Use Ansible config files to manage changes to VM(s)
     Ansible order of precedence for config settings
          1. $ANSIBLE_CONFIG   #first preference given to environment variable
          2. ./ansible.cfg
          3. ~/.ansible.cfg
          4./etc/ansible/ansible.cfg
     
     From command prompt run the following commands
     1. Remove hosts from ~/.ssh/know_hosts and run
        ansible web1 -i inventory_prod -m ping  ## will fail
     2. create ansible.cfg (with host_key_checking=False) in local directory (same dir where inventory file exists) and run
        ansible web1 -i inventory_prod -m ping  ## will pass and add host to know hosts file
     3. Again remove hosts from ~/.ssh/know_hosts. Run export ANSIBLE_HOST_KEY_CHECKING=True and run
        ansible web1 -i inventory_prod -m ping  ## will fail because exported variable took preference over ansible.cfg file

### Use Ansible behaviour parameter to run ansible on linux systems having python 3.x
     In the inventory file add the following parameter. Here 192.168.33.50 has python 3.x and python2.7 is in /usr/bin/python2.7
     192.168.33.50  ansible_python_interpreter=/usr/bin/python2.7

### Install and start web & db services
     1. ansible-doc -l or ansible-doc <module_name> or ansible-doc -s <module_name>    ##list documenation on modules
     2. Install webserver
        ansible webservers -i inventory_prod -m apt -a "pkg=apache2 state=present update_cache=yes" --sudo
        ansible webservers -i inventory_prod -m yum -a "name=httpd state=present" --sudo
     3. Start webserver
        ansible webservers -i inventory_prod -m service -a "name=apache2 enabled=yes state=started" --sudo
        ansible webservers -i inventory_prod -m service -a "name=httpd enabled=yes state=started" --sudo
     4. Install mysql server
        ansible dbservers -i inventory_prod -m apt -a "pkg=mysql-server state=present update_cache=yes" --sudo
        ansible dbservers -i inventory_prod -m yum -a "name=mysql-server state=present" --sudo
     5. Start mysql server
        ansible dbservers -i inventory_prod -m service -a "name=mysqld enabled=yes state=started" --sudo
     6. Stop firewall
        ansible webservers:dbservers -i inventory_prod -m service -a "name=iptables state=stopped" --sudo
     7. http://192.168.33.20 should give http 200 
     
### Query system/VM details 
     1. ansible web1 -i inventory_prod -m setup
     2. ansible web1 -i inventory_prod -m setup -a "filter=ansible_eth*"
     3. ansible web1 -i inventory_prod -m setup -a "filter=ansible_mount*"
     4. ansible all  -i inventory_prod -m setup --tree ./system-details    ##details will be dumped into dir system-details
    