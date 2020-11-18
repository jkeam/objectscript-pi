# Running on OCP

```
oc login
oc new-project iris

oc create serviceaccount useroot
oc adm policy add-scc-to-user anyuid -z useroot

oc apply -f ./1service.yml
oc apply -f ./2deployment.yml
oc apply -f ./2route.yml
```
