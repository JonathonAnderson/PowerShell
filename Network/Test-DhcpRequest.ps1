Function Test-DhcpRequest
{    
    Param
    (
      [ValidatePattern("^(?i:[A-F|\d]{2}(?:[\W|_]?)){5}(?i:[A-F|\d]{2})$")]
      [ValidateLength(12,17)]
      [Parameter(Mandatory=$true)]
      [String]$ClientMacAddress
    )

}