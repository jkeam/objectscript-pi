Class acme.Math.Api Extends %CSP.REST
{
Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
    <Routes>
      <Route Url="/greetings/:name" Method="GET" Call="Greeting"/>
   </Routes> 
}

/// Greet
ClassMethod Greeting(name As %String) As %Status
{
  #dim %response As %CSP.Response
  #dim tSC As %Status = $$$OK
  #dim e As %Exception.AbstractException
  Set result={}
  SET message = ##class(acme.Math.Utils).SayHi(name)
  do result.%Set("message", message)

  Set %response.Status = 200
  Set %response.ContentType = ..#CONTENTTYPEJSON
  Write result.%ToJSON()
  Quit tSC
}

}