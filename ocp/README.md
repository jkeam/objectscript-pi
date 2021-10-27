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

## Test

Navigate to:

```
echo "http://$(oc get route -o=jsonpath='{ .items[0].spec.host }')/csp/sys/%25CSP.Portal.Home.zen"
```

Default credentials are `_SYSTEM` and `SYS`.
