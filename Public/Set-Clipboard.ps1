#!/usr/bin/env powershell
#requires -Version 3.0

if (($PSVersionTable.PSVersion.Major) -lt '5') {
	<#
			PowerShell older then Version 5 is found!
	#>

	function Set-Clipboard {
		<#
				.SYNOPSIS
				Copy content to the Clipboard

				.DESCRIPTION
				Copy content to the Clipboard

				.PARAMETER Import
				Content to import to the Clipboard

				.EXAMPLE
				PS C:\> Set-Clipboard -Import $foo

				Description
				-----------
				It imports the content of the variable $foo to the Clipboard.

				.NOTES
				STA Mode only!

				.LINK
				Get-Clipboard
		#>

		param
		(
			[Parameter(Mandatory,
					ValueFromPipeline,
					Position = 0,
			HelpMessage = 'Content to import')]
			[ValidateNotNullOrEmpty()]
			[String]$Import
		)

		PROCESS {
			if ($Host.Runspace.ApartmentState -eq 'STA') {
				Add-Type -AssemblyName PresentationCore
				[Windows.Clipboard]::SetText($Import)
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
