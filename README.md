# Objectscript Demo

Objectscript demo that generates PI multiple times.

## Setup


### Docker Compose
1.  In one terminal start docker-compose
```
docker-compose up --build
```

2. In another open a connection
```
docker-compose exec iris iris session iris
```

3. At the prompt call the function, here we are calculating pi 50 times
```
USER> write ##class(acme.Math.Utils).CalculatePi(50)
```

4.  You could also hit the API
```
curl http://localhost:52773/api/greetings/jon
# returns {"message":"hi josh"}
```

5.  Management URL is at
```
http://localhost:52773/csp/sys/%25CSP.Portal.Home.zen
username: _SYSTEM
password: SYS
```

### Docker
1.  Build and start container
```
cd objectscript-pi
PROJECT_ROOT=`pwd`

docker build -t objectscript-pi:latest .
docker run -d --name iris -p 1972 -p 52773 -p 53773 -v $PROJECT_ROOT:/irisdev/app -it objectscript-pi
```

2.  Run command
```
docker exec -it iris iris session iris

# at the prompt put in
USER>write ##class(acme.Math.Utils).CalculatePi(50)
```

3.  Stop and cleanup
```
docker stop iris
docker rm iris
```
