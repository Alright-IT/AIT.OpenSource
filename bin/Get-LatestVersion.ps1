#requires -Version 3.0 -Modules PowerShellGet

<#
		.SYNOPSIS
		Get the latest Version via PowerShellGet
	
		.DESCRIPTION
		Get the latest Version via PowerShellGet
	
		.EXAMPLE
		PS C:\> get-LatestVersion.ps1

		Get the latest Version via PowerShellGet

		.EXAMPLE
		PS C:\> get-LatestVersion.ps1 -Force

		Get and enforce the latest Version via PowerShellGet


		.PARAMETER Force
		Enforce the Update

		.NOTES
		Initial Helper
#>
[CmdletBinding(SupportsShouldProcess)]
param
(
	[Parameter(Position = 0)]
	[switch]$Force
)

PROCESS {
	if ($Force) {
		Update-Module -Name 'enatec.OpenSource' -Force
	} else {
		Update-Module -Name 'enatec.OpenSource'
	}
}

END {
	$null = (Get-Module -ListAvailable -Refresh)
}

