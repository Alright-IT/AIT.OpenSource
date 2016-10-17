#!/usr/bin/env powershell
#requires -Version 2.0

if (($PSVersionTable.PSVersion.Major) -lt '5') {
	<#
			PowerShell older then Version 5 is found!
	#>

	function Get-Clipboard {
		<#
				.SYNOPSIS
				Get the actual content of the Clipboard

				.DESCRIPTION
				Get the actual content of the Clipboard

				.NOTES
				It works in PowerShell STA Mode only!

				.EXAMPLE
				PS C:\> $foo = (Get-Clipboard)

				Description
				-----------
				Get the content of the Clipboard and set it to the variable 'foo'

				.LINK
				Set-Clipboard
		#>

		[CmdletBinding()]
		param ()

		PROCESS {
			if ($Host.Runspace.ApartmentState -eq 'STA') {
				Add-Type -AssemblyName PresentationCore
				[Windows.Clipboard]::GetText()
			} else {
				Write-Warning -Message ('Run {0} with the -STA parameter to use this function' -f $Host.Name)
			}
		}
	}
} else {
	<#
			PowerShell 5, or newer is found!

			We do not need that function anymore ;-)

			Use the Build-In one instead...
	#>

	Write-Verbose -Message 'This function is only needed if PowerShell is older then 5!'
}
