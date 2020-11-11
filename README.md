# Objectscript Demo

Objectscript demo that generates PI multiple times.

## Setup
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
