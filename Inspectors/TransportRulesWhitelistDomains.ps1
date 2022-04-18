$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-TransportRulesWhitelistDomains {
Try {

	$domain_whitelist_rules = (Get-TransportRule | Where-Object { $_.SetSCL -AND ($_.SetSCL -as [int] -LE 0) -AND $_.SenderDomainIs }).Name
	
	If ($domain_whitelist_rules.Count -eq 0) {
		return $null
	}
	
	return $domain_whitelist_rules

}
Catch {
Write-Warning "Error message: $_"
$message = $_.ToString()
$exception = $_.Exception
$strace = $_.ScriptStackTrace
$failingline = $_.InvocationInfo.Line
$positionmsg = $_.InvocationInfo.PositionMessage
$pscommandpath = $_.InvocationInfo.PSCommandPath
$failinglinenumber = $_.InvocationInfo.ScriptLineNumber
$scriptname = $_.InvocationInfo.ScriptName
Write-Verbose "Write to log"
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $strace
Write-Verbose "Errors written to log"
}

}

return Inspect-TransportRulesWhitelistDomains


