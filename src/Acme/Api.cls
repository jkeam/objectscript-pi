Class Acme.Api Extends %CSP.REST
{

Parameter Version = "1.0.0";
Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
    <Routes>
      <Route Url="/" Method="GET" Call="GetInfo" />
      <Route Url="/greetings/:name" Method="GET" Call="Greeting" />
      <Route Url="/people" Method="GET" Call="GetPeople" />
      <Route Url="/people" Method="POST" Call="CreatePerson" />
      <Route Url="/people/:id" Method="DELETE" Call="DeletePerson" />
      <Route Url="/people/:id" Method="GET" Call="GetPerson" />
   </Routes>
}

/// Get general information
ClassMethod GetInfo() As %Status
{
  #dim %response As %CSP.Response
  #dim tSC As %Status = $$$OK

  SET version = ..#Version
  SET info = {
    "Version": (version)
  }

  Set %response.Status = 200
  Set %response.ContentType = ..#CONTENTTYPEJSON
  Write info.%ToJSON()
  Quit tSC
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

/// Delete person
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

/// Get specific person
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

/// Get all the people
ClassMethod GetPeople() As %Status
{
  #dim %response As %CSP.Response
  #dim tSC As %Status = $$$OK
  try {

    Set results = []
    Set rs = ##class(%SQL.Statement).%ExecDirect(,"SELECT Id, Name, FavoriteColor FROM Acme.Person")
    Write rs.%Next()
    While rs.%Next() {
      Do results.%Push({
        "Id":              (rs.%Get("Id")),
        "Name":            (rs.%Get("Name")),
        "FavoriteColor":   (rs.%Get("FavoriteColor"))
      })
    }

    Write results.%ToJSON()
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
