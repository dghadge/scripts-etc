Docker :

Build images : docker build -t dghadge/ticketservice . ###  Note "." at the end

List images : docker images

Delete images : docker rmi imgname:2.3

Pull images : docker pull imgname:2.3

Retag a local image with a new image name and tag : docker tag alpine:3.4 myrepo/myalpine:3.4  

Login to registry/dockerhub : docker login my.registry.com:8000 

Push an image to a registry : docker push myrepo/myalpine:3.4

Find IP : docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -q)

Attach terminal: docker exec -it $(docker ps -q) bash

docker run
--rm 		remove container automatically after it exits 
-it 		connect the container to terminal 
--name 	web 	name the container 
-p 	5000:80 	expose local port 5000 externally and map to port 80 
-v 	~/dev:/code	create a host mapped volume inside the container 
alpine:3.4 		the image from which the container is instantiated 
/bin/sh 		the command to run inside the container 

Stop a running container through SIGTERM : docker stop web

Stop a running container through SIGKILL : docker kill web

Delete all running and stopped containers : docker rm -f $(docker ps -aq)

Print the last 100 lines of a container’s logs : docker logs --tail 100 web
List networks : docker network ls
Create an overlay network and specify a subnet :
docker network create --subnet 10.1.0.0/24 --gateway 10.1.0.1 -d overlay mynet



Docker Machine(host)

Set machine environment : eval $(docker-machine env docker-machine-name)

Create machine : docker-machine create --driver amazonec2 --amazonec2-access-key AKIAQF3GQENLQ --amazonec2-secret-key ZYAf75i4uv+rhamUkTQZIUysLt1Z --amazonec2-region us-west-1 docker-machine-name

Login : docker-machine ssh docker-machine-name

List : docker-machine ls

Remove : docker-machine rm docker-machine-name

Restart : docker-machine restart docker-machine-name

Find IP : docker-machine ip docker-machine-name



Docker Swarm(Orchestration)

Init Swarm : docker swarm init --advertise-addr MANAGER_IP (for AWS its the public IP)

List Nodes : docker node ls

Join as worker command : docker swarm join-token worker

Join as manager command : docker swarm join-token manager

Join as worker(first login on worker) : 
docker swarm join — token SWMTKN-1–5mgyf6ehuc5pfbmar00njd3oxv8nmjhteejaald3yzbef7osl1-ad7b1k8k3bl3aa3k3q13zivqd 192.168.1.8:2377

Create Services : docker service create --replicas 5 -p 80:80 --name tickets dghadge/ticketingservice

List services : docker service ls

Services process : docker service ps tickets

Scale services : docker service scale tickets=8

Remove service : docker service rm tickets




