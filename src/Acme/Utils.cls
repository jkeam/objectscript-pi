Class Acme.Utils
{

ClassMethod Test() As %Status
{
    return "It works!"
}

ClassMethod SayHi(name) As %Status
{
    return "hello " _ name
}

ClassMethod Datetime() As %Status
{
    set stamp=$ZTIMESTAMP
    return "UTC date and time:   " _ $ZDATETIME(stamp,1,1,2)
}

// Implementation of BBP (https://en.wikipedia.org/wiki/Bailey%E2%80%93Borwein%E2%80%93Plouffe_formula)
ClassMethod CalculatePi(times) As %Status
{
    FOR i=0:1:times {
      set digits=120
      set sum=0
      FOR index=0:1:digits {
        set a=(1.0 / (16.0**index))
        set k=8.0 * index
        set b=(4.0 / (k + 1.0))
        set c=(2.0 / (k + 4.0))
        set d=(1.0 / (k + 5.0))
        set e=(1.0 / (k + 6.0))
        set f=(a * (b - c - d - e))
        set sum=sum + f
      }
      write i _ ": " _ sum,*12
    }
    return "Done!"
}

}
