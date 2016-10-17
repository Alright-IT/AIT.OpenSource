#requires -Version 3.0

<#
		.SYNOPSIS
		Check if a newer Version is availible via PowerShellGet
	
		.DESCRIPTION
		Check if a newer Version is availible via PowerShellGet
	
		.EXAMPLE
		PS C:\> Get-IsUpdateAvailible.ps1

		Check if a newer Version is availible via PowerShellGet
	
		.NOTES
		Initial Helper
#>
[CmdletBinding(SupportsShouldProcess)]
param ()

PROCESS {
	Update-Module -Name 'enatec.OpenSource' -WhatIf
}
