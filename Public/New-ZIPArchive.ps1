#!/usr/bin/env powershell
#requires -Version 3.0

#region License

<#
		Copyright (c) 2016, Quality Software Ltd.
		All rights reserved.

		Redistribution and use in source and binary forms, with or without
		modification, are permitted provided that the following conditions are met:

		1. Redistributions of source code must retain the above copyright notice,
		this list of conditions and the following disclaimer.

		2. Redistributions in binary form must reproduce the above copyright notice,
		this list of conditions and the following disclaimer in the documentation
		and/or other materials provided with the distribution.

		3. Neither the name of the copyright holder nor the names of its
		contributors may be used to endorse or promote products derived from
		this software without specific prior written permission.

		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
		AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
		IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
		ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
		LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
		CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
		SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
		INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
		CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
		ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
		THE POSSIBILITY OF SUCH DAMAGE.

		By using the Software, you agree to the License, Terms and Conditions above!
#>

#endregion License

if (($PSVersionTable.PSVersion.Major) -lt '5') {
	<#
			PowerShell older then Version 5 is found!
	#>

	function New-ZIPArchive {
		<#
				.SYNOPSIS
				Create a ZIP archive of a given file

				.DESCRIPTION
				Create a ZIP archive of a given file.
				By default within the identicle directory and the identicle name of the input file.
				Many things can be changed via command line parameters.

				.PARAMETER InputFile
				Mandatory

				The parameter InputFile is the file that should be compressed.
				You can use it like this: "ClutterReport-20150617171648.csv", or with a full path like this:
				"C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv"

				.PARAMETER OutputFile
				Optional

				You can use it like this: "ClutterReport-20150617171648", or with a full path like this:
				"C:\scripts\PowerShell\export\ClutterReport-20150617171648"

				Do not append the extension!

				.PARAMETER OutputPath
				Optional

				By default, the new archive will be created in the same directory as the input file, if you would like to have it in another directory specify it here like this: "C:\temp\"

				The directory must exist!

				.EXAMPLE
				PS C:\> New-ZIPArchive -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv"

				Description
				-----------
				This will create the archive "ClutterReport-20150617171648.zip" from the given input file "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".

				The new archive will be located in "C:\scripts\PowerShell\export\"!

				.EXAMPLE
				PS C:\> New-ZIPArchive -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv" -OutputFile "NewClutterReport"

				Description
				-----------
				This will create the archive "NewClutterReport.zip" from the given input file "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
				The new archive will be located in "C:\scripts\PowerShell\export\"!

				.EXAMPLE
				PS C:\> New-ZIPArchive -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv" -OutputPath "C:\temp\"

				Description
				-----------
				This will create the archive "ClutterReport-20150617171648.zip" from the given input file "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
				The new archive will be located in "C:\temp\"! (The directory must exist!)

				.EXAMPLE
				PS C:\> Create-ZIP -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv" -OutputFile "NewClutterReport" -OutputPath "C:\temp\"

				Description
				-----------
				This will create the archive "NewClutterReport.zip" from the given input file "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
				The new archive will be located in "C:\temp\"! (The directory must exist!)

				.LINK
				https://github.com/Alright-IT/AIT.OpenSource

				.LINK
				https://github.com/Alright-IT/AIT.OpenSource/issues
		#>

		param
		(
			[Parameter(Mandatory,
			HelpMessage = 'The parameter InputFile is the file that should be compressed (Mandatory)')]
			[ValidateNotNullOrEmpty()]
			[Alias('Input')]
			[String]$InputFile,
			[Parameter(Mandatory,HelpMessage = 'Add help message for user')][Alias('Output')]
			[String]$OutputFile,
			[Parameter(Mandatory,HelpMessage = 'Add help message for user')][String]$OutputPath
		)

		BEGIN {
			# Cleanup the variables
			Remove-Variable -Name MyFileName -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name MyFilePath -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name OutArchiv -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name zip -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}

		PROCESS {
			# Extract the Filename, without PATH and EXTENSION
			Set-Variable -Name MyFileName -Value $((Get-Item -Path $InputFile).Name)

			# Check if the parameter "OutputFile" is given
			if (-not ($OutputFile)) {
				# Extract the Filename, without PATH
				Set-Variable -Name OutputFile -Value $((Get-Item -Path $InputFile).BaseName)
			}

			# Append the ZIP extension
			Set-Variable -Name OutputFile -Value $($OutputFile + '.zip')

			# Is the OutputPath Parameter given?
			if (-not ($OutputPath)) {
				# Build the new Path Variable
				Set-Variable -Name MyFilePath -Value $((Split-Path -Path $InputFile -Parent) + '\')
			} else {
				# Strip the trailing backslash if it exists
				Set-Variable -Name OutputPath -Value $($OutputPath.TrimEnd('\'))

				# Build the new Path Variable based on the given OutputPath Parameter
				Set-Variable -Name MyFilePath -Value $(($OutputPath) + '\')
			}

			# Build a new Filename with Path
			Set-Variable -Name OutArchiv -Value $(($MyFilePath) + ($OutputFile))

			# Check if the Archive exists and delete it if so
			if (Test-Path -Path $OutArchiv) {
				# If the File is locked, Unblock it!
				Unblock-File -Path $OutArchiv -Confirm:$False -ErrorAction Ignore -WarningAction Ignore

				# Remove the Archive
				Remove-Item -Path $OutArchiv -Force -Confirm:$False -ErrorAction Ignore -WarningAction Ignore
			}

			# The ZipFile class is not available by default in Windows PowerShell because the
			# System.IO.Compression.FileSystem assembly is not loaded by default.
			Add-Type -AssemblyName 'System.IO.Compression.FileSystem'

			# Create a new Archive
			# We use the native .NET Call to do so!
			Set-Variable -Name zip -Value $([IO.Compression.ZipFile]::Open($OutArchiv, 'Create'))

			# Add input to the Archive
			# We use the native .NET Call to do so!
			$null = [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $InputFile, $MyFileName, 'optimal')

			# Close the archive file
			$zip.Dispose()

			# Waiting for compression to complete...
			do {
				# Wait 1 second and try again if working entries are not null
				Start-Sleep -Seconds '1'
			} while (($zip.Entries.count) -ne 0)

			# Extended Support for unattended mode
			if ($RunUnattended) {
				# Inform the Robot (Just pass the Archive Filename)
				Write-Output -InputObject ('{0}' -f $OutArchiv)
			} else {
				# Inform the operator
				Write-Output -InputObject ('Compressed: {0}' -f $InputFile)
				Write-Output -InputObject ('Archive: {0}' -f $OutArchiv)
			}

			# If the File is locked, Unblock it!
			Unblock-File -Path $OutArchiv -Confirm:$False -ErrorAction Ignore -WarningAction Ignore
		}

		END {
			# Cleanup the variables
			Remove-Variable -Name MyFileName -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name MyFilePath -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name OutArchiv -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name zip -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}

	# Set a Alias
	(Set-Alias -Name Create-ZIP -Value New-ZIPArchive -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1

} else {
	<#
			PowerShell 5, or newer is found!

			We do not need that function anymore ;-)

			Use the Build-In one instead...
	#>

	Write-Verbose -Message 'This function is only needed if PowerShell is older then 5!'
}
