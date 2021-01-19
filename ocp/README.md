# Running on OCP

## Installation

```
oc login
oc new-project iris

oc create serviceaccount useroot
oc adm policy add-scc-to-user anyuid -z useroot

oc apply -f ./0pvc.yml
oc apply -f ./1deployment.yml
oc apply -f ./2service.yml
oc apply -f ./3route.yml
```

## Test

Navigate to:

```
echo "http://$(oc get route -o=jsonpath='{ .items[0].spec.host }')/csp/sys/%25CSP.Portal.Home.zen"
```

Default credentials are `_SYSTEM` and `SYS`.
