#!/usr/bin/env powershell
#requires -Version 3.0

if (($PSVersionTable.PSVersion.Major) -lt '5') {
	<#
			PowerShell older then Version 5 is found!
	#>

	function Expand-CompressedItem {
		<#
				.SYNOPSIS
				It expands a compressed archive or container.

				.DESCRIPTION
				It expands a compressed archive or container.

				Currently only ZIP files are supported.
				Per default, the content of the ZIP is expanded in the current directory.
				If an item already exists, you will be visually prompted to overwrite it, skip it, or to have a second copy of the item expanded.
				This is due to the mechanism how this is implemented (via Shell.Application).

				.PARAMETER InputObject
				It specifies the archive to expand. You can either pass this parameter as a path and name to the archive or as a FileInfo object.
				You can also pass an array of archives to the parameter.
				In addition, you can pipe a single archive or an array of archives to this parameter as well.

				.PARAMETER Path
				It specifies the destination path where to expand the archive.
				By default, this is the current directory.

				.PARAMETER Format
				A description of the Format parameter.

				.EXAMPLE
				PS C:\> Expands an archive 'mydata.zip' to the current directory.

				Description
				-----------
				Expand-CompressedItem mydata.zip

				.EXAMPLE
				PS C:\> Expand-CompressedItem mydata.zip -Confirm

				Description
				-----------
				It expands an archive 'mydata.zip' to the current directory and prompts for every item to be extracted.

				.EXAMPLE
				PS C:\> Get-ChildItem Y:\Source\*.zip | Expand-CompressedItem -Path Z:\Destination -Format ZIP -Confirm

				Description
				-----------
				You can also pipe archives to the Cmdlet.
				Enumerate all ZIP files in 'Y:\Source' and passes them to the Cmdlet.
				Each item to be extracted must be confirmed.

				.EXAMPLE
				PS C:\> Expand-CompressedItem "Y:\Source\data1.zip","Y:\Source\data2.zip"

				Description
				-----------
				It expands the archives 'data1.zip' and 'data2.zip' to the current directory.

				.EXAMPLE
				PS C:\> @("Y:\Source\data1.zip","Y:\Source\data2.zip") | Expand-CompressedItem

				Description
				-----------
				It expands archives 'data1.zip' and 'data2.zip' to the current directory.

				.NOTES
				See module manifest for required software versions and dependencies at:
				http://dfch.biz/biz/dfch/PS/System/Utilities/biz.dfch.PS.System.Utilities.psd1/

				.LINK
				Online Version: http://dfch.biz/biz/dfch/PS/System/Utilities/Expand-CompressedItem/
		#>

		[CmdletBinding(ConfirmImpact = 'Low',
				HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/Expand-CompressedItem/',
		SupportsShouldProcess = $True)]
		param
		(
			[Parameter(Mandatory,
					ValueFromPipeline,
					Position = 0,
			HelpMessage = 'Specifies the archive to expand. You can either pass this parameter as a path and name to the archive or as a FileInfo object. You can also pass an array of archives to the parameter. In addition you can pipe a single archive or an array of archives to this parameter as well.')]
			[ValidateScript({ Test-Path -Path ($_)})]
			[String]$InputObject,
			[Parameter(Position = 1)]
			[ValidateScript({ Test-Path -Path ($_)})]
			[IO.DirectoryInfo]$Path = $PWD.Path,
			[ValidateSet('default', 'ZIP')]
			[String]$Format = 'default'
		)

		BEGIN {
			# Build a string
			[String]$fn = ($MyInvocation.MyCommand.Name)

			# Currently only ZIP is supported
			switch ($Format) {
				'ZIP'
				{
					# We use the Shell to extract the ZIP file. If using .NET v4.5 we could have used .NET classes directly more easily.
					Set-Variable -Name ShellApplication -Value $(New-Object -ComObject Shell.Application)
				}
				default {
					# We use the Shell to extract the ZIP file. If using .NET v4.5 we could have used .NET classes directly more easily.
					Set-Variable -Name ShellApplication -Value $(New-Object -ComObject Shell.Application)
				}
			}

			# Set the Variable
			Set-Variable -Name CopyHereOptions -Value $(4 + 1024 + 16)
		}

		PROCESS {
			# Define a variable
			Set-Variable -Name fReturn -Value $($False)

			# Remove a variable that we do not need anymore
			Remove-Variable -Name OutputParameter -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

			# Loop over what we have
			foreach ($Object in $InputObject) {
				# Define a new variable
				Set-Variable -Name $Object -Value $(Get-Item -Path $Object)

				# Check what we have here
				if ($pscmdlet.ShouldProcess(("Extract '{0}' to '{1}'" -f $Object.Name, $Path.FullName))) {
					# Set a new variable
					Set-Variable -Name CompressedObject -Value $($ShellApplication.NameSpace($Object.FullName))

					# Loop over what we have
					foreach ($item in $CompressedObject.Items()) {
						if ($pscmdlet.ShouldProcess(("Extract '{0}' to '{1}'" -f $item.Name, $Path.FullName))) {($ShellApplication.Namespace($Path.FullName).CopyHere($item, $CopyHereOptions))}
					}
				}
			}

			# Show what we have
			Write-Output -InputObject $OutputParameter
		}

		END {
			# Cleanup
			if ($ShellApplication) {
				# Remove a no longer needed variable
				Remove-Variable -Name ShellApplication -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			}

			# Set another variable
			Set-Variable -Name datEnd -Value $([datetime]::Now)
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
