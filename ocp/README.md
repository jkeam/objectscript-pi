# Running on OCP

## Installation

```
oc login
oc new-project iris

oc create serviceaccount useroot
oc adm policy add-scc-to-user anyuid -z useroot
```

Create Image Stream

```
oc apply -f ./build/0image_stream.yml
oc apply -f ./build/1build_config.yml
```


For ephemeral storage use:

```
cat ./1ephemeral_deployment.yml | sed "s/PROJECT/$(oc project -q)/" | oc apply -f -
```


For persistent storage, instead of the above, use:

```
oc apply -f ./0pvc.yml
cat ./1persistent_deployment.yml | sed "s/PROJECT/$(oc project -q)/" | oc apply -f -
```


Create service and route:

```
oc apply -f ./2service.yml
oc apply -f ./3route.yml
```

## Logging In

Navigate to:

```
echo "http://$(oc get route -o=jsonpath='{ .items[0].spec.host }')/csp/sys/%25CSP.Portal.Home.zen"
```

Default credentials are `_SYSTEM` and `SYS`.


## Using API
Hit endpoint with `curl`.

```
# Replace jon with any name
curl "http://$(oc get route -o=jsonpath='{ .items[0].spec.host }')/api/greetings/jon"
# {"message":"hi jon"}
```

## CLI
Connect to IRIS pod.
```
# open connection to pod
oc rsh $(oc get pods -o name --field-selector status.phase=Running -l app=iris | sed 's/pod\///')

# start a new iris session
iris session iris

# invoke the objectscript function
USER> write ##class(Acme.Utils).CalculatePi(50)

# type halt or h to quit the iris session
h

# exit to close connection with pod
exit
```
