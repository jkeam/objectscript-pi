Class Acme.Person Extends (%Persistent, %JSON.Adaptor)
{

Parameter %JSONENABLED = 1;

Parameter EXTENTQUERYSPEC = "Id,Name,FavoriteColor";

Property Id As %Integer [ Calculated, SqlComputeCode = { Set {*} = {%%ID} }, SqlComputed ];

/// Define an index for <property>Name</property>.
Index NameIDX On Name [ Data = Name ];

Property Name As %String(MAXLEN = 250) [ Required ];

Property FavoriteColor As %String(MAXLEN = 50);

}
