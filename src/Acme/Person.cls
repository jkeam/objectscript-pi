Class Acme.Person Extends (%Persistent, %JSON.Adaptor)
{

Parameter %JSONENABLED = 1;

Parameter EXTENTQUERYSPEC = "Id,Name,FavoriteColor";

Property Id As %Integer [ Calculated, SqlComputeCode = { Set {*} = {%%ID} }, SqlComputed ];

/// Define an index for <property>Name</property>.
Index NameIDX On Name [ Data = Name ];

Property Name As %String(MAXLEN = 250) [ Required ];

Property FavoriteColor As %String(MAXLEN = 50);

Query ByName(name As %String = "") As %SQLQuery(CONTAINID = 1, SELECTMODE = "RUNTIME") [ SqlName = SP_Sample_By_Name, SqlProc ]
{
SELECT Id, Name, FavoriteColor
FROM Acme.Person
WHERE (Name %STARTSWITH :name)
ORDER BY Name
}

}
