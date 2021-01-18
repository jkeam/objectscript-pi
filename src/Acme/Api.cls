Class Acme.Api Extends %CSP.REST
{
Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
    <Routes>
      <Route Url="/greetings/:name" Method="GET" Call="Greeting"/>
      <Route Url="/people" Method="GET" Call="GetPeople" />
      <Route Url="/people" Method="POST" Call="CreatePerson" Cors="false"/>
      <Route Url="/people/:id" Method="DELETE" Call="DeletePerson" Cors="false"/>
      <Route Url="/people/:id" Method="GET" Call="GetPerson" />
   </Routes>
}

/// Greet
ClassMethod Greeting(name As %String) As %Status
{
  #dim %response As %CSP.Response
  #dim tSC As %Status = $$$OK
  #dim e As %Exception.AbstractException
  Set result={}
  SET message = ##class(Acme.Utils).SayHi(name)
  do result.%Set("message", message)

  Set %response.Status = 200
  Set %response.ContentType = ..#CONTENTTYPEJSON
  Write result.%ToJSON()
  Quit tSC
}

/// Create person
ClassMethod CreatePerson() As %Status
{
  #dim %response As %CSP.Response
  #dim tSC As %Status = $$$OK
  try {
    Set jsonstring = $ZCONVERT(%request.Content.Read(),"I","UTF8")
    Set data = {}.%FromJSON(jsonstring)

    Set person=##class(Acme.Person).%New()
    Set person.Name = data.Name
    Set person.FavoriteColor = data.FavoriteColor
    Set sc = person.%Save()

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Write person.%JSONExport()
  }
  catch ex {
    Set result={}
    do result.%Set("Success", "false")
    Write result.%ToJSON()
  }
  Quit tSC
}

ClassMethod DeletePerson(id As %String) As %Status
{
  #dim %response As %CSP.Response
  #dim tSC As %Status = $$$OK
  try {
    Set sc = ##class(Acme.Person).%DeleteId(id)

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Set successResult={}
    If ($$$ISOK(sc)) {
      do successResult.%Set("Success", "true")
    } else {
      do successResult.%Set("Success", "false")
    }
    Write successResult.%ToJSON()
  }
  catch ex {
    Set result={}
    do result.%Set("Success", "false")
    Write result.%ToJSON()
  }
  Quit tSC
}

ClassMethod GetPerson(id As %String) As %Status
{
  #dim %response As %CSP.Response
  #dim tSC As %Status = $$$OK
  try {
    Set person = ##class(Acme.Person).%OpenId(id)

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Write person.%JSONExport()
  }
  catch ex {
    Set result={}
    do result.%Set("Success", "false")
    Write result.%ToJSON()
  }
  Quit tSC
}

ClassMethod GetPeople() As %Status
{
  #dim %response As %CSP.Response
  #dim tSC As %Status = $$$OK
  try {

    Set rset = ##class(Acme.Person).ExtentFunc()
    Write "["
    if rset.%Next() {
      Set person = ##class(Acme.Person).%OpenId(rset.%Get("Id"))
      Write person.%JSONExport()
    }
    while rset.%Next() {
      Write ","
      Set person = ##class(Acme.Person).%OpenId(rset.%Get("Id"))
      Write person.%JSONExport()
    }
    Write "]"
    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON
  }
  catch ex {
    Set result={}
    do result.%Set("Success", "false")
    Write result.%ToJSON()
  }
  Quit tSC
}

}
