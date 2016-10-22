﻿#!/usr/bin/env powershell
#requires -Version 4.0

<#
		.SYNOPSIS
		Alright-IT PowerShell Open Source Tools, Functions and useful snippets

		.DESCRIPTION
		Alright-IT PowerShell Open Source Tools, Functions and useful snippets

		.NOTES
		Public Beta Version

		.LINK
		http://www.alright-it.com
		https://github.com/Alright-IT/AIT.OpenSource

		.LINK
#>

#region License

<#
		TODO: Open Issue - Documented in AAT-4

		Copyright (c) 2016, Alright-IT GmbH
		Copyright (c) 2015, Quality Software Ltd
		Copyright (c) 2006-2015, Joerg Hochwald
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

<#
		This is a third party Software!

		The developer of this Software is NOT sponsored by or affiliated with
		Microsoft Corp (MSFT) or any of it's subsidiaries in any way

		The Software is not supported by Microsoft Corp (MSFT)!

		More about Alright-IT GmbH http://www.alright-it.com
#>

#endregion License

#region ModuleDefaults

# Temp Change to the Module Directory
Push-Location -Path $PSScriptRoot

# Start the Module Loading Mode
$LoadingModule = $True

#endregion ModuleDefaults

#region Externals

#endregion Externals

#region Functions
function Approve-MailAddress {
	<#
			.SYNOPSIS
			REGEX checks to see if a given Email address is valid.

			.DESCRIPTION
			It checks a given Mail Address against an REGEX Filter to see if it is RfC822 complaint.
			Most mailers will not be able to handle it if there are non standard chars within the Mail Address.

			.PARAMETER Email
			e.g. "joerg.hochwald@outlook.com"
			Email address to check

			.EXAMPLE
			PS C:\> Approve-MailAddress -Email:"No.Reply@bewoelkt.net"
			True

			Description
			-----------
			It checks a given Mail Address (No.Reply@bewoelkt.net) against an REGEX  Filter to see if it is RfC822 complaint.

			.EXAMPLE
			PS C:\> Approve-MailAddress -Email:"Jörg.hochwald@gmail.com"
			False

			Description
			-----------
			It checks a given Mail Address (Jörg.hochwald@gmail.com) against an REGEX Filter to see if it is RfC822 complaint, and it is NOT.

			.EXAMPLE
			PS C:\> Approve-MailAddress -Email:"Joerg hochwald@gmail.com"
			False

			Description
			-----------
			It checks a given Mail Address (Joerg hochwald@gmail.com) against an REGEX Filter to see if it is RfC822 complaint, and it is NOT.

			.EXAMPLE
			PS C:\> Approve-MailAddress -Email:"Joerg.hochwald@gmail"
			False

			Description
			-----------
			It checks a given Mail Address (Joerg.hochwald@gmail) against an REGEX Filter to see if it is RfC822 complaint, and it is NOT.

			.NOTES
			Internal Helper function to check mail addresses via REGEX to see if they are RfC822 complaint before use them.

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory,
		HelpMessage = 'Enter the Mail Address that you would like to check (Mandatory)')]
		[ValidateNotNullOrEmpty()]
		[Alias('Mail')]
		[String]$Email
	)

	BEGIN {
		# Old REGEX check
		Set-Variable -Name 'EmailRegexOld' -Value $("^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$" -as ([regex] -as [type]))

		# New REGEX check (Upper and Lowercase FIX)
		Set-Variable -Name 'EmailRegex' -Value $('^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,6})$' -as ([regex] -as [type]))
	}

	PROCESS {
		# Check that the given Address is valid.
		if (($Email -match $EmailRegexOld) -and ($Email -match $EmailRegex)) {
			# Email seems to be valid
			Return $True
		} else {
			# Wow, that looks bad!
			Return $False
		}
	}
}

function ConvertTo-Base64 {
	<#
			.SYNOPSIS
			Convert a string to a Base 64 encoded string.

			.DESCRIPTION
			Convert a string to a Base 64 encoded string.

			.PARAMETER plain
			Un-Encodes Input String

			.EXAMPLE
			PS C:\> ConvertTo-Base64 -plain "Hello World"
			SABlAGwAbABvACAAVwBvAHIAbABkAA==

			Description
			-----------
			Convert a string to a Base 64 encoded string.

			.EXAMPLE
			PS C:\> "Just a String" | ConvertTo-Base64
			SgB1AHMAdAAgAGEAIABTAHQAcgBpAG4AZwA=

			Description
			-----------
			Convert a string to a Base 64 encoded string via Pipe(line).

			.NOTES
			Companion function

			.LINK
			ConvertFrom-Base64
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Unencodes Input String')]
		[ValidateNotNullOrEmpty()]
		[Alias('unencoded')]
		[String]$plain
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name 'GetBytes' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'EncodedString' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		# GetBytes .NET
		Set-Variable -Name 'GetBytes' -Value $([Text.Encoding]::Unicode.GetBytes($plain))

		#  Cobert to Base64 via .NET
		Set-Variable -Name 'EncodedString' -Value $([Convert]::ToBase64String($GetBytes))
	}

	END {
		# Dump the Info
		Write-Output -InputObject $EncodedString
	}
}

function ConvertFrom-Base64 {
	<#
			.SYNOPSIS
			Decode a Base64 encoded string back to a plain string.

			.DESCRIPTION
			Decode a Base64 encoded string back to a plain string.

			.PARAMETER encoded
			Base64 encoded String

			.EXAMPLE

			PS C:\> ConvertFrom-Base64 -encoded "SABlAGwAbABvACAAVwBvAHIAbABkAA=="
			Hello World

			Description
			-----------
			Decode a Base64 encoded string back to a plain string.

			.EXAMPLE
			PS C:\> "SABlAGwAbABvACAAVwBvAHIAbABkAA==" | ConvertFrom-Base64
			Hello World

			Description
			-----------
			Decode a Base64 encoded string back to a plain string via Pipe(line).

			.NOTES
			Companion function

			.LINK
			ConvertTo-Base64
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Base64 encoded String')]
		[ValidateNotNullOrEmpty()]
		[String]$encoded
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name 'DecodedString' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		# Decode the Base64 encoded string back
		Set-Variable -Name 'DecodedString' -Value $(([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($encoded))) -as ([String] -as [type]))
	}

	END {
		# Dump the Info
		Write-Output -InputObject $DecodedString

		# Cleanup
		Remove-Variable -Name 'DecodedString' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}
}

function ConvertFrom-BinHex {
	<#
			.SYNOPSIS
			Convert an HEX value to a string.

			.DESCRIPTION
			It converts a given HEX value back to human readable strings.

			.PARAMETER HEX
			HEX string that you like to convert.

			.EXAMPLE
			PS C:\> ConvertFrom-BinHex 0c
			12

			Description
			-----------
			Return the regular value (12) of the given HEX 0c

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			ConvertTo-BinHex

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			Support: https://github.com/jhochwald/NETX/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')][ValidateNotNullOrEmpty()]
		$binhex
	)

	BEGIN {
		# Define a default
		Set-Variable -Name arr -Value $(New-Object -TypeName byte[] -ArgumentList ($binhex.Length/2))
	}

	PROCESS {
		# Loop over the given string
		for ($i = 0; $i -lt $arr.Length; $i++) {$arr[$i] = [Convert]::ToByte($binhex.substring($i * 2, 2), 16)}
	}

	END {
		# Return the new value
		Write-Output -InputObject $arr
	}
}

function ConvertTo-BinHex {
	<#
			.SYNOPSIS
			It converts a string to HEX.

			.DESCRIPTION
			It converts a given string or array to HEX and dumps it.

			.PARAMETER array
			Array that should be converted to HEX

			.EXAMPLE
			PS C:\> ConvertTo-BinHex 1234
			4d2

			Description
			-----------
			Returns the HEX value (4d2) of the string 1234

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			ConvertFrom-BinHex

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			Support: https://github.com/jhochwald/NETX/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')][ValidateNotNullOrEmpty()]
		$array
	)

	BEGIN {
		# Define a default
		Set-Variable -Name str -Value $(New-Object -TypeName system.text.stringbuilder)
	}

	PROCESS {
		# Loop over the String
		$array | ForEach-Object -Process {$null = $str.Append($_.ToString('x2'))}
	}

	END {
		# Print the String
		Write-Output -InputObject $str.ToString()
	}
}

function Invoke-CheckSessionArch {
	<#
			.SYNOPSIS
			Show the CPU architecture

			.DESCRIPTION
			You want to know if this is a 64BIT or still a 32BIT system?
			It might be useful, maybe not!

			.EXAMPLE
			PS C:\> Invoke-CheckSessionArch
			x64

			.EXAMPLE
			PS C:\> Check-SessionArch
			x64

			Description
			-----------
			It shows that the architecture is 64 BIT and that the session also supports X64.

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param ()

	PROCESS {
		# Figure out if this is a x64 or x86 system via NET call
		if ([IntPtr]::Size -eq 8) {Return 'x64'} elseif ([IntPtr]::Size -eq 4) {Return 'x86'} else {Return 'Unknown Type'}
	}
}

function Clear-AllEventLogs {
	<#
			.SYNOPSIS
			Delete all EventLog entries

			.DESCRIPTION
			Delete all EventLog entries

			.EXAMPLE
			PS C:\> Clear-AllEventLogs

			Description
			-----------
			Ask if it should delete all EventLog entries, and you need to confirm it.

			.EXAMPLE
			PS C:\> Clear-AllEventLogs -Confirm:$False

			Description
			-----------
			Delete all EventLog entries, and you do not need to confirm it.

			.NOTES
			It could be great to clean up everything, but everything will be gone forever!
	#>

	[CmdletBinding(ConfirmImpact = 'High',
	SupportsShouldProcess)]
	[OutputType([String])]
	param ()

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		if ($pscmdlet.ShouldProcess('All EventLogs', 'Delete e.g. Cleanup')) {
			Get-EventLog -List | ForEach-Object -Process {
				Write-Host -Object ('Clearing {0}' -f $_.Log)
				Clear-EventLog -LogName $_.Log -Confirm:$False
			}
		} else {
			Write-Output -InputObject 'You denied to clean the EventLog entires...'
		}
	}
}

function Clear-OldFiles {
	<#
			.SYNOPSIS
			It removes old Log files

			.DESCRIPTION
			Convenience function to clean up old Files (House Keeping)

			.PARAMETER days
			Files older than this will be deleted, the Default is 7 (For 7 Days)

			.PARAMETER Path
			The Path where the Logs are located, default is C:\scripts\PowerShell\log

			.PARAMETER Extension
			The File Extension that you would like to remove, the default is ALL (*)

			.EXAMPLE
			PS C:\> Clear-OldFiles

			Description
			-----------
			I will remove all files older than seven (7) days from C:\scripts\PowerShell\log
			You need to confirm every action!

			.EXAMPLE
			PS C:\> Clear-OldFiles -Confirm:$False

			Description
			-----------
			I will remove all files older than seven (7) days from C:\scripts\PowerShell\log
			You do not need to confirm any action!

			.EXAMPLE
			PS C:\> Clear-OldFiles -days:"30" -Confirm:$False

			Description
			-----------
			I will remove all files older than thirty (30) days from C:\scripts\PowerShell\log
			You do not need to confirm any action!

			.EXAMPLE
			PS C:\> Clear-OldFiles -Extension:".csv" -days:"365" -Path:"C:\scripts\PowerShell\export" -Confirm:$False

			Description
			-----------
			I will remove all csv files older than 365 days from C:\scripts\PowerShell\export
			You do not need to confirm any action!

			.NOTES
			Want to clean out old logfiles?
	#>

	[CmdletBinding(ConfirmImpact = 'Medium')]
	param
	(
		[ValidateNotNullOrEmpty()]
		[int]$Days = 7,
		[ValidateNotNullOrEmpty()]
		[String]$Path = 'C:\scripts\PowerShell\log',
		[ValidateNotNullOrEmpty()]
		[Alias('ext')]
		[String]$Extension = '*'
	)

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		Get-ChildItem -Path $Path -Recurse -Include $Extension |
		Where-Object -FilterScript { $_.CreationTime -lt (Get-Date).AddDays(0 - $Days) } |
		ForEach-Object -Process {
			try {
				Remove-Item -Path $_.FullName -Force -ErrorAction Stop
				Write-Output -InputObject ('Deleted {0}' -f $_.FullName)
			} catch {
				Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
			}
		}
	}
}

function Clear-TempDir {
	<#
			.SYNOPSIS
			Clean up the TEMP Directory

			.DESCRIPTION
			Clean up the TEMP Directory

			.PARAMETER Days
			Number of days, older files will be removed!

			.EXAMPLE
			PS C:\> Clear-TempDir
			Freed 439,58 MB disk space

			Description
			-----------
			I will delete all Files older than 30 Days (This is the default)
			You have to confirm every item before it is deleted.

			.EXAMPLE
			PS C:\> Clear-TempDir -Days:60 -Confirm:$False
			Freed 407,17 MB disk space

			Description
			-----------
			I will delete all Files older than 30 Days (This is the default)
			You do not have to confirm every item before it is deleted

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Position = 0)]
		[Alias('RemoveOlderThen')]
		[int]$Days = 30,
		[switch]$Confirm = $True,
		[Switch]$Whatif = $False
	)

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		# Do we want to confirm?
		if (-not ($Confirm)) {
			Set-Variable -Name '_Confirm' -Value $($False -as ([bool] -as [type]))
		} elseif ($Confirm) {
			Set-Variable -Name '_Confirm' -Value $($True -as ([bool] -as [type]))
		}

		# Is there a WhatIf?
		if (-not ($Whatif)) {
			Set-Variable -Name '_WhatIf' -Value $('#')
		} elseif ($Whatif) {
			Set-Variable -Name '_WhatIf' -Value $('-WhatIf')
		}

		# Set the Cut Off Date
		Set-Variable -Name 'cutoff' -Value $((Get-Date) - (New-TimeSpan -Days $Days))

		# Save what we have before we start the Clean up
		Set-Variable -Name 'before' -Value $((Get-ChildItem -Path $env:temp | Measure-Object -Property Length -Sum).Sum)

		# Find all Files within the TEMP Directory and process them
		Get-ChildItem -Path $env:temp |
		Where-Object -FilterScript { ($_.Length) } |
		Where-Object -FilterScript { $_.LastWriteTime -lt $cutoff } |
		Remove-Item -Recurse -Force -ErrorAction SilentlyContinue -Confirm -Path $_Confirm

		# How much do we have now?
		Set-Variable -Name 'after' -Value $((Get-ChildItem -Path $env:temp | Measure-Object -Property Length -Sum).Sum)

		'Freed {0:0.00} MB disk space' -f (($before - $after)/1MB)
	}
}

function Save-CommandHistory {
	<#
			.SYNOPSIS
			It dumps the command history to an XML File.

			.DESCRIPTION
			It dumps the command history to an XML File.
			This file is located in the User Profile.
			You can then restore it via the sibling command Import-CommandHistory

			.EXAMPLE
			PS C:\> Save-CommandHistory

			Description
			-----------
			It dumps the command history to the XML file "commandHistory.xml" in the user profile folder.

			.NOTES
			Companion command

			.LINK
			Import-CommandHistory
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		# Where to store the XML History Dump
		[String]$CommandHistoryDump = "$env:USERPROFILE\commandHistory.xml"

		# Be verbose
		Write-Verbose -Message ('Save History to {0}' -f ($CommandHistoryDump))

		# Dump the History
		(Get-History | Export-Clixml -Path $CommandHistoryDump -Force -Confirm:$False -Encoding utf8)
	}
}

function Import-CommandHistory {
	<#
			.SYNOPSIS
			It loads the command history dumped via the sibling command Save-CommandHistory

			.DESCRIPTION
			This is the Companion Command for Save-CommandHistory.
			It loads the command history from an XML File in the user profile.

			.EXAMPLE
			PS C:\> Import-CommandHistory

			Description
			-----------
			It loads the command history from an XML file "commandHistory.xml" in the user profile folder.

			.NOTES
			Companion command

			.LINK
			Save-CommandHistory
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		# Where-Object to Find the XML History Dump
		[String]$CommandHistoryDump = "$env:USERPROFILE\commandHistory.xml"

		# Be verbose
		Write-Verbose -Message 'Clear History to keep things clean'

		# Clear History to keep things clean
		# UP (Cursor) will sill show the existing command history
		Clear-History -Confirm:$False

		# Be verbose
		Write-Verbose -Message ('Load History from {0}' -f ($CommandHistoryDump))

		# Import the History
		Add-History -InputObject (Import-Clixml -Path $CommandHistoryDump)
	}
}

function Confirm-XMLisValid {
	<#
			.SYNOPSIS
			It checks if one, or more, given files looks like valid XML formatted.

			.DESCRIPTION
			This function does some basic checks to see if one, or more, given files looks valid XML formatted.
			If you use multiple files at once, the answer is False (Boolean) even if just one is not a valid XML file!

			.PARAMETER XmlFilePath
			One or more Files to check

			.EXAMPLE
			PS C:\> Confirm-XMLisValid -XmlFilePath 'D:\apache-maven-3.3.9\conf\settings.xml'
			True

			Description
			-----------
			This will check if the file 'D:\apache-maven-3.3.9\conf\settings.xml' looks like a well formatted XML file, what it does.

			.EXAMPLE
			PS C:\> Confirm-XMLisValid -XmlFilePath 'D:\apache-maven-3.3.9\README.txt'
			False

			Description
			-----------
			Looks like the File 'D:\apache-maven-3.3.9\README.txt' is not a valid XML formatted file.

			.EXAMPLE
			PS C:\> Confirm-XMLisValid -XmlFilePath 'D:\apache-maven-3.3.9\README.txt', 'D:\apache-maven-3.3.9\conf\settings.xml'
			False

			Description
			-----------
			Checks multiple files to see if they are valid XML files.
			If one is not, "False" is returned!

			.NOTES
			The return is boolean. The function should never throw an error; maximum is a warning!
			So if you want to catch a problem be aware of that!
	#>

	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = 'One or more Files to check')]
		[String[]]$XmlFilePath
	)

	PROCESS {
		foreach ($XmlFileItem in $XmlFilePath) {
			if (Test-Path -Path $XmlFileItem -ErrorAction SilentlyContinue) {
				try {
					# Get the file
					$XmlFile = (Get-Item -Path $XmlFileItem)

					# Keep count of how many errors there are in the XML file
					$script:ErrorCount = 0

					# Perform the XML Validation
					$ReaderSettings = (New-Object -TypeName System.Xml.XmlReaderSettings)
					$ReaderSettings.ValidationType = [Xml.ValidationType]::Schema
					$ReaderSettings.ValidationFlags = [Xml.Schema.XmlSchemaValidationFlags]::ProcessInlineSchema -bor [Xml.Schema.XmlSchemaValidationFlags]::ProcessSchemaLocation
					$ReaderSettings.add_ValidationEventHandler{ $script:ErrorCount++ }
					$Reader = [Xml.XmlReader]::Create($XmlFile.FullName, $ReaderSettings)

					# Now we try to figure out if this is a valid XML file
					try {
						while ($Reader.Read()) { }
					} catch {
						$script:ErrorCount++
					}

					# Close the open file
					$Reader.Close()

					# Verify the results of the XSD validation
					if ($script:ErrorCount -gt 0) {
						# XML is NOT valid
						Return $False
					} else {
						# XML is valid
						Return $True
					}
				} catch {
					Write-Warning -Message ('{0} - Error: {1} - Line Number: {2}' -f $MyInvocation.MyCommand.Name, $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
				}
			} else {
				Write-Warning -Message ('{0} - Error: {1} - Line Number: {2}' -f $MyInvocation.MyCommand.Name, $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
			}
		}
	}
}

function ConvertFrom-CurlRequest {
	<#
			.SYNOPSIS
			Parse a Curl command to get a parameter hash table for Invoke-RestMethod

			.DESCRIPTION
			Parse a Curl command to get a parameter hash table for Invoke-RestMethod

			It could be useful if you have an example Curl request or the API documentation just contains Curl based examples, often the case in API documentations.

			.PARAMETER InputObject
			Curl Command to convert

			.EXAMPLE
			$RestParams = ('curl -X "GET" "https://echo.luckymarmot.com"' | ConvertFrom-CurlRequest)
			Invoke-RestMethod @RestParams

			Description
			-----------
			It parses the given Curl command to get a parameter hash table for Invoke-RestMethod
			In this example, we use no headers!

			.EXAMPLE
			$RestParams = ('curl -X "GET" "https://echo.luckymarmot.com" -H "Authorization: Basic dXNlcm5hbWU6KioqKiogSGlkZGVuIGNyZWRlbnRpYWxzICoqKioq"' | ConvertFrom-CurlRequest)
			Invoke-RestMethod @RestParams

			Description
			-----------
			It parses the given Curl command to get a parameter hash table for Invoke-RestMethod

			.EXAMPLE
			$RestParams = ('curl -X "GET" "https://echo.luckymarmot.com" -H "Authorization: Basic dXNlcm5hbWU6KioqKiogSGlkZGVuIGNyZWRlbnRpYWxzICoqKioq"' | ConvertFrom-CurlRequest)
			$RestParams

			Name                           Value
			----                           -----
			Method                         GET
			Headers                        {Authorization}
			Uri                            https://echo.luckymarmot.com

			Description
			-----------
			It parses the given Curl command to get a parameter hash table for Invoke-RestMethod
			Do not execute Invoke-RestMethod; just dump the hash table. Make sense for saving it to your own script (Splatting)

			.NOTES
			Based on the Idea of Nicholas M. Getchell

			.LINK
			https://github.com/ngetchell/Parse-Curl
	#>

	[OutputType([Hashtable])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Curl Command to convert')]
		[String]$InputObject
	)

	BEGIN {
		<#
				Sub-Functions
		#>

		function Update-CurlStringBody {
			<#
					.SYNOPSIS
					Sub-Function to update the current cURL body

					.DESCRIPTION
					Sub-Function to update the current cURL body

					.PARAMETER body
					cURL body

					.PARAMETER data
					cURL body data

					.NOTES
					Sub-Function

					.LINK
					Update-CurlStringHeader
					ConvertFrom-CurlRequest
			#>

			[CmdletBinding()]
			param
			(
				$body,
				[string]$data
			)

			if (!$body) {
				$body = @()
			}

			$body = @($body) + $data

			return $body
		}

		function Update-CurlStringHeader {
			<#
					.SYNOPSIS
					Sub-Function to update the current cURL header

					.DESCRIPTION
					Sub-Function to update the current cURL header

					.PARAMETER headers
					current cURL header

					.PARAMETER data
					current cURL header data

					.NOTES
					Sub-Function

					.LINK
					Update-CurlStringBody
					ConvertFrom-CurlRequest
			#>

			[CmdletBinding()]
			param
			(
				$headers,
				[string]$data
			)

			BEGIN {
				if (-not ($headers)) {
					$headers = @{ }
				}
			}

			PROCESS {
				$dataArray = $data.Split(':')
				$headers.Add($dataArray[0].Trim(), $dataArray[1].Trim())
			}

			END {
				return $headers
			}
		}

		# Cleanup
		$ParamList = @{ }
	}

	PROCESS {
		$tokens = ([Management.Automation.PSParser]::Tokenize($InputObject, [ref]$null) | Select-Object -ExpandProperty Content)
		$index = 0

		while ($index -lt ($tokens.Count)) {
			switch ($tokens[$index]) {
				'curl' { }
				{ $_ -like '*://*' } {
					$ParamList['Uri'] = $tokens[$index]
				}
				{ $_ -eq '-D' -or $_ -eq '--data' } {
					$index++
					$ParamList['Body'] = Update-CurlStringBody -body $ParamList['Body'] -data $tokens[$index]
					if (!$ParamList['Method']) { $ParamList['Method'] = 'Post' }
				}
				{ $_ -eq '-H' -or $_ -eq '--header' } {
					$index++
					$ParamList['Headers'] = Update-CurlStringHeader -headers $ParamList['Headers'] -data $tokens[$index]
				}
				{ $_ -eq '-A' -or $_ -eq '--user-agent' } {
					$index++
					if (!$ParamList['UserAgent']) { $ParamList['UserAgent'] = $tokens[$index] }
				}
				{ $_ -eq '-X' -or $_ -eq '--request ' } {
					$index++
					if (!$ParamList['Method']) { $ParamList['Method'] = $tokens[$index] }
				}
				{ $_ -eq '--max-redirs' } {
					$index++
					if (!$ParamList['MaximumRedirection']) { $ParamList['MaximumRedirection'] = $tokens[$index] }
				}
			}

			$index++
		}
	}

	END {
		Write-Output -InputObject $ParamList -NoEnumerate
	}
}

function ConvertFrom-DateString {
	<#
			.SYNOPSIS
			It converts a string representation of a date.

			.DESCRIPTION
			It converts the specified string representation of a date and time to its DateTime equivalent using the specified format and culture-specific format information.
			The format of the string representation must match the specified format exactly.

			.PARAMETER Value
			A string containing a date and time to convert.

			.PARAMETER FormatString
			The required format of the date string value. If FormatString defines a date with no time element, the resulting DateTime value has a time of midnight (00:00:00).
			If FormatString defines a time with no date element, the resulting DateTime value has a date of DateTime.Now.Date.
			If FormatString is a custom format pattern that does not include date or time separators (such as "yyyyMMdd HHmm"), use the invariant culture (e.g [System.Globalization.CultureInfo]::InvariantCulture), for the provider parameter and the widest form of each custom format specified.
			For example, if you want to specify hours in the format pattern, specify the wider form, "HH"; instead of the narrower form, "H".
			The format parameter is a string that contains either a single standard format specifier, or one or more custom format specifiers that define the required format of StringFormats. For details about valid formatting codes, see 'Standard Date and Time Format Strings' (http://msdn.microsoft.com/en-us/library/az4se3k1.aspx) or 'Custom Date and Time Format Strings' (http://msdn.microsoft.com/en-us/library/8kb3ddd4.aspx).

			.PARAMETER Culture
			An object that supplies culture-specific formatting information about the date string value. The default value is null.
			A value of null corresponds to the current culture.

			.PARAMETER InvariantCulture
			It gets the CultureInfo that is culture-independent (invariant).
			The invariant culture is culture-insensitive. It is associated in the English language but not with any country/region.

			.EXAMPLE
			ConvertFrom-DateString -Value 'Sun 15 Jun 2008 8:30 AM -06:00' -FormatString 'ddd dd MMM yyyy h:mm tt zzz' -InvariantCulture

			Sunday, June 15, 2008 5:30:00 PM

			Description
			-----------
			This example converts the date string, 'Sun 15 Jun 2008 8:30 AM -06:00', according to the specifier that defines the required format.
			The InvariantCulture switch parameter formats the date string in a culture-independent manner.

			.EXAMPLE
			'jeudi 10 avril 2008 06:30' | ConvertFrom-DateString -FormatString 'dddd dd MMMM yyyy HH:mm' -Culture fr-FR

			Thursday, April 10, 2008 6:30:00 AM

			Description
			-----------
			In this example a date string, in French format (culture).
			The date string is piped to ConvertFrom-DateString.
			The input value is bound for the Value parameter.
			The FormatString value defines the required format of the date string value.
			The result is a DateTime object that is equivalent on the date and time contained in the Value parameter, as specified by FormatString and Culture parameters.

			.EXAMPLE
			ConvertFrom-DateString -Value 'Sun 15 Jun 2008 8:30 AM -06:00' -FormatString 'ddd dd MMM yyyy h:mm tt zzz'

			Sunday, June 15, 2008 5:30:00 PM

			Description
			-----------
			It converts the date string specified for the Value parameter with the custom specifier specified for the FormatString parameter.
			The result DateTime object format corresponds to the current culture.

			.NOTES
			We just adopted and tweaked the existing function from Shay Levy.

			.LINK
			Blog	http://PowerShay.com

			.LINK
			information	http://msdn.microsoft.com/en-us/library/w2sa9yss.aspx

			.LINK
			http://gallery.technet.microsoft.com/scriptcenter/5b40075b-caef-45e8-8b12-d882fcd0dd9c
	#>

	[CmdletBinding(DefaultParameterSetName = 'Culture')]
	[OutputType([DateTime])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'A string containing a date and time to convert.')]
		[String]$Value,
		[Parameter(Mandatory,
				Position = 1,
		HelpMessage = 'The required format of the date string value')]
		[Alias('format')]
		[String]$FormatString,
		[Parameter(ParameterSetName = 'Culture')]
		[cultureinfo]$Culture = $null,
		[Parameter(ParameterSetName = 'InvariantCulture',
				Mandatory,
		HelpMessage = 'Gets the CultureInfo that is culture-independent (invariant).')]
		[switch]$InvariantCulture
	)

	PROCESS {
		if ($pscmdlet.ParameterSetName -eq 'InvariantCulture') {$Culture = [cultureinfo]::InvariantCulture}

		Try {[DateTime]::ParseExact($Value, $FormatString, $Culture)
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop

			# Capture any failure and display it in the error section
			# The Exit with Code 1 shows any calling App that there was something wrong
			exit 1
		} catch {
			Write-Error -Message ('{0} is not in the correct format.' -f ($Value))

			# Still here? Make sure we are done!
			break
		}
	}
}

function ConvertTo-HashTable {
	<#
			.Synopsis
			It converts an object to a HashTable

			.Description
			It converts an object to a HashTable excluding certain types.

			For example ListDictionaryInternal doesn't support serialization therefore it can't be converted.

			.Parameter InputObject
			The object to convert

			.Parameter ExcludeTypeName
			The array of types to skip adding to resulting HashTable.
			Default is to skip ListDictionaryInternal and Object arrays.

			.Parameter MaxDepth
			Maximum depth of embedded objects to convert, default is 4.

			.Example
			$bios = Get-CimInstance win32_bios
			$bios | ConvertTo-HashTable

			Name                           Value
			----                           -----
			SoftwareElementState           3
			Manufacturer                   American Megatrends Inc.
			Caption                        4.6.5
			CurrentLanguage                en|US|iso8859-1

			Description
			-----------
			It converts an object to a HashTable

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	Param (
		[Parameter(Mandatory,
				HelpMessage = 'Add help message for user',
		ValueFromPipeline)]
		[Object]$InputObject,
		[string[]]$ExcludeTypeName = @('ListDictionaryInternal', 'Object[]'),
		[ValidateRange(1, 10)]
		[int]$MaxDepth = 4
	)

	PROCESS {
		$propNames = $InputObject.psobject.Properties | Select-Object -ExpandProperty Name

		$hash = @{ }

		$propNames | ForEach-Object -Process {
			if (($InputObject.$_)) {
				if ($InputObject.$_ -is [String] -or (Get-Member -MemberType Properties -InputObject ($InputObject.$_)).Count -eq 0) {$hash.Add($_, $InputObject.$_)} else {
					if ($InputObject.$_.GetType().Name -in $ExcludeTypeName) {
						# Be Verbose
						Write-Verbose -Message ('Skipped {0}' -f $_)
					} elseif ($MaxDepth -gt 1) {$hash.Add($_, (ConvertTo-HashTable -InputObject $InputObject.$_ -MaxDepth ($MaxDepth - 1)))}
				}
			}
		}
	}

	END {
		Write-Output -InputObject $hash
	}
}

function ConvertTo-hex {
	<#
			.SYNOPSIS
			Converts a given integer to HEX

			.DESCRIPTION
			Converts any given Integer (INT) to Hex and dumps it to the Console

			.PARAMETER dec
			N.A.

			.EXAMPLE
			PS C:\> ConvertTo-hex "100"
			0x64

			Description
			-----------
			Converts a given integer to HEX

			.NOTES
			Renamed function
			Just a little helper function

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([long])]
	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')]
		[ValidateNotNullOrEmpty()]
		[long]$dec
	)

	PROCESS {
		# Print
		Return '0x' + $dec.ToString('X')
	}
}

function ConvertTo-HumanReadable {
	<#
			.SYNOPSIS
			It converts a given long number to a more human readable format.

			.DESCRIPTION
			It converts a given long number to a more human readable format.,
			it coverts 1024 to 1KB as basic example.

			.PARAMETER num
			Input Number

			.EXAMPLE
			PS C:\> ConvertTo-HumanReadable -num '1024'
			1,0 KB

			Description
			-----------
			It converts a given long number to a more human readable format.

			.EXAMPLE
			PS C:\> (Get-Item 'C:\scripts\PowerShell\profile.ps1').Length | ConvertTo-HumanReadable
			25 KB

			Description
			-----------
			Get the Size of a File (C:\scripts\PowerShell\profile.ps1 in this case)
			and make it human understandable
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Input Number')]
		[long]$num
	)

	PROCESS {
		switch ($num) { { $num -lt 1000 } {
				'{0,4:N0}  B' -f ($num)
				break
			}
			{ $num -lt 10KB } {
				'{0,4:N1} KB' -f ($num / 1KB)
				break
			}
			{ $num -lt 1000KB } {
				'{0,4:N0} KB' -f ($num / 1KB)
				break
			}
			{ $num -lt 10MB } {
				'{0,4:N1} MB' -f ($num / 1MB)
				break
			}
			{ $num -lt 1000MB } {
				'{0,4:N0} MB' -f ($num / 1MB)
				break
			}
			{ $num -lt 10GB } {
				'{0,4:N1} GB' -f ($num / 1GB)
				break
			}
			{ $num -lt 1000GB } {
				'{0,4:N0} GB' -f ($num / 1GB)
				break
			}
			{ $num -lt 10TB } {
				'{0,4:N1} TB' -f ($num / 1TB)
				break
			}
			default { '{0,4:N0} TB' -f ($num / 1TB) }
		}
	}
}

function ConvertTo-Objects {
	<#
			.SYNOPSIS
			You receive a result from a query and convert it to an array of objects.

			.DESCRIPTION
			You receive a result from a query and convert it to an array of objects, which is more legible to understand.

			.PARAMETER Input
			Input Objects

			.EXAMPLE
			$input = Select-SqlCeServer 'SELECT * FROM TABLE1' 'Data Source=C:\Users\cdbody05\Downloads\VisorImagenesNacional\VisorImagenesNacional\DIVIPOL.sdf;'
			$input | ConvertTo-Objects

			Description
			-----------
			You receive a result from a query and convert it to an array of objects, which is more legible to understand.
	#>

	[OutputType([Management.Automation.PSCustomObject[]])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Input Objects')]
		[Object[]]$Input
	)

	BEGIN {
		# Cleanup
		$arr = @()
		$count = 0
	}

	PROCESS {
		if ($Input) {
			# We load the results in order and loop over what we have then
			foreach ($item in $Input) {
				$count++
				$obj = (New-Object -TypeName PSObject)

				# List all the fields that are in the query
				$obj | Add-Member -MemberType Noteproperty -Name N -Value $count
				for ($i = 0; $i -lt $item.FieldCount; $i++) { $obj | Add-Member -MemberType Noteproperty -Name $item.GetName($i) -Value $item[$i] }
				$arr += $obj
			}
		}
	}

	END {
		# Dump
		$arr
	}
}

function ConvertTo-PlainText {
	<#
			.SYNOPSIS
			It converts a secure string back to plain text.

			.DESCRIPTION
			It converts a secure string back to plain text.

			.PARAMETER secure
			Secure String to convert back to plain text.

			.EXAMPLE
			PS C:\> ConvertTo-PlainText -Secure 'SECURESTRINGHERE'

			Plain String

			Description
			-----------
			It converts a secure string back to plain text.

			.NOTES
			Helper function

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = 'Secure String to convert')]
		[ValidateNotNullOrEmpty()]
		[Alias('SecureString')]
		[securestring]$secure
	)

	BEGIN {
		# Define the Marshal Variable
		# We use the native .NET Call to do so!
		$marshal = [Runtime.InteropServices.Marshal]
	}

	PROCESS {
		# Return what we have
		# We use the native .NET Call to do so!
		Write-Output -InputObject ('{0}' -f $marshal::PtrToStringAuto($marshal::SecureStringToBSTR($secure)))
	}
}

function ConvertTo-StringList {
	<#
			.SYNOPSIS
			Function to convert an array into a string list with a delimiter.

			.DESCRIPTION
			Function to convert an array into a string list with a delimiter.

			.PARAMETER Array
			Specifies the array to process.

			.PARAMETER Delimiter
			Separator between value, default is ","

			.EXAMPLE
			$Computers = "Computer1","Computer2"
			ConvertTo-StringList -Array $Computers
			Computer1,Computer2

			Description
			-----------
			Convert an array into a string list with a default delimiter.

			.EXAMPLE
			$Computers = "Computer1","Computer2"
			ConvertTo-StringList -Array $Computers -Delimiter "__"
			Computer1__Computer2

			Description
			-----------
			Convert an array into a string list with a given delimiter.

			.EXAMPLE
			$Computers = "Computer1"
			ConvertTo-StringList -Array $Computers -Delimiter "__"
			Computer1

			Description
			-----------
			Convert an array into a string list with a given delimiter.
			In this case, just one item is given!

			.NOTES
			Based on an idea of Francois-Xavier Cat

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
		HelpMessage = 'Specifies the array to process.')]
		[ValidateNotNullOrEmpty()]
		[Array]$array,
		[string]$Delimiter = ','
	)

	BEGIN {
		$StringList = $null
	}

	PROCESS {
		# Be verbose
		Write-Verbose -Message ('Array: {0}' -f $array)

		# Loop over each iten in the array
		foreach ($item in $array) {
			# Adding the current object to the list
			$StringList += "$item$Delimiter"
		}

		# Be verbose
		Write-Verbose -Message ('StringList: {0}' -f $StringList)
	}

	END {
		try {
			if ($StringList) {
				$lenght = $StringList.Length

				# Be verbose
				Write-Verbose -Message ('StringList Lenght: {0}' -f $lenght)

				# Output Info without the last delimiter
				$StringList.Substring(0, ($lenght - $($Delimiter.length)))
			}
		} catch {
			Write-Warning -Message '[END] Something wrong happening when output the result'
			$Error[0].Exception.Message
		} finally {Remove-Variable -Name 'StringList' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue}
	}
}

function Disable-IEESEC {
	<#
			.SYNOPSIS
			Disabling IE Enhanced Security Configuration (IE ESC)

			.DESCRIPTION
			Disabling IE Enhanced Security Configuration (IE ESC)

			.PARAMETER Users
			Apply for Users?

			.PARAMETER Admins
			Apply for Admins?

			.PARAMETER All
			Apply for Users and Admins?

			.EXAMPLE
			PS C:\> Disable-IEESEC -Admins

			Description
			-----------
			Remove the IE Enhanced Security Configuration (IE ESC) for Admin Users

			.EXAMPLE
			PS C:\> Disable-IEESEC -Users

			Description
			-----------
			Remove the IE Enhanced Security Configuration (IE ESC) for regular
			Users

			.EXAMPLE
			PS C:\> Disable-IEESEC -All

			Description
			-----------
			Remove the IE Enhanced Security Configuration (IE ESC) for Admin and
			regular Users

			.EXAMPLE
			PS C:\> Disable-IEESEC -WhatIf
			What if: Performing the operation "Set the new value: Disable" on target "IE Enhanced Security Configuration".

			Description
			-----------
			Show what would be changed without doing it!
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param
	(
		[switch]$Users = ($False),
		[switch]$Admins = ($True),
		[switch]$All = ($False)
	)

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}

		if ($All) {
			$Admins = ($True)
			$Users = ($True)
		}
	}

	PROCESS {
		if ($pscmdlet.ShouldProcess('IE Enhanced Security Configuration', 'Set the new value: Disable')) {
			# Set the new value for Admins
			if ($Admins) {
				$Key = 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}'
				try {
					Set-ItemProperty -Path $Key -Name 'IsInstalled' -Value 0 -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
				} catch {
					# Do nothing
					Write-Verbose -Message 'Minor Exception catched!'
				}
			}

			# Set the new value for Users
			if ($Users) {
				$Key = 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}'
				try {
					Set-ItemProperty -Path $Key -Name 'IsInstalled' -Value 0 -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
				} catch {
					# Do nothing
					Write-Verbose -Message 'Minor Exception catched!'
				}
			}

			# Enforce the new settings
			Stop-Process -Name Explorer
		}
	}
}

function Edit-HostsFile {
	<#
			.SYNOPSIS
			Edit the Windows Host file

			.DESCRIPTION
			A shortcut to quickly edit the Windows host file. It might be useful for testing things without changing the regular DNS.

			Handle with care!

			.EXAMPLE
			PS C:\> Edit-HostsFile

			Description
			-----------
			Opens the Editor configured within the VisualEditor variable to edit
			the Windows Host file

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		# Open the Host file with...
		if (-not ($VisualEditor)) {
			# Aw SNAP! The VisualEditor is not configured...
			Write-Error -Message 'System is not configured! The Visual Editor is not given...' -ErrorAction Stop

			# If you want to skip my VisualEditor function, add the following here instead of the Write-Error:
			# Start-Process -FilePath notepad -ArgumentList "$env:windir\system32\drivers\etc\hosts"
		} else {
			# Here we go: Edit the Host file...
			Start-Process -FilePath $VisualEditor -ArgumentList "$env:windir\system32\drivers\etc\hosts"
		}
	}
}

function ConvertTo-EscapeString {
	<#
			.SYNOPSIS
			HTML on web pages uses tags and other special characters to define the page.

			.DESCRIPTION
			HTML on web pages uses tags and other special characters to define the page.
			To make sure the text is not misinterpreted as HTML tags, you may want to escape text and automatically convert any ambiguous text character in an encoded format.
			Mostly useful if you need to use it in Web-Calls or for automated posts (via your own scripts).

			.PARAMETER String
			String to escape

			.EXAMPLE
			PS C:\> ConvertTo-EscapeString -String "Hello World"
			Hello%20World

			Description
			-----------
			In this example we escape the space in the string "Hello World"

			.EXAMPLE
			PS C:\> "http://www.alright-it.com" | ConvertTo-EscapeString
			http%3A%2F%2Fwww.alright-it.com

			Description
			-----------
			In this example we escape the URL string

			.NOTES
			This function has a companion: ConvertFrom-EscapedString
			The companion reverses the escaped strings back to regular ones.

			.LINK
			ConvertFrom-EscapedString
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'String to escape')]
		[ValidateNotNullOrEmpty()]
		[Alias('Message')]
		[String]$String
	)

	PROCESS {
		# Try to Escape
		try {
			# We use the .NET EscapeDataString provided by the System.URI type
			[Uri]::EscapeDataString($String)
		} catch {
			# Whoooops!
			Write-Warning -Message ('Sorry, but we where unable to escape {0}' -f $String)
		}
	}
}

function ConvertFrom-EscapedString {
	<#
			.SYNOPSIS
			It converts an encoded (escaped) string back into the original representation.

			.DESCRIPTION
			If you have an escaped string, this function makes it human readable  again.
			Some Web services returns strings an escaped format, so we convert an  encoded (escaped) string back into the original representation.
			Mostly useful if you need to use it in Web-Calls or for automated posts (via your own scripts).

			.PARAMETER String
			String to un-escape

			.EXAMPLE
			PS C:\> ConvertFrom-EscapedString -String "Hello%20World"
			Hello World

			Description
			-----------
			In this example we un-escape the space in the string "Hello%20World"

			.EXAMPLE
			PS C:\> "http%3A%2F%2Fwww.alright-it.com" | ConvertFrom-EscapedString
			http://www.alright-it.com

			Description
			-----------
			In this example we un-escape the masked (escaped) URL string

			.NOTES
			This function has a companion: ConvertTo-EscapeString
			The companion escapes any given regular string.

			.LINK
			ConvertTo-EscapeString
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'String to un-escape')]
		[ValidateNotNullOrEmpty()]
		[Alias('Message')]
		[String]$String
	)

	PROCESS {
		# Try to Un-escape
		try {
			# We use the .NET UnescapeDataString provided by the System.URI type
			[Uri]::UnescapeDataString($String)
		} catch {
			# Whoooops!
			Write-Warning -Message ('Sorry, but we where unable to unescape {0}' -f $String)
		}
	}
}

function Expand-ArrayObject {
	<#
			.SYNOPSIS
			You get an array of objects and perform an expansion of data separated by a spacer.

			.DESCRIPTION
			You get an array of objects and perform an expansion of data separated by a spacer.

			.PARAMETER array
			Input Array

			.PARAMETER field
			Field to extract from the Array

			.PARAMETER delimiter
			Delimiter within the Array, default is ";"

			.EXAMPLE
			$arr | Expand-ArrayObject fieldX

			Description
			-----------
			You get an array of objects and perform an expansion of data separated by a spacer.
	#>

	[OutputType([Management.Automation.PSCustomObject[]])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Input Array')]
		[ValidateNotNullOrEmpty()]
		[Array]$array,
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = 'Field to extract from the Array')]
		[String]$field,
		[Char]$Delimiter = ';'
	)

	BEGIN {
		[PSObject[]]$array_result = @()
	}

	PROCESS {
		foreach ($item in $array) {
			$item."$field" -split $Delimiter | ForEach-Object -Process {
				$newItem = $item.PSObject.Copy()
				$newItem."$field" = $_
				$array_result += $newItem
			}
		}
	}

	END {
		Write-Output -InputObject $array_result
	}
}

function Invoke-WindowsExplorer {
	<#
			.SYNOPSIS
			Open the Windows Explorer.

			.DESCRIPTION
			Open the Windows Explorer in the current or given directory.

			.PARAMETER Location
			Where to open the Windows Explorer, default is where the command is called.

			.EXAMPLE
			PS C:\> Invoke-WindowsExplorer

			Description
			-----------
			Open the Windows Explorer in the current directory

			.EXAMPLE
			PS C:\> Invoke-WindowsExplorer 'C:\scripts'

			Description
			-----------
			Open the Windows Explorer in the given 'C:\scripts' directory.

			.NOTES
			Just a little helper function

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param
	(
		[Alias('loc')]
		[String]$Location = '.'
	)

	PROCESS {
		# That is easy!
		& "$env:windir\explorer.exe" '/e,'$Location""
	}
}

function Test-Filelock {
	<#
			.SYNOPSIS
			It tests if a given file is locked.

			.DESCRIPTION
			It tests if a given file is locked.

			.EXAMPLE
			PS C:\scripts\PowerShell> Test-Filelock .\profile.ps1

			path          filelocked
			----          ----------
			.\profile.ps1      False

			Description
			-----------
			It tests if a given file is locked.

			.PARAMETER Path
			File to check

			.NOTES
			Just a helper function

			.LINK
			Get-FileLock
	#>

	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'File to check')]
		[Alias('File')]
		[IO.FileInfo]$Path
	)

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		try {
			# initialize variables
			$script:filelocked = $False

			# attempt to open file and detect file lock
			$script:fileInfo = (New-Object -TypeName System.IO.FileInfo -ArgumentList $Path)
			$script:fileStream = ($fileInfo.Open([IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None))

			# close stream if not lock
			if ($fileStream) {$fileStream.Close()}
		} catch {
			# catch fileStream had failed
			$filelocked = $True
		} finally {
			# return result
			[PSCustomObject]@{
				path       = $Path
				filelocked = $filelocked
			}
		}
	}
}

function Get-FileLock {
	<#
			.SYNOPSIS
			It tests if a given file is locked.

			.DESCRIPTION
			It tests if a given file is locked.

			.PARAMETER Path
			File to check

			.EXAMPLE
			PS C:\> Get-FileLock

			Description
			-----------
			It tests if a given file is locked.

			.NOTES
			Companion function Test-Filelock is needed!

			.LINK
			Test-Filelock
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'File to check')]
		[ValidateNotNullOrEmpty()]
		[string]$Path
	)

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}

		# Check if the helper function exists...
		if (-not (Get-Command -Name Test-Filelock -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)) {
			#
			# Did not see this one coming!
			Write-Error -Message 'Sorry, something is wrong! please check that the command Test-Filelock is available!' -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}
	}

	PROCESS {
		try {
			if (Test-Path -Path $Path) {
				if ((Get-Item -Path $Path) -is [IO.FileInfo]) {
					return Test-Filelock -Path $Path
				} elseif ((Get-Item -Path $Path) -is [IO.DirectoryInfo]) {
					Write-Verbose -Message "[$Path] detect as $((Get-Item -Path $Path).GetType().FullName). Skip check."
				}
			} else {
				Write-Error -Message ('[{0}] could not be found.' -f $Path)
			}
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop

			# Capture any failure and display it in the error section
			# The Exit with Code 1 shows any calling App that there was something wrong
			exit 1
		} catch {
			# Did not see this one coming!
			Write-Error -Message ('Could not check {0}' -f $Path) -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}
	}
}

function Set-FirewallExceptionRDP {
	<#
			.SYNOPSIS
			It enables Windows Remote Desktop (RDP) via Windows Firewall.

			.DESCRIPTION
			It enables Windows Remote Desktop (RDP) via Windows Firewall.

			.EXAMPLE
			PS C:\> Set-FirewallExceptionRDP

			Description
			-----------
			It enables Windows Remote Desktop (RDP) via Windows Firewall.

			.NOTES
			Only the defaults are supported. If you use another port, you need to check the firewall rules!
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param ()

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		& "$env:windir\system32\netsh.exe" advfirewall firewall set rule group="remote desktop" new enable=Yes
	}
}

function Set-FirewallExceptionFileSharing {
	<#
			.SYNOPSIS
			It enables File Sharing via Windows Firewall.

			.DESCRIPTION
			It enables File Sharing via Windows Firewall.

			.EXAMPLE
			PS C:\> Set-FirewallExceptionFileSharing

			Description
			-----------
			It enables File Sharing via Windows Firewall.

			.NOTES
			Only SMB sharing is supported here.
			If you want to use iSCSI or any AFP (Apple File Sharing) extension, you need to enable this by yourself.
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param ()

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		& "$env:windir\system32\netsh.exe" advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
	}
}

function Get-Accelerators {
	<#
			.SYNOPSIS
			Get a list of all .NET functions

			.DESCRIPTION
			Get a list of all .NET functions

			.EXAMPLE
			PS C:\> Get-Accelerators
			Key                                                             Value
			---                                                             -----
			Alias                                                           System.Management.Automation.AliasAttribute

			Description
			-----------
			Get a list of all .NET functions

			.EXAMPLE
			PS C:\> Get-Accelerators | Format-List
			Key   : Alias
			Value : System.Management.Automation.AliasAttribute

			Key   : AllowEmptyCollection
			Value : System.Management.Automation.AllowEmptyCollectionAttribute

			Description
			-----------
			Get a list of all .NET functions

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		[psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::get
	}
}

function Get-AdminUser {
	<#
			.SYNOPSIS
			Check if the user has started the PowerShell session as admin.

			.DESCRIPTION
			Check if the user has started the PowerShell session as admin.

			.EXAMPLE
			PS C:\> Get-AdminUser
			True

			Description
			-----------
			Return a boolean (True if the user is Admin and False if not)

			.EXAMPLE
			PS C:\> if ( Get-AdminUser ) { Write-Output "Hello Admin User" }

			Description
			-----------
			Prints "Hello Admin User" to the Console if the session is started
			as Admin!

			.NOTES
			Just a little helper function

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([bool])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Set the objects
		Set-Variable -Name 'Id' -Value $([Security.Principal.WindowsIdentity]::GetCurrent())
		Set-Variable -Name 'IdWindowsPrincipal' -Value $(New-Object -TypeName Security.Principal.WindowsPrincipal -ArgumentList ($Id))
	}

	PROCESS {
		# Return what we have
		Write-Output -InputObject ('{0}' -f $IdWindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
	}
}

function Get-ASCBanner {
	<#
			.SYNOPSIS
			Create an ASC II Banner for a given string.

			.DESCRIPTION
			Create an ASC II Banner for a given string.
			It looks a bit 80s like first, but with PowerShell we heavily rely on the Shell. And ASCII Art might still be useful today.

			.PARAMETER IsString
			Is this a String that should be dumped as ASC Art?

			.PARAMETER ASCChar
			Character for the ASC Banner, * is the default

			.EXAMPLE
			PS C:\> Get-ASCBanner -InputString 'Welcome' -IsString -ASCChar '#'
			#     #
			#  #  #  ######  #        ####    ####   #    #  ######
			#  #  #  #       #       #    #  #    #  ##  ##  #
			#  #  #  #####   #       #       #    #  # ## #  #####
			#  #  #  #       #       #       #    #  #    #  #
			#  #  #  #       #       #    #  #    #  #    #  #
			## ##   ######  ######   ####    ####   #    #  ######

			Description
			-----------
			Create an ASC II Banner for a given String

			.EXAMPLE
			PS C:\scripts\PowerShell> Get-ASCBanner -InputString 'Alright-IT' -IsString -ASCChar '*'

			*                                                              ***   *******
			* *    *       *****      *     ****   *    *   *****            *       *
			*   *   *       *    *     *    *    *  *    *     *              *       *
			*     *  *       *    *     *    *       ******     *    *****     *       *
			*******  *       *****      *    *  ***  *    *     *              *       *
			*     *  *       *   *      *    *    *  *    *     *              *       *
			*     *  ******  *    *     *     ****   *    *     *             ***      *

			Description
			-----------
			Create an ASC II Banner for a given String

			.NOTES
			Just for fun!
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				ValueFromRemainingArguments,
				Position = 0,
		HelpMessage = 'The String')]
		[string[]]$InputString,
		[Parameter(Position = 1)]
		[switch]$IsString = ($True),
		[Parameter(Position = 2)]
		[char]$ASCChar = '*'
	)

	BEGIN {
		$bit = @(128, 64, 32, 16, 8, 4, 2, 1)
		$chars = @(
			@(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00), # ' '
			@(0x38, 0x38, 0x38, 0x10, 0x00, 0x38, 0x38), # '!'
			@(0x24, 0x24, 0x24, 0x00, 0x00, 0x00, 0x00), # '"' UNV
			@(0x28, 0x28, 0xFE, 0x28, 0xFE, 0x28, 0x28), # '#'
			@(0x7C, 0x92, 0x90, 0x7C, 0x12, 0x92, 0x7C), # '$'
			@(0xE2, 0xA4, 0xE8, 0x10, 0x2E, 0x4A, 0x8E), # '%'
			@(0x30, 0x48, 0x30, 0x70, 0x8A, 0x84, 0x72), # '&'
			@(0x38, 0x38, 0x10, 0x20, 0x00, 0x00, 0x00), # '''
			@(0x18, 0x20, 0x40, 0x40, 0x40, 0x20, 0x18), # '('
			@(0x30, 0x08, 0x04, 0x04, 0x04, 0x08, 0x30), # ')'
			@(0x00, 0x44, 0x28, 0xFE, 0x28, 0x44, 0x00), # '*'
			@(0x00, 0x10, 0x10, 0x7C, 0x10, 0x10, 0x00), # '+'
			@(0x00, 0x00, 0x00, 0x38, 0x38, 0x10, 0x20), # ','
			@(0x00, 0x00, 0x00, 0x7C, 0x00, 0x00, 0x00), # '-'
			@(0x00, 0x00, 0x00, 0x00, 0x38, 0x38, 0x38), # '.'
			@(0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80), # '/'
			@(0x38, 0x44, 0x82, 0x82, 0x82, 0x44, 0x38), # '0'
			@(0x10, 0x30, 0x50, 0x10, 0x10, 0x10, 0x7C), # '1'
			@(0x7C, 0x82, 0x02, 0x7C, 0x80, 0x80, 0xFE), # '2'
			@(0x7C, 0x82, 0x02, 0x7C, 0x02, 0x82, 0x7C), # '3'
			@(0x80, 0x84, 0x84, 0x84, 0xFE, 0x04, 0x04), # '4'
			@(0xFE, 0x80, 0x80, 0xFC, 0x02, 0x82, 0x7C), # '5'
			@(0x7C, 0x82, 0x80, 0xFC, 0x82, 0x82, 0x7C), # '6'
			@(0xFC, 0x84, 0x08, 0x10, 0x20, 0x20, 0x20), # '7'
			@(0x7C, 0x82, 0x82, 0x7C, 0x82, 0x82, 0x7C), # '8'
			@(0x7C, 0x82, 0x82, 0x7E, 0x02, 0x82, 0x7C), # '9'
			@(0x10, 0x38, 0x10, 0x00, 0x10, 0x38, 0x10), # ':'
			@(0x38, 0x38, 0x00, 0x38, 0x38, 0x10, 0x20), # ';'
			@(0x08, 0x10, 0x20, 0x40, 0x20, 0x10, 0x08), # '<'
			@(0x00, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0x00), # '=' UNV.
			@(0x20, 0x10, 0x08, 0x04, 0x08, 0x10, 0x20), # '>'
			@(0x7C, 0x82, 0x02, 0x1C, 0x10, 0x00, 0x10), # '?'
			@(0x7C, 0x82, 0xBA, 0xBA, 0xBC, 0x80, 0x7C), # '@'
			@(0x10, 0x28, 0x44, 0x82, 0xFE, 0x82, 0x82), # 'A'
			@(0xFC, 0x82, 0x82, 0xFC, 0x82, 0x82, 0xFC), # 'B'
			@(0x7C, 0x82, 0x80, 0x80, 0x80, 0x82, 0x7C), # 'C'
			@(0xFC, 0x82, 0x82, 0x82, 0x82, 0x82, 0xFC), # 'D'
			@(0xFE, 0x80, 0x80, 0xF8, 0x80, 0x80, 0xFE), # 'E'
			@(0xFE, 0x80, 0x80, 0xF8, 0x80, 0x80, 0x80), # 'F'
			@(0x7C, 0x82, 0x80, 0x9E, 0x82, 0x82, 0x7C), # 'G'
			@(0x82, 0x82, 0x82, 0xFE, 0x82, 0x82, 0x82), # 'H'
			@(0x38, 0x10, 0x10, 0x10, 0x10, 0x10, 0x38), # 'I'
			@(0x02, 0x02, 0x02, 0x02, 0x82, 0x82, 0x7C), # 'J'
			@(0x84, 0x88, 0x90, 0xE0, 0x90, 0x88, 0x84), # 'K'
			@(0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xFE), # 'L'
			@(0x82, 0xC6, 0xAA, 0x92, 0x82, 0x82, 0x82), # 'M'
			@(0x82, 0xC2, 0xA2, 0x92, 0x8A, 0x86, 0x82), # 'N'
			@(0xFE, 0x82, 0x82, 0x82, 0x82, 0x82, 0xFE), # 'O'
			@(0xFC, 0x82, 0x82, 0xFC, 0x80, 0x80, 0x80), # 'P'
			@(0x7C, 0x82, 0x82, 0x82, 0x8A, 0x84, 0x7A), # 'Q'
			@(0xFC, 0x82, 0x82, 0xFC, 0x88, 0x84, 0x82), # 'R'
			@(0x7C, 0x82, 0x80, 0x7C, 0x02, 0x82, 0x7C), # 'S'
			@(0xFE, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10), # 'T'
			@(0x82, 0x82, 0x82, 0x82, 0x82, 0x82, 0x7C), # 'U'
			@(0x82, 0x82, 0x82, 0x82, 0x44, 0x28, 0x10), # 'V'
			@(0x82, 0x92, 0x92, 0x92, 0x92, 0x92, 0x6C), # 'W'
			@(0x82, 0x44, 0x28, 0x10, 0x28, 0x44, 0x82), # 'X'
			@(0x82, 0x44, 0x28, 0x10, 0x10, 0x10, 0x10), # 'Y'
			@(0xFE, 0x04, 0x08, 0x10, 0x20, 0x40, 0xFE), # 'Z'
			@(0x7C, 0x40, 0x40, 0x40, 0x40, 0x40, 0x7C), # '['
			@(0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02), # '\'
			@(0x7C, 0x04, 0x04, 0x04, 0x04, 0x04, 0x7C), # ']'
			@(0x10, 0x28, 0x44, 0x00, 0x00, 0x00, 0x00), # '^'
			@(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE), # '_'
			@(0x00, 0x38, 0x38, 0x10, 0x08, 0x00, 0x00), # '`'
			@(0x00, 0x18, 0x24, 0x42, 0x7E, 0x42, 0x42), # 'a'
			@(0x00, 0x7C, 0x42, 0x7C, 0x42, 0x42, 0x7C), # 'b'
			@(0x00, 0x3C, 0x42, 0x40, 0x40, 0x42, 0x3C), # 'c'
			@(0x00, 0x7C, 0x42, 0x42, 0x42, 0x42, 0x7C), # 'd'
			@(0x00, 0x7E, 0x40, 0x7C, 0x40, 0x40, 0x7E), # 'e'
			@(0x00, 0x7E, 0x40, 0x7C, 0x40, 0x40, 0x40), # 'f'
			@(0x00, 0x3C, 0x42, 0x40, 0x4E, 0x42, 0x3C), # 'g'
			@(0x00, 0x42, 0x42, 0x7E, 0x42, 0x42, 0x42), # 'h'
			@(0x00, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08), # 'i'
			@(0x00, 0x02, 0x02, 0x02, 0x02, 0x42, 0x3C), # 'j'
			@(0x00, 0x42, 0x44, 0x78, 0x48, 0x44, 0x42), # 'k'
			@(0x00, 0x40, 0x40, 0x40, 0x40, 0x40, 0x7E), # 'l'
			@(0x00, 0x42, 0x66, 0x5A, 0x42, 0x42, 0x42), # 'm'
			@(0x00, 0x42, 0x62, 0x52, 0x4A, 0x46, 0x42), # 'n'
			@(0x00, 0x3C, 0x42, 0x42, 0x42, 0x42, 0x3C), # 'o'
			@(0x00, 0x7C, 0x42, 0x42, 0x7C, 0x40, 0x40), # 'p'
			@(0x00, 0x3C, 0x42, 0x42, 0x4A, 0x44, 0x3A), # 'q'
			@(0x00, 0x7C, 0x42, 0x42, 0x7C, 0x44, 0x42), # 'r'
			@(0x00, 0x3C, 0x40, 0x3C, 0x02, 0x42, 0x3C), # 's'
			@(0x00, 0x3E, 0x08, 0x08, 0x08, 0x08, 0x08), # 't'
			@(0x00, 0x42, 0x42, 0x42, 0x42, 0x42, 0x3C), # 'u'
			@(0x00, 0x42, 0x42, 0x42, 0x42, 0x24, 0x18), # 'v'
			@(0x00, 0x42, 0x42, 0x42, 0x5A, 0x66, 0x42), # 'w'
			@(0x00, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42), # 'x'
			@(0x00, 0x22, 0x14, 0x08, 0x08, 0x08, 0x08), # 'y'
			@(0x00, 0x7E, 0x04, 0x08, 0x10, 0x20, 0x7E), # 'z'
			@(0x38, 0x40, 0x40, 0xC0, 0x40, 0x40, 0x38), # '{'
			@(0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10), # '|'
			@(0x38, 0x04, 0x04, 0x06, 0x04, 0x04, 0x38), # '}'
			@(0x60, 0x92, 0x0C, 0x00, 0x00, 0x00, 0x00) # '~'
		)

		$o = (New-Object -TypeName psobject)
		Add-Member -InputObject $o -MemberType NoteProperty -Name OriginalStrings -Value @()
		$o.psobject.typenames.Insert(0, 'Banner')
	}
	PROCESS {
		$o.OriginalStrings += $InputString
		$output = ''
		$width = [math]::floor(($Host.ui.rawui.buffersize.width - 1)/8)
		# check and bail if a string is too long
		foreach ($substring in $InputString) {
			if ($substring.length -gt $width) { throw ('strings must be less than {0} characters' -f $width) }
		}

		foreach ($substring in $InputString) {
			for ($r = 0; $r -lt 7; $r++) {
				foreach ($c in $substring.ToCharArray()) {
					$bitmap = 0

					if (($c -ge ' ') -and ($c -le [char]'~')) {
						$offset = (([int]$c) - 32)
						$bitmap = ($chars[$offset][$r])
					}

					for ($c = 0; $c -lt 8; $c++) {if ($bitmap -band $bit[$c]) { $output += $ASCChar } else { $output += ' ' }}
				}

				$output += "`n"
			}
		}
		#$output
		$sb = ($executioncontext.invokecommand.NewScriptBlock("'$output'"))
		$o | Add-Member -Force -MemberType ScriptMethod -Name ToString -Value $sb

		if ($IsString) {
			$o.ToString()
		} else {
			$o
		}
	}
}

function Get-AvailibleDriveLetter {
	<#
			.SYNOPSIS
			Get an available Drive Letter

			.DESCRIPTION
			Get an available Drive Letter, next free available or random

			.PARAMETER Random
			Get a random available Drive letter instead of the next free one.

			.EXAMPLE
			PS C:\> Get-AvailibleDriveLetter -Random
			O:

			Description
			-----------
			Get an available Drive Letter (A Random selection of a free letter)

			.EXAMPLE
			PS C:\> Get-AvailibleDriveLetter
			F:

			Description
			-----------
			Get the next available unused Drive Letter (non random)

			.NOTES
			Found the base idea on PowerShellMagazine

			.LINK
			http://www.powershellmagazine.com/2012/01/12/find-an-unused-drive-letter/
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param
	(
		[switch]$Random
	)

	PROCESS {
		if ($Random) {
			Get-ChildItem -Path function:[d-z]: -Name |
			Where-Object -FilterScript { !(Test-Path -Path $_) } |
			Get-Random
		} else {
			for ($j = 67; Get-PSDrive -Name ($d = [char]++$j)2>0) { }$d + ':'
		}
	}
}

function Get-BingSearch {
	<#
			.SYNOPSIS
			It gets the Bing search results for a string.

			.DESCRIPTION
			It gets the latest Bing search results for a given string and presents it on the console.

			.PARAMETER searchstring
			String to search for on Bing

			.EXAMPLE
			PS C:\> Get-BingSearch -searchstring "Joerg Hochwald"

			Description
			-----------
			Return the Bing Search Results for "Joerg Hochwald"

			.EXAMPLE
			PS C:\> Get-BingSearch -searchstring "KreativSign GmbH"

			Description
			-----------
			Return the Bing Search Results for "KreativSign GmbH" as a formated
			List (fl = Format-List)

			.NOTES
			This is a function that Michael found useful, so we adopted and
			tweaked it a bit.

			The original function was found somewhere on the Internet!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param
	(
		[ValidateNotNullOrEmpty()]
		[Alias('Search')]
		[String]$searchstring = $(throw 'Please specify a search string.')
	)

	BEGIN {
		# Use the native .NET Client implementation
		$client = New-Object -TypeName System.Net.WebClient

		# What to call?
		$url = "http://www.bing.com/search?q={0}`&format=rss" -f $searchstring
	}

	PROCESS {
		# By the way: This is XML ;-)
		[xml]$results = ($client.DownloadString($url))

		# Save the info to a variable
		$channel = ($results.rss.channel)

		# Now we loop over the return
		foreach ($item in $channel.item) {
			# Create a new Object
			$result = (New-Object -TypeName PSObject)

			# Fill the new Object
			Add-Member -InputObject $result -MemberType NoteProperty -Name Title -Value $item.title
			Add-Member -InputObject $result -MemberType NoteProperty -Name Link -Value $item.link
			Add-Member -InputObject $result -MemberType NoteProperty -Name Description -Value $item.description
			Add-Member -InputObject $result -MemberType NoteProperty -Name PubDate -Value $item.pubdate

			$sb = {
				$ie = New-Object -ComObject internetexplorer.application
				$ie.navigate($this.link)
				$ie.visible = $True
			}

			$result | Add-Member -MemberType ScriptMethod -Name Open -Value $sb
		}
	}

	END {
		# Dump it to the console
		Write-Output -InputObject $result
	}
}

function Get-Calendar {
	<#
			.SYNOPSIS
			It displays a calendar to the console.

			.DESCRIPTION
			It displays a calendar to the console.
			You might find it handy to have that on a core server or in a remote PowerShell session.

			.PARAMETER StartDate
			The Date the Calendar should start

			.EXAMPLE
			PS C:\> Get-Calendar
			April 2016
			Mo Tu We Th Fr Sa Su
			01 02 03
			04 05 06 07 08 09 10
			11 12 13 14 15 16 17
			18 19 20 21 22 23 24
			25 26 27 28 29 30

			Description
			-----------
			Dumps a calendar to the console.
	#>

	[CmdletBinding()]
	param
	(
		[ValidateNotNullOrEmpty()]
		[datetime]$StartDate = (Get-Date)
	)

	BEGIN {
		$startDay = (Get-Date -Date (Get-Date -Date $StartDate -Format 'yyyy-MM-01'))
	}

	PROCESS {
		Write-Host -Object (Get-Date -Date $StartDate -Format 'MMMM yyyy')
		Write-Host -Object 'Mo Tu We Th Fr Sa Su'

		For ($i = 1; $i -lt (Get-Date -Date $startDay).dayOfWeek.value__; $i++) { Write-Host -Object '   ' -NoNewline }

		$processDate = $startDay

		while ($processDate -lt $startDay.AddMonths(1)) {
			Write-Host -Object (Get-Date -Date $processDate -Format 'dd ') -NoNewline

			if ((Get-Date -Date $processDate).dayOfWeek.value__ -eq 0) {
				Write-Host -Object ''
			}

			$processDate = $processDate.AddDays(1)
		}

		Write-Host -Object ''
	}
}

function Get-DiskInfo {
	<#
			.SYNOPSIS
			Show free disk space for all disks.

			.DESCRIPTION
			It shows the free disk space for all available disks.

			.EXAMPLE
			PS C:\> Get-DiskInfo
			Loading system disk free space information...
			C Drive has 24,77 GB of free space.
			D Drive has 1,64 GB of free space.

			Description
			-----------
			It shows the free disk space for all available disks.

			.NOTES
			Internal Helper
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param ()

	PROCESS {
		$wmio = (Get-WmiObject -Class win32_logicaldisk)

		$Drives = ($wmio |
			Where-Object -FilterScript { ($_.size) } |
			Select-Object -Property Deviceid, @{
				name       = 'Free Space'
				Expression = { ($_.freespace/1gb) }
		})

		$DrivesString = (0..$($Drives.count - 1) | ForEach-Object -Process { " $(($Drives[$_]).Deviceid.Replace(':', ' Drive')) has $('{0:N2}' -f $(($Drives[$_]).'free space')) GB of free space.`r`n" })
		$DrivesString = "`r`nLoading system disk free space information...`r`n" + $DrivesString
	}

	END {
		Write-Output -InputObject $DrivesString -NoEnumerate
	}
}

function Get-EnvironmentVariables {
	<#
			.SYNOPSIS
			Get and list all environment variables.

			.DESCRIPTION
			Dump all existing environment variables.
			Sometimes this becomes handy if you do something that changes them; and you want to compare the values before and after the changes (see examples).

			.EXAMPLE
			PS C:\> Get-EnvironmentVariables

			Description
			-----------
			Get and list all environment variables.

			.EXAMPLE
			PS C:\> $before = (Get-EnvironmentVariables)
			PS C:\> Installer
			PS C:\> $after = (Get-EnvironmentVariables)
			PS C:\> Compare-Object -ReferenceObject $before -DifferenceObject $after

			Description
			-----------
			Get and list all Environment Variables and save them to a variable.
			Install, or do whatever you want to do... Something that might change the Environment Variables.
			Get and list all Environment Variables again and save them to a variable.
			Then we compare the two results...

			.EXAMPLE
			PS C:\> (Get-EnvironmentVariables) | C:\scripts\PowerShell\export\before.txt
			PS C:\> Installer
			PS C:\> reboot
			PS C:\> (Get-EnvironmentVariables) | C:\scripts\PowerShell\export\after.txt
			PS C:\> Compare-Object -ReferenceObject 'C:\scripts\PowerShell\export\before.txt' -DifferenceObject 'C:\scripts\PowerShell\export\after.txt'

			Description
			-----------
			Get and list all Environment Variables and save them to a file.
			Install, or do whatever you want to do... Something that might change the Environment Variables.
			Get and list all Environment Variables again and save them to another file.
			Then we compare the two results...

			.NOTES
			Initial Version...
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param ()

	(Get-ChildItem -Path env: | Sort-Object -Property name)
}

function Get-ExternalIP {
	<#
			.Synopsis
			Get the current external IP address.

			.Description
			Get the current external IP address.

			.PARAMETER Speed
			Try to measure the speed of the actual connection.

			.PARAMETER Ping
			Use Ping to see if a given host is reachable. Useful to see if we have a working Internet connection.

			.PARAMETER short
			Minimize the output.

			.PARAMETER PingHost
			Ping the given host

			.Example
			PS C:\> Get-ExternalIP -Short
			84.132.180.143

			Description
			-----------
			Get the current external IP address.

			.Example
			PS C:\> Get-ExternalIP -Speed
			Current external IP Address:  84.132.174.61
			Download Speed: 136,95 Mbit/sec

			Description
			-----------
			Get the current external IP address and measure the download speed of the actual connection.

			.Example
			PS C:\> Get-ExternalIP -Ping
			Current external IP Address:  84.132.174.61
			Ping Info for 8.8.8.8: Minimum = 30ms, Maximum = 31ms, Average = 30ms

			Description
			-----------
			Get the current external IP address and measure the Ping Time.

			.Example
			PS C:\> Get-ExternalIP -Ping -Speed
			Current external IP Address:  84.132.174.61
			Download Speed: 102,73 Mbit/sec
			Ping Info for 8.8.8.8: Minimum = 30ms, Maximum = 31ms, Average = 30ms

			Description
			-----------
			Get the current external IP address and measure the Ping Time and Download Speed.


			.Example
			PS C:\> Get-ExternalIP
			Current external IP Address:  84.132.174.61

			Description
			-----------
			Get the current external IP address in longer format.

			.NOTES
			TODO: Move the check function to another Server and enable https

			.LINK
			https://tools.aitlab.de/ip.php
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param
	(
		[switch]$Speed,
		[switch]$Ping,
		[switch]$Short,
		[String]$PingHost = '8.8.8.8'
	)

	BEGIN {
		# URL to ask
		$site = 'https://tools.aitlab.de/ip.php'
	}

	PROCESS {
		try {
			# Use the native Web call function
			$beginbrowser = (New-Object -TypeName System.Net.WebClient)
			$get = ($beginbrowser.downloadString($site))
		} catch {
			if ($_.Exception.HResult -eq '-2146233087') {
				Write-Error -Message 'Not connected to the Internet!' -ErrorAction Stop
			} else {
				Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop
			}

			# Done!!!
			break
		}

		if ($Speed) {
			$SpeedInfo = 'Download Speed: {0:N2} Mbit/sec' -f ((10/(Measure-Command -Expression { $null = Invoke-WebRequest -Uri 'http://cachefly.cachefly.net/1mb.test' }).TotalSeconds) * 8)
		}

		if ($Ping) {
			$PingData = (& "$env:windir\system32\ping.exe" $PingHost)
			$PingInfo = ('Ping Info for {0}: {1}' -f ($PingHost), $PingData[10].Trim())
		}
	}

	END {
		# Dump the IP info
		if ($Short) {
			Write-Output -InputObject $get
		} else {
			Write-Output -InputObject ('Current external IP Address:  {0}' -f $get)
			if ($Speed) {
				$SpeedInfo
			}
			if ($Ping) {
				$PingInfo
			}
		}
	}
}

function Get-FreeDiskSpace {
	<#
			.SYNOPSIS
			It shows the free disk space of all local disks.

			.DESCRIPTION
			This is a Uni* DF like command that shows the available disk space.
			It is human readable (e.g. more like df -h)

			.EXAMPLE
			PS C:\scripts\PowerShell> Get-FreeDiskSpace
			Name Disk Size(GB) Free (%)
			---- ------------- --------
			C          64         42%
			D           2         84%

			Description
			-----------
			It shows the free disk space of all local disks.

			.NOTES
			Just a quick hack to make Powershell more Uni* like

			.LINK
			Idea http://www.computerperformance.co.uk/powershell/powershell_get_psdrive.htm
	#>

	[OutputType([Array])]
	[CmdletBinding()]
	param ()

	PROCESS {
		# Get all Disks (Only logical drives of type 3)
		$Disks = ((Get-WmiObject -Class win32_logicaldisk | Where-Object -FilterScript { $_.DriveType -eq 3 }).DeviceID)

		# remove the ":" from the windows like Drive letter
		$Disks = ($Disks -replace '[:]', '')

		# Not sexy, but it works!
		# Base Idea is from here: http://www.computerperformance.co.uk/powershell/powershell_get_psdrive.htm
		(Get-PSDrive -Name $Disks | Format-Table -Property Name, @{
				Name       = 'Disk Size(GB)'
				Expression = { '{0,8:N0}' -f ($_.free/1gb + $_.used/1gb) }
			}, @{
				Name       = 'Free (%)'
				Expression = { '{0,6:P0}' -f ($_.free / ($_.free + $_.used)) }
		} -AutoSize)
	}
}

function Get-Hash {
	<#
			.SYNOPSIS
			It dumps the MD5 hash for the given file object.

			.DESCRIPTION
			It dumps the MD5 hash for the given file object.

			.PARAMETER File
			File or path to dump MD5 Hash for

			.PARAMETER Hash
			It specifies the cryptographic hash function to use for computing the hash value to the contents of the specified file.

			.EXAMPLE
			PS C:\> Get-Hash -File 'C:\scripts\PowerShell\profile.ps1'
			30BB3458D34B1A0F10E52F9F39025925

			Description
			-----------
			Dumps the MD5 hash for the given File

			.EXAMPLE
			PS C:\> Get-Hash -File 'C:\scripts\PowerShell\profile.ps1' -hash SHA1
			36A09B3C5BCB35AE48719D31699E96F72721FFFE

			Description
			-----------
			Dumps the SHA1 hash for the given File

			.NOTES
			It is removed and replaced with a wrapper of the native PowerShell function!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'File or path to dum MD5 Hash for')]
		[String]$File,
		[Parameter(ValueFromPipeline,
		Position = 1)]
		[ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160')]
		[ValidateNotNullOrEmpty()]
		[String]$hash = 'MD5'
	)

	PROCESS {
		if (Get-Command -Name Get-FileHash -ErrorAction SilentlyContinue) {
			Return (Get-FileHash -Algorithm $hash -Path $File).Hash
		} else {
			Return $False
		}
	}
}

function Get-HostFileEntry {
	<#
			.SYNOPSIS
			It dumps the HOSTS File to the Console

			.DESCRIPTION
			It dumps the HOSTS File to the Console
			It dumps the WINDIR\System32\drivers\etc\hosts file! And only this.

			.EXAMPLE
			PS C:\> Get-HostFileEntry

			IP                                                              Hostname
			--                                                              --------
			10.211.55.123                                                   GOV13714W7
			10.211.55.10                                                    jhwsrv08R2
			10.211.55.125                                                   KSWIN07DEV

			Description
			-----------
			Dumps the HOSTS File to the Console

			.NOTES
			This is just a little helper function to make the shell more flexible
			Sometimes I need to know what is set in the HOSTS File...
			So I came up with that approach.

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		# Cleanup
		$HostOutput = @()

		# Which File to load
		Set-Variable -Name 'HostFile' -Scope Script -Value $($env:windir + '\System32\drivers\etc\hosts')

		# REGEX Filter
		[regex]$r = '\S'
	}

	PROCESS {
		# Open the File from above
		Get-Content -Path $HostFile |
		Where-Object -FilterScript {(($r.Match($_)).value -ne '#') -and ($_ -notmatch '^\s+$') -and ($_.Length -gt 0)} |
		ForEach-Object -Process {
			$null = $_ -match '(?<IP>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(?<HOSTNAME>\S+)'
			$HostOutput += New-Object -TypeName PSCustomObject -Property @{
				'IP'     = $matches.ip
				'Hostname' = $matches.hostname
			}
		}

		# Dump it to the Console
		Write-Output -InputObject $HostOutput
	}
}

function Get-HttpHead {
	<#
			.Synopsis
			It retrieves the HTTP headers from a given web server.

			.Description
			This command will get the HTTP headers from the target web server and test for the presence of various security-related HTTP headers and also display the cookie information.

			.PARAMETER url
			The URL for inspection, e.g. https://www.linkedin.com

			.Example
			PS C:> Get-HttpHead -url https://www.linkedin.com

			Header Information for https://www.linkedin.com

			Description
			-----------
			Retrieve HTTPs Headers from www.linkedin.com

			.Example
			PS C:> Get-HttpHead -url http://enatec.io

			Header Information for http://enatec.io

			Description
			-----------
			Retrieve HTTP Headers from enatec.io

			.NOTES
			Based on an idea of Dave Hardy, davehardy20@gmail.com @davehrdy20

			.LINK
			Source: https://github.com/davehardy20/PowerShell-Scripts/blob/master/Get-HttpSecHead.ps1
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				ValueFromPipelineByPropertyName,
				Position = 0,
		HelpMessage = 'The URL for inspection, e.g. https://www.linkedin.com')]
		[ValidateNotNullOrEmpty()]
		[Alias('link')]
		[String]$url
	)

	BEGIN {
		# Cleanup
		$webrequest = $null
		$cookies = $null
		$cookie = $null
	}

	PROCESS {
		$webrequest = (Invoke-WebRequest -Uri $url -SessionVariable websession)
		$cookies = ($websession.Cookies.GetCookies($url))

		Write-Host -Object "`n"
		Write-Host 'Header Information for' $url
		Write-Host -Object ($webrequest.Headers | Out-String)
		Write-Host

		Write-Host -ForegroundColor White -Object "HTTP security Headers`nConsider adding the values in RED to improve the security of the webserver. `n"

		if ($webrequest.Headers.ContainsKey('x-xss-protection')) { Write-Host -ForegroundColor Green -Object "X-XSS-Protection Header PRESENT`n" } else { Write-Host -ForegroundColor Red -Object 'X-XSS-Protection Header MISSING' }
		if ($webrequest.Headers.ContainsKey('Strict-Transport-Security')) { Write-Host -ForegroundColor Green -Object 'Strict-Transport-Security Header PRESENT' } else { Write-Host -ForegroundColor Red -Object 'Strict-Transport-Security Header MISSING' }
		if ($webrequest.Headers.ContainsKey('Content-Security-Policy')) { Write-Host -ForegroundColor Green -Object 'Content-Security-Policy Header PRRESENT' } else { Write-Host -ForegroundColor Red -Object 'Content-Security-Policy Header MISSING' }
		if ($webrequest.Headers.ContainsKey('X-Frame-Options')) { Write-Host -ForegroundColor Green -Object 'X-Frame-Options Header PRESENT' } else { Write-Host -ForegroundColor Red -Object 'X-Frame-Options Header MISSING' }
		if ($webrequest.Headers.ContainsKey('X-Content-Type-Options')) { Write-Host -ForegroundColor Green -Object 'X-Content-Type-Options Header PRESENT' } else { Write-Host -ForegroundColor Red -Object 'X-Content-Type-Options Header MISSING' }
		if ($webrequest.Headers.ContainsKey('Public-Key-Pins')) { Write-Host -ForegroundColor Green -Object 'Public-Key-Pins Header PRESENT' } else { Write-Host -ForegroundColor Red -Object 'Public-Key-Pins Header MISSING' }

		Write-Host -Object "`n"

		Write-Host 'Cookies Set by' $url
		Write-Host -Object "Inspect cookies that don't have the HTTPOnly and Secure flags set."
		Write-Host -Object "`n"

		foreach ($cookie in $cookies) {
			Write-Host -Object ('{0} = {1}' -f $cookie.name, $cookie.value)

			if ($cookie.HttpOnly -eq 'True') { Write-Host -Object ('HTTPOnly Flag Set = {0}' -f $cookie.HttpOnly) -ForegroundColor Green } else { Write-Host -Object ('HTTPOnly Flag Set = {0}' -f $cookie.HttpOnly) -ForegroundColor Red }

			if ($cookie.Secure -eq 'True') { Write-Host -Object ('Secure Flag Set = {0}' -f $cookie.Secure) -ForegroundColor Green } else { Write-Host -Object ('Secure Flag Set = {0}' -f $cookie.Secure) -ForegroundColor Red }

			Write-Host -Object ("Domain = {0} `n" -f $cookie.Domain)
		}
	}

	END {
		# Cleanup
		$webrequest = $null
		$cookies = $null
		$cookie = $null
	}
}

function Get-InstalledDotNetVersions {
	<#
			.SYNOPSIS
			It shows all installed .NET versions

			.DESCRIPTION
			It shows all .NET versions installed on the local system

			.EXAMPLE
			PS C:\> Get-InstalledDotNetVersions

			Version FullVersion
			------- -----------
			2.0     2.0.50727.5420
			3.0     3.0.30729.5420
			3.5     3.5.30729.5420
			4.0     4.0.0.0
			4.5+    4.6.1

			Description
			-----------
			Shows all .NNET versions installed on the local system

			.NOTES
			Based on Show-MyDotNetVersions from Tzvika N 9. I just tweaked the Code and removed the HTML parts
			All Versions after .NET 4.5 will have the Version 4.5+ and show the full version in the FullVersion

			.LINK
			http://poshcode.org/6403
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	[CmdletBinding()]
	param ()

	BEGIN {
		$RegistryBase = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP'
		$RegistryDotNet20 = "$($RegistryBase)\v2.0*"
		$RegistryDotNet30 = "$($RegistryBase)\v3.0"
		$RegistryDotNet35 = "$($RegistryBase)\v3.5"
		$RegistryDotNet40 = "$($RegistryBase)\v4.0\Client"
		$RegistryDotNet45 = "$($RegistryBase)\v4\Full"
	}

	PROCESS {
		# .Net 2.0
		if (Test-Path -Path $RegistryDotNet20) { $DotNet20 = ((Get-ItemProperty -Path $RegistryDotNet20 -Name Version).Version) }

		# .Net 3.0
		if (Test-Path -Path $RegistryDotNet30) { $DotNet30 = ((Get-ItemProperty -Path $RegistryDotNet30 -Name Version).Version) }

		# .Net 3.5
		if (Test-Path -Path $RegistryDotNet35) { $DotNet35 = ((Get-ItemProperty -Path $RegistryDotNet35 -Name Version).Version) }

		# .Net 4.0
		if (Test-Path -Path $RegistryDotNet40) { $DotNet40 = ((Get-ItemProperty -Path $RegistryDotNet40 -Name Version).Version) }

		# .Net 4.5 and later
		if (Test-Path -Path $RegistryDotNet45) {
			$verDWord = ((Get-ItemProperty -Path $RegistryDotNet45 -Name Release).Release)

			switch ($verDWord) {
				378389 { $DotNet45 = '4.5'
				break }
				378675 { $DotNet45 = '4.5.1'
				break }
				378758 { $DotNet45 = '4.5.1'
				break }
				379893 { $DotNet45 = '4.5.2'
				break }
				393295 { $DotNet45 = '4.6'
				break }
				393297 { $DotNet45 = '4.6'
				break }
				394254 { $DotNet45 = '4.6.1'
				break }
				394271 { $DotNet45 = '4.6.1'
				break }
				394747 { $DotNet45 = '4.6.2'
				break }
				394748 { $DotNet45 = '4.6.2'
				break }
				default { $DotNet45 = '4.5' }
			}
		}

		$dotNetProperty20 = [ordered]@{
			Version     = '2.0'
			FullVersion = $DotNet20
		}
		$dotNetProperty30 = [ordered]@{
			Version     = '3.0'
			FullVersion = $DotNet30
		}
		$dotNetProperty35 = [ordered]@{
			Version     = '3.5'
			FullVersion = $DotNet35
		}
		$dotNetProperty40 = [ordered]@{
			Version     = '4.0'
			FullVersion = $DotNet40
		}
		$dotNetProperty45 = [ordered]@{
			Version     = '4.5+'
			FullVersion = $DotNet45
		}

		$dotNetObject20 = (New-Object -TypeName psobject -Property $dotNetProperty20)
		$dotNetObject30 = (New-Object -TypeName psobject -Property $dotNetProperty30)
		$dotNetObject35 = (New-Object -TypeName psobject -Property $dotNetProperty35)
		$dotNetObject40 = (New-Object -TypeName psobject -Property $dotNetProperty40)
		$dotNetObject45 = (New-Object -TypeName psobject -Property $dotNetProperty45)

		$dotNetVersionObjects = $dotNetObject20, $dotNetObject30, $dotNetObject35, $dotNetObject40, $dotNetObject45
	}

	END {
		Write-Output -InputObject $dotNetVersionObjects
	}
}

function Get-IsSessionElevated {
	<#
			.SYNOPSIS
			Is the Session started as admin (Elevated)

			.DESCRIPTION
			Quick Helper that return if the session is started as admin (Elevated)
			It returns a Boolean (True or False) and sets a global variable (IsSessionElevated) with this Boolean value.
			This might be useful for further use!

			.EXAMPLE
			PS C:\> Get-IsSessionElevated
			True

			Description
			-----------
			If the session is elevated

			.EXAMPLE
			PS C:\> Get-IsSessionElevated
			False

			Description
			-----------
			If the session is not elevated

			.NOTES
			Quick Helper that Return if the session is started as admin (Elevated)

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([bool])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Build the current Principal variable
		[Security.Principal.WindowsPrincipal]$currentPrincipal = (New-Object -TypeName System.Security.Principal.WindowsPrincipal -ArgumentList ([Security.Principal.WindowsIdentity]::GetCurrent()))

		# Do we have admin permission?
		[Security.Principal.WindowsBuiltInRole]$administratorsRole = ([Security.Principal.WindowsBuiltInRole]::Administrator)
	}

	PROCESS {
		if ($currentPrincipal.IsInRole($administratorsRole)) {
			# Set the Variable
			Set-Variable -Name IsSessionElevated -Scope Global -Value $True

			# Yep! We have some power...
			Return $True
		} else {
			# Set the Variable
			Set-Variable -Name IsSessionElevated -Scope Global -Value $False

			# Nope! Regular User Session!
			Return $False
		}
	}
}

function Get-IsVirtual {
	<#
			.SYNOPSIS
			It checks if the is a Virtual Machine

			.DESCRIPTION
			It checks if the is a Virtual Machine
			If this is a virtual System the Boolean is True, if not it is False

			.EXAMPLE
			PS C:\> Get-IsVirtual
			True

			Description
			-----------
			If this is a virtual System the Boolean is True, if not it is False

			.EXAMPLE
			PS C:\> Get-IsVirtual
			False

			Description
			-----------
			If this is not a virtual System the Boolean is False, if so it is True

			.NOTES
			The Function name is changed!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([bool])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Cleanup
		Remove-Variable -Name SysInfo_IsVirtual -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name SysInfoVirtualType -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name WMI_BIOS -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name WMI_ComputerSystem -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		# Get some System infos via NET (WMI) call
		Set-Variable -Name 'WMI_BIOS' -Scope Script -Value $($WMI_BIOS = (Get-WmiObject -Class 'Win32_BIOS' -ErrorAction Stop | Select-Object -Property 'Version', 'SerialNumber'))
		Set-Variable -Name 'WMI_ComputerSystem' -Scope Script -Value $((Get-WmiObject -Class 'Win32_ComputerSystem' -ErrorAction Stop | Select-Object -Property 'Model', 'Manufacturer'))

		# First we try to figure out if this is a Virtual Machine based on the
		# Bios Serial information that we get via WMI
		if ($WMI_BIOS.SerialNumber -like '*VMware*') {
			Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
			Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('VMWare')
		} elseif ($WMI_BIOS.Version -like 'VIRTUAL') {
			Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
			Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('Hyper-V')
		} elseif ($WMI_BIOS.Version -like 'A M I') {
			Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
			Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('Virtual PC')
		} elseif ($WMI_BIOS.Version -like '*Xen*') {
			Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
			Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('Xen')
		} elseif (($WMI_BIOS.Version -like 'PRLS*') -and ($WMI_BIOS.SerialNumber -like 'Parallels-*')) {
			Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
			Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('Parallels')
		}

		# Looks like this is not a Virtual Machine, but to make sure that figure it out!
		# So we try some other information that we have via WMI :-)
		if (-not ($SysInfo_IsVirtual)) {
			if ($WMI_ComputerSystem.Manufacturer -like '*Microsoft*') {
				Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
				Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('Hyper-V')
			} elseif ($WMI_ComputerSystem.Manufacturer -like '*VMWare*') {
				Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
				Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('VMWare')
			} elseif ($WMI_ComputerSystem.Manufacturer -like '*Parallels*') {
				Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
				Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('Parallels')
			} elseif ($wmisystem.model -match 'VirtualBox') {
				Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
				Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('VirtualBox')
			} elseif ($wmisystem.model -like '*Virtual*') {
				Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($True)
				Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('Unknown Virtual Machine')
			}
		}

		# OK, this does not look like a Virtual Machine to us!
		if (-not ($SysInfo_IsVirtual)) {
			Set-Variable -Name 'SysInfo_IsVirtual' -Scope Script -Value $($False)
			Set-Variable -Name 'SysInfoVirtualType' -Scope Script -Value $('Not a Virtual Machine')
		}

		# Dump the Boolean Info!
		Write-Output -InputObject ('{0}' -f $SysInfo_IsVirtual)

		# Write some Debug Infos ;-)
		Write-Verbose -Message ('{0}' -f $SysInfoVirtualType)
	}

	END {
		# Cleanup
		Remove-Variable -Name SysInfo_IsVirtual -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name SysInfoVirtualType -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name WMI_BIOS -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name WMI_ComputerSystem -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}
}

function Get-LocalIPAdresses {
	<#
			.SYNOPSIS
			Show all local IP Addresses

			.DESCRIPTION
			Show all local IP Addresses

			.PARAMETER LinkLocal
			Show IsIPv6LinkLocal?

			.EXAMPLE
			PS C:\> Get-LocalIPAdresses

			IPAddressToString                                          AddressFamily
			-----------------                                          -------------
			fe80::3db7:8507:3f9a:bb13%11                              InterNetworkV6
			10.211.55.125                                               InterNetwork

			Description
			-----------
			Show all local IP Addresses

			.EXAMPLE
			PS C:\> Get-LocalIPAdresses

			IPAddressToString  AddressFamily
			-----------------  -------------
			10.211.55.5         InterNetwork
			::1               InterNetworkV6

			Description
			-----------
			Show all local IP Addresses

			.EXAMPLE
			PS C:\> Get-LocalIPAdresses | Format-List

			IPAddressToString : fe80::3db7:8507:3f9a:bb13%11
			AddressFamily     : InterNetworkV6

			IPAddressToString : 10.211.55.125
			AddressFamily     : InterNetwork

			Description
			-----------
			Show all local IP Addresses, formated

			.EXAMPLE
			PS C:\> Get-LocalIPAdresses -LinkLocal | ConvertTo-Csv -NoTypeInformation
			"IPAddressToString","AddressFamily","IsIPv6LinkLocal"
			"fe80::3db7:8507:3f9a:bb13%11","InterNetworkV6","True"
			"10.211.55.125","InterNetwork","False"

			Description
			-----------
			Show all local IP Addresses as CSV and shows IsIPv6LinkLocal info
	#>

	[CmdletBinding()]
	param
	(
		[switch]$LinkLocal
	)

	BEGIN {
		# Cleanup
		$result = @()
	}

	PROCESS {
		$AllIpInfo = @()

		# Get the info via .NET
		$AllIpInfo = ([Net.DNS]::GetHostAddresses([Net.DNS]::GetHostName()))

		# Loop over the Info
		foreach ($SingleIpInfo in $AllIpInfo) {
			$Object = New-Object -TypeName PSObject -Property @{
				AddressFamily     = $SingleIpInfo.AddressFamily
				IPAddressToString = $SingleIpInfo.IPAddressToString
			}

			if ($LinkLocal) {
				if (($SingleIpInfo.IsIPv6LinkLocal) -eq $True) {$Object | Add-Member -TypeName 'NoteProperty' -Name IsIPv6LinkLocal -Value $True} else {$Object | Add-Member -TypeName 'NoteProperty' -Name IsIPv6LinkLocal -Value $False}
			}

			# Add
			$result += $Object

			# Cleanup
			$Object = $null
		}

	}

	END {
		# DUMP
		Write-Output -InputObject $result -NoEnumerate
		# Cleanup
		$result = $null
	}
}

function Get-LocalListenPort {
	<#
			.SYNOPSIS
			This parses the native netstat.exe output using the command line
			"netstat -anb" to find all of the network ports in use on a local
			machine and all associated processes and services

			.DESCRIPTION
			This parses the native netstat.exe output using the command line
			"netstat -anb" to find all of the network ports in use on a local
			machine and all associated processes and services

			.EXAMPLE
			PS> Get-LocalListenPort

			Description
			-----------
			This example will find all network ports in uses on the local
			computer with associated processes and services

			.EXAMPLE
			PS> Get-LocalListenPort | Where-Object {$_.ProcessOwner -eq 'svchost.exe'}
			RemotePort    : 0
			ProcessOwner  : svchost.exe
			IPVersion     : IPv4
			LocalPort     : 135
			State         : LISTENING
			LocalAddress  : 0.0.0.0
			RemoteAddress : 0.0.0.0
			Protocol      : TCP
			Service       : RpcSs

			Description
			-----------
			This example will find all network ports in use on the local computer
			that were opened by the svchost.exe process. (Example output trimmed)

			.EXAMPLE
			PS> Get-LocalListenPort | Where-Object {$_.IPVersion -eq 'IPv4'}
			RemotePort    : 0
			ProcessOwner  : svchost.exe
			IPVersion     : IPv4
			LocalPort     : 135
			State         : LISTENING
			LocalAddress  : 0.0.0.0
			RemoteAddress : 0.0.0.0
			Protocol      : TCP
			Service       : RpcSs

			Description
			-----------
			This example will find all network ports in use on the local computer
			using IPv4 only. (Example output trimmed)

			.EXAMPLE
			PS> Get-LocalListenPort | Where-Object {$_.IPVersion -eq 'IPv6'}
			RemotePort    : 0
			ProcessOwner  : svchost.exe
			IPVersion     : IPv6
			LocalPort     : 135
			State         : LISTENING
			LocalAddress  : ::
			RemoteAddress : ::
			Protocol      : TCP
			Service       : RpcSs

			Description
			-----------
			This example will find all network ports in use on the local computer
			using IPv6 only. (Example output trimmed)

			.NOTES
			Based on an idea of Adam Bertram
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		try {
			# Capture the output of the native netstat.exe utility
			# Remove the top row from the result and trim off any leading or trailing spaces from each line
			# Replace all instances of more than 1 space with a pipe symbol.
			# This allows easier parsing of the fields
			$Netstat = (& "$env:windir\system32\netstat.exe" -anb |
			Where-Object -FilterScript { $_ -and ($_ -ne 'Active Connections') }).Trim() |
			Select-Object -Skip 1 |
			ForEach-Object -Process { $_ -replace '\s{2,}', '|' }

			$i = 0

			foreach ($Line in $Netstat) {
				# Create the hashtable to conver to object later
				$Out = @{
					'Protocol'    = ''
					'State'       = ''
					'IPVersion'   = ''
					'LocalAddress' = ''
					'LocalPort'   = ''
					'RemoteAddress' = ''
					'RemotePort'  = ''
					'ProcessOwner' = ''
					'Service'     = ''
				}

				# If the line is a port
				if ($Line -cmatch '^[A-Z]{3}\|') {
					$Cols = ($Line.Split('|'))
					$Out.Protocol = ($Cols[0])

					# Some ports don't have a state.
					# If they do, there's always 4 fields in the line
					if ($Cols.Count -eq 4) {$Out.State = ($Cols[3])}

					# All port lines that start with a [ are IPv6
					if ($Cols[1].StartsWith('[')) {
						$Out.IPVersion = 'IPv6'
						$Out.LocalAddress = ($Cols[1].Split(']')[0].TrimStart('['))
						$Out.LocalPort = ($Cols[1].Split(']')[1].TrimStart(':'))

						if ($Cols[2] -eq '*:*') {
							$Out.RemoteAddress = '*'
							$Out.RemotePort = '*'
						} else {
							$Out.RemoteAddress = ($Cols[2].Split(']')[0].TrimStart('['))
							$Out.RemotePort = ($Cols[2].Split(']')[1].TrimStart(':'))
						}
					} else {
						$Out.IPVersion = 'IPv4'
						$Out.LocalAddress = ($Cols[1].Split(':')[0])
						$Out.LocalPort = ($Cols[1].Split(':')[1])
						$Out.RemoteAddress = ($Cols[2].Split(':')[0])
						$Out.RemotePort = ($Cols[2].Split(':')[1])
					}

					# Because the process owner and service are on separate lines than the port line and the number of lines between them is variable this craziness was necessary.
					# This line starts parsing the netstat output at the current port line and searches for all lines after that that are NOT a port line and finds the first one.
					# This is how many lines there are until the next port is defined.
					$LinesUntilNextPortNum = ($Netstat |
						Select-Object -Skip $i |
						Select-String -Pattern '^[A-Z]{3}\|' -NotMatch |
					Select-Object -First 1).LineNumber
					# Add the current line to the number of lines until the next port definition to find the associated process owner and service name

					$NextPortLineNum = ($i + $LinesUntilNextPortNum)
					# This would contain the process owner and service name

					$PortAttribs = ($Netstat[($i + 1)..$NextPortLineNum])
					# The process owner is always enclosed in brackets of, if it can't find the owner, starts with 'Can'

					$Out.ProcessOwner = ($PortAttribs -match '^\[.*\.exe\]|Can')

					if ($Out.ProcessOwner) {
						# Get rid of the brackets and pick the first index because this is an array
						$Out.ProcessOwner = (($Out.ProcessOwner -replace '\[|\]', '')[0])
					}

					# A service is always a combination of multiple word characters at the start of the line
					if ($PortAttribs -match '^\w+$') {$Out.Service = (($PortAttribs -match '^\w+$')[0])}

					$MyOut = [pscustomobject]$Out
					Write-Output -InputObject $MyOut
				}

				# Keep the counter
				$i++
			}
		} catch {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
		}
	}
}

function Get-MicrosoftUpdateInfo {
	<#
			.SYNOPSIS
			Gives a list of all Microsoft Updates sorted by KB number/HotfixID

			.DESCRIPTION
			Gives a list of all Microsoft Updates sorted by KB number/HotfixID

			.PARAMETER raw
			Just dum the Objects?

			.EXAMPLE
			PS C:\> Get-MicrosoftUpdateInfo

			Description
			-----------
			Return the installed Microsoft Updates

			.EXAMPLE
			PS C:\> $MicrosoftUpdateInfo = (Get-MicrosoftUpdateInfo -raw)
			$MicrosoftUpdateInfo | Where-Object { $_.HotFixID -eq "KB3121461" }

			Description
			-----------
			Return the installed Microsoft Updates in a more raw format, this might
			be handy if you want to reuse it!
			In this example we search for the Update "KB3121461" only and
			displays that info.

			.EXAMPLE
			PS C:\> $MicrosoftUpdateInfo = (Get-MicrosoftUpdateInfo -raw)
			[System.String](($MicrosoftUpdateInfo | Where-Object { $_.HotFixID -eq "KB3121461" }).Title)

			Description
			-----------
			Return the installed Microsoft Updates in a more raw format, this might
			be handy if you want to reuse it!
			In this example we search for the Update "KB3121461" only and
			displays the info about that Update as String.

			.NOTES
			Basic Function found here: http://tomtalks.uk/2013/09/list-all-microsoftwindows-updates-with-powershell-sorted-by-kbhotfixid-Get-microsoftupdate/
			By Tom Arbuthnot. Lyncdup.com

			We just adopted and tweaked it.

			.LINK
			Source: http://tomtalks.uk/2013/09/list-all-microsoftwindows-updates-with-powershell-sorted-by-kbhotfixid-Get-microsoftupdate/

			.LINK
			http://blogs.technet.com/b/tmintner/archive/2006/07/07/440729.aspx

			.LINK
			http://www.gfi.com/blog/windows-powershell-extracting-strings-using-regular-expressions/

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Position = 0)]
		[switch]$raw = $False
	)

	BEGIN {
		$wu = (New-Object -ComObject 'Microsoft.Update.Searcher')

		$totalupdates = ($wu.GetTotalHistoryCount())

		$All = ($wu.QueryHistory(0, $totalupdates))

		# Define a new array to gather output
		$OutputCollection = @()
	}

	PROCESS {
		Foreach ($update in $All) {
			$String = $update.title

			$Regex = 'KB\d*'
			$KB = ($String |
				Select-String -Pattern $Regex |
			Select-Object { $_.Matches })

			$output = (New-Object -TypeName PSobject)
			Add-Member -InputObject $output -MemberType NoteProperty -Name 'HotFixID' -Value $KB.' $_.Matches '.Value
			Add-Member -InputObject $output -MemberType NoteProperty -Name 'Title' -Value $String
			$OutputCollection += $output
		}
	}

	END {
		if ($raw) {
			Write-Output -InputObject $OutputCollection | Sort-Object -Property HotFixID
		} else {
			# Return
			Write-Output -InputObject ('{0} Updates Found' -f $OutputCollection.Count)

			# Output the collection sorted and formatted:
			$OutputCollection |
			Sort-Object -Property HotFixID |
			Select-Object -Property *
		}
	}
}

function Get-myPROCESS {
	<#
			.SYNOPSIS
			Get our own process information

			.DESCRIPTION
			Get our own process information about the PowerShell Session

			.EXAMPLE
			PS C:\> Get-myProcess

			Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
			-------  ------    -----      ----- -----   ------     --  -- -----------
			666      51   124016     127952   773    10,55   1096   1 powershell

			Description
			-----------
			Get our own process information

			.NOTES
			Just a little helper function that might be useful if you have a long
			running shell session

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([Diagnostics.Process])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Do a garbage collection
		if ((Get-Command -Name Invoke-GC -ErrorAction SilentlyContinue)) {Invoke-GC}
	}

	PROCESS {
		# Get the info
		[diagnostics.process]::GetCurrentProcess()
	}
}

function Get-NetFramework {
	<#
			.SYNOPSIS
			retrieve the list of Framework Installed

			.DESCRIPTION
			This function will retrieve the list of Framework Installed

			.EXAMPLE
			PS C:\> Get-NetFramework

			PSChildName                                   Version
			-----------                                   -------
			v2.0.50727                                    2.0.50727.4927
			v3.0                                          3.0.30729.4926
			Windows Communication Foundation              3.0.4506.4926
			Windows Presentation Foundation               3.0.6920.4902
			v3.5                                          3.5.30729.4926
			Client                                        4.5.51641
			Full                                          4.5.51641
			Client                                        4.0.0.0

			Description
			-----------
			This function will retrieve the list of Framework Installed

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param()

	BEGIN {
		$netFramework = $null
	}

	PROCESS {
		# Get the Net Framework Installed
		$netFramework = (Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
			Get-ItemProperty -Name Version -ErrorAction SilentlyContinue |
			Where-Object -FilterScript { $_.PSChildName -match '^(?!S)\p{L}' } |
		Select-Object -Property PSChildName, Version)
	}

	END {
		Write-Output -InputObject $netFramework -NoEnumerate
	}
}

function Get-NetStat {
	<#
			.SYNOPSIS
			This function will get the output of netstat -n and parse the output

			.DESCRIPTION
			This function will get the output of netstat -n and parse the output

			.NOTES
			Based on an idea of Francois-Xavier Cat

			.EXAMPLE
			PS C:\> Get-NetStat
			LocalAddressIP     : 10.211.59.125
			LocalAddressPort   : 1321
			State              : ESTABLISHED
			ForeignAddressIP   : 10.211.16.2
			ForeignAddressPort : 10943
			Protocole          : TCP

			Description
			-----------
			This function will get the output of netstat -n and parse the output

			.LINK
			Idea: http://www.lazywinadmin.com/2014/08/powershell-parse-this-netstatexe.html

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		# Get the output of netstat
		Set-Variable -Name 'data' -Value $(& "$env:windir\system32\netstat.exe" -n)

		# Keep only the line with the data (we remove the first lines)
		Set-Variable -Name 'data' -Value $($data[4..$data.count])

		# Each line need to be spitted and get rid of unnecessary spaces
		foreach ($Line in $data) {
			# Get rid of the first whitespace, at the beginning of the line
			Set-Variable -Name 'line' -Value $($Line -replace '^\s+', '')

			# Split each property on whitespace block
			Set-Variable -Name 'line' -Value $($Line -split '\s+')

			# Define the properties
			$Properties = @{
				Protocole          = $Line[0]
				LocalAddressIP     = ($Line[1] -split ':')[0]
				LocalAddressPort   = ($Line[1] -split ':')[1]
				ForeignAddressIP   = ($Line[2] -split ':')[0]
				ForeignAddressPort = ($Line[2] -split ':')[1]
				State              = $Line[3]
			}

			# Output the current line
			New-Object -TypeName PSObject -Property $Properties
		}
	}
}

function Get-NewAesKey {
	<#
			.SYNOPSIS
			Get a AES Key

			.DESCRIPTION
			Get a AES Key

			.EXAMPLE
			PS C:\> Get-NewAesKey
			3z38JJzHJghPYm9X95EP8Xbh2fuE8/rPxBi6N7mME9M=

			Description
			-----------
			Get a AES Key

			.NOTES
			Initial Version
	#>
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([String])]
	param ()

	BEGIN {
		# Cleanup
		$NewAesKey = $null
	}

	PROCESS {
		# Generate the Key
		$NewAlgorithm = [Security.Cryptography.SymmetricAlgorithm]::Create('Rijndael')
		$KeyBytes = $NewAlgorithm.get_Key()
		$NewAesKey = [Convert]::ToBase64String($KeyBytes)

	}

	END {
		# Sump the Key
		Write-Output -InputObject $NewAesKey

		# Cleanup
		$NewAesKey = $null
	}
}

function Get-NewPassword {
	<#
			.SYNOPSIS
			Generates a New password with varying length and Complexity,

			.DESCRIPTION
			Generate a New Password for a User.  Defaults to 8 Characters
			with Moderate Complexity.  Usage

			GET-NEWPASSWORD or

			GET-NEWPASSWORD $Length $Complexity

			Where $Length is an integer from 1 to as high as you want
			and $Complexity is an Integer from 1 to 4

			.PARAMETER PasswordLength
			Password Length

			.PARAMETER Complexity
			Complexity Level

			.EXAMPLE
			PS C:\> Get-NewPassword
			zemermyya784vKx93

			Description
			-----------
			Create New Password based on the defaults

			.EXAMPLE
			PS C:\> Get-NewPassword 9 1
			zemermyya

			Description
			-----------
			Generate a Password of strictly Uppercase letters 9 letters long

			.EXAMPLE
			PS C:\> Get-NewPassword 5
			zemermyya784vKx93K2sqG

			Description
			-----------
			Generate a Highly Complex password 5 letters long

			.EXAMPLE
			$MYPASSWORD = (ConvertTo-SecureString (Get-NewPassword 8 2) -asplaintext -Force)

			Description
			-----------
			Create a new 8 Character Password of Uppercase/Lowercase and store as
			a Secure.String in Variable called $MYPASSWORD

			.NOTES
			The Complexity falls into the following setup for the Complexity level
			1 - Pure lowercase Ascii
			2 - Mix Uppercase and Lowercase Ascii
			3 - Ascii Upper/Lower with Numbers
			4 - Ascii Upper/Lower with Numbers and Punctuation

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param
	(
		[ValidateNotNullOrEmpty()]
		[Alias('Length')]
		[int]$PasswordLength = '8',
		[ValidateNotNullOrEmpty()]
		[Alias('Level')]
		[int]$Complexity = '3'
	)

	PROCESS {
		# Declare an array holding what I need.  Here is the format
		# The first number is a the number of characters (e.g. 26 for the alphabet)
		# The Second Number is Where-Object it resides in the ASCII Character set
		# So 26,97 will pick a random number representing a letter in ASCII
		# and add it to 97 to produce the ASCII Character
		[int32[]]$ArrayofAscii = 26, 97, 26, 65, 10, 48, 15, 33

		# Complexity can be from 1 - 4 with the results being
		# 1 - Pure lowercase ASCII
		# 2 - Mix Uppercase and Lowercase ASCII
		# 3 - ASCII Upper/Lower with Numbers
		# 4 - ASCII Upper/Lower with Numbers and Punctuation
		if ($Complexity -eq $null) { Set-Variable -Name 'Complexity' -Scope Script -Value $(3) }

		# Password Length can be from 1 to as Crazy as you want
		#
		if ($PasswordLength -eq $null) { Set-Variable -Name 'PasswordLength' -Scope Script -Value $(10) }

		# Nullify the Variable holding the password
		Remove-Variable -Name 'NewPassword' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

		# Here is our loop
		Foreach ($counter in 1..$PasswordLength) {
			# What we do here is pick a random pair (4 possible)
			# in the array to generate out random letters / numbers
			Set-Variable -Name 'pickSet' -Scope Script -Value $((Get-Random -Maximum $Complexity) * 2)

			# Pick an ASCII Character and add it to the Password
			# Here is the original line I was testing with
			# [System.Char] (GET-RANDOM 26) +97 Which generates
			# Random Lowercase ASCII Characters
			# [System.Char] (GET-RANDOM 26) +65 Which generates
			# Random Uppercase ASCII Characters
			# [System.Char] (GET-RANDOM 10) +48 Which generates
			# Random Numeric ASCII Characters
			# [System.Char] (GET-RANDOM 15) +33 Which generates
			# Random Punctuation ASCII Characters
			Set-Variable -Name 'NewPassword' -Scope Script -Value $($NewPassword + [Char]((Get-Random -Maximum $ArrayofAscii[$pickset]) + $ArrayofAscii[$pickset + 1]))
		}
	}

	END {
		# When we're done we Return the $NewPassword
		# BACK to the calling Party
		Write-Output -InputObject $NewPassword
	}
}

function Get-Pause {
	<#
			.SYNOPSIS
			Wait for user to press any key

			.DESCRIPTION
			Shows a console message and waits for user to press any key.

			Optional:
			The message to display could be set by a command line parameter.

			.PARAMETER PauseMessage
			This optional parameter is the text that the function displays.
			If this is not set, it uses a default text "Press any key..."

			.EXAMPLE
			PS C:\> Get-Pause

			Display a console message and wait for user to press any key.
			It shows the default Text "Press any key..."

			.EXAMPLE
			PS C:\> Get-Pause "Please press any key"

			Description
			-----------
			Display a console message and wait for user to press any key.
			It shows the Text "Please press any key"

			.EXAMPLE
			PS C:\> Get-Pause -PauseMessage "Please press any key"

			Description
			-----------
			Display a console message and wait for user to press any key.
			It shows the Text "Please press any key"

			.NOTES
			PowerShell have no build in function like this

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(ValueFromPipeline,
		Position = 1)]
		[ValidateNotNullOrEmpty()]
		[Alias('Message')]
		[String]$PauseMessage = 'Press any key...'
	)

	BEGIN {
		# Do we need to show the default?
		if (($PauseMessage -eq '') -or ($PauseMessage -eq $null) -or (!$PauseMessage)) {
			# Text to show - Default text!
			Set-Variable -Name 'PauseMessage' -Value $('Press any key...' -as ([String] -as [type]))
		}
	}

	PROCESS {
		# This is the Message
		Write-Host -Object ('{0}' -f $PauseMessage) -ForegroundColor Yellow

		# Wait for the Keystroke
		$null = ($Host.ui.RawUI.ReadKey('NoEcho,IncludeKeyDown'))
	}

	END {
		# Cleanup
		Remove-Variable -Name 'PauseMessage' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}
}

function Get-PendingReboot {
	<#
			.SYNOPSIS
			Gets the pending reboot status on a local or remote computer.

			.DESCRIPTION
			This function will query the registry on a local or remote computer and
			determine if the system is pending a reboot, from either Microsoft
			Patching or a Software Installation.
			For Windows 2008+ the function will query the CBS registry key as
			another factor in determining pending reboot state.
			"PendingFileRenameOperations" and "Auto Update\RebootRequired" are
			observed as being consistent across Windows Server 2003 & 2008.

			CBServicing = Component Based Servicing (Windows 2008)
			WindowsUpdate = Windows Update / Auto Update (Windows 2003 / 2008)
			CCMClientSDK = SCCM 2012 Clients only (DetermineIfRebootPending method) otherwise $null value
			PendFileRename = PendingFileRenameOperations (Windows 2003 / 2008)

			.PARAMETER ComputerName
			A single Computer or an array of computer names.

			The default is localhost ($env:COMPUTERNAME).

			.EXAMPLE
			PS C:\> Get-PendingReboot -ComputerName (Get-Content C:\ServerList.txt) | Format-Table -AutoSize

			Computer CBServicing WindowsUpdate CCMClientSDK PendFileRename PendFileRenVal RebootPending
			-------- ----------- ------------- ------------ -------------- -------------- -------------
			DC01     False   False           False      False
			DC02     False   False           False      False
			FS01     False   False           False      False

			Description
			-----------
			This example will capture the contents of C:\ServerList.txt and query
			the pending reboot information from the systems contained in the file
			and display the output in a table.
			The null values are by design, since these systems do not have the
			SCCM 2012 client installed, nor was the PendingFileRenameOperations
			value populated.

			.EXAMPLE
			PS C:\> Get-PendingReboot

			Computer     : WKS01
			CBServicing  : False
			WindowsUpdate      : True
			CCMClient    : False
			PendComputerRename : False
			PendFileRename     : False
			PendFileRenVal     :
			RebootPending      : True

			Description
			-----------
			This example will query the local machine for pending reboot information.

			.EXAMPLE
			PS C:\> $Servers = Get-Content C:\Servers.txt
			PS C:\> Get-PendingReboot -Computer $Servers | Export-Csv C:\PendingRebootReport.csv -NoTypeInformation

			Description
			-----------
			This example will create a report that contains pending reboot
			information.

			.NOTES
			Based on an idea of Brian Wilhite

			.LINK
			Component-Based Servicing: http://technet.microsoft.com/en-us/library/cc756291(v=WS.10).aspx

			.LINK
			PendingFileRename/Auto Update: http://support.microsoft.com/kb/2723674

			.LINK
			http://technet.microsoft.com/en-us/library/cc960241.aspx

			.LINK
			http://blogs.msdn.com/b/hansr/archive/2006/02/17/patchreboot.aspx

			.LINK
			SCCM 2012/CCM_ClientSDK: http://msdn.microsoft.com/en-us/library/jj902723.aspx
	#>

	param
	(
		[Parameter(ValueFromPipeline,
				ValueFromPipelineByPropertyName,
		Position = 0)]
		[Alias('CN', 'Computer')]
		[String[]]$ComputerName = "$env:COMPUTERNAME"
	)

	PROCESS {
		Foreach ($Computer in $ComputerName) {
			Try {
				# Setting pending values to false to cut down on the number of else statements
				$CompPendRen, $PendFileRename, $Pending, $SCCM = $False, $False, $False, $False

				# Setting CBSRebootPend to null since not all versions of Windows has this value
				Remove-Variable -Name 'CBSRebootPend' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

				# Querying WMI for build version
				$WMI_OS = (Get-WmiObject -Class Win32_OperatingSystem -Property BuildNumber, CSName -ComputerName $Computer -ErrorAction Stop)

				# Making registry connection to the local/remote computer
				Set-Variable -Name 'HKLM' -Value $([UInt32] '0x80000002')
				Set-Variable -Name 'WMI_Reg' -Value $([WMIClass] "\\$Computer\root\default:StdRegProv")

				# If Vista/2008 & Above query the CBS Reg Key
				if ([int]$WMI_OS.BuildNumber -ge 6001) {
					Set-Variable -Name 'RegSubKeysCBS' -Value $($WMI_Reg.EnumKey($HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\'))
					Set-Variable -Name "$CBSRebootPend" -Value $($RegSubKeysCBS.sNames -contains 'RebootPending')
				}

				# Query WUAU from the registry
				Set-Variable -Name 'RegWUAURebootReq' -Value $($WMI_Reg.EnumKey($HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\'))
				Set-Variable -Name 'WUAURebootReq' -Value $($RegWUAURebootReq.sNames -contains 'RebootRequired')

				# Query PendingFileRenameOperations from the registry
				Set-Variable -Name 'RegSubKeySM' -Value $($WMI_Reg.GetMultiStringValue($HKLM, 'SYSTEM\CurrentControlSet\Control\Session Manager\', 'PendingFileRenameOperations'))
				Set-Variable -Name 'RegValuePFRO' -Value $($RegSubKeySM.sValue)

				# Query ComputerName and ActiveComputerName from the registry
				Set-Variable -Name 'ActCompNm' -Value $($WMI_Reg.GetStringValue($HKLM, 'SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName\', 'ComputerName'))
				Set-Variable -Name 'CompNm' -Value $($WMI_Reg.GetStringValue($HKLM, 'SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\', 'ComputerName'))


				if ($ActCompNm -ne $CompNm) { Set-Variable -Name 'CompPendRen' -Value $($True) }

				# If PendingFileRenameOperations has a value set $RegValuePFRO variable to $True
				if ($RegValuePFRO) { Set-Variable -Name 'PendFileRename' -Value $($True) }

				# Determine SCCM 2012 Client Reboot Pending Status
				# To avoid nested 'if' statements and unneeded WMI calls to determine if the CCM_ClientUtilities class exist, setting EA = 0
				Remove-Variable -Name 'CCMClientSDK' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

				$CCMSplat = @{
					NameSpace    = 'ROOT\ccm\ClientSDK'
					Class        = 'CCM_ClientUtilities'
					Name         = 'DetermineIfRebootPending'
					ComputerName = $Computer
					ErrorAction  = 'Stop'
				}


				Try {
					Set-Variable -Name 'CCMClientSDK' -Value $(Invoke-WmiMethod @CCMSplat)
				} Catch [UnauthorizedAccessException] {
					Set-Variable -Name 'CcmStatus' -Value $(Get-Service -Name CcmExec -ComputerName $Computer -ErrorAction SilentlyContinue)

					if ($CcmStatus.Status -ne 'Running') {
						Write-Warning -Message ('{0}: Error - CcmExec service is not running.' -f $Computer)

						Remove-Variable -Name 'CCMClientSDK' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
					}
				} Catch {
					Remove-Variable -Name 'CCMClientSDK' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
				}

				if ($CCMClientSDK) {
					if ($CCMClientSDK.ReturnValue -ne 0) { Write-Warning -Message ('Error: DetermineIfRebootPending returned error code {0}' -f $CCMClientSDK.ReturnValue) }

					if ($CCMClientSDK.IsHardRebootPending -or $CCMClientSDK.RebootPending) { Set-Variable -Name 'SCCM' -Value $($True) }
				} else {
					Remove-Variable -Name 'SCCM' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
				}

				## Creating Custom PSObject and Select-Object Splat
				$SelectSplat = @{
					Property = (
						'Computer',
						'CBServicing',
						'WindowsUpdate',
						'CCMClientSDK',
						'PendComputerRename',
						'PendFileRename',
						'PendFileRenVal',
						'RebootPending'
					)
				}

				New-Object -TypeName PSObject -Property @{
					Computer           = $WMI_OS.CSName
					CBServicing        = $CBSRebootPend
					WindowsUpdate      = $WUAURebootReq
					CCMClientSDK       = $SCCM
					PendComputerRename = $CompPendRen
					PendFileRename     = $PendFileRename
					PendFileRenVal     = $RegValuePFRO
					RebootPending      = ($CompPendRen -or $CBSRebootPend -or $WUAURebootReq -or $SCCM -or $PendFileRename)
				} | Select-Object -ExpandProperty @SelectSplat
			} Catch {
				Write-Warning -Message ('{0}: {1}' -f $Computer, $_)
			}
		}
	}
}

function Get-PhoneticSpelling {
	<#
			.SYNOPSIS
			Get the Phonetic Spelling for a given input String

			.DESCRIPTION
			Get the Phonetic Spelling for a given input String

			.PARAMETER Char
			Input that should be Phonetic Spelled

			.EXAMPLE
			PS C:\> (Get-PhoneticSpelling -Char 'Test').Table

			Char Phonetic
			---- --------
			T Capital-Tango
			e Lowercase-Echo
			s Lowercase-Sierra
			t Lowercase-Tango

			Description
			-----------
			Show the Input and Phonetic Spelling (table) for 'Test'

			.EXAMPLE
			PS C:\> (Get-PhoneticSpelling -Char 'Test').PhoneticForm
			Capital-Tango  Lowercase-Echo  Lowercase-Sierra  Lowercase-Tango

			Description
			-----------
			Convert 'Test' to Phonetic Spelling

			.NOTES
			Simple function to convert a string to Phonetic Spelling
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = 'Input that should be Phonetic Spelled')]
		[ValidateNotNullOrEmpty()]
		[Char[]]$Char
	)

	BEGIN {
		# Build a HashTable with the alphabet and the matching Phonetic Spelled
		[HashTable]$PhoneticTable = @{
			'a' = 'Alpha'
			'b' = 'Bravo'
			'c' = 'Charlie'
			'd' = 'Delta'
			'e' = 'Echo'
			'f' = 'Foxtrot'
			'g' = 'Golf'
			'h' = 'Hotel'
			'i' = 'India'
			'j' = 'Juliet'
			'k' = 'Kilo'
			'l' = 'Lima'
			'm' = 'Mike'
			'n' = 'November'
			'o' = 'Oscar'
			'p' = 'Papa'
			'q' = 'Quebec'
			'r' = 'Romeo'
			's' = 'Sierra'
			't' = 'Tango'
			'u' = 'Uniform'
			'v' = 'Victor'
			'w' = 'Whiskey'
			'x' = 'X-ray'
			'y' = 'Yankee'
			'z' = 'Zulu'
			'0' = 'Zero'
			'1' = 'One'
			'2' = 'Two'
			'3' = 'Three'
			'4' = 'Four'
			'5' = 'Five'
			'6' = 'Six'
			'7' = 'Seven'
			'8' = 'Eight'
			'9' = 'Nine'
			'.' = 'Period'
			'!' = 'Exclamation-mark'
			'?' = 'Question-mark'
			'@' = 'At'
			'{' = 'Left-brace'
			'}' = 'Right-brace'
			'[' = 'Left-bracket'
			']' = 'Left-bracket'
			'+' = 'Plus'
			'>' = 'Greater-than'
			'<' = 'Less-than'
			'\' = 'Back-slash'
			'/' = 'Forward-slash'
			'|' = 'Pipe'
			':' = 'Colon'
			';' = 'Semi-colon'
			'"' = 'Double-quote'
			"'" = 'Single-quote'
			'(' = 'Left-parenthesis'
			')' = 'Right-parenthesis'
			'*' = 'Asterisk'
			'-' = 'Hyphen'
			'#' = 'Pound'
			'^' = 'Caret'
			'~' = 'Tilde'
			'=' = 'Equals'
			'&' = 'Ampersand'
			'%' = 'Percent'
			'$' = 'Dollar'
			',' = 'Comma'
			'_' = 'Underscore'
			'`' = 'Back-tick'
		}
	}

	PROCESS {
		$result = Foreach ($Character in $Char) {
			if ($PhoneticTable.ContainsKey("$Character")) {
				if ([Char]::IsUpper([Char]$Character)) {
					[PSCustomObject]@{
						Char     = $Character
						Phonetic = "Capital-$($PhoneticTable["$Character"])"
					}
				} elseif ([Char]::IsLower([Char]$Character)) {
					[PSCustomObject]@{
						Char     = $Character
						Phonetic = "Lowercase-$($PhoneticTable["$Character"])"
					}
				} elseif ([Char]::IsNumber([Char]$Character)) {
					[PSCustomObject]@{
						Char     = $Character
						Phonetic = "Number-$($PhoneticTable["$Character"])"
					}
				} else {
					[PSCustomObject]@{
						Char     = $Character
						Phonetic = $PhoneticTable["$Character"]
					}
				}
			} else {
				[PSCustomObject]@{
					Char     = $Character
					Phonetic = $Character
				}
			}
		}

		# Loop over each char
		$InputText = -join $Char

		$TableFormat = ($result |
			Format-Table -AutoSize |
		Out-String)

		$StringFormat = ($result.Phonetic -join '  ')

		# Create the new HashTable
		[hashtable]$Properties = @{
			PhoneticForm = $StringFormat
			Table        = $TableFormat
			InputText    = $InputText
		}

		$Object = (New-Object -TypeName PSObject -Property $Properties)

		$Object.PSObject.Typenames.Insert(0, 'Phonetic')
	}

	END {
		# Dump what we have
		Write-Output -InputObject $Object
	}
}

# TODO: Check in detail!!!
function Get-PreReqModules {
	<#
			.SYNOPSIS
			Get all required Office 365 Modules and Software from Microsoft

			.DESCRIPTION
			Get all required Office 365 Modules and Software from Microsoft

			.PARAMETER Path
			Where to Download

			.EXAMPLE
			PS C:\> Get-PreReqModules

			Description
			-----------
			Get all required Office 365 Modules and Software from Microsoft.
			Downloads them to: "c:\scripts\powershell\prereq"
			(Will be created if it doe not exist)

			.EXAMPLE
			PS C:\> Get-PreReqModules -Path 'c:\scripts\download'

			Description
			-----------
			Get all required Office 365 Modules and Software from Microsoft.
			Downloads them to: "c:\scripts\download"
			(Will be created if it doe not exist)

			.NOTES
			Just a helper function based on an idea of En Pointe Technologies

			It Downloads:
			-> .NET Framework 4.6.1 Off-line Installer
			-> Microsoft Online Services Sign-In Assistant for IT Professionals RTW
			-> Microsoft Azure Active Directory PowerShell Module
			-> SharePoint Online Management Shell
			-> Skype for Business Online Windows PowerShell Module

			The .NET Framework 4.6.1 Off-line Installer URL
			https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe

			Microsoft Online Services Sign-In Assistant for IT Professionals RTW URL
			http://download.microsoft.com/download/5/0/1/5017D39B-8E29-48C8-91A8-8D0E4968E6D4/EN/msoidcli_64.msi

			Microsoft Azure Active Directory PowerShell Module URL
			https://bposast.vo.msecnd.net/MSOPMW/Current/AMD64/AdministrationConfig-EN.msi

			SharePoint Online Management Shell URL
			https://download.microsoft.com/download/0/2/E/02E7E5BA-2190-44A8-B407-BC73CA0D6B87/sharepointonlinemanagementshell_5326-1200_x64_en-us.msi

			Skype for Business Online Windows PowerShell Module URL
			https://download.microsoft.com/download/2/0/5/2050B39B-4DA5-48E0-B768-583533B42C3B/SkypeOnlinePowershell.exe

			.LINK
			https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe
			http://download.microsoft.com/download/5/0/1/5017D39B-8E29-48C8-91A8-8D0E4968E6D4/EN/msoidcli_64.msi
			https://bposast.vo.msecnd.net/MSOPMW/Current/AMD64/AdministrationConfig-EN.msi
			https://download.microsoft.com/download/0/2/E/02E7E5BA-2190-44A8-B407-BC73CA0D6B87/sharepointonlinemanagementshell_5326-1200_x64_en-us.msi
			https://download.microsoft.com/download/2/0/5/2050B39B-4DA5-48E0-B768-583533B42C3B/SkypeOnlinePowershell.exe
	#>

	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[String]$Path = 'c:\scripts\powershell\prereq'
	)

	BEGIN {
		# Is the download path already here?
		if (-not (Test-Path -Path $Path)) {
			(New-Item -ItemType Directory -Path $Path -Force -Confirm:$False) > $null 2>&1 3>&1
		} else {
			Write-Output -InputObject 'Download path already exists'
		}
	}

	PROCESS {
		<#
				Now download all the required software
		#>

		try {
			# Where to download and give the Filename
			$dlPath = (Join-Path -Path $Path -ChildPath 'NDP452-KB2901907-x86-x64-AllOS-ENU.exe')

			# Is this file already downloaded?
			if (Test-Path -Path $dlPath) {
				# It exists
				Write-Output -InputObject ('{0} exists...' -f $dlPath)
			} else {
				# Download it
				Write-Output -InputObject 'Processing: .NET Framework 4.6.1 Off-line Installer'
				Invoke-WebRequest -Uri 'https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe' -OutFile $dlPath
			}
		} catch {
			# Aw Snap!
			Write-Warning -Message 'Unable to download: .NET Framework 4.5.2 Off-line Installer'
		}

		try {
			$dlPath = (Join-Path -Path $Path -ChildPath 'msoidcli_64.msi')

			if (Test-Path -Path $dlPath) {
				Write-Output -InputObject ('{0} exists...' -f $dlPath)
			} else {
				Write-Output -InputObject 'Processing: Microsoft Online Services Sign-In Assistant for IT Professionals'
				Invoke-WebRequest -Uri 'http://download.microsoft.com/download/5/0/1/5017D39B-8E29-48C8-91A8-8D0E4968E6D4/EN/msoidcli_64.msi' -OutFile $dlPath
			}
		} catch {
			Write-Warning -Message 'Unable to download: Microsoft Online Services Sign-In Assistant for IT Professionals'
		}

		try {
			$dlPath = (Join-Path -Path $Path -ChildPath 'AdministrationConfig-en.msi')

			if (Test-Path -Path $dlPath) {
				Write-Output -InputObject ('{0} exists...' -f $dlPath)
			} else {
				Write-Output -InputObject 'Processing: Microsoft Azure Active Directory PowerShell Module'
				Invoke-WebRequest -Uri 'https://bposast.vo.msecnd.net/MSOPMW/Current/AMD64/AdministrationConfig-EN.msi' -OutFile $dlPath
			}
		} catch {
			Write-Warning -Message 'Unable to download: Microsoft Azure Active Directory PowerShell Module'
		}

		try {
			$dlPath = (Join-Path -Path $Path -ChildPath 'sharepointonlinemanagementshell_5326-1200_x64_en-us.msi')

			if (Test-Path -Path $dlPath) {
				Write-Output -InputObject ('{0} exists...' -f $dlPath)
			} else {
				Write-Output -InputObject 'Processing: SharePoint Online Management Shell'
				Invoke-WebRequest -Uri 'https://download.microsoft.com/download/0/2/E/02E7E5BA-2190-44A8-B407-BC73CA0D6B87/sharepointonlinemanagementshell_5326-1200_x64_en-us.msi' -OutFile $dlPath
			}
		} catch {
			Write-Warning -Message 'Unable to download: SharePoint Online Management Shell'
		}

		try {
			$dlPath = (Join-Path -Path $Path -ChildPath 'SkypeOnlinePowershell.exe')

			if (Test-Path -Path $dlPath) {
				Write-Output -InputObject ('{0} exists...' -f $dlPath)
			} else {
				Write-Output -InputObject 'Processing: Skype for Business Online Windows PowerShell Module'
				Invoke-WebRequest -Uri 'https://download.microsoft.com/download/2/0/5/2050B39B-4DA5-48E0-B768-583533B42C3B/SkypeOnlinePowershell.exe' -OutFile $dlPath
			}
		} catch {
			Write-Warning -Message 'Unable to download: Skype for Business Online Windows PowerShell Module'
		}
	}

	END {
		Write-Output -InputObject ('Prerequisites downloaded to {0}' -f ($Path))

		# Open the download directory!
		Invoke-Item -Path $Path
	}
}

function Get-ProxyInfo {
	<#
			.SYNOPSIS
			Detect the proxy for a given URL

			.DESCRIPTION
			Detect the proxy for a given URL

			.PARAMETER URL
			URL to check, the default is http://www.google.com

			.EXAMPLE
			PS C:\> Get-ProxyInfo
			proxy.netx.local:8080

			Description
			-----------
			Detect the proxy for a given url (http://www.google.com what is the default)

			.NOTES
			Internal Helper
	#>

	param
	(
		[Parameter(ValueFromPipeline)]
		[String]$url = 'http://www.google.com'
	)

	BEGIN {
		$WebClient = (New-Object -TypeName System.Net.WebClient)
	}

	PROCESS {
		if ($WebClient.Proxy.IsBypassed($url)) {
			Return $null
		} else {
			$ProxyServerAddress = ($WebClient.Proxy.GetProxy($url).Authority)
		}
	}

	END {
		Write-Output -InputObject $ProxyServerAddress
	}
}

function Get-Quote {
	<#
			.SYNOPSIS
			Get a random Quote from an Array

			.DESCRIPTION
			Get a random Quote from an Array of Quotes I like.

			I like to put Quotes in slides and presentations, here is a collection
			of whose I used...


			.EXAMPLE
			PS C:\> Get-Quote
			*******************************************************************
			*  The only real mistake is the one from which we learn nothing.  *
			*                                                     Henry Ford  *
			*******************************************************************

			Description
			-----------
			Get a random Quote from an Array

			.NOTES
			Based on an idea of Jeff Hicks

			I just implemented this because it was fun to do so ;-)

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# The quote should include the author separated by " - ".
		$texts = @(
			'It was a mistake to think that GUIs ever would, could, or even should, eliminate CLIs. - Jeffrey Snover',
			"Leader who don't Listen will eventually be surrounded by people who have nothing to say. - @AndyStanley",
			'Good is the enemy of great. - Sir Jonathan Ive',
			'There are 9 rejected ideas for every idea that works. - Sir Jonathan Ive'
			"People's interest is in the product, not in its authorship. - Sir Jonathan Ive",
			"I think it's really important to design things with a kind of personality. - Marc Newson",
			'Intelligence is the ability to adapt to change. - Stephen Hawking',
			'We are all now connected by the Internet, like neurons in a giant brain. - Stephen Hawking',
			'The best ideas start as conversations. - Sir Jonathan Ive',
			'If something is not good enough, stop doing it. - Sir Jonathan Ive',
			"There's no learning without trying lots of ideas and failing lots of times. - Sir Jonathan Ive",
			'Any product that needs a manual to work is broken. - Elon Musk',
			'Business has only two functions: marketing and innovation. - Milan Kundera',
			"Just because something doesn't do what you planned it to do doesn't mean it's useless. - Thomas A. Edison",
			'Great companies are built on great products. - Elon Musk',
			'Test fast, fail fast, adjust fast. - Tom Peters',
			"Winning isn't everything, it's the only thing. - Vince Lombardi (Former NFL Coach)",
			'The only place success comes before work is in the dictionary. - Vince Lombardi (Former NFL Coach)',
			'The measure of who we are is what we do with what we have. - Vince Lombardi (Former NFL Coach)',
			'The greatest accomplishment is not in never falling, but in rising again after you fall. - Vince Lombardi (Former NFL Coach)'
			'Perfection is not attainable. But if we chase perfection, we can catch excellence. - Vince Lombardi (Former NFL Coach)',
			"Stay focused. Your start does not determine how you're going to finish. - Herm Edwards (Former NFL Coach)",
			'Nobody who ever gave his best regretted it. - George S. Halas (Former NFL Coach)',
			"Don't let the noise of others' opinions drown out your own inner voice. - Steve Jobs",
			'One way to remember who you are is to remember who your heroes are. - Walter Isaacson (Steve Jobs)',
			'Why join the navy if you can be a pirate? - Steve Jobs',
			'Innovation distinguishes between a leader and a follower. - Steve Jobs',
			"Sometimes life hits you in the head with a brick. Don't lose faith. - Steve Jobs",
			'Design is not just what it looks like and feels like. Design is how it works. - Steve Jobs',
			"We made the buttons on the screen look so good you'll want to lick them. - Steve Jobs",
			"Things don't have to change the world to be important. - Steve Jobs",
			'Your most unhappy customers are your greatest source of learning. - Bill Gates',
			'Software is a great combination between artistry and engineering. - Bill Gates',
			"Success is a lousy teacher. It seduces smart people into thinking they can't lose. - Bill Gates",
			"If you can't make it good, at least make it look good. - Bill Gates",
			"If you're not making mistakes, then you're not making decisions. - Catherine Cook (MeetMe Co-Founder)",
			"I have not failed. I've just found 10.000 ways that won't work. - Thomas Edison",
			"If you don't build your dream, someone will hire you to help build theirs. - Tony Gaskin (Motivational Speaker)",
			"Don't count the days, make the days count. - Muhammad Ali",
			'Everything you can imagine is real. - Pablo Picasso',
			"In three words I can sum up everything I've learned about life: it goes on. - Robert Frost"
		)

		# get random text
		Set-Variable -Name 'text' -Value $(Get-Random -Maximum $texts)
	}

	PROCESS {
		# split the text to an array on ' - '
		Set-Variable -Name 'split' -Value $($text -split ' - ')
		Set-Variable -Name 'quote' -Value $($split[0].Trim())
		Set-Variable -Name 'author' -Value $($split[1].Trim())

		# turn the quote into an array of characters
		Set-Variable -Name 'arr' -Value $($quote.ToCharArray())

		$arr | ForEach-Object -Begin {
			# define an array of colors
			#$colors = "Red", "Green", "White", "Magenta"

			# insert a few blank lines
			Write-Host -Object "`n"

			# insert top border
			Write-Host -Object ('*' * $($quote.length + 6))

			# insert side border
			Write-Host -Object '*  ' -NoNewline
		} -Process {
			# write each character in a different holiday color
			Write-Host -Object ('{0}' -f $_) -ForegroundColor White -NoNewline
		} -End {
			Write-Host -Object '  *'

			# insert side border
			Write-Host -Object '* ' -NoNewline

			# write the author
			# Write-Host "- $author  *".padleft($quote.length + 4)
			Write-Host -Object ('{0}  *' -f $author).padleft($quote.length + 4)

			# insert bottom border
			Write-Host -Object ('*' * $($quote.length + 6))
			Write-Host -Object "`n"
		}
	}

	END {
		# Cleanup
		Remove-Variable -Name 'texts' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'text' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'split' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'quote' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'author' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'arr' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}
}

function Get-RelativePath {
	<#
			.SYNOPSIS
			Get a path to a file (or folder) relative to another folder

			.DESCRIPTION
			Converts the FilePath to a relative path rooted in the specified Folder

			.PARAMETER Folder
			The folder to build a relative path from

			.PARAMETER FilePath
			The File (or folder) to build a relative path TO

			.PARAMETER Resolve
			If true, the file and folder paths must exist

			.Example
			PS C:\> Get-RelativePath ~\Documents\WindowsPowerShell\Logs\ ~\Documents\WindowsPowershell\Modules\Logger\log4net.xslt
			..\Modules\Logger\log4net.xslt

			Description
			-----------
			Returns a path to log4net.xslt relative to the Logs folder

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = 'The folder to build a relative path from')]
		[String]$Folder,
		[Parameter(Mandatory,
				ValueFromPipelineByPropertyName,
				Position = 1,
		HelpMessage = 'The File (or folder) to build a relative path TO')]
		[Alias('FullName')]
		[String]$FilePath,
		[switch]$Resolve
	)

	BEGIN {
		# FROM (Compare 1)
		$from = $Folder = (Split-Path -Path $Folder -NoQualifier -Resolve:$Resolve)

		# TO (Compare 2)
		$to = $FilePath = (Split-Path -Path $FilePath -NoQualifier -Resolve:$Resolve)
	}

	PROCESS {
		# Now we compare what we have
		while ($from -and $to -and ($from -ne $to)) {
			# Check the Length of both
			if ($from.Length -gt $to.Length) {$from = (Split-Path -Path $from)} else {$to = (Split-Path -Path $to)}
		}

		# Setup and fill the Variables
		$FilePath = ($FilePath -replace '^' + [regex]::Escape($to) + '\\')
		$from = ($Folder)

		# compare to figure out what to show
		while ($from -and $to -and $from -gt $to) {
			# Setup and fill the Variables
			$from = (Split-Path -Path $from)
			$FilePath = (Join-Path -Path '..' -ChildPath $FilePath)
		}
	}

	END {
		# Do a garbage collection
		Write-Output -InputObject $FilePath
	}
}

function Get-ReqParams {
	<#
			.SYNOPSIS
			A quick way to view required parameters on a cmdlet

			.DESCRIPTION
			A quick way to view required parameters on a cmdlet, function,
			provider, script or workflow

			.PARAMETER command
			Gets required parameters of the specified command or concept.
			Enter the name of a cmdlet, function, provider, script, or workflow,
			such as "Get-Member", a conceptual topic name, such as "about_Objects",
			or an alias, such as "ls".

			.EXAMPLE
			PS C:\> Get-ReqParams -command 'New-ADUser'

			-Name <String>
			Specifies the name of the object. This parameter sets the Name property of the Active Directory object. The LDAP Display
			Name (ldapDisplayName) of this property is name.

			Required?                    true
			Position?                    2
			Default value
			Accept pipeline input?       True (ByPropertyName)
			Accept wildcard characters?  false

			.NOTES
			Just a filter for Get-Help
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'cmdlet')]
		[ValidateNotNullOrEmpty()]
		[Alias('cmd')]
		[String]$command
	)

	PROCESS {
		Get-Help -Name $command -Parameter * | Where-Object -FilterScript { $_.required -eq $True }
	}
}

function Get-ServiceStatus {
	<#
			.SYNOPSIS
			List Services Where-Object StartMode is AUTOMATIC that are NOT running

			.DESCRIPTION
			This function will list services from a local or remote computer
			Where-Object the StartMode property is set to "Automatic" and
			Where-Object the state is different from RUNNING
			(so mostly Where-Object the state is NOT RUNNING)

			.PARAMETER ComputerName
			Computer Name to execute the function

			.EXAMPLE
			PS C:\> Get-ServiceStatus
			DisplayName                                  Name                           StartMode State
			-----------                                  ----                           --------- -----
			Microsoft .NET Framework NGEN v4.0.30319_X86 clr_optimization_v4.0.30319_32 Auto      Stopped
			Microsoft .NET Framework NGEN v4.0.30319_X64 clr_optimization_v4.0.30319_64 Auto      Stopped
			Multimedia Class Scheduler                   MMCSS                          Auto      Stopped

			Description
			-----------
			List Services Where-Object StartMode is AUTOMATIC that are NOT running

			.NOTES
			Just an initial Version of the Function,
			it might still need some optimization.

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Position = 0)]
		[String]$ComputerName = "$env:COMPUTERNAME"
	)

	PROCESS {
		# Try one or more commands
		try {
			# Cleanup
			Remove-Variable -Name 'ServiceStatus' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

			# Get the Infos
			Set-Variable -Name 'ServiceStatus' -Value $(Get-WmiObject -Class Win32_Service -ComputerName $ComputerName |
				Where-Object -FilterScript { ($_.startmode -like '*auto*') -and ($_.state -notlike '*running*') } |
				Select-Object -Property DisplayName, Name, StartMode, State |
			Format-Table -AutoSize)

			# Dump it to the Console
			Write-Output -InputObject $ServiceStatus
		} catch {
			# Whoopsie!!!
			Write-Warning -Message ('Could not get the list of services for {0}' -f $ComputerName)
		} finally {
			# Cleanup
			Remove-Variable -Name 'ServiceStatus' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}
}

function Get-ShortDate {
	<#
			.SYNOPSIS
			Get a short Date String

			.DESCRIPTION
			Get a short Date String, just the date not the time

			.EXAMPLE
			PS C:\> Get-ShortDate
			05.03.2016

			Description
			-----------
			Get a short Date String

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param ()

	PROCESS {
		(Get-Date).toShortDateString()
	}
}

function Get-Syntax {
	<#
			.SYNOPSIS
			Get the syntax of a cmdlet, even if we have no help for it

			.DESCRIPTION
			Helper function to get the syntax of a alias or cmdlet,
			even if we have no help for it

			.PARAMETER cmdlet
			command-let that you want to check

			.EXAMPLE
			PS C:\> Get-Syntax Get-Syntax
			Get-Syntax [-cmdlet] <Object> [<CommonParameters>]

			Description
			-----------
			Get the syntax and parameters for the cmdlet "Get-Syntax".
			Makes no sense at all, but this is just an example!

			.EXAMPLE
			PS C:\> Get-Syntax Get-Help

			Get-Help [[-Name] <string>] [-Path <string>] [-Category <string[]>] [-Component <string[]>] [-Functionality <string[]>] [-Role <string[]>] [-Full] [<CommonParameters>]

			Get-Help [[-Name] <string>] -Detailed [-Path <string>] [-Category <string[]>] [-Component <string[]>] [-Functionality <string[]>] [-Role <string[]>] [<CommonParameters>]

			Get-Help [[-Name] <string>] -Examples [-Path <string>] [-Category <string[]>] [-Component <string[]>] [-Functionality <string[]>] [-Role <string[]>] [<CommonParameters>]

			Get-Help [[-Name] <string>] -Parameter <string> [-Path <string>] [-Category <string[]>] [-Component <string[]>] [-Functionality <string[]>] [-Role <string[]>] [<CommonParameters>]

			Get-Help [[-Name] <string>] -Online [-Path <string>] [-Category <string[]>] [-Component <string[]>] [-Functionality <string[]>] [-Role <string[]>] [<CommonParameters>]

			Get-Help [[-Name] <string>] -ShowWindow [-Path <string>] [-Category <string[]>] [-Component <string[]>] [-Functionality <string[]>] [-Role <string[]>] [<CommonParameters>]

			Description
			-----------
			Get the syntax and parameters for the cmdlet "Get-Help".

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')][ValidateNotNullOrEmpty()]
		[Alias('Command')]
		$cmdlet
	)

	PROCESS {
		# Use Get-Command to show the syntax
		Get-Command -Name $cmdlet -Syntax
	}
}

function Get-SysType {
	<#
			.SYNOPSIS
			Show if the system is Workstation or a Server

			.DESCRIPTION
			This function shows of the system is a server or a workstation.
			Additionally it can show more detailed infos (like Domain Membership)

			.PARAMETER d
			Shows a more detailed information, including the domain level

			.EXAMPLE
			PS C:\> Get-SysType
			Workstation

			Description
			-----------
			The system is a Workstation (with or without Domain membership)

			.EXAMPLE
			PS C:\>  Get-SysType -d
			Standalone Server

			Description
			-----------
			The system is a non domain joined server.

			.NOTES
			Wrote this for myself to see what system I was connected to via
			Remote PowerShell

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>
	[OutputType([String])]
	param
	(
		[Parameter(Position = 0)]
		[Alias('detail')]
		[switch]$d
	)

	BEGIN {
		# Cleanup
		$role = $null

		# Read role
		$role = ((Get-WmiObject -Class Win32_ComputerSystem).DomainRole)
	}

	PROCESS {
		if ($d) {
			Switch ($role) {
				0 {Return 'Standalone Workstation'}
				1 {Return 'Member Workstation'}
				2 {Return 'Standalone Server'}
				3 {Return 'Member Server'}
				4 {Return 'Backup Domain Controller'}
				5 {Return 'Primary Domain Controller'}
				default {Return 'Unknown'}
			}
		} else {
			if (($role) -eq '0' -OR ($role) -eq '1') {Return 'Workstation'} elseif (($role) -gt '1' -AND ($role) -le '5') {Return 'Server'} else {Return 'Unknown'}
		}
	}

	END {
		# Cleanup
		$role = $null
	}
}

function Get-TempFile {
	<#
			.SYNOPSIS
			Creates a string with a temp file

			.DESCRIPTION
			Creates a string with a temp file

			.PARAMETER Extension
			File Extension as a string.
			The default is "tmp"

			.EXAMPLE
			PS C:\> Get-TempFile
			C:\Users\josh\AppData\Local\Temp\332ddb9a-5e52-4687-aa01-1d67ab6ae2b1.tmp

			Description
			-----------
			Returns a String of the Temp File with the extension TMP.

			.EXAMPLE
			PS C:\> Get-TempFile -Extension txt
			C:\Users\josh\AppData\Local\Temp\332ddb9a-5e52-4687-aa01-1d67ab6ae2b1.txt

			Description
			-----------
			Returns a String of the Temp File with the extension TXT

			.EXAMPLE
			PS C:\> $foo = (Get-TempFile)
			PS C:\> New-Item -Path $foo -Force -Confirm:$False
			PS C:\> Add-Content -Path $foo -Value 'Test' -Encoding 'UTF8' -Force

			Description
			-----------
			Creates a temp File: C:\Users\josh\AppData\Local\Temp\d08cec6f-8697-44db-9fba-2c369963a017.tmp

			And fill the newly created file with the String "Test"

			.NOTES
			Helper to avoid "System.IO.Path]::GetTempFileName()" usage.

			.LINK
			Idea: http://powershell.com/cs/blogs/tips/archive/2015/10/15/creating-temporary-filenames.aspx

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param
	(
		[String]$Extension = 'tmp'
	)

	BEGIN {
		$elements = @()
	}


	PROCESS {
		# Define objects
		$elements += [IO.Path]::GetTempPath()
		$elements += [Guid]::NewGuid()
		$elements += $Extension.TrimStart('.')
	}

	END {
		# Here we go: This is a Teampfile
		'{0}{1}.{2}' -f $elements
	}
}

function Get-TimeStamp {
	<#
			.SYNOPSIS
			Get-TimeStamp dumps a default Time-Stamp

			.DESCRIPTION
			Get-TimeStamp dumps a default Time-Stamp in the following format:
			yyyy-MM-dd HH:mm:ss

			.EXAMPLE
			PS C:\> Get-TimeStamp
			2015-12-13 18:05:18

			Description
			-----------
			Get a Time-Stamp as i would like it.

			.NOTES
			This is just a little helper function to make the shell more flexible
			It is just a kind of a leftover: Used that within my old logging
			functions a lot

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	PROCESS {
		Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
	}
}

function Get-Timezone {
	<#
			.Synopsis
			A function that retrieves valid computer timezones.

			.Description
			This function is a wrapper around tzutil.exe, aiming to make getting timezones slightly easier.

			.Parameter Timezone
			Specify the timezone that you wish to retrieve data for.
			Not specifying this parameter will return the current timezone.

			.Parameter UTCOffset
			Specify the offset from UTC to return timezones for,
			using the format NN:NN (implicitly positive), -NN:NN or +NN:NN.

			.Parameter All
			Return all timezones supported by tzutil available on the system.

			.Example
			PS C:\> Get-Timezone

			ExampleLocation                         UTCOffset                               Timezone
			---------------                         ---------                               --------
			(UTC+01:00) Amsterdam, Berlin, Bern,... +01:00                                  W. Europe Standard Time

			Description
			-----------
			Gets the current computer timezone

			.Example
			PS C:\> Get-Timezone -Timezone 'UTC'
			ExampleLocation                         UTCOffset                               Timezone
			---------------                         ---------                               --------
			(UTC) Coordinated Universal Time        +00:00                                  UTC

			Description
			-----------
			Get the timezone for Singapore standard time (UTC+08:00).

			.Example
			PS C:\> Get-Timezone -All

			Description
			-----------
			Returns all valid computer timezones.

			.Notes
			Author: David Green (http://tookitaway.co.uk/)
	#>

	[CmdletBinding(DefaultParameterSetName = 'Specific')]
	param
	(
		[Parameter(ParameterSetName = 'Specific',
				ValueFromPipeline,
				ValueFromPipelineByPropertyName,
		Position = 1)]
		[ValidateScript({
					$tz = (& "$env:windir\system32\tzutil.exe" /l)
					$validoptions = foreach ($t in $tz) {
						if (($tz.IndexOf($t) - 1) % 3 -eq 0) {
							$t.Trim()
						}
					}

					$validoptions -contains $_
		})]
		[String[]]$Timezone = (& "$env:windir\system32\tzutil.exe" /g),
		[Parameter(Mandatory,ParameterSetName = 'ByOffset',
				Position = 2,
		HelpMessage = 'Specify the timezone offset.')]
		[ValidateScript({
					$_ -match '^[+-]?[0-9]{2}:[0-9]{2}$'
		})]
		[String[]]$UTCOffset,
		[Parameter(ParameterSetName = 'All',
		Position = 3)]
		[switch]$All
	)

	Begin {
		$tz = (& "$env:windir\system32\tzutil.exe" /l)

		$Timezones = foreach ($t in $tz) {
			if (($tz.IndexOf($t) - 1) % 3 -eq 0) {
				$TimezoneProperties = @{
					Timezone        = $t
					UTCOffset       = $null
					ExampleLocation = ($tz[$tz.IndexOf($t) - 1]).Trim()
				}

				if (($tz[$tz.IndexOf($t) - 1]).StartsWith('(UTC)')) {
					$TimezoneProperties.UTCOffset = '+00:00'
				} elseif (($tz[$tz.IndexOf($t) - 1]).Length -gt 10) {
					$TimezoneProperties.UTCOffset = ($tz[$tz.IndexOf($t) - 1]).SubString(4, 6)
				}

				$TimezoneObj = (New-Object -TypeName PSObject -Property $TimezoneProperties)
				Write-Output -InputObject $TimezoneObj
			}
		}
	}

	Process {
		switch ($pscmdlet.ParameterSetName) {
			'All' {
				if ($All) {
					Write-Output -InputObject $Timezones
				}
			}

			'Specific' {
				foreach ($t in $Timezone) {
					Write-Output -InputObject $Timezones | Where-Object -FilterScript { $_.Timezone -eq $t }
				}
			}

			'ByOffset' {
				foreach ($offset in $UTCOffset) {
					$OffsetOutput = switch ($offset) {
						{ $_ -match '^[+-]00:00' } {
							Write-Output -InputObject '+00:00'
						}

						{ $_ -match '^[0-9]' } {
							Write-Output -InputObject ('+{0}' -f $offset)
						}

						default {
							Write-Output -InputObject $offset
						}
					}

					Write-Output -InputObject $Timezones | Where-Object -FilterScript { $_.UTCOffset -eq $OffsetOutput }
				}
			}
		}
	}
}

function Get-TopProcesses {
	<#
			.SYNOPSIS
			Make the PowerShell a bit more *NIX like

			.DESCRIPTION
			This is a PowerShell Version of the well known *NIX like TOP

			.EXAMPLE
			PS C:\> top

			Description
			-----------
			Shows the top CPU consuming processes

			.NOTES
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		# Define objects
		Set-Variable -Name SetValX -Value $([Console]::CursorLeft)
		Set-Variable -Name SetValY -Value $([Console]::CursorTop)
	}

	PROCESS {
		# figure out what uses the most CPU Time
		While ($True) {
			# Get the fist 30 items
			(Get-Process |
				Sort-Object -Descending -Property CPU |
			Select-Object -First 30)

			# Wait 2 seconds
			Start-Sleep -Seconds 2

			# Dump the Info
			[Console]::SetCursorPosition($SetValX, $SetValY + 3)
		}
	}
}

# Uni* like Uptime
function Get-Uptime {
	<#
			.SYNOPSIS
			Show how long system has been running

			.DESCRIPTION
			Uni* like Uptime - The uptime utility displays the current time,
			the length of time the system has been up

			.EXAMPLE
			PS C:\> Get-Uptime
			Uptime: 0 days, 2 hours, 11 minutes

			Description
			-----------
			Returns the uptime of the system, the time since last reboot/startup

			.NOTES
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param ()

	PROCESS {
		# Define objects
		$os = (Get-WmiObject -Class win32_operatingsystem)
		$uptime = ((Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime)))
		$Display = 'Uptime: ' + $uptime.Days + ' days, ' + $uptime.Hours + ' hours, ' + $uptime.Minutes + ' minutes'
	}

	END {
		# Dump the Infos
		Write-Output -InputObject $Display
	}
}

function Get-ValidateIsIP {
	<#
			.SYNOPSIS
			Validates if input is an IP Address

			.DESCRIPTION
			Validates if input is an IP Address

			.PARAMETER IP
			A string containing an IP address

			.EXAMPLE
			PS C:\> Get-ValidateIsIP 10.211.55.125
			True

			Description
			-----------
			Validates if input is an IP Address

			.EXAMPLE
			PS C:\> Get-ValidateIsIP -IP '10.211.55.125'
			True

			Description
			-----------
			Validates if input is an IP Address

			.EXAMPLE
			PS C:\> Get-ValidateIsIP -IP 'fe80::3db7:8507:3f9a:bb13%11'
			True

			Description
			-----------
			Validates if input is an IP Address

			.OUTPUTS
			System.Boolean

			.NOTES
			Very easy helper function

			.INPUTS
			System.String
	#>

	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory,ValueFromPipeline,
				Position = 1,
		HelpMessage = 'A string containing an IP address')]
		[ValidateNotNullOrEmpty()]
		[String]$IP
	)

	PROCESS {
		try {
			$null = ([ipaddress]::Parse($IP))
			return $True
		} catch {
			Write-Debug -Message 'Something is wrong!!!'
			return $False
		}
	}
}

function Get-Whois {
	<#
			.SYNOPSIS
			Script to retrieve WhoIs information from a list of domains

			.DESCRIPTION
			This script will, by default, create a report of WhoIs information on
			1 or more Internet domains. Not all Top-Level Domains support Whois
			queries! e.g. .de (Germany) domains!

			Report options are CSV, Json, XML, HTML, and object (default) output.
			Dates in the CSV, Json, and HTML options are formatted for the culture
			settings on the PC.
			Columns in HTML report are also sortable, just click on the headers.

			.PARAMETER Domain
			One or more domain names to check. Accepts pipeline.

			.PARAMETER Path
			Path Where-Object the resulting HTML or CSV report will be saved.

			Default is: C:\scripts\PowerShell\export

			.PARAMETER RedThresold
			If the number of days left before the domain expires falls below this
			number the entire row will be highlighted in Red (HTML reports only).

			Default is 30 (Days)

			.PARAMETER YellowThresold
			If the number of days left before the domain expires falls below this
			number the entire row will be highlighted in Yellow (HTML reports only)

			Default is 90 (Days)

			.PARAMETER GreyThresold
			If the number of days left before the domain expires falls below this
			number the entire row will be highlighted in Grey (HTML reports only).

			Default is 365 (Days)

			.PARAMETER OutputType
			Specify what kind of report you want.  Valid types are Json, XML,HTML,
			CSV, or Object.

			The default is Object.

			.EXAMPLE
			PS C:\> Get-Whois -Domain "alright-it.com"

			Description
			-----------
			Will create object Whois output of the domain registration data.

			.EXAMPLE
			PS C:\> Get-Whois -Domain "alright-it.com" -OutputType json

			Description
			-----------
			Will create Json Whois Report of the domain registration data.

			.NOTES
			Based on an idea of Martin Pugh (Martin Pugh)

			.LINK
			Source: http://community.spiceworks.com/scripts/show/2809-whois-report-Get-whois-ps1

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'One or more domain names to check. Accepts pipeline.')]
		[String]$Domain,
		[String]$Path = 'C:\scripts\PowerShell\export',
		[int]$RedThresold = 30,
		[int]$YellowThresold = 90,
		[int]$GreyThresold = 365,
		[Parameter(ValueFromPipeline,
		Position = 1)]
		[ValidateSet('object', 'json', 'csv', 'html', 'html', 'xml')]
		[String]$OutputType = 'object'
	)

	BEGIN {
		# Be Verbose
		Write-Verbose -Message ('{0}: Get-WhoIs script beginning.' -f (Get-Date))

		# Validate the path
		if ($Path) {
			if (Test-Path -Path $Path) {
				if (-not (Get-Item -Path $Path).PSisContainer) {
					# Aw Snap!
					Write-Error  -Message ('You cannot specify a file in the Path parameter, must be a folder: {0}' -f $Path)

					# Die headers
					exit 1
				}
			} else {
				# Aw Snap!
				Write-Error  -Message ('Unable to locate: {0}' -f $Path)

				# Die hard!
				exit 1
			}
		} else {$Path = (Split-Path -Path $MyInvocation.MyCommand.Path)}

		# Create the Web Proxy instance
		$WC = (New-WebServiceProxy -Uri 'http://www.webservicex.net/whois.asmx?WSDL')

		# Cleanup
		$data = @()
	}

	PROCESS {
		# Loop over the given domains
		$data += ForEach ($Dom in $Domain) {
			# Be Verbose
			Write-Verbose -Message ('{0}: Querying for {1}' -f (Get-Date), $Dom)

			# Cleanup
			$DNError = ''

			Try {$raw = $WC.GetWhoIs($Dom)} Catch {
				# Some domains throw an error, I assume because the WhoIs server isn't returning standard output
				$DNError = ('{0}: Unknown Error retrieving WhoIs information' -f $Dom.ToUpper())
			}

			# Test if the domain name is good or if the data coming back is ok--Google.Com just returns a list of domain names so no good
			if ($raw -match 'No match for') {$DNError = ('{0}: Unable to find registration for domain' -f $Dom.ToUpper())} elseif ($raw -notmatch 'Domain Name: (.*)') {$DNError = ('{0}: WhoIs data not in correct format' -f $Dom.ToUpper())}

			if ($DNError) {
				# Use 999899 to tell the script later that this is a bad domain and color it properly in HTML (if HTML output requested)
				[PSCustomObject]@{
					DomainName  = $DNError
					Registrar   = ''
					WhoIsServer = ''
					NameServers = ''
					DomainLock  = ''
					LastUpdated = ''
					Created     = ''
					Expiration  = ''
					DaysLeft    = 999899
				}

				# Bad!
				Write-Warning -Message ('{0}' -f $DNError)
			} else {
				# Parse out the DNS servers
				$NS = ForEach ($Match in ($raw | Select-String -Pattern 'Name Server: (.*)' -AllMatches).Matches) {$Match.Groups[1].Value}

				#Parse out the rest of the data
				[PSCustomObject]@{
					DomainName  = (($raw | Select-String -Pattern 'Domain Name: (.*)').Matches.Groups[1].Value)
					Registrar   = (($raw | Select-String -Pattern 'Registrar: (.*)').Matches.Groups[1].Value)
					WhoIsServer = (($raw | Select-String -Pattern 'WhoIs Server: (.*)').Matches.Groups[1].Value)
					NameServers = ($NS -join ', ')
					DomainLock  = (($raw | Select-String -Pattern 'Status: (.*)').Matches.Groups[1].Value)
					LastUpdated = [datetime]($raw | Select-String -Pattern 'Updated Date: (.*)').Matches.Groups[1].Value
					Created     = [datetime]($raw | Select-String -Pattern 'Creation Date: (.*)').Matches.Groups[1].Value
					Expiration  = [datetime]($raw | Select-String -Pattern 'Expiration Date: (.*)').Matches.Groups[1].Value
					DaysLeft    = ((New-TimeSpan -Start (Get-Date) -End ([datetime]($raw | Select-String -Pattern 'Expiration Date: (.*)').Matches.Groups[1].Value)).Days)
				}
			}
		}
	}

	END {
		# Be Verbose
		Write-Verbose -Message ('{0}: Producing {1} report' -f (Get-Date), $OutputType)

		#
		$WC.Dispose()

		# Sort the Domain Data
		$data = $data | Sort-Object -Property DomainName

		# What kind of output?
		Switch ($OutputType) {
			'object'
			{
				# Dump to Console
				(Write-Output -InputObject $data | Select-Object -Property DomainName, Registrar, WhoIsServer, NameServers, DomainLock, LastUpdated, Created, Expiration, @{
						Name       = 'DaysLeft'
						Expression = { if ($_.DaysLeft -eq 999899) { 0 } else { $_.DaysLeft } }
				})
			}
			'csv'
			{
				# Export a CSV
				$ReportPath = (Join-Path -Path $Path -ChildPath 'WhoIs.CSV')
				($data |
					Select-Object -Property DomainName, Registrar, WhoIsServer, NameServers, DomainLock, @{
						Name       = 'LastUpdated'
						Expression = { Get-Date -Date $_.LastUpdated -Format (Get-Culture).DateTimeFormat.ShortDatePattern }
					}, @{
						Name       = 'Created'
						Expression = { Get-Date -Date $_.Created -Format (Get-Culture).DateTimeFormat.ShortDatePattern }
					}, @{
						Name       = 'Expiration'
						Expression = { Get-Date -Date $_.Expiration -Format (Get-Culture).DateTimeFormat.ShortDatePattern }
					}, DaysLeft |
				Export-Csv -Path $ReportPath -NoTypeInformation)
			}
			'xml'
			{
				# Still like XML?
				$ReportPath = (Join-Path -Path $Path -ChildPath 'WhoIs.XML')
				($data |
					Select-Object -Property DomainName, Registrar, WhoIsServer, NameServers, DomainLock, LastUpdated, Created, Expiration, @{
						Name       = 'DaysLeft'
						Expression = { if ($_.DaysLeft -eq 999899) { 0 } else { $_.DaysLeft } }
					} |
				Export-Clixml -Path $ReportPath)
			}
			'json'
			{
				# I must admin: I like Json...
				$ReportPath = (Join-Path -Path $Path -ChildPath 'WhoIs.json')
				$JsonData = ($data | Select-Object -Property DomainName, Registrar, WhoIsServer, NameServers, DomainLock, @{
						Name       = 'LastUpdated'
						Expression = { Get-Date -Date $_.LastUpdated -Format (Get-Culture).DateTimeFormat.ShortDatePattern }
					}, @{
						Name       = 'Created'
						Expression = { Get-Date -Date $_.Created -Format (Get-Culture).DateTimeFormat.ShortDatePattern }
					}, @{
						Name       = 'Expiration'
						Expression = { Get-Date -Date $_.Expiration -Format (Get-Culture).DateTimeFormat.ShortDatePattern }
				}, DaysLeft)
				ConvertTo-Json -InputObject $JsonData -Depth 10 > $ReportPath
			}
			'html'
			{
				# OK, HTML is should be!
				$Header = @'
<script src="http://kryogenix.org/code/browser/sorttable/sorttable.js"></script>
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TR:Hover TD {Background-Color: #C1D5F8;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;cursor: pointer;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
<title>
WhoIS Report
</title>
'@

				$PreContent = @'
<p><h1>WhoIs Report</h1></p>
'@

				$PostContent = @"
<p><br/><h3>Legend</h3>
<pre><span style="background-color:red">    </span>  Expires in under $RedThreshold days
<span style="background-color:yellow">    </span>  Expires in under $YellowThreshold days
<span style="background-color:#B0C4DE">    </span>  Expires in under $GreyThreshold days
<span style="background-color:#DEB887">    </span>  Problem retrieving information about domain/Domain not found</pre></p>
<h6><br/>Run on: $(Get-Date)</h6>
"@

				$RawHTML = ($data |
					Select-Object -Property DomainName, Registrar, WhoIsServer, NameServers, DomainLock, @{
						Name       = 'LastUpdated'
						Expression = { Get-Date -Date $_.LastUpdated -Format (Get-Culture).DateTimeFormat.ShortDatePattern }
					}, @{
						Name       = 'Created'
						Expression = { Get-Date -Date $_.Created -Format (Get-Culture).DateTimeFormat.ShortDatePattern }
					}, @{
						Name       = 'Expiration'
						Expression = { Get-Date -Date $_.Expiration -Format (Get-Culture).DateTimeFormat.ShortDatePattern }
					}, DaysLeft |
				ConvertTo-Html -Head $Header -PreContent $PreContent -PostContent $PostContent)

				$HTML = ForEach ($Line in $RawHTML) {
					if ($Line -like '*<tr><td>*') {
						$Value = [float](([xml]$Line).SelectNodes('//td').'#text'[-1])

						if ($Value) {
							if ($Value -eq 999899) {$Line.Replace('<tr><td>', '<tr style="background-color: #DEB887;"><td>').Replace('<td>999899</td>', '<td>0</td>')} elseif ($Value -lt $RedThreshold) {$Line.Replace('<tr><td>', '<tr style="background-color: red;"><td>')} elseif ($Value -lt $YellowThreshold) {$Line.Replace('<tr><td>', '<tr style="background-color: yellow;"><td>')} elseif ($Value -lt $GreyThreshold) {$Line.Replace('<tr><td>', '<tr style="background-color: #B0C4DE;"><td>')} else {$Line}
						}
					} elseif ($Line -like '*<table>*') {$Line.Replace('<table>', '<table class="sortable">')} else {$Line}
				}

				# File name
				$ReportPath = (Join-Path -Path $Path -ChildPath 'WhoIs.html')

				# Dump the HTML
				($HTML | Out-File -FilePath $ReportPath -Encoding ASCII)

				# Immediately display the html if in debug mode
				if ($pscmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {& $ReportPath}
			}
		}

		# Be Verbose
		Write-Verbose -Message ('{0}: Get-WhoIs script completed!' -f (Get-Date))
	}
}

# Old implementation of the above GREP tool
# More complex but even more UNI* like
function Invoke-GnuGrep {
	<#
			.SYNOPSIS
			File pattern searcher

			.DESCRIPTION
			This command emulates the well known (and loved?) GNU file
			pattern searcher

			.PARAMETER pattern
			Pattern (STRING) - Mandatory

			.PARAMETER filefilter
			File (STRING) - Mandatory

			.PARAMETER r
			Recurse

			.PARAMETER i
			Ignore case

			.PARAMETER l
			List filenames

			.EXAMPLE
			Invoke-GnuGrep

			Description
			-----------
			File pattern searcher

			.EXAMPLE
			Invoke-GnuGrep

			Description
			-----------
			File pattern searcher

			.NOTES
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues

	#>

	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = ' Pattern (STRING) - Mandatory')]
		[ValidateNotNullOrEmpty()]
		[Alias('PaternString')]
		[String]$pattern,
		[Parameter(Mandatory,
				Position = 1,
		HelpMessage = ' File (STRING) - Mandatory')]
		[ValidateNotNullOrEmpty()]
		[Alias('FFilter')]
		[String]$filefilter,
		[Alias('Recursive')]
		[switch]$r,
		[Alias('IgnoreCase')]
		[switch]$i,
		[Alias('ListFilenames')]
		[switch]$l
	)

	BEGIN {
		# Define object
		$Path = $PWD

		# need to add filter for files only, no directories
		$files = (Get-ChildItem -Path $Path -Include "$filefilter" -Recurse:$r)
	}

	PROCESS {
		# What to do?
		if ($l) {
			# Do we need to loop?
			$files | ForEach-Object -Process {
				# What is it?
				if ($(Get-Content -Path $_ | Select-String -Pattern $pattern -CaseSensitive:$i).Count > 0) {
					$_ | Select-Object -ExpandProperty path
				}
			}
			Select-String -Pattern $pattern -Path $files -CaseSensitive:$i
		} else {
			$files | ForEach-Object -Process {
				$_ | Select-String -Pattern $pattern -CaseSensitive:$i
			}
		}
	}
}

function Grant-PathFullPermission {
	<#
			.SYNOPSIS
			Grant Full Access Permission for a given user to a given Path

			.DESCRIPTION
			Grant Full Access Permission for a given user to a given Path

			.PARAMETER path
			Path you want to grant the access to

			.PARAMETER user
			User you want to grant the access to

			.EXAMPLE
			PS C:\> Grant-PathFullPermission -path 'D:\dev' -user 'John'

			Description
			-----------
			Grant Full Access Permission for a given user 'John' to a given
			Path 'D:\dev'
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Path you want to grant the access to')]
		[ValidateNotNullOrEmpty()]
		[String]$Path,
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = 'User you want to grant the access to')]
		[String]$user
	)

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}

		if (-not (Test-Path -Path $Path -PathType Container)) {
			Write-Error -Message ('Sorry {0} does not exist!' -f $Path) -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		} else {
			Write-Output -InputObject ('Set full permission on {0} for {1}.' -f $Path, $user)
		}
	}

	PROCESS {
		# Get the existing ACL for the Path
		try {
			($acl = (Get-Acl -Path $Path -ErrorAction Stop -WarningAction SilentlyContinue)) > $null 2>&1 3>&1
		} catch {
			# Whoopsie
			Write-Error -Message ('Could not get existing ACL for {0}' -f $Path) -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}

		# Do we have inheritance?
		$inheritance = $(
			if (Test-Path -Path $Path -PathType Container) {
				'ContainerInherit, ObjectInherit'
			} else {
				'None'
		})

		# Build a new Rule...
		$rule = (New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList ($user, 'FullControl', $inheritance, 'None', 'Allow'))

		# Set the new rule
		$acl.SetAccessRule($rule)

		# Apply the new Rule to the Path
		try {
			(Set-Acl -Path $Path -AclObject $acl -ErrorAction Stop -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		} catch {
			# Whoopsie
			Write-Error -Message ('Could not set new ACL for {0} on {1}' -f $user, $Path) -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}
	}
}

function Invoke-PowerHead {
	<#
			.SYNOPSIS
			Display first lines of a file

			.DESCRIPTION
			This filter displays the first count lines or bytes of each of the
			specified files, or of the standard input if no files are specified.

			If count is omitted it defaults to 10.

			.PARAMETER File
			Filename

			.PARAMETER count
			A description of the count parameter, default is 10.

			.EXAMPLE
			PS C:\> head 'C:\scripts\info.txt'

			Description
			-----------
			Display first 10 lines of a file 'C:\scripts\info.txt'

			.EXAMPLE
			PS C:\> Invoke-PowerHead -File 'C:\scripts\info.txt'

			Description
			-----------
			Display first 10 lines of a file 'C:\scripts\info.txt'

			.EXAMPLE
			PS C:\> Invoke-PowerHead -File 'C:\scripts\info.txt' -count '2'

			Description
			-----------
			Display first 2 lines of a file 'C:\scripts\info.txt'

			.NOTES
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
		HelpMessage = 'Filename')]
		[ValidateNotNullOrEmpty()]
		[Alias('FileName')]
		[String]$File,
		[Alias('Counter')]
		[int]$count = 10
	)

	BEGIN {
		# Does this exist?
		if (-not (Test-Path -Path $File)) {
			# Aw Snap!
			Write-Error -Message ('Unable to locate file {0}' -f $File) -ErrorAction Stop

			Return
		}
	}

	PROCESS {
		# Show the fist X entries
		Return (Get-Content -Path $File | Select-Object -First $count)
	}
}

function Invoke-PowerHelp {
	<#
			.SYNOPSIS
			Wrapper that use the cmdlet Get-Help -full

			.DESCRIPTION
			Wrapper that use the regular cmdlet Get-Help -full to show all
			technical informations about the given command

			.EXAMPLE
			PS C:\> help Get-item

			Description
			-----------
			Show the full technical informations of the Get-item cmdlet

			.NOTES
			This is just a little helper function to make the shell more flexible

			.PARAMETER cmdlet
			command-let

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		# Make the console clean
		[Console]::Clear()
		[Console]::SetWindowPosition(0,[Console]::CursorTop)
	}

	PROCESS {
		# Get the FULL Help Message for the given command-let
		Get-Help -Name $args[0] -Full
	}
}

function Set-IgnoreSslTrust {
	<#
			.SYNOPSIS
			This workaround completely disables SSL certificate checks

			.DESCRIPTION
			This workaround disables the SSL certificate trust checking.
			This seems to be useful if you need to use self signed SSL certificates

			But there is a string attached:
			This is very dangerous.

			And this is not a joke, it is dangerous, because you leave the door
			wide open (and honestly it means completely open) for bad certificates,
			hijacked certificates and even Man-In-The-middle attacks!

			So really think twice before you use this in a production environment!

			.EXAMPLE
			PS C:\> Set-IgnoreSslTrust

			Description
			-----------
			This workaround completely disables SSL certificate checks.
			Do this only if you know what you are doing here!!!

			.NOTES
			Be careful:
			If you really need to disable the SSL Trust setting,
			just use it for the calls you really need to!

			.LINK
			Source: https://msdn.microsoft.com/en-us/library/system.net.servicepointmanager.servercertificatevalidationcallback.aspx
			Source: https://msdn.microsoft.com/en-us/library/system.net.security.remotecertificatevalidationcallback.aspx

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding(ConfirmImpact = 'High',
	SupportsShouldProcess)]
	param ()

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		# Set the SSL Ignore based on the configuration Value Leaves the door wide open...
		# Think before set this Boolean to $True


			# AGAIN:
			# Think before you enable this! It could be very dangerous!!!
			[Net.ServicePointManager]::ServerCertificateValidationCallback = { Return $True }

			# Be Verbose
			Write-Verbose -Message 'SSL Trust IS ignored - BAD IDEA'

			# Tell the user what we think about that!
			Write-Warning -Message 'SSL Trust IS ignored - BAD IDEA'
	}
}

function Set-NotIgnoreSslTrust {
	<#
			.SYNOPSIS
			Enables the SSL certificate checks

			.DESCRIPTION
			This is a companion function for the usage of the
			"Set-IgnoreSslTrust" function
			It might be a great idea to disable the SSL Trust check for a single
			call (If you real need to do it) via the "Set-IgnoreSslTrust"
			function and then enable it directly after the call
			via "Set-NotIgnoreSslTrust"

			.EXAMPLE
			PS C:\> Set-NotIgnoreSslTrust

			Description
			-----------
			Enables the SSL certificate checks

			.NOTES
			Do yourself a favor and use this function right after a call
			without SSL Trust check!!!

			.LINK
			Source: https://msdn.microsoft.com/en-us/library/system.net.servicepointmanager.servercertificatevalidationcallback.aspx
			Source: https://msdn.microsoft.com/en-us/library/system.net.security.remotecertificatevalidationcallback.aspx
	#>

	[CmdletBinding(ConfirmImpact = 'Low',
	SupportsShouldProcess)]
	param ()

	PROCESS {
		[Net.ServicePointManager]::ServerCertificateValidationCallback = { Return $False }

		# Be Verbose
		Write-Verbose -Message 'SSL Trust is NOT ignored - GOOD IDEA'
	}
}

function Initialize-ModuleUpdate {
	<#
			.SYNOPSIS
			Refresh the PowerShell Module Information

			.DESCRIPTION
			Refresh the PowerShell Module Information
			Wrapper for the following command: Get-Module -ListAvailable -Refresh

			.PARAMETER Verbosity
			Verbose output, default is not

			.EXAMPLE
			PS C:\> Initialize-ModuleUpdate -Verbose

			Description
			-----------
			Refresh the PowerShell Module Information

			.EXAMPLE
			PS C:\> Initialize-ModuleUpdate -Verbose

			Description
			-----------
			Refresh the PowerShell Module Information

			.NOTES
			PowerShell will auto-load modules. However, with some modules, this
			technique may fail.

			Their cmdlets will still only be available after you manually import
			the module using Import-Module.

			The reason most likely is the way these modules were built.

			PowerShell has no way of detecting which cmdlets are exported by
			these modules.

	#>

	param
	(
		[Parameter(Position = 0)]
		[switch]$Verbosity = $False
	)

	BEGIN {
		Write-Output -InputObject 'Update...'
	}

	PROCESS {
		if ($Verbosity) {
			Get-Module -ListAvailable -Refresh
		} else {
			(Get-Module -ListAvailable -Refresh) > $null 2>&1 3>&1
		}
	}
}

function Invoke-AnimatedSleep {
	<#
			.SYNOPSIS
			Animated sleep

			.DESCRIPTION
			Takes the title and displays a looping animation for a given number of
			seconds.
			The animation will delete itself once it's finished,
			to save on console scrolling.

			.PARAMETER seconds
			A number of seconds to sleep for

			.PARAMETER title
			Some words to put next to the thing

			.EXAMPLE
			PS C:\> Invoke-AnimatedSleep

			Description
			-----------
			Will display a small animation for 1 second

			.EXAMPLE
			PS C:\> Invoke-AnimatedSleep 5

			Description
			-----------
			Will display a small animation for 5 seconds

			.EXAMPLE
			PS C:\> Invoke-AnimatedSleep 10 "Waiting for domain sync"

			Description
			-----------
			Will display "Waiting for domain sync " and a small animation for
			10 seconds

			.NOTES
			Based on an idea of Doug Kerwin

			.LINK
			Source https://github.com/dwkerwin/powershell_profile/blob/master/autoload-scripts/vendor/sleepanim.ps1
	#>

	param
	(
		[Parameter(ValueFromPipeline,
		Position = 1)]
		[int]$seconds = 1,
		[Parameter(ValueFromPipeline,
		Position = 2)]
		[string]$title = 'Sleeping'
	)

	BEGIN {
		$blank = "`b" * ($title.length + 11)
		$clear = ' ' * ($title.length + 11)
		$anim = @('0o.......o', 'o0o.......', '.o0o......', '..o0o.....', '...o0o....', '....o0o...', '.....o0o..', '......o0o.', '.......o0o', 'o.......o0') # Animation sequence characters
	}

	PROCESS {
		while ($seconds -gt 0) {
			$anim | ForEach-Object -Process {
				Write-Host -Object "$blank$title $_" -NoNewline -ForegroundColor Yellow
				Start-Sleep -Milliseconds 100
			}

			$seconds--
		}
	}

	END {
		Write-Host -Object "$blank$clear$blank" -NoNewline
	}
}

function Invoke-baloonTip {
	<#
			.SYNOPSIS
			Shows a Windows Balloon notification

			.DESCRIPTION
			Shows a Windows Balloon notification

			.PARAMETER Title
			Title of the Balloon Tip

			.PARAMETER Message
			Message of the Balloon Tip

			.PARAMETER Icon
			Type for the Balloon

			.EXAMPLE
			PS C:\> Invoke-baloonTip

			Description
			-----------
			Show a windows Balloon with the Title "Title" and the Text "Message..."
			as "Information".

			This is the default values for everything.

			.EXAMPLE
			PS C:\> Invoke-baloonTip -Title 'Diskspace!!!' -Message 'Diskspace on c: is low' -Icon 'Exclamation'

			Description
			-----------
			This shows an Balloon with the Title "Diskspace!!!",
			the message is "Diskspace on c: is low" as "Exclamation"

			.EXAMPLE
			PS C:\> Invoke-baloonTip -Title 'Reconnect?' -Message 'Should is reconnect to Office 365???' -Icon 'Question'

			Description
			-----------
			This shows an Balloon with the Title "Reconnect?",
			the message is "Should is reconnect to Office 365???" as "Question"

			.NOTES
			Tested with Windows 7, Windows 8/8.1 and Windows Server 2012/2012R2
	#>

	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[String]$title = 'Information',
		[Parameter(ValueFromPipeline,
		Position = 1)]
		[String]$Message = 'Message...',
		[Parameter(ValueFromPipeline,
		Position = 2)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Question', 'Exclamation', 'Information')]
		[String]$Icon = 'Information'
	)

	BEGIN {
		$null = (Add-Type -AssemblyName System.Drawing)
		$null = (Add-Type -AssemblyName System.Windows.Forms)
	}

	PROCESS {
		$notification = (New-Object -TypeName System.Windows.Forms.NotifyIcon)

		# Define the icon for the system tray
		$notification.Icon = [Drawing.SystemIcons]::$Icon

		#Display title of balloon window
		$notification.BalloonTipTitle = $title

		#Type of balloon icon
		$notification.BalloonTipIcon = 'Info'

		#Notification message
		$notification.BalloonTipText = $Message

		#Make balloon tip visible when called
		$notification.Visible = $True

		#Call the balloon notification
		$notification.ShowBalloonTip(15000)
	}

	END {
		if ($debug) {
			Write-Output -InputObject $notification
		}
	}
}

function Invoke-CreateMissingRegistryDrives {
	<#
			.SYNOPSIS
			Create Missing Registry Drives

			.DESCRIPTION
			Create Missing Registry Drives

			.EXAMPLE
			PS C:\> Invoke-CreateMissingRegistryDrives

			Description
			-----------
			Create Missing Registry Drives

			.NOTES
			Based on an idea of ALIENQuake

			.LINK
			ALIENQuake https://github.com/ALIENQuake/WindowsPowerShell
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		$null = (New-PSDrive -Name 'HKU' -PSProvider 'Registry' -Root Registry::HKEY_USERS)
		$null = (New-PSDrive -Name 'HKCR' -PSProvider 'Registry' -Root Registry::HKEY_CLASSES_ROOT)
		$null = (New-PSDrive -Name 'HKCC' -PSProvider 'Registry' -Root Registry::HKEY_CURRENT_CONFIG)
	}
}

function Invoke-GC {
	<#
			.SYNOPSIS
			Do a garbage collection

			.DESCRIPTION
			Do a garbage collection within the PowerShell Session

			.EXAMPLE
			PS C:\> Invoke-GC

			Description
			-----------
			Do a garbage collection

			.NOTES
			Just a little helper function to do garbage collection
			PowerShell sometimes do not cleanup and this uses more memory then
			it should...
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		# Call the .NET function
		$null = ([GC]::Collect())
	}
}

function Invoke-VisualEditor {
	<#
			.SYNOPSIS
			Wrapper to edit files

			.DESCRIPTION
			This is a quick wrapper that edits files with editor from the
			VisualEditor variable

			.PARAMETER args
			Arguments

			.PARAMETER Filename
			File that you would like to edit

			.EXAMPLE
			PS C:\> Invoke-VisualEditor example.txt

			Description
			-----------
			Invokes Note++ or ISE and edits "example.txt".
			This is possible, even if the File does not exists...
			The editor should ask you if it should create it for you

			.EXAMPLE
			PS C:\> Invoke-VisualEditor

			Description
			-----------
			Invokes Note++ or ISE without opening a file

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			Set-VisualEditor

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter()]
		[Alias('File')]
		[String]$args
	)

	PROCESS {
		# Call the newly set Editor
		if (-not ($VisualEditor)) {
			# Aw SNAP! The VisualEditor is not configured...
			Write-Error -Message 'System is not configured well! Use Set-VisualEditor to setup!' -ErrorAction Stop
		} else {
			# Yeah! Do it...
			if (-not ($args)) {
				#
				Start-Process -FilePath $VisualEditor
			} else {
				#
				Start-Process -FilePath $VisualEditor -ArgumentList "$args"
			}
		}
	}
}

function Convert-IPToBinary {
	<#
			.SYNOPSIS
			Converts an IP address string to it's binary string equivalent

			.DESCRIPTION
			Takes a IP as a string and returns the same IP address as a binary
			string with no decimal points

			.PARAMETER IP
			The IP address which will be converted to a binary string

			.EXAMPLE
			PS C:\> Convert-IPToBinary -IP '10.211.55.1'
			Binary                           IPAddress
			------                           ---------
			00001010110100110011011100000001 10.211.55.1

			Description
			-----------
			Converts 10.211.55.1 to the binary equivalent (00001010110100110011011100000001)

			.NOTES
			Works with IPv4 addresses only!
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	param
	(
		[Parameter(Mandatory,ValueFromPipeline,
				Position = 1,
		HelpMessage = 'The IP address which will be converted to a binary string')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')]
		[Alias('IPAddress')]
		[String]$IP
	)

	BEGIN {
		$Binary = $null
		$result = $null
		$SingleIP = $null
	}

	PROCESS {
		foreach ($SingleIP in $IP) {
			try {
				$SingleIP.split('.') | ForEach-Object -Process { $Binary = $Binary + $([convert]::toString($_, 2).padleft(8, '0')) }
			} catch [System.Exception] {
				Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop

				# Capture any failure and display it in the error section
				# The Exit with Code 1 shows any calling App that there was something wrong
				exit 1
			} catch {
				Write-Error -Message ('Could not convert {0}!' -f $SingleIP) -ErrorAction Stop

				# Still here? Make sure we are done!
				break
			}

			$result = New-Object -TypeName PSObject -Property @{
				IPAddress = $SingleIP
				Binary    = $Binary
			}
		}
	}

	END {
		Write-Output -InputObject $result
	}
}

function Convert-IPtoDecimal {
	<#
			.SYNOPSIS
			Converts an IP address to decimal.

			.DESCRIPTION
			Converts an IP address to decimal value.

			.PARAMETER IPAddress
			An IP Address you want to check

			.EXAMPLE
			PS C:\> Convert-IPtoDecimal -IPAddress '127.0.0.1'

			decimal		IPAddress
			-------		---------
			2130706433	127.0.0.1

			Description
			-----------
			Converts an IP address to decimal.

			.EXAMPLE
			PS C:\> Convert-IPtoDecimal '10.0.0.1'

			decimal		IPAddress
			-------		---------
			167772161	10.0.0.1

			Description
			-----------
			Converts an IP address to decimal.

			.EXAMPLE
			PS C:\> '192.168.0.1' |  Convert-IPtoDecimal

			decimal		IPAddress
			-------		---------
			3232235521	192.168.0.1

			Description
			-----------
			Converts an IP address to decimal.

			.NOTES
			Sometimes I need to have that info, so I decided it would be great
			to have a functions who do the job!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'An IP Address you want to check')]
		[Alias('IP')]
		[String]$IPAddress
	)

	BEGIN {
		# Dummy block - We so nothing here
	}

	PROCESS {
		# OK make sure the we have a string here!
		# Then we split everthing based on the DOTs.
		[String[]]$IP = $IPAddress.Split('.')

		# Create a new object and transform it to Decimal
		$Object = New-Object -TypeName psobject -Property (@{
				'IPAddress' = $($IPAddress)
				'Decimal' = [long](
					([int]::Parse($IP[0]) * [Math]::Pow(2, 24) +
						([int]::Parse($IP[1]) * [Math]::Pow(2, 16) +
							([int]::Parse($IP[2]) * [Math]::Pow(2, 8) +
								([int]::Parse($IP[3])
								)
							)
						)
					)
				)
		})
	}

	END {
		# Dump the info to the console
		Write-Output -InputObject $Object
	}
}

function Invoke-CheckIPaddress {
	<#
			.SYNOPSIS
			Check if a given IP Address seems to be valid

			.DESCRIPTION
			Check if a given IP Address seems to be valid.
			We use the .NET function to do so. This is not 100% reliable,
			but is enough most times.

			.PARAMETER IPAddress
			An IP Address you want to check

			.EXAMPLE
			PS C:\> Invoke-CheckIPaddress -IPAddress '10.10.16.10'
			True

			Description
			-----------
			Check if a given IP Address seems to be valid

			.EXAMPLE
			PS C:\> Invoke-CheckIPaddress -IPAddress '010.010.016.010'
			True

			Description
			-----------
			Check if a given IP Address seems to be valid

			.EXAMPLE
			PS C:\> Check-IPaddress -IPAddress '10.10.16.01O'
			False

			Description
			-----------
			Check if a given IP Address seems to be valid

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipelineByPropertyName,
				Position = 0,
		HelpMessage = 'An IP Address you want to check')]
		[ValidateScript({
					$_ -match [IPAddress]
					$_
		})]
		[Alias('IP')]
		[String]$IPAddress
	)

	PROCESS {
		# Use the .NET Call to figure out if the given address is valid or not.
		Set-Variable -Name 'IsValid' -Scope Script -Value $(($IPAddress -As [IPAddress]) -As [Bool])
	}

	END {
		# Dump the bool value to the console
		Write-Output -InputObject $IsValid
	}
}

function Get-NtpTime {
	<#
			.SYNOPSIS
			Get the NTP Time from a given Server

			.DESCRIPTION
			Get the NTP Time from a given Server.

			.PARAMETER Server
			NTP Server to use. The default is de.pool.ntp.org

			.EXAMPLE
			PS C:\scripts\PowerShell> Get-NtpTime -Server 'de.pool.ntp.org'
			5. April 2016 00:58:59

			Description
			-----------
			Get the NTP Time from a given Server

			.NOTES
			This sends an NTP time packet to the specified NTP server and reads
			back the response.
			The NTP time packet from the server is decoded and returned.

			Note: this uses NTP (rfc-1305: http://www.faqs.org/rfcs/rfc1305.html)
			on UDP 123.
			Because the function makes a single call to a single server this is
			strictly a SNTP client (rfc-2030).
			Although the SNTP protocol data is similar (and can be identical) and
			the clients and servers are often unable to distinguish the difference.
			Where-Object SNTP differs is that is does not accumulate historical
			data (to enable statistical averaging) and does not retain a session
			between client and server.

			An alternative to NTP or SNTP is to use Daytime (rfc-867) on TCP
			port 13 although this is an old protocol and is not supported
			by all NTP servers.

			.LINK
			Source: https://chrisjwarwick.wordpress.com/2012/08/26/getting-ntpsntp-network-time-with-powershell/
	#>

	[OutputType([datetime])]
	[CmdletBinding()]
	param
	(
		[Alias('NETServer')]
		[String]$Server = 'de.pool.ntp.org'
	)

	PROCESS {
		# Construct client NTP time packet to send to specified server
		# (Request Header: [00=No Leap Warning; 011=Version 3; 011=Client Mode]; 00011011 = 0x1B)
		[Byte[]]$NtpData = , 0 * 48
		$NtpData[0] = 0x1B

		# Create the connection
		$Socket = New-Object -TypeName Net.Sockets.Socket -ArgumentList ([Net.Sockets.AddressFamily]::InterNetwork, [Net.Sockets.SocketType]::Dgram, [Net.Sockets.ProtocolType]::Udp)

		# Configure the connection
		$Socket.Connect($Server, 123)
		$null = $Socket.Send($NtpData)

		# Returns length â€" should be 48
		$null = $Socket.Receive($NtpData)

		# Close the connection
		$Socket.Close()

		<#
				Decode the received NTP time packet

				We now have the 64-bit NTP time in the last 8 bytes of the received data.
				The NTP time is the number of seconds since 1/1/1900 and is split into an
				integer part (top 32 bits) and a fractional part, multiplied by 2^32, in the
				bottom 32 bits.
		#>

		# Convert Integer and Fractional parts of 64-bit NTP time from byte array
		$IntPart = 0

		foreach ($Byte in $NtpData[40..43]) {
			$IntPart = ($IntPart * 256 + $Byte)
		}

		$FracPart = 0

		foreach ($Byte in $NtpData[44..47]) {
			$FracPart = ($FracPart * 256 + $Byte)
		}

		# Convert to Milliseconds (convert fractional part by dividing value by 2^32)
		[UInt64]$Milliseconds = $IntPart * 1000 + ($FracPart * 1000 / 0x100000000)

		# Create UTC date of 1 Jan 1900,
		# add the NTP offset and convert result to local time
		(New-Object -TypeName DateTime -ArgumentList (1900, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)).AddMilliseconds($Milliseconds).ToLocalTime()
	}
}

function Invoke-AppendClassPath {
	<#
			.SYNOPSIS
			Append a given path to the Class Path

			.DESCRIPTION
			Appends a given path to the Java Class Path.
			Useful if you still need that old Java crap!

			By the way: I hate Java!

			.EXAMPLE
			PS C:\> Invoke-AppendClassPath "."

			Description
			-----------
			Include the directory Where-Object you are to the Java Class Path

			.NOTES
			This is just a little helper function to make the shell more flexible

			.PARAMETER path
			Path to include in the Java Class Path

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param ()

	PROCESS {
		# Do we have a class path?
		if ([String]::IsNullOrEmpty($env:CLASSPATH)) {
			$env:CLASSPATH = ($args)
		} else {
			$env:CLASSPATH += ';' + $args
		}
	}
}

function Invoke-JavaLove {
	<#
			.SYNOPSIS
			Set the JAVAHOME Variable to use JDK and/or JRE instances withing the
			Session

			.DESCRIPTION
			You are still using Java Stuff?
			OK... Your choice, so we do you the favor and create/fill the
			variable JAVAHOME based on the JDK/JRE that we found.
			It also append the Info to the PATH variable to make things easier
			for you.
			But think about dropping the buggy Java crap as soon as you can.
			Java is not only buggy, there are also many Security issues with it!

			.EXAMPLE
			PS C:\> JavaLove

			Description
			-----------
			Find the installed JDK and/or JRE version and crate the JDK_HOME
			and JAVA_HOME variables for you.
			It also appends the Path to the PATH  and CLASSPATH variable to make
			it easier for you.

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param ()

	BEGIN {
		# Where-Object do we want to search for the Java crap?
		Set-Variable -Name baseloc -Value $("$env:ProgramFiles\Java\")
	}

	PROCESS {
		# Show Java a little love...
		# And I have no idea why I must do that!
		if ((Test-Path -Path $baseloc)) {
			# Include JDK if found
			Set-Variable -Name sdkdir -Value $(Resolve-Path -Path "$baseloc\jdk*")

			# Do we have a SDK?
			if (($sdkdir) -and (Test-Path -Path $sdkdir)) {
				# Set the enviroment
				$env:JDK_HOME = $sdkdir

				# Tweak the PATH
				append-path "$sdkdir\bin"
			}

			# Include JRE if found
			$jredir = (Resolve-Path -Path "$baseloc\jre*")

			# Do we have a JRE?
			if (($jredir) -and (Test-Path -Path $jredir)) {
				# Set the enviroment
				$env:JAVA_HOME = $jredir

				# Tweak the PATH
				append-path "$jredir\bin"
			}

			# Update the Classpath
			Invoke-AppendClassPath '.'
		}
	}
}

function Get-MaskedJson {
	<#
			.SYNOPSIS
			Masks all special characters within a JSON File

			.DESCRIPTION
			Masks all special characters within a JSON File.
			mostly used with C# or some other windows tools.

			.PARAMETER json
			Regular Formated JSON String or File

			.EXAMPLE
			PS C:\> Get-MaskedJson '{"name":"John", "Age":"21"}'
			{\"name\":\"John\", \"Age\":\"21\"}

			Description
			-----------
			Masks all special characters within a JSON File
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Regular Formated JSON String or File')]
		[String]$json
	)

	PROCESS {
		$json -replace '"', '\"'
	}
}

function Get-RegularJson {
	<#
			.SYNOPSIS
			Converts a C# dumped JSON to regular JSON

			.DESCRIPTION
			Converts a C# dumped JSON to regular JSON

			.PARAMETER csjson
			C# formated JSON (The one with mased characters)

			.EXAMPLE
			PS C:\> Get-RegularJson '{\"name\":\"John\", \"Age\":\"21\"}'
			{"name":"John", "Age":"21"}

			Description
			-----------
			Converts a C# dumped JSON to regular JSON
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'C# formated JSON (The one with mased characters)')]
		[String]$csjson
	)

	PROCESS {
		$csjson -replace '\\"', '"'
	}
}

function Invoke-PowerLL {
	<#
			.SYNOPSIS
			Quick helper to make my PowerShell a bit more like *nix

			.DESCRIPTION
			Everyone ever used a modern Unix and/or Linux system knows and love
			the colored output of LL

			This function is hack to emulate that on PowerShell.

			.PARAMETER dir
			Show the content of this Directory

			.PARAMETER all
			Show all files, included the hidden ones!

			.EXAMPLE
			PS C:\> Invoke-PowerLL

			Description
			-----------
			Quick helper to make my PowerShell a bit more like *nix

			.NOTES
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param
	(
		[Alias('Directory')]
		$dir = '.',
		[Alias('ShowAll')]
		$All = $False
	)

	BEGIN {
		# Define object
		Set-Variable -Name origFg -Value $($Host.UI.RawUI.ForegroundColor)
	}

	PROCESS {
		# What to do?
		if ($All) {
			Set-Variable -Name toList -Value $(Get-ChildItem -Force -Path $dir)
		} else {
			Set-Variable -Name toList -Value $(Get-ChildItem -Path $dir)
		}

		# Define the display colors for given extensions
		foreach ($item in $toList) {
			Switch ($item.Extension) {
				'.exe' { $Host.UI.RawUI.ForegroundColor = 'DarkYellow' }
				'.hta' { $Host.UI.RawUI.ForegroundColor = 'DarkYellow' }
				'.cmd' { $Host.UI.RawUI.ForegroundColor = 'DarkRed' }
				'.ps1' { $Host.UI.RawUI.ForegroundColor = 'DarkGreen' }
				'.html' { $Host.UI.RawUI.ForegroundColor = 'Cyan' }
				'.htm' { $Host.UI.RawUI.ForegroundColor = 'Cyan' }
				'.7z' { $Host.UI.RawUI.ForegroundColor = 'Magenta' }
				'.zip' { $Host.UI.RawUI.ForegroundColor = 'Magenta' }
				'.gz' { $Host.UI.RawUI.ForegroundColor = 'Magenta' }
				'.rar' { $Host.UI.RawUI.ForegroundColor = 'Magenta' }
				Default { $Host.UI.RawUI.ForegroundColor = $origFg }
			}

			# All directories a Dark Grey
			if ($item.Mode.StartsWith('d')) {
				$Host.UI.RawUI.ForegroundColor = 'DarkGray'
			}

			# Dump it
			$item
		}
	}

	END {
		$Host.UI.RawUI.ForegroundColor = $origFg
	}
}

function Invoke-ReloadPesterModule {
	<#
			.SYNOPSIS
			Load Pester Module

			.DESCRIPTION
			Load the Pester PowerShell Module to the Global context.
			Pester is a Mockup, Unit Test and Function Test Module for PowerShell

			.NOTES
			Pester Module must be installed

			.EXAMPLE
			PS C:\> Invoke-ReloadPesterModule

			Description
			-----------
			Unloads and load Pester PowerShell Module

			.LINK
			Pester: https://github.com/pester/Pester

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		# Lets check if the Pester PowerShell Module is installed
		if (Get-Module -ListAvailable -Name Pester -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) {
			try {
				#Make sure we remove the Pester Module (if loaded)
				Remove-Module -Name [P]ester -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

				# Import the Pester PowerShell Module in the Global context
				Import-Module -Name [P]ester -DisableNameChecking -Force -Scope Global -ErrorAction Stop -WarningAction SilentlyContinue
			} catch {
				# Sorry, Pester PowerShell Module is not here!!!
				Write-Error -Message 'Error: Pester Module was not imported...' -ErrorAction Stop

				# Still here? Make sure we are done!
				break
			}
		} else {
			# Sorry, Pester PowerShell Module is not here!!!
			Write-Warning  -Message 'Pester Module is not installed! Go to https://github.com/pester/Pester to get it!'
		}
	}
}

function Invoke-PowerHelp {
	<#
			.SYNOPSIS
			Wrapper of Get-Help

			.DESCRIPTION
			This wrapper uses Get-Help -full for a given cmdlet and shows
			everything paged. This is very much like the typical *nix like man

			.EXAMPLE
			PS C:\> man Get-item

			Description
			-----------
			Shows the complete help text of the cmdlet "Get-item", page by page

			.NOTES
			This is just a little helper function to make the shell more flexible

			.PARAMETER cmdlet
			command-let

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		# Cleanup the console
		[Console]::Clear()
		[Console]::SetWindowPosition(0,[Console]::CursorTop)
	}

	PROCESS {
		# get the Help for given command-let
		Get-Help -Name $args[0] -Full | Out-Host -Paging
	}
}

function Invoke-MakeDirectory {
	<#
			.SYNOPSIS
			Wrapper of New-Item

			.DESCRIPTION
			Wrapper of New-Item to create a directory

			.PARAMETER Directory
			Directory name to create

			.PARAMETER path
			Name of the directory that you would like to create

			.EXAMPLE
			PS C:\> mkdir test

			Description
			-----------
			Creates a directory with the name "test"

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Directory name to create')]
		[Alias('dir')]
		[String]$Directory
	)

	PROCESS {
		try {
			# Do it: Create the directory
			New-Item -ItemType directory -Force -Path $Directory -Confirm:$False -ErrorAction stop -WarningAction SilentlyContinue
		} catch {
			Write-Error -Message ('Sorry, we had a problem while we try to create {0}' -f $Directory)
		}
	}
}

function Update-SysInfo {
	<#
			.SYNOPSIS
			Update Information about the system

			.DESCRIPTION
			This function updates the informations about the systems it runs on

			.EXAMPLE
			PS C:\> Update-SysInfo

			Description
			-----------
			Update Information about the system, no output!

			.LINK
			Based on an idea found here: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues

	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		# Call Companion to Cleanup
		if ((Get-Command -Name Invoke-CleanSysInfo -ErrorAction SilentlyContinue)) {
			Invoke-CleanSysInfo
		}
	}

	PROCESS {
		# Fill Variables with values
		Set-Variable -Name Operating_System -Scope Global -Value $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property LastBootUpTime, TotalVisibleMemorySize, FreePhysicalMemory, Caption, Version, SystemDrive)
		Set-Variable -Name Processor -Scope Global -Value $(Get-CimInstance -ClassName Win32_Processor | Select-Object -Property Name, LoadPercentage)
		Set-Variable -Name Logical_Disk -Scope Global -Value $(Get-CimInstance -ClassName Win32_LogicalDisk |
			Where-Object -Property DeviceID -EQ -Value $($Operating_System.SystemDrive) |
		Select-Object -Property Size, FreeSpace)
		Set-Variable -Name Get_Date -Scope Global -Value $(Get-Date)
		Set-Variable -Name Get_Date_plus -Scope Global -Value $((Get-Date -Format 'yyyy-MM-dd') + ' ' + (Get-Date -Format 'HH:mm:ss'))
		Set-Variable -Name Get_OS_Name -Scope Global -Value $($Operating_System.Caption)
		Set-Variable -Name Get_Kernel_Info -Scope Global -Value $($Operating_System.Version)
		Set-Variable -Name Get_Uptime -Scope Global -Value $("$(($Get_Uptime = $Get_Date - $($Operating_System.LastBootUpTime)).Days) days, $($Get_Uptime.Hours) hours, $($Get_Uptime.Minutes) minutes")
		Set-Variable -Name Get_Shell_Info -Scope Global -Value $('{0}.{1}' -f $psversiontable.PSVersion.Major, $psversiontable.PSVersion.Minor)
		Set-Variable -Name Get_CPU_Info -Scope Global -Value $($Processor.Name -replace '\(C\)', '' -replace '\(R\)', '' -replace '\(TM\)', '' -replace 'CPU', '' -replace '\s+', ' ')
		Set-Variable -Name Get_Process_Count -Scope Global -Value $((Get-Process).Count)
		Set-Variable -Name Get_Current_Load -Scope Global -Value $($Processor.LoadPercentage)
		Set-Variable -Name Get_Memory_Size -Scope Global -Value $('{0}mb/{1}mb Used' -f (([math]::round($Operating_System.TotalVisibleMemorySize/1KB)) - ([math]::round($Operating_System.FreePhysicalMemory/1KB))), ([math]::round($Operating_System.TotalVisibleMemorySize/1KB)))
		Set-Variable -Name Get_Disk_Size -Scope Global -Value $('{0}gb/{1}gb Used' -f (([math]::round($Logical_Disk.Size/1GB)) - ([math]::round($Logical_Disk.FreeSpace/1GB))), ([math]::round($Logical_Disk.Size/1GB)))

		# Do we have the enaTEC Base Module?
		if ((Get-Command -Name Get-NETXCoreVer -ErrorAction SilentlyContinue)) {
			Set-Variable -Name MyPoSHver -Scope Global -Value $(Get-AitToolBoxVersion -s)
		} else {
			Set-Variable -Name MyPoSHver -Scope Global -Value $('Unknown')
		}

		# Are we Admin?
		if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
			Set-Variable -Name AmIAdmin -Scope Global -Value $('(User)')
		} else {
			Set-Variable -Name AmIAdmin -Scope Global -Value $('(Admin)')
		}

		# Is this a Virtual or a Real System?
		if ((Get-Command -Name Get-IsVirtual -ErrorAction SilentlyContinue)) {
			if ((Get-IsVirtual) -eq 'True') {
				Set-Variable -Name IsVirtual -Scope Global -Value $('(Virtual)')
			} else {
				Set-Variable -Name IsVirtual -Scope Global -Value $('(Real)')
			}
		} else {
			# No idea what to do without the command-let!
			Remove-Variable -Name IsVirtual -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}

		<#
				# This is the old way (Will be removed soon)
				if (Get-adminuser -ErrorAction SilentlyContinue) {
				if (Get-adminuser) {
				Set-Variable -Name AmIAdmin -Scope Global -Value $("(Admin)")
				} elseif (-not (Get-adminuser)) {
				Set-Variable -Name AmIAdmin -Scope Global -Value $("(User)")
				} else {
				Set-Variable -Name AmIAdmin -Scope Global -Value $("")
				}
				}
		#>

		# What CPU type do we have here?
		if ((Invoke-CheckSessionArch -ErrorAction SilentlyContinue)) {
			Set-Variable -Name CPUtype -Scope Global -Value $(Invoke-CheckSessionArch)
		}

		# Define object
		Set-Variable -Name MyPSMode -Scope Global -Value $($Host.Runspace.ApartmentState)
	}
}

function Invoke-CleanSysInfo {
	<#
			.SYNOPSIS
			Companion for Update-SysInfo

			.DESCRIPTION
			Cleanup for variables from the Update-SysInfo function

			.EXAMPLE
			PS C:\> Invoke-CleanSysInfo

			Description
			-----------
			Cleanup for variables from the Update-SysInfo function

			.NOTES

	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		# Cleanup old objects
		Remove-Variable -Name Operating_System -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Processor -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Logical_Disk -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_Date -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_Date_plus -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_OS_Name -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_Kernel_Info -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_Uptime -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_Shell_Info -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_CPU_Info -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_Process_Count -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_Current_Load -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_Memory_Size -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name Get_Disk_Size -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name MyPoSHver -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name AmIAdmin -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name CPUtype -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name MyPSMode -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name IsVirtual -Scope Global -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}
}

function Get-MOTD {
	<#
			.SYNOPSIS
			Displays system information to a host.

			.DESCRIPTION
			The Get-MOTD cmdlet is a system information tool written in PowerShell.

			.EXAMPLE
			PS C:\> Get-MOTD

			Description
			-----------
			Display the colorful Message of the Day with a Microsoft Logo and some
			system infos

			.NOTES
			inspired by this: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1

			The Microsoft Logo, PowerShell, Windows and some others are registered
			Trademarks by Microsoft Corporation.

			I do not own them, i just use them here :-)

			I moved some stuff in a separate function to make it reusable
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		# Update the Infos
		Update-SysInfo
	}

	PROCESS {
		# Write to the Console
		Write-Host -Object ('')
		Write-Host -Object ('')
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Red
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Green
		Write-Host -Object ('    Date/Time: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Date_plus)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Red
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Green
		Write-Host -Object ('         User: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0} {1}' -f ${env:UserName}, $AmIAdmin)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Red
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Green
		Write-Host -Object ('         Host: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $env:COMPUTERNAME)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Red
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Green
		Write-Host -Object ('           OS: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_OS_Name)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Red
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Green
		Write-Host -Object ('       Kernel: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ('NT ') -NoNewline -ForegroundColor Gray
		Write-Host -Object (('{0} - {1}' -f $Get_Kernel_Info, $CPUtype)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Red
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Green
		Write-Host -Object ('       Uptime: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Uptime)) -ForegroundColor Gray
		Write-Host -Object ('') -NoNewline
		Write-Host -Object ('                                  NETX PoSH: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0} ({1} - {2})' -f $MyPoSHver, $localDomain, $environment)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Blue
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Yellow
		Write-Host -Object ('        Shell: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('Powershell {0} - {1} Mode' -f $Get_Shell_Info, $MyPSMode)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Blue
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Yellow
		Write-Host -Object ('          CPU: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0} {1}' -f $Get_CPU_Info, $IsVirtual)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Blue
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Yellow
		Write-Host -Object ('    Processes: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Process_Count)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Blue
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Yellow
		Write-Host -Object ('         Load: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Current_Load)) -NoNewline -ForegroundColor Gray
		Write-Host -Object ('%') -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Blue
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Yellow
		Write-Host -Object ('       Memory: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Memory_Size)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Blue
		Write-Host -Object (' ███████████') -NoNewline -ForegroundColor Yellow
		Write-Host -Object ('         Disk: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Disk_Size)) -ForegroundColor Gray
		Write-Host -Object ('      ') -NoNewline
		Write-Host -Object ('')
		Write-Host -Object ('')
	}

	END {
		# Call Cleanup
		if ((Get-Command -Name Invoke-CleanSysInfo -ErrorAction SilentlyContinue)) {
			Invoke-CleanSysInfo
		}
	}
}

function Get-SysInfo {
	<#
			.SYNOPSIS
			Displays Information about the system

			.DESCRIPTION
			Displays Information about the system it is started on

			.EXAMPLE
			PS C:\> Get-SysInfo

			Description
			-----------
			Display some system infos

			.NOTES
			Based on an idea found here: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		# Update the Infos
		Update-SysInfo
	}

	PROCESS {
		# Write to the Console
		Write-Host -Object ('')
		Write-Host -Object ('  Date/Time: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Date_plus)) -ForegroundColor Gray
		Write-Host -Object ('  User:      ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0} {1}' -f ${env:UserName}, $AmIAdmin)) -ForegroundColor Gray
		Write-Host -Object ('  Host:      ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $env:COMPUTERNAME)) -ForegroundColor Gray
		Write-Host -Object ('  OS:        ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_OS_Name)) -ForegroundColor Gray
		Write-Host -Object ('  Kernel:    ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ('NT ') -NoNewline -ForegroundColor Gray
		Write-Host -Object (('{0} - {1}' -f $Get_Kernel_Info, $CPUtype)) -ForegroundColor Gray
		Write-Host -Object ('  Uptime:    ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Uptime)) -ForegroundColor Gray
		Write-Host -Object ('  NETX PoSH: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0} ({1} - {2})' -f $MyPoSHver, $localDomain, $environment)) -ForegroundColor Gray
		Write-Host -Object ('  Shell:     ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('Powershell {0} - {1} Mode' -f $Get_Shell_Info, $MyPSMode)) -ForegroundColor Gray
		Write-Host -Object ('  CPU:       ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0} {1}' -f $Get_CPU_Info, $IsVirtual)) -ForegroundColor Gray
		Write-Host -Object ('  Processes: ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Process_Count)) -ForegroundColor Gray
		Write-Host -Object ('  Load:      ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Current_Load)) -NoNewline -ForegroundColor Gray
		Write-Host -Object ('%') -ForegroundColor Gray
		Write-Host -Object ('  Memory:    ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Memory_Size)) -ForegroundColor Gray
		Write-Host -Object ('  Disk:      ') -NoNewline -ForegroundColor DarkGray
		Write-Host -Object (('{0}' -f $Get_Disk_Size)) -ForegroundColor Gray
		Write-Host -Object ('')
	}

	END {
		# Call Cleanup
		if ((Get-Command -Name Invoke-CleanSysInfo -ErrorAction SilentlyContinue)) {
			Invoke-CleanSysInfo
		}
	}
}

function Get-MyLS {
	<#
			.SYNOPSIS
			Wrapper for Get-ChildItem

			.DESCRIPTION
			This wrapper for Get-ChildItem shows all directories and files
			(even hidden ones)

			.PARAMETER loc
			A description of the loc parameter.

			.PARAMETER location
			This optional parameters is useful if you would like to see the
			content of another directory

			.EXAMPLE
			PS C:\> myls

			Description
			-----------
			Show the content of the directory Where-Object you are

			.EXAMPLE
			PS C:\> myls c:\

			Description
			-----------
			Show the content of "c:\"

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues

	#>

	[CmdletBinding()]
	param
	(
		[Alias('Location')]
		[String]$loc = '.'
	)

	PROCESS {
		# Execute GCI
		Get-ChildItem -Force -Attributes !a -Path "$loc"
		Get-ChildItem -Force -Attributes !d -Path "$loc"
	}
}

function New-BasicAuthHeader {
	<#
			.SYNOPSIS
			Create a basic authentication header for Web requests

			.DESCRIPTION
			Create a basic authentication header for Web requests, often used
			in Rest API Calls (Works perfect for Invoke-RestMethod calls)

			.PARAMETER user
			User name to use

			.PARAMETER password
			Password to use

			.EXAMPLE
			PS C:\> New-BasicAuthHeader -user 'apiuser' -password 'password'
			YXBpdXNlcjpwYXNzd29yZA==

			Description
			-----------
			Create a valid password and Auth header, perfect for REST Web Services

			.EXAMPLE
			PS C:\> Invoke-RestMethod -Uri 'https://service.contoso.com/api/auth' -Method 'Get' -Headers @{Authorization=("Basic {0}" -f (New-BasicAuthHeader 'apiuser' 'password'))}

			Description
			-----------
			Call the URI 'https://service.contoso.com/api/auth' with an basic
			authentication header for the given credentials.

			.NOTES
			Very basic for now!
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = 'User name to use')]
		[ValidateNotNullOrEmpty()]
		[String]$user,
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 2,
		HelpMessage = 'Password to use')]
		[ValidateNotNullOrEmpty()]
		[String]$password
	)

	BEGIN {
		# Cleanup
		$BasicAuthHeader = $null
	}

	PROCESS {
		if ($pscmdlet.ShouldProcess('BasicAuthHeader', 'Create')) {
			$BasicAuthHeader = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(('{0}:{1}' -f $user, $password)))
		}
	}

	END {
		if ($BasicAuthHeader) {
			Write-Output -InputObject $BasicAuthHeader
		}

		# Cleanup
		$BasicAuthHeader = $null
	}
}

function Find-String
{
	<#
			.Synopsis
			Searches text files by pattern and displays the results.

			.Description
			Searches text files by pattern and displays the results.

			.PARAMETER pattern
			A description of the pattern parameter.

			.PARAMETER include
			A description of the include parameter.

			.PARAMETER recurse
			A description of the recurse parameter.

			.PARAMETER caseSensitive
			A description of the caseSensitive parameter.

			.PARAMETER directoryExclude
			A description of the directoryExclude parameter.

			.PARAMETER context
			A description of the context parameter.

			.EXAMPLE
			PS C:\> Find-String

			Description
			-----------
			Searches text files by pattern and displays the results.

			.Notes
			TODO: Documentation

			.LINK
			Out-ColorMatchInfo

			.LINK
			http://weblogs.asp.net/whaggard/archive/2007/03/23/powershell-script-to-find-strings-and-highlight-them-in-the-output.aspx
			http://poshcode.org/426
	#>

	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')]
		[regex]$pattern,
		[string[]]$include = '*',
		[switch]$recurse = $True,
		[switch]$caseSensitive = $False,
		[string[]]$directoryExclude = 'x{999}',
		[int[]]$context = 0
	)

	BEGIN {
		if ((-not $caseSensitive) -and (-not $pattern.Options -match 'IgnoreCase')) {$pattern = New-Object -TypeName regex -ArgumentList $pattern.ToString(), @($pattern.Options, 'IgnoreCase')}
	}

	PROCESS {
		$allExclude = $directoryExclude -join '|'
		Get-ChildItem -Recurse:$recurse -Include:$include |
		Where-Object -FilterScript { $_.FullName -notmatch $allExclude } |
		Select-String -CaseSensitive:$caseSensitive -Pattern:$pattern -AllMatches -Context $context |
		Out-ColorMatchInfo
	}
}

function Enable-WinRM {
	<#
			.SYNOPSIS
			Enables Remote PowerShell

			.DESCRIPTION
			Enables Remote PowerShell on the local host

			.EXAMPLE
			PS C:\> Enable-WinRM

			Description
			-----------
			Enables Windows Remote (WinRM) on the local system

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param ()

	PROCESS {
		try {Enable-PSRemoting -Force -Confirm:$False} catch
		{
			Write-Error -Message 'Unable to enable PowerShell Remoting'
			break
		}

		try {
			Set-Item -Path wsman:\localhost\client\trustedhosts -Value * -Force -Confirm:$False
		} catch {
			Write-Error -Message 'Unable to set trusted hosts for PowerShell Remoting'
			break
		}

		try {Restart-Service -Name WinRM -Force} catch
		{
			Write-Error -Message 'Restart of WinRM service failed!'
			break
		}
	}
}

function Get-NewPsSession {
	<#
			.SYNOPSIS
			Create a session and the given credentials are used

			.DESCRIPTION
			Create a session and the given credentials are used

			.PARAMETER computerName
			Name of the System

			.PARAMETER PsCredentials
			Credentials to use

			.EXAMPLE
			PS C:\> Get-NewPsSession -ComputerName 'Raven' -PsCredentials $myCreds

			Description
			-----------
			Open a PowerShell Session to the System 'Raven' and use the
			credentials stored in the Variable '$myCreds'

			.EXAMPLE
			PS C:\> Get-NewPsSession -ComputerName 'Raven' -PsCredentials (Get-Credential)

			Description
			-----------
			Open a PowerShell Session to the System 'Raven' and ask for the
			credentials to use

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[ValidateNotNullOrEmpty()]
		[Alias('Computer')]
		$ComputerName = ($env:COMPUTERNAME),
		[ValidateNotNullOrEmpty()]
		$PsCredentials = ($Credentials)
	)

	PROCESS {
		New-PSSession -ComputerName $ComputerName -Credential $credencial
	}
}

function Set-CurrentSession {
	<#
			.SYNOPSIS
			Make the Session globally available

			.DESCRIPTION
			Make the Session globally available

			.PARAMETER session
			Session to use

			.EXAMPLE
			PS C:\> Set-CurrentSession -session $psSession

			Description
			-----------
			Make the Session in the variable '$psSession' globally available
			Might be useful if you open a session from within a script and want
			to use it after the script is finished!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,ValueFromPipeline,
		HelpMessage = 'Session to use')]
		$session
	)

	PROCESS {
		Set-Variable -Name 'remoteSession' -Scope Global -Value $($session)
	}
}

function Install-PsGet {
	<#
			.SYNOPSIS
			Install PsGet package management

			.DESCRIPTION
			Install PsGet package management

			.EXAMPLE
			PS C:\> Install-PsGet

			Description
			-----------
			Install the PsGet package management

			.NOTES
			Just a wrapper for the known installer command

			.LINK
			http://psget.net

			.LINK
			https://github.com/psget/psget
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param ()

	PROCESS {
		if ($pscmdlet.ShouldProcess('PsGet', 'Download and Install')) {
			if (-not (Get-Module -ListAvailable -Name PackageManagement)) {
				# Use the command provided via http://psget.net
				try {
					# I hate Invoke-Expression, by the way! Is there another way to do that???
					(New-Object -TypeName Net.WebClient).DownloadString('http://psget.net/GetPsGet.ps1') | Invoke-Expression
				} catch [System.Exception] {
					Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop

					# Capture any failure and display it in the error section
					# The Exit with Code 1 shows any calling App that there was something wrong
					exit 1
				} catch {
					Write-Error -Message 'Unable to install PsGet' -ErrorAction Stop

					# Still here? Make sure we are done!
					break
				}
			} else {
				Write-Output -InputObject 'PsGet Package Management is already installed!'
			}
		}
	}
}

function Enable-PSGallery {
	<#
			.SYNOPSIS
			Enables the PSGallery Repository

			.DESCRIPTION
			Enables the PSGallery Repository

			.EXAMPLE
			PS C:\> Enable-PSGallery

			Description
			-----------
			Enable the PSGallery as installation source.

			.NOTES
			The PSGallery is a great source for PowerShell Modules.
	#>

	[CmdletBinding(ConfirmImpact = 'None',
	SupportsShouldProcess)]
	param ()

	PROCESS {
		if ($pscmdlet.ShouldProcess('PSGallery', 'Enable Repository')) {
			try {
				if (-not (Get-PSRepository -Name PSGallery)) {
					Set-PSRepository -Name 'PSGallery' -SourceLocation 'https://www.powershellgallery.com/api/v2/' -InstallationPolicy 'Trusted'
				} else {
					Write-Output -InputObject 'PSGallery is already enabled'
				}
			} catch [System.Exception] {
				Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop

				# Capture any failure and display it in the error section
				# The Exit with Code 1 shows any calling App that there was something wrong
				exit 1
			} catch {
				Write-Error -Message 'Unable to enable the PSGallery Repository' -ErrorAction Stop

				# Still here? Make sure we are done!
				break
			}
		}
	}
}

function Update-AllPsGetModules {
	<#
			.SYNOPSIS
			Search for all installed PsGet Modules and updates them if needed

			.DESCRIPTION
			Search for all installed PsGet Modules and updates them if needed

			.PARAMETER force
			No confirm for the update needed

			.EXAMPLE
			PS C:\> Update-AllPsGetModules -force

			Description
			-----------
			Update all installed PsGet Modules without confirming anything!

			.EXAMPLE
			PS C:\> Update-AllPsGetModules

			Description
			-----------
			Update all installed PsGet Modules...

			.NOTES
			Inspired by Homebrew (OS X) command: brew update && brew upgrade
	#>

	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(Position = 1)]
		[switch]$Force
	)

	BEGIN {
		# Cleanup
		$InstalledPsGetModules = @()

		# Check for installed PsGet Modules
		$InstalledPsGetModules = @(Get-InstalledModule)
	}

	PROCESS {
		if ($pscmdlet.ShouldProcess('All installed PsGet Modules', 'Install available updates')) {
			# Loop over the List of Modules
			foreach ($InstalledPsGetModule in $InstalledPsGetModules) {
				# Be verbose
				Write-Verbose -Message ('Process {0}' -f ($InstalledPsGetModule).name)

				# Now we do the Update...
				try {
					if ($Force) {
						# OK, you want to install all available without confirmation
						Update-Module -Name ($InstalledPsGetModule).name -Confirm:$False -ErrorAction Stop -WarningAction SilentlyContinue
					} else {
						Update-Module -Name ($InstalledPsGetModule).name -ErrorAction Stop -WarningAction SilentlyContinue
					}
				} catch {
					Write-Warning -Message ('Update of {0} failed!!!' -f ($InstalledPsGetModule).name)
				}

				# Be verbose
				Write-Verbose -Message ('Process {0}' -f ($InstalledPsGetModule).name)
			}
		}
	}
}

function Send-Pushover {
	<#
			.SYNOPSIS
			Sends a push message via Pushover

			.DESCRIPTION
			We established a lot of automated messaging and push services,
			Pushover was missing!

			We do not use Pushover that much, but sometimes it is just nice to
			have the function ready...

			.EXAMPLE
			PS C:\> Send-Pushover -User "USERTOKEN" -token "APPTOKEN" -Message "Test"

			Description
			-----------
			Send the message "Test" to all your devices. The App Name is
			displayed a title of the push

			.EXAMPLE
			PS C:\> Send-Pushover -User "USERTOKEN" -token "APPTOKEN" -Message "Test" -device "Josh-iPadPro"

			Description
			-----------
			Send the message "Test" to the device with the name "Josh-iPadPro".
			The App Name is displayed a title of the push

			.EXAMPLE
			PS C:\> Send-Pushover -User "USERTOKEN" -token "APPTOKEN" -Message "Test" -title "Hello!" -sound "cosmic"

			Description
			-----------
			Send the message "Test" to all your devices. It will have the
			Title "Hello!" and use the notification sound "cosmic"

			.EXAMPLE
			PS C:\> Send-Pushover -User "USERTOKEN" -token "APPTOKEN" -Message "Nice URL for you" -title "Hello!" -url "http://enatec.io" -url_title "My Site"

			Description
			-----------
			Send the message "Nice URL for you" with the title "Hello!" to all
			your devices.
			The Push contains a link to "http://enatec.io" with the
			URL title "My Site"

			.PARAMETER User
			The user/group key (not e-mail address) of your user (or you),
			viewable when logged into our Pushover dashboard

			.PARAMETER Message
			Your message, can be HTML like formated

			.PARAMETER token
			Your Pushover application API token

			.PARAMETER device
			Your device name to send the message directly to that device,
			rather than all of the devices (multiple devices may be separated by
			a comma). You can use Get-PushoverUserDeviceInfo to get a list of
			all registered devices.

			.PARAMETER title
			Your message title, otherwise your app name is used

			.PARAMETER url
			A supplementary URL to show with your message

			.PARAMETER url_title
			A title for your supplementary URL, otherwise just the URL is shown

			.PARAMETER priority
			The Push priority (-2 to +2)

			.PARAMETER sound
			The name of one of the sounds supported by device clients to override
			the user's default sound choice

			.NOTES
			Based on our Send-SlackChat function

			.LINK
			Get-PushoverUserDeviceInfo

			.LINK
			Info: https://pushover.net

			.LINK
			API: https://pushover.net/api

			.LINK
			Send-SlackChat

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = 'The user/group key of your user, viewable when logged into our Pushover dashboard')]
		[ValidateNotNullOrEmpty()]
		[String]$user,
		[Parameter(Mandatory,
				Position = 1,
		HelpMessage = 'Your message, can be HTML like formated')]
		[ValidateNotNullOrEmpty()]
		[String]$Message,
		[Parameter(Mandatory,Position = 2,
		HelpMessage = 'Your Pushover application API token')]
		[ValidateNotNullOrEmpty()]
		[String]$token,
		[Parameter(Mandatory,HelpMessage = 'Your device name to send the message directly to that device, rather than all of the devices')]
		$device,
		[Parameter(Mandatory,HelpMessage = 'Your message title, otherwise your app name is used')]
		$title,
		[Parameter(Mandatory,HelpMessage = 'A supplementary URL to show with your message')]
		$url,
		[Parameter(Mandatory,HelpMessage = 'A title for your supplementary URL, otherwise just the URL is shown')]
		$url_title,
		[ValidateSet('-2', '-1', '0', '1', '2')]
		$priority = '0',
		[ValidateSet('pushover', 'bike', 'bugle', 'cashregister', 'classical', 'cosmic', 'falling', 'gamelan', 'incoming', 'intermission', 'magic', 'mechanical', 'pianobar', 'siren', 'spacealarm', 'tugboat', 'alien', 'climb', 'persistent', 'echo', 'updown', 'none')]
		$sound = 'pushover'
	)

	BEGIN {
		# Cleanup all variables...
		Remove-Variable -Name 'uri' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'body' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'myBody' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'myMethod' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		Set-Variable -Name 'uri' -Value $('https://api.pushover.net/1/messages.json')

		# Build the body as per https://pushover.net/faq#library
		# We convert this to JSON then...
		Set-Variable -Name 'body' -Value $(@{
				token   = $token
				user    = $user
				message = $Message
		})

		# Sent a push to a special Device? Could be a list separated by comma
		if ($device) {
			$TmpBody = @{
				device = $device
			}
			$body = $body + $TmpBody
			$TmpBody = $null
		}

		# Want a Title for this Push?
		if ($title) {
			$TmpBody = @{
				title = $title
			}
			$body = $body + $TmpBody
			$TmpBody = $null
		}

		# Attach a URL to the push?
		if ($url) {
			# Encode the URL if possible
			if ((Get-Command -Name ConvertTo-UrlEncoded -ErrorAction SilentlyContinue)) {
				try {$url = (ConvertTo-UrlEncoded -InputObject $url)} catch {
					# Argh! Use a unencoded URL
					$UrlEncoded = ($url)
				}
			} else {
				# Use a unencoded URL
				$UrlEncoded = ($url)
			}
			$TmpBody = @{
				url = $UrlEncoded
			}
			$body = $body + $TmpBody
			$TmpBody = $null
		}

		# Give the URL a nice title. Just URLs suck!
		if ($url_title) {
			$TmpBody = @{
				url_title = $url_title
			}
			$body = $body + $TmpBody
			$TmpBody = $null
		}

		# Set a Priotity for this push
		if ($priority) {
			$TmpBody = @{
				priority = $priority
			}
			$body = $body + $TmpBody
			$TmpBody = $null
		}

		# Special Sound?
		if ($sound) {
			$TmpBody = @{
				sound = $sound
			}
			$body = $body + $TmpBody
			$TmpBody = $null
		}

		# Convert the Body Variable to JSON Check if the Server understands Compression,
		# could reduce bandwidth Be careful with the Depth Parameter, bigger values means less performance
		Set-Variable -Name 'myBody' -Value $(ConvertTo-Json -InputObject $body -Depth 2 -Compress:$False)

		# Method to use for the RESTful Call
		Set-Variable -Name 'myMethod' -Value $('POST' -as ([String] -as [type]))

		# Use the API via RESTful call
		try {(Invoke-RestMethod -Uri $uri -Method $myMethod -Body $body -UserAgent "Mozilla/5.0 (Windows NT; Windows NT 6.1; en-US) enaTEC WindowsPowerShell Service $CoreVersion" -ErrorAction Stop -WarningAction SilentlyContinue)} catch [System.Exception] {
			<#
					Argh!
					That was an Exception...
			#>

			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
		} catch {
			# Whoopsie!
			# That should not happen...
			Write-Warning -Message ('Could not send notification to your Slack {0}' -f $user)
		} finally {
			# Cleanup all variables...
			Remove-Variable -Name 'uri' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'body' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'myBody' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'myMethod' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}
}

function Get-PushoverUserDeviceInfo {
	<#
			.SYNOPSIS
			Retrieves a list of registered devices with Pushover

			.DESCRIPTION
			Perfect in combination with the Send-Pushover command to send a
			notification using the "device" parameter of Send-Pushover

			.PARAMETER User
			The user/group key (not e-mail address) of your user (or you),
			viewable when logged into our Pushover dashboard

			.PARAMETER token
			Your Pushover application API token

			.EXAMPLE
			PS C:\> Get-PushoverUserDeviceInfo -User "John" -token "APPTOKEN"

			John-Mac
			John-iPadMini
			John-iPhone5S
			John-S5

			Description
			-----------
			Get all Devices for User 'John'

			.LINK
			Send-Pushover

			.LINK
			Info: https://pushover.net

			.LINK
			API: https://pushover.net/api

			.LINK
			Send-SlackChat

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues

	#>
	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = 'The user/group key of your user, viewable when logged into our Pushover dashboard')]
		[ValidateNotNullOrEmpty()]
		[String]$user,
		[Parameter(Mandatory,Position = 2,
		HelpMessage = 'Your Pushover application API token')]
		[ValidateNotNullOrEmpty()]
		[String]$token
	)

	BEGIN {
		# Cleanup all variables...
		Remove-Variable -Name 'uri' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'body' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'myBody' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'myMethod' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		Set-Variable -Name 'uri' -Value $('https://api.pushover.net/1/users/validate.json')

		# Build the body as per https://pushover.net/faq#library
		# We convert this to JSON then...
		Set-Variable -Name 'body' -Value $(@{
				token = $token
				user  = $user
		})

		# Convert the Body Variable to JSON Check if the Server understands Compression,
		# could reduce bandwidth Be careful with the Depth Parameter, bigger values means less performance
		Set-Variable -Name 'myBody' -Value $(ConvertTo-Json -InputObject $body -Depth 2 -Compress:$False)

		# Method to use for the RESTful Call
		Set-Variable -Name 'myMethod' -Value $('POST' -as ([String] -as [type]))

		# Use the API via RESTful call
		try {$PushoverUserDeviceInfo = (Invoke-RestMethod -Uri $uri -Method $myMethod -Body $body -UserAgent "Mozilla/5.0 (Windows NT; Windows NT 6.1; en-US) enaTEC WindowsPowerShell Service $CoreVersion" -ErrorAction Stop -WarningAction SilentlyContinue)} catch [System.Exception] {
			<#
					Argh!

					That was an Exception...
			#>

			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
		} catch {
			# Whoopsie!
			# That should not happen...
			Write-Warning -Message ('Could not send notification to your Slack {0}' -f $user)
		} finally {
			# Cleanup all variables...
			Remove-Variable -Name 'uri' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'body' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'myBody' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'myMethod' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}

	END {
		Return ($PushoverUserDeviceInfo.devices)
	}
}

function Invoke-RDPSession {
	<#
			.SYNOPSIS
			Wrapper for the Windows RDP Client

			.DESCRIPTION
			Just a wrapper for the Windows Remote Desktop Protocol (RDP) Client.

			.PARAMETER Server
			The Host could be a host name or an IP address

			.PARAMETER Port
			The RDP Port to use

			.EXAMPLE
			PS C:\> Invoke-RDPSession SNOOPY

			Description
			-----------
			Opens a Remote Desktop Session to the system with the Name SNOOPY

			.EXAMPLE
			PS C:\> Invoke-RDPSession -Server "deepblue.fra01.kreativsign.net"

			Description
			-----------
			Opens a Remote Desktop Session to the system
			"deepblue.fra01.kreativsign.net"

			.EXAMPLE
			PS C:\> Invoke-RDPSession -host '10.10.16.10'

			Description
			-----------
			Opens a Remote Desktop Session to the system with the IPv4
			address 10.10.16.10

			.NOTES
			We use the follwing defaults: /admin /w:1024 /h:768
			Change this within the script if you like other defaults.
			A future version might provide more parameters

			The default Port is 3389.
			You might want to change that via the commandline parameter

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
				Position = 1,
		HelpMessage = 'The Host could be a host name or an IP address')]
		[ValidateNotNullOrEmpty()]
		[Alias('RDPHost')]
		[String]$Server,
		[Parameter(Position = 2)]
		[Alias('RDPPort')]
		[int]$Port = 3389
	)

	BEGIN {
		# Test RemoteDesktop Connection is valid or not
		try {
			$TestRemoteDesktop = New-Object -TypeName System.Net.Sockets.TCPClient -ArgumentList $Server, $Port
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop

			# Capture any failure and display it in the error section
			# The Exit with Code 1 shows any calling App that there was something wrong
			exit 1
		} catch {
			# Did not see this one coming!
			Write-Error -Message ('Sorry, but {0} did not answer on port {1}' -f $Server, $Port) -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}
	}

	PROCESS {
		# What do we have?
		if (-not ($Server)) {
			Write-Error -Message 'Mandatory Parameter HOST is missing' -ErrorAction Stop
		} else {
			if ($TestRemoteDesktop) {
				$RDPHost2Connect = ($Server + ':' + $Port)
				Start-Process -FilePath mstsc -ArgumentList "/admin /w:1024 /h:768 /v:$RDPHost2Connect"
			} else {
				# Did not see this one coming!
				Write-Error -Message ('Sorry, but {0} did not answer on port {1}' -f $Server, $Port) -ErrorAction Stop

				# Still here? Make sure we are done!
				break
			}
		}
	}
}

function Get-DefaultMessage {
	<#
			.SYNOPSIS
			Helper Function to show default message used in VERBOSE/DEBUG/WARNING

			.DESCRIPTION
			Helper Function to show default message used in VERBOSE/DEBUG/WARNING
			and... HOST in some case.
			This is helpful to standardize the output messages

			.PARAMETER Message
			Specifies the message to show

			.EXAMPLE
			PS C:\> Get-DefaultMessage -Message "Test"
			[2016.04.04-23:53:26:61][] Test

			Description
			-----------
			Display the given message with a Time-Stamp

			.EXAMPLE
			PS C:\> .\dummy.ps1
			[2016.04.04-23:53:26:61][dummy.ps1] Test

			Description
			-----------
			Use the function from within another script
			The following code is used in "dummy.ps1"
			Get-DefaultMessage -Message "Test"

			.NOTES
			Based on an ideas of Francois-Xavier Cat

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,HelpMessage = 'Specifies the message to show')]
		[String]$Message
	)

	PROCESS {
		# Set the Variables
		Set-Variable -Name 'DateFormat' -Scope Script -Value $(Get-Date -Format 'yyyy/MM/dd-HH:mm:ss:ff')
		Set-Variable -Name 'FunctionName' -Scope Script -Value $((Get-Variable -Scope 1 -Name MyInvocation -ValueOnly).MyCommand.Name)

		# Dump to the console
		Write-Output -InputObject ('[{0}][{1}] {2}' -f $DateFormat, $functionName, $Message)
	}
}

function Disable-RemoteDesktop {
	<#
			.SYNOPSIS
			The function Disable-RemoteDesktop will disable RemoteDesktop on a
			local or remote machine.

			.DESCRIPTION
			The function Disable-RemoteDesktop will disable RemoteDesktop on a
			local or remote machine.

			.PARAMETER ComputerName
			Specifies the computername

			.PARAMETER Credentials
			Specifies the Credentials to use

			.PARAMETER CimSession
			Specifies one or more existing CIM Session(s) to use

			.EXAMPLE
			PS C:\> Disable-RemoteDesktop -ComputerName 'DC01'

			Description
			-----------
			Disable RDP on Server 'DC01'

			.EXAMPLE
			PS C:\> Disable-RemoteDesktop -ComputerName DC01 -Credentials (Get-Credentials -cred "FX\SuperAdmin")

			Description
			-----------
			Disable RDP on Server 'DC01' and use the Domain (FX) Credentials
			for 'SuperAdmin', The password will be queried.

			.EXAMPLE
			PS C:\> Disable-RemoteDesktop -CimSession $Session

			Description
			-----------
			Disable RDP for the host where the CIM Session '$Session' is open.

			.EXAMPLE
			PS C:\> Disable-RemoteDesktop -CimSession $Session1,$session2,$session3

			Description
			-----------
			Disable RDP for the host where the CIM Sessions
			'$Session1,$session2,$session3' are open.

			.NOTES
			Based on an idea of Francois-Xavier Cat
	#>

	[CmdletBinding(DefaultParameterSetName = 'CimSession',
			ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param
	(
		[Parameter(ParameterSetName = 'Main',
				ValueFromPipeline,
		ValueFromPipelineByPropertyName)]
		[Alias('CN', '__SERVER', 'PSComputerName')]
		[String[]]$ComputerName = "$env:COMPUTERNAME",
		[Parameter(ParameterSetName = 'Main')]
		[System.Management.Automation.Credential()]
		[Alias('RunAs')]
		[PSCredential]$Credentials = '[System.Management.Automation.PSCredential]::Empty',
		[Parameter(Mandatory,ParameterSetName = 'CimSession',
		HelpMessage = 'Specifies one or more existing CIM Session(s) to use')]
		[Microsoft.Management.Infrastructure.CimSession[]]$CimSession
	)

	PROCESS {
		if ($PSBoundParameters['CimSession']) {
			foreach ($Cim in $CimSession) {
				$CIMComputer = $($Cim.ComputerName).ToUpper()

				try {
					# Parameters for Get-CimInstance
					$CIMSplatting = @{
						Class         = 'Win32_TerminalServiceSetting'
						NameSpace     = 'root\cimv2\terminalservices'
						CimSession    = $Cim
						ErrorAction   = 'Stop'
						ErrorVariable = 'ErrorProcessGetCimInstance'
					}

					# Parameters for Invoke-CimMethod
					$CIMInvokeSplatting = @{
						MethodName    = 'SetAllowTSConnections'
						Arguments     = @{
							AllowTSConnections      = 0
							ModifyFirewallException = 0
						}
						ErrorAction   = 'Stop'
						ErrorVariable = 'ErrorProcessInvokeCim'
					}

					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - disable Remote Desktop (and Modify Firewall Exception")

					Get-CimInstance @CIMSplatting | Invoke-CimMethod @CIMInvokeSplatting
				} catch {
					Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Something wrong happened")

					if ($ErrorProcessGetCimInstance) { Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Get-CimInstance") }
					if ($ErrorProcessInvokeCim) { Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Invoke-CimMethod") }

					Write-Warning -Message $Error[0].Exception.Message
				} finally {
					$CIMSplatting.Clear()
					$CIMInvokeSplatting.Clear()
				}
			}
		}

		foreach ($Computer in $ComputerName) {
			# Set a variable with the computername all upper case
			Set-Variable -Name 'Computer' -Value $($Computer.ToUpper())

			try {
				# Be verbose
				Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Test-Connection")

				if (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {
					$Splatting = @{
						Class         = 'Win32_TerminalServiceSetting'
						NameSpace     = 'root\cimv2\terminalservices'
						ComputerName  = $Computer
						ErrorAction   = 'Stop'
						ErrorVariable = 'ErrorProcessGetWmi'
					}

					if ($PSBoundParameters['Credentials']) {$Splatting.credential = $Credentials}

					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Get-WmiObject - disable Remote Desktop")

					# disable Remote Desktop
					$null = (Get-WmiObject @Splatting).SetAllowTsConnections(0, 0)

					# Disable requirement that user must be authenticated
					#(Get-WmiObject -Class Win32_TSGeneralSetting @Splatting -Filter TerminalName='RDP-tcp').SetUserAuthenticationRequired(0)  Out-Null
				}
			} catch {
				Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Something wrong happened")

				if ($ErrorProcessGetWmi) { Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Issue with Get-WmiObject") }

				Write-Warning -Message $Error[0].Exception.Message
			} finally {$Splatting.Clear()}
		}
	}
}

function Enable-RemoteDesktop {
	<#
			.SYNOPSIS
			The function Enable-RemoteDesktop will enable RemoteDesktop on a
			local or remote machine.

			.DESCRIPTION
			The function Enable-RemoteDesktop will enable RemoteDesktop on a
			local or remote machine.

			.PARAMETER ComputerName
			Specifies the computername

			.PARAMETER Credentials
			Specifies the Credentials to use

			.PARAMETER CimSession
			Specifies one or more existing CIM Session(s) to use

			.EXAMPLE
			PS C:\> Enable-RemoteDesktop -ComputerName 'DC01'

			Description
			-----------
			Enables RDP on 'DC01'

			.EXAMPLE
			PS C:\> Enable-RemoteDesktop -ComputerName DC01 -Credentials (Get-Credentials -cred "FX\SuperAdmin")

			Description
			-----------
			Enables RDP on 'DC01' and use the Domain (FX) Credentials for
			'SuperAdmin', The password will be queried.

			.EXAMPLE
			PS C:\> Enable-RemoteDesktop -CimSession $Session

			Description
			-----------
			Enable RDP for the host where the CIM Session '$Session' is open.

			.EXAMPLE
			PS C:\> Enable-RemoteDesktop -CimSession $Session1,$session2,$session3

			Description
			-----------
			Enable RDP for the host where the CIM Sessions
			'$Session1,$session2,$session3' are open.

			.NOTES
			Based on an idea of Francois-Xavier Cat
	#>

	[CmdletBinding(DefaultParameterSetName = 'CimSession',
			ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param
	(
		[Parameter(ParameterSetName = 'Main',
				ValueFromPipeline,
		ValueFromPipelineByPropertyName)]
		[Alias('CN', '__SERVER', 'PSComputerName')]
		[String[]]$ComputerName = "$env:COMPUTERNAME",
		[Parameter(ParameterSetName = 'Main')]
		[System.Management.Automation.Credential()]
		[Alias('RunAs')]
		[pscredential]$Credentials = '[System.Management.Automation.PSCredential]::Empty',
		[Parameter(Mandatory,ParameterSetName = 'CimSession',
		HelpMessage = 'Specifies one or more existing CIM Session(s) to use')]
		[Microsoft.Management.Infrastructure.CimSession[]]$CimSession
	)

	PROCESS {
		if ($PSBoundParameters['CimSession']) {
			foreach ($Cim in $CimSession) {
				# Create a Variable with an all upper case computer name
				Set-Variable -Name 'CIMComputer' -Value $($($Cim.ComputerName).ToUpper())

				try {
					# Parameters for Get-CimInstance
					$CIMSplatting = @{
						Class         = 'Win32_TerminalServiceSetting'
						NameSpace     = 'root\cimv2\terminalservices'
						CimSession    = $Cim
						ErrorAction   = 'Stop'
						ErrorVariable = 'ErrorProcessGetCimInstance'
					}

					# Parameters for Invoke-CimMethod
					$CIMInvokeSplatting = @{
						MethodName    = 'SetAllowTSConnections'
						Arguments     = @{
							AllowTSConnections      = 1
							ModifyFirewallException = 1
						}
						ErrorAction   = 'Stop'
						ErrorVariable = 'ErrorProcessInvokeCim'
					}

					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Enable Remote Desktop (and Modify Firewall Exception")

					#
					Get-CimInstance @CIMSplatting | Invoke-CimMethod @CIMInvokeSplatting
				} CATCH {
					# Whoopsie!
					Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Something wrong happened")

					if ($ErrorProcessGetCimInstance) { Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Get-CimInstance") }

					if ($ErrorProcessInvokeCim) { Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Invoke-CimMethod") }

					Write-Warning -Message $Error[0].Exception.Message
				} FINALLY {
					# Cleanup
					$CIMSplatting.Clear()
					$CIMInvokeSplatting.Clear()
				}
			}
		}

		foreach ($Computer in $ComputerName) {
			# Creatre a Variable with the all upper case Computername
			Set-Variable -Name 'Computer' -Value $($Computer.ToUpper())

			try {
				Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Test-Connection")
				if (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {
					$Splatting = @{
						Class         = 'Win32_TerminalServiceSetting'
						NameSpace     = 'root\cimv2\terminalservices'
						ComputerName  = $Computer
						ErrorAction   = 'Stop'
						ErrorVariable = 'ErrorProcessGetWmi'
					}

					if ($PSBoundParameters['Credentials']) {$Splatting.credential = $Credentials}

					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Get-WmiObject - Enable Remote Desktop")

					# Enable Remote Desktop
					$null = (Get-WmiObject @Splatting).SetAllowTsConnections(1, 1)

					# Disable requirement that user must be authenticated
					#(Get-WmiObject -Class Win32_TSGeneralSetting @Splatting -Filter TerminalName='RDP-tcp').SetUserAuthenticationRequired(0)  Out-Null
				}
			} catch {
				# Whoopsie!
				Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Something wrong happened")

				if ($ErrorProcessGetWmi) { Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Issue with Get-WmiObject") }

				Write-Warning -Message $Error[0].Exception.Message
			} finally {
				# Cleanup
				$Splatting.Clear()
			}
		}
	}
}

function Invoke-ReloadModule {
	<#
			.SYNOPSIS
			Reloads one, or more, PowerShell Module(s)

			.DESCRIPTION
			This function forces an unload and then load the given PowerShell
			Module again.

			There is no build-in Re-Load function in PowerShell, at least yet!

			If you want to reload more then one Module at the time,
			just separate them by comma (Usual in PowerShell for multiple-values)

			.PARAMETER Module
			Name one, or more, PowerShell Module(s) to reload

			.EXAMPLE
			PS C:\> Invoke-ReloadModule -Module 'enatec.opensource'

			Description
			-----------
			Reloads the module 'enatec.opensource'

			.EXAMPLE
			PS C:\> Reload-Module -Module 'enatec.opensource', 'enatec.ActiveDirectory'

			Description
			-----------
			Reloads the module 'enatec.opensource' and 'enatec.ActiveDirectory'

			.NOTES
			Needs to be documented

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = 'Name of the Module to reload')]
		[ValidateNotNullOrEmpty()]
		[Alias('ModuleName')]
		[String[]]$Module
	)

	PROCESS {
		foreach ($SingleModule in $Module) {
			#Check if the Module is loaded
			if (((Get-Module -Name $SingleModule -All | Measure-Object).count) -gt 0) {
				# Unload the Module
				(Remove-Module -Name $SingleModule -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1

				# Make sure it is unloaded!
				(Remove-Module -Name $SingleModule -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
			} else {
				Write-Warning -Message ('The Module {0} was not loaded...' -f $SingleModule)
			}

			if (((Get-Module -Name $SingleModule -ListAvailable | Measure-Object).count) -gt 0) {
				# Load the module
				try {
					(Import-Module -Name $SingleModule -DisableNameChecking -Force -Verbose:$False -ErrorAction Stop -WarningAction SilentlyContinue)
				} catch {
					Write-Warning -Message ('Unable to load {0}' -f $SingleModule)
				}
			} else {
				Write-Warning -Message ('Sorry, the Module {0} was not found!' -f $SingleModule)
			}
		}
	}
}

function Remove-ItemSafely {
	<#
			.SYNOPSIS
			Deletes files and folders into the Recycle Bin

			.DESCRIPTION
			Deletes the file or folder as if it had been done via File Explorer.

			.PARAMETER Path
			The path to the file/files or folder/folders

			.PARAMETER DeletePermanently
			Bypasses the recycle bin, deleting the file or folder permanently

			.NOTES
			Early Beta Version

			.EXAMPLE
			PS C:\> Remove-ItemSafely -Path 'C:\scripts\PowerShell\test.ps1'

			Description
			-----------
			Deletes file 'C:\scripts\PowerShell\test.ps1' into the Recycle Bin

			.EXAMPLE
			PS C:\> Remove-ItemSafely -Path 'C:\scripts\PowerShell\test.ps1' -DeletePermanently

			Description
			-----------
			Deletes file 'C:\scripts\PowerShell\test.ps1' and skip the Recycle Bin

			.LINK
			Based on http://stackoverflow.com/a/502034/2688

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'The path to the file or folder')]
		[String[]]$Path,
		[switch]$DeletePermanently
	)

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		foreach ($SingleItem in $Path) {
			try {
				if ($DeletePermanently) {
					try {
						# Bypasses the recycle bin, deleting the file or folder permanently
						(Remove-Item -Path:$SingleItem -Force)
					} catch {
						Write-Warning -Message ('Unable to Delete {0}, please check!' -f $SingleItem)
					}

					# Done!
					return
				}

				# Soft Delete
				$item = (Get-Item -Path $SingleItem)
				$directoryPath = (Split-Path -Path $item -Parent)
				$shell = (New-Object -ComObject 'Shell.Application')
				$shellFolder = ($shell.Namespace($directoryPath))
				$shellItem = ($shellFolder.ParseName($item.Name))
				$shellItem.InvokeVerb('delete')
			} catch {
				Write-Warning -Message ('Unable to Delete {0}, please check!' -f $SingleItem)
			}
		}
	}
}

function Remove-TempFiles {
	<#
			.SYNOPSIS
			Removes all temp files older then a given time period

			.DESCRIPTION
			Removes all temp files older then a given time period from the system or the user environment.

			.PARAMETER Month
			Remove temp files older then X month.
			The default is 1

			.PARAMETER Context
			Remove the System or User Temp Files?
			The default is All.

			.EXAMPLE
			PS C:\> Remove-TempFiles -Confirm:$False

			TotalSize                     Retrieved                   TotalSizeMB                   RetrievedMB
			---------                     ---------                   -----------                   -----------
			518485778                     417617315                         494,5                         398,3

			Description
			-----------
			Removes all 'User' and 'System' temp file older then one month,
			without asking if you are sure! This could be dangerous...

			.EXAMPLE
			PS C:\> Remove-TempFiles -Confirm:$False
			WARNING: The process cannot access the file 'C:\Users\josh\AppData\Local\Temp\FXSAPIDebugLogFile.txt' because it is being used by another process. - Line Number: 96

			TotalSize                       Retrieved                     TotalSizeMB                     RetrievedMB
			---------                       ---------                     -----------                     -----------
			264147489                       214105710                           251,9                           204,2

			Description
			-----------
			Removes all 'User' and 'System' temp file older then one month,
			without asking if you are sure! This could be dangerous...

			One file is locked by another process! Just a warning will show up,
			the cleanup will continue.

			.EXAMPLE
			PS C:\> Remove-TempFiles -Month 3 -Context 'System'
			[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y")

			TotalSize                       Retrieved                     TotalSizeMB                     RetrievedMB
			---------                       ---------                     -----------                     -----------
			264147489                       214105710                           251,9                           204,2

			Description
			-----------
			Removes all 'System' temp files older then 3 month

			.EXAMPLE
			PS C:\> Remove-TempFiles -Month 3 -Context 'User'
			[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y")

			TotalSize                       Retrieved                     TotalSizeMB                     RetrievedMB
			---------                       ---------                     -----------                     -----------
			151519609                       145693231                           144,5                           138,9

			Description
			-----------
			Removes all 'User' temp files older then 3 month.

			.NOTES
			Adopted from a snippet found on Powershell.com

			.LINK
			Source http://powershell.com/cs/blogs/tips/archive/2016/05/27/cleaning-week-deleting-temp-files.aspx
	#>

	[CmdletBinding(ConfirmImpact = 'High',
	SupportsShouldProcess)]
	[OutputType([Management.Automation.PSCustomObject])]
	param
	(
		[Parameter(Position = 1)]
		[long]$Month = 1,
		[Parameter(ValueFromPipeline,
		Position = 2)]
		[ValidateSet('System', 'User', 'All', IgnoreCase = $True)]
		[String]$context = 'All'
	)

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}

		# Look at temp files older than given period
		$cutoff = ((Get-Date).AddMonths(- $Month))

		# Use an ordered hash table to store logging info
		$sizes = [Ordered]@{ }
	}

	PROCESS {
		if ($context -eq 'System') {$Target = "$env:windir\temp"} elseif ($context -eq 'User') {$Target = "$env:temp"} elseif ($context -eq 'All') {$Target = "$env:windir\temp", $env:temp} else {
			Write-Error -Message ('I have no idea what to clean: {0}' -f ($Target)) -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}

		if ($pscmdlet.ShouldProcess("$($context)", "Remove Temp file older then $($Month)")) {
			<#
					Mind the Pipes. All in a very long command :-)
			#>
			# Find all files in both temp folders recursively
			Get-ChildItem -Path $Target -Recurse -Force -File |
			# calculate total size before cleanup
			ForEach-Object -Process {
				$sizes['TotalSize'] += $_.Length
				$_
			} |
			# take only outdated files
			Where-Object -FilterScript { $_.LastWriteTime -lt $cutoff } |
			# Try to delete. Add retrieved file size only if the file could be deleted
			ForEach-Object -Process {
				try {
					$fileSize = ($_.Length)

					Remove-Item -Path $_.FullName -Force -Confirm:$False -ErrorAction Stop -WarningAction SilentlyContinue

					$sizes['Retrieved'] += $fileSize
				} catch [System.Exception] {
					Write-Warning -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
				} catch {
					# Did not see this one coming!
					Write-Warning -Message ('Unable to remove {0}' -f $_.FullName)
				}
			}
		}
	}

	END {
		# Turn bytes into MB
		$sizes['TotalSizeMB'] = [Math]::Round(($sizes['TotalSize']/1MB), 1)
		$sizes['RetrievedMB'] = [Math]::Round(($sizes['Retrieved']/1MB), 1)

		# Dump the info
		New-Object -TypeName PSObject -Property $sizes
	}
}

function Repair-DotNetFrameWorks {
	<#
			.SYNOPSIS
			Optimize all installed NET Frameworks

			.DESCRIPTION
			Optimize all installed NET Frameworks by executing NGEN.EXE for each.

			This could be useful to improve the performance and sometimes the
			installation of new NET Frameworks, or even patches, makes them use
			a single (the first) core only.

			Why Microsoft does not execute the NGEN.EXE with each installation...

			no idea!

			.EXAMPLE
			PS C:\> Repair-DotNetFrameWorks
			C:\Windows\Microsoft.NET\Framework\v4.0.30319\ngen.exe executeQueuedItems
			C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ngen.exe executeQueuedItems

			Description
			-----------
			Optimize all installed NET Frameworks

			.NOTES
			The Function name is changed!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}

		# Cleanup
		Remove-Variable -Name frameworks -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		# Get all NET framework paths and build an array with it
		$frameworks = @("$env:SystemRoot\Microsoft.NET\Framework")

		# If we run on an 64Bit system (what we should), we add these frameworks to
		if (Test-Path -Path "$env:SystemRoot\Microsoft.NET\Framework64") {
			# Add the 64Bit Path to the array
			$frameworks += "$env:SystemRoot\Microsoft.NET\Framework64"
		}

		# Loop over all NET frameworks that we found.
		ForEach ($framework in $frameworks) {
			# Find the latest version of NGEN.EXE in the current framework path
			$ngen_path = Join-Path -Path (Join-Path -Path $framework -ChildPath (Get-ChildItem -Path $framework |
					Where-Object -FilterScript { ($_.PSIsContainer) -and (Test-Path -Path (Join-Path -Path $_.FullName -ChildPath 'ngen.exe')) } |
					Sort-Object -Property Name -Descending |
			Select-Object -First 1).Name) -ChildPath 'ngen.exe'

			# Execute the optimization command and suppress the output, we also prevent a new window
			Write-Output -InputObject ('{0} executeQueuedItems' -f $ngen_path)
			Start-Process -FilePath $ngen_path -ArgumentList 'executeQueuedItems' -NoNewWindow -Wait -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -LoadUserProfile:$False -RedirectStandardOutput null
		}
	}

	END {
		# Cleanup
		Remove-Variable -Name frameworks -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}
}

function Get-EncryptSecretText {
	<#
			.SYNOPSIS
			Encrypts a given string with a given certificate

			.DESCRIPTION
			Sometimes you might need to transfer a password (or another secret)
			via Mail (or any other insecure media) here a strong encryption is
			very handy.
			Get-EncryptSecretText uses a given Certificate to encrypt a given String

			.PARAMETER CertificatePath
			Path to the certificate that you would like to use

			.PARAMETER plaintext
			Plain text string that you would like to encrypt with the certificate

			.EXAMPLE
			PS C:\> Get-EncryptSecretText -CertificatePath "Cert:\CurrentUser\My\XYZ" -PlainText "My Secret Text"
			MIIB9QYJKoZIhvcNAQcDoIIB5jCCAeICAQAxggGuMIIBqgIBADCBkTB9MQswCQYDVQQGEwJHQjEbnBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8
			gQ0EgTGltaXRlZDEjMCEGA1UEAxMaQ09NT0RPIFJTQSBDb2RlIFNpZ25pbmcgQ0ECEBbU91MdmxgnT/ImczrRgFwwDQYJKoZIhvcNAQEBBQAEggEAi5M7w7k/siGdGiYW8z8izVUNfI15HaHqHJs/t3VIZkgfSc
			GAKUpZjwJW7xMZHoKppw0eL/mUZr4823M276swiktXnpRbol8g8Kqvy2c7dUx2lNJm/+s8YLG0rsK70EhSPzAEbNtFAqlWj5ETnskTlfuEiJdB2tFjC42oweWKRokQ0exyztY1sN7V7vImkMtCS7JHeJF23SyNv
			PbFw0hE0QtiKVdu8DESO2CB9H1bVYIxVWTvpvT71yDQCFFOwg0JdGJpCI6l+YxPqHqKhFcdWZtuP8JMvNZ8UbxveNVmBOrasM5ZTHfHljWIT6V6tDxy5jOd9cTiuayh/X1A2eKA/DArBgkqhkiG9w0BBwEwFAYI
			KoZIhvcNAwcECFjYhWLX5qsEgAgjq1toxGP5GQ==

			Description
			-----------
			In this example the Certificate with the Fingerprint "XYZ" from the
			certificate store of the user is used.

			.LINK
			Get-DecryptSecretText

			.NOTES
			You need Get-DecryptSecretText to make it human readable again

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Path to the certificate that you would like to use')]
		[ValidateNotNullOrEmpty()]
		[String]$CertificatePath,
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = 'Plain text string that you would like to encyt with the certificate')]
		[ValidateNotNullOrEmpty()]
		[String]$PlainText
	)

	BEGIN {
		$null = (Add-Type -AssemblyName System.Security)
	}

	PROCESS {
		#Get the certificate
		Set-Variable -Name 'Certificate' -Value $(Get-Item -Path $CertificatePath)

		# GetBytes .NET
		Set-Variable -Name 'ContentInfo' -Value $(New-Object -TypeName Security.Cryptography.Pkcs.ContentInfo -ArgumentList ( , [Text.Encoding]::Unicode.GetBytes($PlainText)))

		# Set the secured envelope infos
		Set-Variable -Name 'SecureEnvelope' -Value $(New-Object -TypeName Security.Cryptography.Pkcs.EnvelopedCms -ArgumentList $ContentInfo)
		$SecureEnvelope.Encrypt((New-Object -TypeName System.Security.Cryptography.Pkcs.CmsRecipient -ArgumentList ($Certificate)))

		# And here is the secured string
		Set-Variable -Name 'SecretText' -Value $([Convert]::ToBase64String($SecureEnvelope.Encode()))
	}

	END {
		# Dump it
		Write-Output -InputObject $SecretText
	}
}

function Get-DecryptSecretText {
	<#
			.SYNOPSIS
			Decrypts a given String, encrypted by Get-EncryptSecretText

			.DESCRIPTION
			Get-DecryptSecretText makes a string encrypted by Get-EncryptSecretText
			decrypts it to and human readable again.

			.PARAMETER EncryptedText
			The encrypted test string

			.EXAMPLE
			PS C:\> $Foo = (Get-EncryptSecretText -CertificatePath "Cert:\CurrentUser\My\XYZ" -PlainText "My Secret Text")
			PS C:\> Get-DecrypSecretText -EncryptedText $Foo
			My Secret Text

			Description
			-----------
			Get-DecryptSecretText makes a string encrypted by Get-EncryptSecretText
			human readable again.
			In this example the Certificate with the Fingerprint "XYZ" from the
			certificate store of the user is used.

			.NOTES
			You need the certificate that was used with Get-EncryptSecretText to
			encrypt the string

			.LINK
			Get-EncryptSecretText

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'The encrypted test string')]
		[ValidateNotNullOrEmpty()]
		[String]$EncryptedText
	)

	BEGIN {
		$null = (Add-Type -AssemblyName System.Security)
	}

	PROCESS {
		# Decode the Base64 encoded string back
		Set-Variable -Name 'SecretText' -Value $([Convert]::FromBase64String($EncryptedText))

		# the secured envelope infos
		Set-Variable -Name 'SecureEnvelope' -Value $(New-Object -TypeName Security.Cryptography.Pkcs.EnvelopedCms)
		$SecureEnvelope.Decode($SecretText)
		$SecureEnvelope.Decrypt()

		# And here is the human readable string again!
		Set-Variable -Name 'UnicodeContent' -Value $([text.encoding]::Unicode.GetString($SecureEnvelope.ContentInfo.Content))
	}

	END {
		# Dump it
		Write-Output -InputObject $UnicodeContent
	}
}

function Send-HipChat {
	<#
			.SYNOPSIS
			Send a notification message to a HipChat room.

			.DESCRIPTION
			Send a notification message to a HipChat room via a RESTful Call to
			the HipChat API V2 Atlassian requires a separate token for each room
			within HipChat!

			So please note, that the Room and the Token parameter must match.

			.PARAMETER Token
			HipChat Auth Token

			.PARAMETER Room
			HipChat Room Name that get the notification.
			The Token has to fit to the Room!

			.PARAMETER notify
			Whether this message should trigger a user notification
			(change the tab color, play a sound, notify mobile phones, etc).
			Each recipient's notification preferences are taken into account.

			.PARAMETER color
			Background color for message.

			Valid is
			- yellow
			- green
			- red
			- purple
			- gray
			-random

			.PARAMETER Message
			The message body itself. Please see the HipChat API V2 documentation

			.PARAMETER Format
			Determines how the message is treated by our server and rendered
			inside HipChat applications

			.EXAMPLE
			PS C:\> Send-HipChat -Message "This is just a BuildServer Test" -color "gray" -Room "Testing" -notify $True

			Description
			-----------
			Sent a HipChat Room notification "This is just a BuildServer Test" to
			the Room "Testing".
			It uses the Color "gray", and it sends a notification to all users
			in the room.
			It uses a default Token to do so!

			.EXAMPLE
			PS C:\> Send-HipChat -Message "Hello @JoergHochwald" -color "Red" -Room "DevOps" -Token "1234567890" -notify $False

			Description
			-----------
			Sent a HipChat Room notification "Hello @JoergHochwald" to the
			Room "DevOps".
			The @ indicates a user mention, this is supported like in a regular
			chat from user 2 User.
			It uses the Color "red", and it sends no notification to users in
			the room.
			It uses a Token "1234567890" to do so! The Token must match the Room!

			.NOTES
			We use the API V2 now ;-)

			.LINK
			API: https://www.hipchat.com/docs/apiv2

			.LINK
			Docs: https://www.hipchat.com/docs/apiv2/method/send_room_notification

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Alias('AUTH_TOKEN')]
		[String]$token = '8EWA77eidxEJG5IFluWjD9794ft8WSzfKhjBCKpv',
		[Alias('ROOM_ID')]
		[String]$Room = 'Testing',
		[bool]$notify = $False,
		[ValidateSet('yellow', 'green', 'red', 'purple', 'gray', 'random', IgnoreCase = $True)]
		[String]$color = 'gray',
		[Parameter(Mandatory,HelpMessage = 'The message body')]
		[ValidateNotNullOrEmpty()]
		[String]$Message,
		[ValidateSet('html', 'text', IgnoreCase = $True)]
		[Alias('message_format')]
		[String]$Format = 'text'
	)

	BEGIN {
		# Cleanup all variables...
		Remove-Variable -Name 'headers' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'body' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'myBody' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'uri' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'myMethod' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'post' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		# Set the Header Variable
		Set-Variable -Name 'headers' -Value $(@{
				'Authorization' = "Bearer $($token)"
				'Content-type' = 'application/json'
		})

		# Make the content of the Variable all lower case
		$color = $color.ToLower()
		$Format = $Format.ToLower()

		# Set the Body Variable, will be converted to JSON then
		Set-Variable -Name 'body' -Value $(@{
				'color'        = "$color"
				'message_format' = "$Format"
				'message'      = "$Message"
				'notify'       = "$notify"
		})

		# Convert the Body Variable to JSON Check if the Server understands Compression, could reduce bandwidth
		# Be careful with the Depth Parameter, bigger values means less performance
		Set-Variable -Name 'myBody' -Value $(ConvertTo-Json -InputObject $body -Depth 2 -Compress:$False)

		# Set the URI Variable based on the Atlassian HipChat API V2 documentation
		Set-Variable -Name 'uri' -Value $('https://api.hipchat.com/v2/room/' + $Room + '/notification')

		# Method to use for the RESTful Call
		Set-Variable -Name 'myMethod' -Value $('POST' -as ([String] -as [type]))

		# Use the API via RESTful call
		try {
			# We fake the User Agent here!
			(Invoke-RestMethod -Uri $uri -Method $myMethod -Headers $headers -Body $myBody -UserAgent "Mozilla/5.0 (Windows NT; Windows NT 6.1; en-US) enaTEC WindowsPowerShell Service $CoreVersion" -ErrorAction Stop -WarningAction SilentlyContinue)
		} catch [System.Exception] {
			<#
					Argh! Catched an Exception...
			#>

			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
		} catch {
			# Whoopsie!
			# That should not happen...
			Write-Warning -Message ('Could not send notification to your HipChat Room {0}' -f $Room)
			<#
					I use Send-HipChat a lot within automated tasks.
					I post updates from my build server and info from customers Mobile Device Management systems.
					So I decided to use a warning instead of an error here.

					You might want to change this to fit you needs.

					Remember: If you throw an terminating error, you might want to add a "finally" block to this try/catch Block here.
			#>
		} finally {
			# Cleanup all variables...
			Remove-Variable -Name 'headers' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'body' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'myBody' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'uri' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'myMethod' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'post' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}
}

function Send-Packet {
	<#
			.SYNOPSIS
			Send a packet via IP, TCP or UDP

			.DESCRIPTION
			Send a packet via IP, TCP or UDP
			Found this useful to test firewall configurations and routing.
			Or even to test some services.

			.PARAMETER Target
			Target name or IP

			.PARAMETER Protocol
			protocol to use, default is IP

			.PARAMETER TargetPort
			Target Port (against the target)

			.PARAMETER SourcePort
			Fake Source port (Default is random)

			.PARAMETER Ttl
			The Time To Life (Default is 128)

			.PARAMETER Count
			The count, how many packets? (Default is one)

			.EXAMPLE
			PS C:\> Send-Packet -Target '10.10.16.29' -Protocol 'TCP' -TargetPort '4711'

			Description
			-----------
			Send a 'TCP' packet on port '4711' to target '10.10.16.29'

			.EXAMPLE
			PS C:\> Send-Packet -Target '10.10.16.29' -Protocol 'UDP' -TargetPort '4711' -Count '10'

			Description
			-----------
			Send 10 'UDP' packets on port '4711' to target '10.10.16.29'

			.EXAMPLE
			PS C:\> Send-Packet -Target '10.10.16.29' -Protocol 'TCP' -TargetPort '4711' -SourcePort '14712'

			Description
			-----------
			Send a 'TCP' packet on port '4711' to target '10.10.16.29' and it
			uses a fake source port '14712'
			This could be useful for port knocking or to check Firewall behaviors

			.NOTES
			Based on an idea of JohnLaska

			.LINK
			Source: https://github.com/JohnLaska/PowerShell/blob/master/Send-Packet.ps1
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Target name or IP')]
		[String]$Target,
		[Parameter(Position = 1)]
		[ValidateSet('IP', 'TCP', 'UDP')]
		[String]$Protocol = 'IP',
		[Parameter(Mandatory,
				Position = 2,
		HelpMessage = 'Target Port (against the target)')]
		[ValidateRange(0, 65535)]
		[int]$TargetPort,
		[Parameter(Position = 3)]
		[ValidateRange(0, 65535)]
		[int]$SourcePort = (Get-Random -Minimum 0 -Maximum 65535),
		[Parameter(Position = 4)]
		[int]$TTL = 128,
		[Parameter(Position = 5)]
		[int]$count = 1
	)

	PROCESS {
		$packet = New-Object -TypeName System.Net.Sockets.Socket -ArgumentList (
			[Net.Sockets.AddressFamily]::InterNetwork,
			[Net.Sockets.SocketType]::Raw,
			[Net.Sockets.ProtocolType]::$Protocol
		)

		$packet.Ttl = ($TTL)
	}
}

function Send-Prowl {
	<#
			.SYNOPSIS
			Prowl is the Growl client for iOS.

			.DESCRIPTION
			Prowl is the Growl client for iOS. Push to your iPhone, iPod touch,
			or iPad notifications from a Mac or Windows computer,
			or from a multitude of apps and services.
			Easily integrate the Prowl API into your applications.

			.PARAMETER Event
			The Text of the Prowl Message

			.PARAMETER Description
			Description of the Prowl Message

			.PARAMETER ApplicationName
			Name your Application, e.g. BuildBot. Default is PowerShell

			.PARAMETER Priority
			Priority of the Prowl Message (0, 1,2), default is 0

			.PARAMETER url
			URL you would like to attach to the Prowl Message

			.PARAMETER apiKey
			Prowl API Key (Required)

			.EXAMPLE
			Send-Prowl -apiKey "1234567890" -Event "Hello World!"

			Description
			-----------
			Send the Prowl message "Hello World!"

			.EXAMPLE
			Send-Prowl -apiKey "1234567890" -Event "Call the Helpdesk!" -Priority "2" -Description "Call the Helpdesk, we need your feedback!!!" -url "tel:1234567890"

			Description
			-----------
			Send Prowl event "Call the Helpdesk!" with priority 2 and the
			description "Call the Helpdesk, we need your feedback!!!".

			It attaches the URL "tel:1234567890"

			.EXAMPLE
			Send-Prowl -apiKey "1234567890" -Event "Your Ticket is updated" -Priority 1 -Description "The Helpdesk Team updated your ticket!" -url "http://support.enatec.io/"

			Description
			-----------
			Send Prowl event "Your Ticket is updated" with priority 2 and the
			description "The Helpdesk Team updated your ticket!".

			It attaches the URL "http://support.enatec.io/"

			.LINK
			Info: http://www.prowlapp.com

			.LINK
			API: http://www.prowlapp.com/api.php

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory,
		HelpMessage = 'The Text of the Prowl Message')]
		[ValidateNotNullOrEmpty()]
		[ValidateLength(1, 1024)]
		[String]$Event,
		[ValidateLength(0, 10000)]
		[String]$Description = '',
		[ValidateLength(1, 256)]
		[String]$ApplicationName = 'PowerShell',
		[ValidateRange(1, 2)]
		[int]$priority = 0,
		[Parameter(Mandatory,HelpMessage = 'URL you would like to attach to the Prowl Message')]
		[ValidateLength(0, 512)]
		[String]$url,
		[Parameter(Mandatory,
		HelpMessage = 'Prowl API Key (Required)')]
		[ValidateScript({ $_.Length -ge 40 })]
		[String]$apiKey
	)

	BEGIN {
		# URL-encode some strings
		$null = (Add-Type -AssemblyName System.Web)
		$Event = [web.httputility]::urlencode($Event.Trim())
		$Description = [web.httputility]::urlencode($Description.Trim())
		$ApplicationName = [web.httputility]::urlencode($ApplicationName.Trim())
		$url = [web.httputility]::urlencode($url.Trim())

		# Compose the complete URL
		$apiBaseUrl = 'https://prowl.weks.net/publicapi/add'
		$ProwlUrl = "$($apiBaseUrl)?apikey=$($apiKey)&application=$($ApplicationName)&event=$($Event)&Description=$($Description)&priority=$($priority)&url=$($url)"

		# Be Verbose
		Write-Verbose -Message ('Complete URL: {0}' -f ($ProwlUrl))
	}

	PROCESS {
		# Try to send message
		try {
			# Fire it up!
			$webReturn = ([String] (New-Object -TypeName Net.WebClient).DownloadString($ProwlUrl))
		} catch {
			# Be Verbose
			Write-Verbose -Message ('Error sending Prowl Message: {0}' -f ($Error[0]))

			Return $False
		}

		# Output what comes back from the API
		Write-Verbose -Message $webReturn

		if (([xml]$webReturn).prowl.success.code -eq 200) {
			# Be Verbose
			Write-Verbose -Message 'Prowl message sent OK'

			Return $True
		} else {
			# Be Verbose
			Write-Verbose -Message ('Error sending Prowl Message: {0} - {1}' -f (1$webReturn).prowl.error.code, (1$webReturn).prowl.error.innerXml)

			Return $False
		}
	}
}

function Send-SlackChat {
	<#
			.SYNOPSIS
			Sends a chat message to a Slack organization

			.DESCRIPTION
			The Post-ToSlack cmdlet is used to send a chat message to a Slack
			channel, group, or person.

			Slack requires a token to authenticate to an organization within Slack.

			.PARAMETER Channel
			Slack Channel to post to

			.PARAMETER Message
			Chat message to post

			.PARAMETER token
			Slack API token

			.PARAMETER BotName
			Optional name for the bot

			.EXAMPLE
			PS C:\> Send-SlackChat -channel '#general' -message 'Hello everyone!' -botname 'The Borg' -token '1234567890'

			Description
			-----------
			This will send a message to the "#General" channel using a specific
			token 1234567890, and the bot's name will be "The Borg".

			.EXAMPLE
			PS C:\> Send-SlackChat -channel '#general' -message 'Hello everyone!' -token '1234567890'

			Description
			-----------
			This will send a message to the "#General" channel using a specific t
			oken 1234567890, and the bot's name will be default ("Build Bot").

			.NOTES
			Based on an idea of @ChrisWahl
			Please note the Name change and the removal of some functions

			.LINK
			Info: https://api.slack.com/tokens

			.LINK
			API: https://api.slack.com/web

			.LINK
			Info: https://api.slack.com/bot-users

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = 'Slack Channel to post to')]
		[ValidateNotNullOrEmpty()]
		[String]$channel,
		[Parameter(Mandatory,
				Position = 1,
		HelpMessage = 'Chat message to post')]
		[ValidateNotNullOrEmpty()]
		[String]$Message,
		[Parameter(Mandatory,Position = 2,
		HelpMessage = 'Slack API token')]
		[ValidateNotNullOrEmpty()]
		[String]$token,
		[Parameter(Position = 3)]
		[Alias('Name')]
		[String]$BotName = 'Build Bot'
	)

	BEGIN {
		# Cleanup all variables...
		Remove-Variable -Name 'uri' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'body' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'myBody' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		Set-Variable -Name 'uri' -Value $('https://slack.com/api/chat.postMessage')

		# Build the body as per https://api.slack.com/methods/chat.postMessage
		# We convert this to JSON then...
		Set-Variable -Name 'body' -Value $(@{
				token    = $token
				channel  = $channel
				text     = $Message
				username = $BotName
				parse    = 'full'
		})

		# Convert the Body Variable to JSON Check if the Server understands Compression,
		# could reduce bandwidth Be careful with the Depth Parameter, bigger values means less performance
		Set-Variable -Name 'myBody' -Value $(ConvertTo-Json -InputObject $body -Depth 2 -Compress:$False)

		# Method to use for the RESTful Call
		Set-Variable -Name 'myMethod' -Value $('POST' -as ([String] -as [type]))

		# Use the API via RESTful call
		try {(Invoke-RestMethod -Uri $uri -Method $myMethod -Body $body -UserAgent "Mozilla/5.0 (Windows NT; Windows NT 6.1; en-US) enaTEC WindowsPowerShell Service $CoreVersion" -ErrorAction Stop -WarningAction SilentlyContinue)} catch [System.Exception] {
			<#
					Argh!
					That was an Exception...
			#>

			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
		} catch {
			# Whoopsie!
			# That should not happen...
			Write-Warning -Message ('Could not send notification to your Slack {0}' -f $channel)
		} finally {
			# Cleanup all variables...
			Remove-Variable -Name 'uri' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'body' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Remove-Variable -Name 'myBody' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}
}

function Set-AcceptProtocolViolation {
	<#
			.SYNOPSIS
			Workaround for servers with SSL header problems

			.DESCRIPTION
			Workaround for the following Exception "DownloadString" with "1"
			argument(s):
			"The underlying connection was closed: Could not establish trust
			relationship for the SSL/TLS secure channel."

			.EXAMPLE
			PS C:\> Set-AcceptProtocolViolation

			Description
			-----------
			Establish the workaround (Be careful)

			.NOTES
			Be careful:
			This is just a workaround for servers that have a problem with
			SSL headers.

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param ()

	PROCESS {
		# Set the SSL Header unsafe parser based on the value from the configuration
		if ($AcceptProtocolViolation) {
			# Be Verbose
			Write-Verbose -Message 'Set the SSL Header unsafe parser based on the value from the configuration'

			# Read the existing settings to a variable
			Set-Variable -Name 'netAssembly' -Value $([Reflection.Assembly]::GetAssembly([Net.Configuration.SettingsSection]))

			# Check if we have something within the Variable
			if ($netAssembly) {
				# Set some new values
				Set-Variable -Name 'bindingFlags' -Value $([Reflection.BindingFlags] 'Static,GetProperty,NonPublic')
				Set-Variable -Name 'settingsType' -Value $($netAssembly.GetType('System.Net.Configuration.SettingsSectionInternal'))
				Set-Variable -Name 'instance' -Value $($settingsType.InvokeMember('Section', $bindingFlags, $null, $null, @()))

				# Check for the Instance variable
				if ($instance) {
					# Change the values if they exist
					$bindingFlags = 'NonPublic', 'Instance'
					Set-Variable -Name 'useUnsafeHeaderParsingField' -Value $($settingsType.GetField('useUnsafeHeaderParsing', $bindingFlags))

					# Check for the unsafe HEader Variable
					if ($useUnsafeHeaderParsingField) {
						# Looks like the variable exists, set the value...
						$useUnsafeHeaderParsingField.SetValue($instance, $True)
					}
				}
			}
		}
	}
}

function Set-Culture {
	<#
			.SYNOPSIS
			Set the PowerShell culture to a given culture

			.DESCRIPTION
			Set the PowerShell culture to a given culture

			.PARAMETER culture
			Culture to use

			.EXAMPLE
			PS C:\> Set-Culture -culture "en-US" | ConvertFrom-UnixDate -Date 1458205878
			Thursday, March 17, 2016 9:11:18 AM

			Description
			-----------
			Returns the date in the given culture (en-US) format instead of
			the system culture.

			.NOTES
			Inspired by Use-Culture.ps1 by Lee Holmes

			.LINK
			Use-Culture http://poshcode.org/2226
	#>

	param
	(
		[Parameter(ValueFromPipeline,
		Position = 1)]
		[ValidateNotNullOrEmpty()]
		[cultureinfo]$Culture = 'en-US'
	)

	PROCESS {
		$OldCulture = [Threading.Thread]::CurrentThread.CurrentUICulture

		[Threading.Thread]::CurrentThread.CurrentUICulture = $Culture
		[Threading.Thread]::CurrentThread.CurrentCulture = $Culture

		$TheCulture = [Threading.Thread]::CurrentThread.CurrentUICulture
	}

	END {
		# Be Verbose
		Write-Verbose -Message ('Old: {0}' -f $OldCulture)
		Write-Verbose -Message ('New: {0}' -f $TheCulture)
	}
}

function Set-DebugOn {
	<#
			.SYNOPSIS
			Turn Debug on

			.DESCRIPTION
			Turn Debug on

			.NOTES
			Just an internal function to make our life easier!

			.EXAMPLE
			PS C:\> Set-DebugOn

			Description
			-----------
			Turn Debug on

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		Set-Variable -Name DebugPreference -Scope Global -Value:'Continue' -Option AllScope -Visibility Public -Confirm:$False
		Set-Variable -Name NETXDebug -Scope Global -Value:$True -Option AllScope -Visibility Public -Confirm:$False
	}

	END {
		Write-Output -InputObject 'Debug enabled'
	}
}

function Set-DebugOff {
	<#
			.SYNOPSIS
			Turn Debug off

			.DESCRIPTION
			Turn Debug off

			.NOTES
			Just an internal function to make our life easier!

			.EXAMPLE
			PS C:\> Set-DebugOff

			Description
			-----------
			Turn Debug off
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		Set-Variable -Name DebugPreference -Scope Global -Value SilentlyContinue -Option AllScope -Visibility Public -Confirm:$False
		Set-Variable -Name NETXDebug -Scope Global -Value $False -Option AllScope -Visibility Public -Confirm:$False
	}

	END {
		Write-Output -InputObject 'Debug disabled'
	}
}

function Set-Encoding {
	<#
			.SYNOPSIS
			Converts Encoding of text files

			.DESCRIPTION
			Allows you to change the encoding of files and folders.
			It supports file extension agnostic

			Please note: Overwrites original file if destination equals the path

			.PARAMETER path
			Folder or file to convert

			.PARAMETER dest
			If you want so save the newly encoded file/files to a new location

			.PARAMETER encoding
			Encoding method to use for the Patch or File

			.EXAMPLE
			PS C:\> Set-Encoding -path "c:\windows\temp\folder1" -encoding "UTF8"

			Description
			-----------
			Converts all Files in the Folder c:\windows\temp\folder1 in the UTF8 format

			.EXAMPLE
			PS C:\> Set-Encoding -path "c:\windows\temp\folder1" -dest "c:\windows\temps\folder2" -encoding "UTF8"

			Description
			-----------
			Converts all Files in the Folder c:\windows\temp\folder1 in the UTF8
			format and save them to c:\windows\temp\folder2

			.EXAMPLE
			PS C:\> (Get-Content -path "c:\temp\test.txt") | Set-Content -Encoding UTF8 -Path "c:\temp\test.txt"

			Description
			-----------
			This converts a single File via hardcore PowerShell without a Script.
			Might be useful if you want to convert this script after a transfer!

			.NOTES
			BETA!!!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')]
		[ValidateNotNullOrEmpty()]
		[Alias('PathName')]
		[String]$Path,
		[Alias('Destination')]
		[String]$dest = $Path,
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')]
		[Alias('enc')]
		[String]$encoding
	)

	BEGIN {
		# ensure it is a valid path
		if (-not (Test-Path -Path $Path)) {
			# Aw, Snap!
			throw 'File or directory not found at {0}' -f $Path
		}
	}

	PROCESS {
		# if the path is a file, else a directory
		if (Test-Path -Path $Path -PathType Leaf) {
			# if the provided path equals the destination
			if ($Path -eq $dest) {
				# get file extension
				Set-Variable -Name ext -Value $([IO.Path]::GetExtension($Path))

				#create destination
				Set-Variable -Name dest -Value $($Path.Replace([IO.Path]::GetFileName($Path), ('temp_encoded{0}' -f $ext)))

				# output to file with encoding
				Get-Content -Path $Path | Out-File -FilePath $dest -Encoding $encoding -Force

				# copy item to original path to overwrite (note move-item loses encoding)
				Copy-Item -Path $dest -Destination $Path -Force -PassThru | ForEach-Object -Process { Write-Output -InputObject ('{0} encoded {1}' -f $encoding, $_) }

				# remove the extra file
				Remove-Item -Path $dest -Force -Confirm:$False
			} else {
				# output to file with encoding
				Get-Content -Path $Path | Out-File -FilePath $dest -Encoding $encoding -Force
			}

		} else {
			# get all the files recursively
			foreach ($i in Get-ChildItem -Path $Path -Recurse) {
				if ($i.PSIsContainer) {
					continue
				}

				# get file extension
				Set-Variable -Name ext -Value $([IO.Path]::GetExtension($i))

				# create destination
				Set-Variable -Name dest -Value $("$Path\temp_encoded{0}" -f $ext)

				# output to file with encoding
				Get-Content -Path $i.FullName | Out-File -FilePath $dest -Encoding $encoding -Force

				# copy item to original path to overwrite (note move-item loses encoding)
				Copy-Item -Path $dest -Destination $i.FullName -Force -PassThru | ForEach-Object -Process { Write-Output -InputObject ('{0} encoded {1}' -f $encoding, $_) }

				# remove the extra file
				Remove-Item -Path $dest -Force -Confirm:$False
			}
		}
	}
}

function Set-FolderDate {
	<#
			.SYNOPSIS
			Change one folder, or more, last-write time based on the latest
			last-write of the included files

			.DESCRIPTION
			Change one folder, or more, folder last-write time based on the
			latest last-write of the included files
			Makes windows a lot more Uni* like and have some Convenience.

			.PARAMETER Path
			One folder, or more, you would like to update

			Default is C:\scripts\PowerShell\log

			.EXAMPLE
			Set-FolderDate -Path "D:\temp"

			Description
			-----------
			Change "D:\temp" last-write time based on the latest last-write
			of the included files

			.NOTES
			We intercept all Errors! This is the part in the "BEGIN" block.
			You might want to change that to a warning...

			We use this function in bulk operations and from scheduled scripts,
			so we do not want that!!!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[ValidateNotNullOrEmpty()]
		[String[]]$Path = 'C:\scripts\PowerShell\log'
	)

	BEGIN {
		# Suppress all error messages!
		Trap [Exception] {
			Write-Verbose -Message $('TRAPPED: ' + $_.Exception.Message)

			# Be Verbose
			Write-Verbose -Message 'Could not change date on folder (Folder open in explorer?)'

			# Ignore what happened and just continue with what you are doing...
			Continue
		}
	}

	PROCESS {
		# Get latest file date in folder
		$LatestFile = (Get-ChildItem -Path $Path |
			Sort-Object -Property LastWriteTime -Descending |
		Select-Object -First 1)

		# Change the date, if needed
		$Folder = Get-Item -Path $Path

		if ($LatestFile.LastWriteTime -ne $Folder.LastWriteTime) {
			# Be Verbose
			Write-Verbose -Message ("Changing date on folder '{0}' to '{1}' taken from '{2}'" -f ($Path), $LatestFile.LastWriteTime, ($LatestFile))

			$Folder.LastWriteTime = ($LatestFile.LastWriteTime)
		}
	}

	END {
		Write-Output -InputObject $Folder
	}
}

function Set-VisualEditor {
	<#
			.SYNOPSIS
			Set the VisualEditor variable

			.DESCRIPTION
			Setup the VisualEditor variable. Checks if the free (GNU licensed)
			Notepad++ is installed,
			if so it uses this great free editor.

			If not the fall back is the PowerShell ISE.

			.EXAMPLE
			PS C:\> Set-VisualEditor

			Description
			-----------
			Set the VisualEditor variable. Nothing is returned, no parameter,
			no nothing ;-)

			.EXAMPLE
			PS C:\> $VisualEditor
			C:\Program Files (x86)\Notepad++\notepad++.exe

			Description
			-----------
			Show the variable (Notepad++ in this case)

			.EXAMPLE
			PS C:\> $VisualEditor
			PowerShell_ISE.exe

			Description
			-----------
			Show the variable (PowerShell ISE in this case)
			So no Sublime (our favorite) or Notepad++ (Fallback) installed.
			looks like a plain vanilla PowerShell box.
			But hey, since PowerShell 4, ISE is great!

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		# Do we have the Sublime Editor installed?
		Set-Variable -Name SublimeText -Value $(Resolve-Path -Path (Join-Path -Path (Join-Path -Path "$env:PROGRAMW6432*" -ChildPath 'Sublime*') -ChildPath 'Sublime_text*'))

		# Check if the GNU licensed Note++ is installed
		Set-Variable -Name NotepadPlusPlus -Value $(Resolve-Path -Path (Join-Path -Path (Join-Path -Path "$env:PROGRAMW6432*" -ChildPath 'notepad*') -ChildPath 'notepad*'))

		# Do we have it?
		(Resolve-Path -Path "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)

		# What Editor to use?
		if (($SublimeText) -and (Test-Path -Path $SublimeText)) {
			# We have Sublime Editor installed, so we use it
			Set-Variable -Name VisualEditor -Scope Global -Value $($SublimeText.Path)
		} elseif (($NotepadPlusPlus) -and (Test-Path -Path $NotepadPlusPlus)) {
			# We have Notepad++ installed, Sublime Editor is not here... use Notepad++
			Set-Variable -Name VisualEditor -Scope Global -Value $($NotepadPlusPlus.Path)
		} else {
			# No fancy editor, so we use ISE instead
			Set-Variable -Name VisualEditor -Scope Global -Value $('PowerShell_ISE.exe')
		}
	}

	END {
		# Be Verbose
		Write-Verbose -Message ('{0}' -f $VisualEditor)
	}
}

function Get-ShortDate {
	<#
			.SYNOPSIS
			Get the Date as short String

			.DESCRIPTION
			Get the Date as short String

			.PARAMETER FilenameCompatibleFormat
			Make sure it is compatible to File Dates

			.EXAMPLE
			PS C:\> Get-ShortDate
			19.03.16

			Description
			-----------
			Get the Date as short String

			.EXAMPLE
			PS C:\> Get-ShortDate -FilenameCompatibleFormat
			19-03-16

			Description
			-----------
			Get the Date as short String and replace the '.' with '-'.
			Useful is you want to append this to filenames.

			The dots are bad for such use cases!

			.NOTES
			Helper Function based on an idea of Robert D. Biddle

			.LINK
			Source https://github.com/RobBiddle/Get-ShortDateTime/blob/master/Get-ShortDateTime.psm1
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Position = 0)]
		[Switch]$FilenameCompatibleFormat
	)

	PROCESS {
		if ($FilenameCompatibleFormat) {
			$Date = (Get-Date)

			# Dump
			Return (($Date.ToShortDateString()).Replace('/', '-'))
		} else {
			$Date = (Get-Date)

			# Dump
			Return ($Date.ToShortDateString())
		}
	}
}

function Get-ShortTime {
	<#
			.SYNOPSIS
			Get the Time as short String

			.DESCRIPTION
			Get the Time as short String

			.PARAMETER FilenameCompatibleFormat
			Make sure it is compatible to File Timestamp

			.EXAMPLE
			PS C:\> Get-ShortTime
			16:17

			Description
			-----------
			Get the Time as short String

			.EXAMPLE
			PS C:\> Get-ShortTime -FilenameCompatibleFormat
			16-17

			Description
			-----------
			Get the Time as short String and replace the ':' with '-'.
			Useful is you want to append this to filenames.
			The dash could be bad for such use cases!

			.NOTES
			Helper Function based on an idea of Robert D. Biddle

			.LINK
			Source https://github.com/RobBiddle/Get-ShortDateTime/blob/master/Get-ShortDateTime.psm1
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Position = 0)]
		[Switch]$FilenameCompatibleFormat
	)

	PROCESS {
		if ($FilenameCompatibleFormat) {
			$time = (Get-Date)

			# Dump
			Return (($time.ToShortTimeString()).Replace(':', '-').Replace(' ', '-'))
		} else {
			$time = (Get-Date)

			# Dump
			Return ($time.ToShortTimeString())
		}
	}
}

function Invoke-WithElevation {
	<#
			.SYNOPSIS
			Uni* like Superuser Do (Sudo)

			.DESCRIPTION
			This is not a hack or something:
			You still to have the proper access rights (permission) to execute
			something with elevated rights (permission)!
			Windows will tell you (and ask for confirmation) that the given
			command is executes with administrative rights.

			The command opens another window and you can still use your existing
			shell with you regular permissions.

			Keep that in mind when you execute it...

			.PARAMETER file
			Script/Program to run

			.EXAMPLE
			PS C:\> sudo 'C:\scripts\PowerShell\profile.ps1'

			Description
			-----------
			Try to execute 'C:\scripts\PowerShell\profile.ps1' with elevation
			We use the Uni* like alias here

			.EXAMPLE
			PS C:\> Invoke-WithElevation 'C:\scripts\PowerShell\profile.ps1'

			Description
			-----------
			Try to execute 'C:\scripts\PowerShell\profile.ps1' with elevation

			.NOTES
			Still a internal Beta function!
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = ' Script/Program to run')]
		[Alias('FileName')]
		[String]$File
	)

	BEGIN {
		if (-not (Get-AdminUser)) {
			Write-Error -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.' -ErrorAction Stop

			break
		}
	}

	PROCESS {
		# Define some defaults
		$sudo = (New-Object -TypeName System.Diagnostics.ProcessStartInfo)
		$sudo.Verb = 'runas'
		$sudo.FileName = "$pshome\PowerShell.exe"
		$sudo.windowStyle = 'Normal'
		$sudo.WorkingDirectory = (Get-Location)

		# What to execute?
		if ($File) {
			if (Test-Path -Path $File) {
				$sudo.Arguments = "-executionpolicy unrestricted -NoExit -noprofile -Command $File"
			} else {
				Write-Error -Message ('Error: File does not exist - {0}' -f $File) -ErrorAction Stop
			}
		} else {
			# No file given, so we open a plain Shell (Console window)
			$sudo.Arguments = "-executionpolicy unrestricted -NoExit -Command  &{Set-Location '" + (Get-Location).Path + "'}"
		}
	}

	END {
		# NET call to execute SuDo
		if ($pscmdlet.ShouldProcess("$sudo", 'Execute elevated')) {
			$null = [Diagnostics.Process]::Start($sudo)
		}
	}
}

function Invoke-Tail {
	<#
			.SYNOPSIS
			Make the PowerShell a bit more *NIX like

			.DESCRIPTION
			Wrapper for the PowerShell command Get-Content. It opens a given
			file and shows the content...
			Get-Content normally exists as soon as the end of the given file is
			reached, this wrapper keeps it open and display every new informations
			as soon as it appears. This could be very useful for parsing log files.

			Everyone ever used Unix or Linux known tail ;-)

			.PARAMETER f
			Follow

			.PARAMETER file
			File to open

			.EXAMPLE
			PS C:\> Invoke-Tail C:\scripts\PowerShell\logs\create_new_OU_Structure.log

			Description
			-----------
			Opens the given Log file
			(C:\scripts\PowerShell\logs\create_new_OU_Structure.log) and shows
			every new entry until you break it (CTRL + C)

			.EXAMPLE
			PS C:\> tail C:\scripts\PowerShell\logs\create_new_OU_Structure.log

			Description
			-----------
			Opens the given Log file
			(C:\scripts\PowerShell\logs\create_new_OU_Structure.log) and shows
			every new entry until you break it (CTRL + C)

			.NOTES
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[switch]$f,
		[Parameter(Mandatory,
		HelpMessage = 'File to open')]
		[ValidateNotNullOrEmpty()]
		$File
	)

	PROCESS {
		if ($f) {
			# Follow is enabled, dump the last 10 lines and follow the stream
			Get-Content -Path $File -Tail 10 -Wait
		} else {
			# Follow is not enabled, just dump the last 10 lines
			Get-Content -Path $File -Tail 10
		}
	}
}

function Test-Method {
	<#
			.SYNOPSIS
			Check if the given Function is loaded from a given Module

			.DESCRIPTION
			Check if the given Function is loaded from a given Module

			.PARAMETER Module
			Name of the Module

			.PARAMETER Function
			Name of the function

			.EXAMPLE
			PS C:\> Test-Method -Module 'NETX.AD' -Function 'Add-AdThumbnailPhoto'
			True

			Description
			-----------
			Check if the given Function 'Add-AdThumbnailPhoto' is loaded from a
			given Module 'NETX.AD', what it IS.

			.EXAMPLE
			PS C:\> Test-Method -Module 'NETX.AD' -Function 'Test-TCPPort'
			True

			Description
			-----------
			Check if the given Function 'Test-TCPPort' is loaded from a given
			Module 'NETX.AD', what it is NOT.

			.NOTES
			Quick helper function to shortcut things. / MBE

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = 'Name of the Module')]
		[Alias('moduleName')]
		[String]$Module,
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 2,
		HelpMessage = 'Name of the function')]
		[Alias('functionName')]
		[String]$Function
	)

	PROCESS {
		if ($pscmdlet.ShouldProcess("$Function", "Check if loaded from $Module")) {
			((Get-Command -Module $Module |
					Where-Object -FilterScript { $_.Name -eq "$Function" } |
			Measure-Object).Count -eq 1)
		}
	}
}

function Test-ModuleAvailableToLoad {
	<#
			.SYNOPSIS
			Test if the given Module exists

			.DESCRIPTION
			Test if the given Module exists

			.PARAMETER modname
			Name of the Module to check

			.EXAMPLE
			PS C:\> Test-ModuleAvailableToLoad EXISTINGMOD
			True

			Description
			-----------
			This module exists

			.EXAMPLE
			PS C:\> Test-ModuleAvailableToLoad WRONGMODULE
			False

			Description
			-----------
			This Module does not exists

			.EXAMPLE
			$MSOLModname = "MSOnline"
			$MSOLTrue = (Test-ModuleAvailableToLoad $MSOLModName)

			Description
			-----------
			Bit more complex example that put the Boolean in a variable
			for later use.

			.NOTES
			Quick helper function
	#>

	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory,
				HelpMessage = 'Add help message for user',
				ValueFromPipeline,
		Position = 0)]
		[string[]]$modname
	)

	BEGIN {
		# Easy, gust check if it exists
		$modtest = (Get-Module -ListAvailable -Name $modname -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	}

	PROCESS {
		if (-not ($modtest)) {
			Return $False
		} else {
			Return $True
		}
	}
}

function Test-ProxyBypass {
	<#
			.SYNOPSIS
			Testing URLs for Proxy Bypass

			.DESCRIPTION
			If you'd like to find out whether a given URL goes through a proxy or
			is accessed directly

			.PARAMETER url
			URL to check for Proxy Bypass

			.EXAMPLE
			PS C:\> Test-ProxyBypass -url 'https://outlook.office.com'
			True

			Description
			-----------
			Check if the given URL 'https://outlook.office.com' is directly
			accessible, what it IS!

			.EXAMPLE
			PS C:\> Test-ProxyBypass -url 'http://technet.microsoft.com'
			False

			Description
			-----------
			Check if the given URL 'http://technet.microsoft.com' is directly
			accessible, what it is NOT!

			.NOTES
			Initial version of the function

			.Link
			Source: http://powershell.com/cs/blogs/tips/archive/2012/08/14/testing-urls-for-proxy-bypass.aspx

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([bool])]
	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[ValidateNotNullOrEmpty()]
		[Alias('uri')]
		[String]$url = 'http://enatec.io'
	)

	BEGIN {
		# Cleanup
		$WebClient = $null
	}

	PROCESS {
		if ($pscmdlet.ShouldProcess("$url", 'Check if direct access is possible')) {
			$WebClient = (New-Object -TypeName System.Net.WebClient)

			Write-Output -InputObject "$($WebClient.Proxy.IsBypassed($url))"
		}
	}

	END {
		# Cleanup
		$WebClient = $null
	}
}

function Test-RemotePOSH {
	<#
			.SYNOPSIS
			Check if PSRemoting (Remote execution of PowerShell) is enabled on
			a given Host

			.DESCRIPTION
			Check if PSRemoting (Remote execution of PowerShell) is enabled on
			a given Host

			.PARAMETER ComputerName
			Hostname of the System to perform, default is the local system

			.PARAMETER POSHcred
			The credentials to use!

			Default is the credentials that we use for Azure, Exchange...

			.EXAMPLE
			PS C:\> Enable-RemotePOSH -ComputerName 'NXLIMCLN01'
			WARNING: Unable to establish remote session with NXLIMCLN01.

			Description
			-----------
			Check if PSRemoting (Remote execution of PowerShell) is enabled on
			'NXLIMCLN01'. It uses the default credentials (Same that we use to
			administer Exchange Online and Azue)

			.EXAMPLE
			PS C:\> Enable-RemotePOSH -ComputerName 'NXLIMCLN02' -POSHcred (Get-Credential)
			NXLIMCLN02

			Description
			-----------
			Check if PSRemoting (Remote execution of PowerShell) is enabled on
			'NXLIMCLN02'.

			And is asks for the credentials to use.

			.NOTES
			Initial Beta based on an idea of Adrian Rodriguez (adrian@rdrgz.net)

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[string[]]$Computer = ($env:COMPUTERNAME),
		[Parameter(Mandatory,
		HelpMessage = 'The credentials to use! Default is the centials that we use for Azure, Exchange...')]
		[System.Management.Automation.Credential()][pscredential]$POSHcred
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name 'ScriptBlock' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'InvokeArgs' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'Failures' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'Item' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		# Define a dummy ScriptBlock
		$ScriptBlock = { $env:COMPUTERNAME }

		# Define the Argument List
		$InvokeArgs = @{
			ComputerName = $Computer
			ScriptBlock  = $ScriptBlock
		}

		# Do we have credentials?
		if ($null -ne $POSHcred) {
			# Yeah!
			$InvokeArgs.Credential = $POSHcred
		}

		# Try to connect
		Invoke-Command @InvokeArgs -ErrorAction SilentlyContinue -ErrorVariable Failures

		# Loop over the Problems, if we have one... or more?
		ForEach ($Failure in $Failures) {
			# Warn the user
			Write-Warning -Message ('Unable to establish remote session with {0}.' -f $Failure.TargetObject)
		}
	}

	END {
		# Cleanup
		Remove-Variable -Name 'ScriptBlock' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'InvokeArgs' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'Failures' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		Remove-Variable -Name 'Item' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}
}

function Get-Time {
	<#
			.SYNOPSIS
			Timing How Long it Takes a Script or Command to Run

			.DESCRIPTION
			This is a quick wrapper for Measure-Command Cmdlet

			Make the PowerShell a bit more *NIX like

			Everyone ever used Unix or Linux known time ;-)

			.PARAMETER file
			Script or command to execute

			.EXAMPLE
			PS C:\> time new-Bulk-devices.ps1

			Description
			-----------
			Runs the script new-Bulk-devices.ps1 and shows how log it takes
			to execute

			We use the well known Uni* alias here!

			.EXAMPLE
			PS C:\> time Get-Service | Export-Clixml c:\scripts\test.xml

			Description
			-----------
			When you run this command, service information will be saved to
			the file Test.xml

			It also shows how log it takes to execute
			We use the well known Uni* alias here!

			.EXAMPLE
			PS C:\> Get-Time new-Bulk-devices.ps1

			Description
			-----------
			Runs the script new-Bulk-devices.ps1 and shows how log it takes to
			execute

			Makes no sense, instead of Measure-Command we use Get-Time,
			but we need to use this name to make it right ;-)

			.NOTES
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
		HelpMessage = 'Script or command to execute')]
		[ValidateNotNullOrEmpty()]
		[Alias('Command')]
		$File
	)

	PROCESS {
		# Does the file exist?
		if (-not ($File)) {
			# Aw SNAP! That sucks...
			Write-Error -Message 'Error: Input is missing but mandatory...' -ErrorAction Stop
		} else {
			# Measure the execution for you, Sir! ;-)
			Measure-Command -Expression { $File }
		}
	}
}

function Set-FileTime {
	<#
			.SYNOPSIS
			Change file Creation + Modification + Last Access times

			.DESCRIPTION
			The touch utility sets the Creation + Modification + Last Access
			times of files.

			If any file does not exist, it is created with default permissions by
			default.

			To prevent this, please use the -NoCreate parameter!

			.PARAMETER Path
			Path to the File that we would like to change

			.PARAMETER AccessTime
			Change the Access Time Only

			.PARAMETER WriteTime
			Change the Write Time Only

			.PARAMETER CreationTime
			Change the Creation Time Only

			.PARAMETER NoCreate
			Do not create a new file, if the given one does not exist.

			.PARAMETER Date
			Date to set

			.EXAMPLE
			touch foo.txt

			Description
			-----------
			Change the Creation + Modification + Last Access Date/time and if the
			file does not already exist, create it with the default permissions.
			We use the alias touch instead of Set-FileTime to make it more *NIX like

			.EXAMPLE
			Set-FileTime foo.txt -NoCreate

			Description
			-----------
			Change the Creation + Modification + Last Access Date/time if this
			file exists.

			The -NoCreate makes sure, that the file will not be created!

			.EXAMPLE
			Set-FileTime foo.txt -only_modification

			Description
			-----------
			Change only the modification time

			.EXAMPLE
			Set-FileTime foo.txt -only_access

			Description
			-----------
			Change only the last access time

			.EXAMPLE
			dir . -recurse -filter "*.xls" | Set-FileTime

			Description
			-----------
			Change multiple files

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues

			.LINK
			Based on this: http://ss64.com/ps/syntax-touch.html
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
		HelpMessage = 'Path to the File')]
		[String[]]$Path,
		[switch]$AccessTime,
		[switch]$WriteTime,
		[switch]$CreationTime,
		[switch]$NoCreate,
		[datetime]$Date
	)

	PROCESS {
		# Let us test if the given file exists
		if (Test-Path -Path $Path) {
			if ($Path -is [IO.FileSystemInfo]) {
				Set-Variable -Name 'FileSystemInfoObjects' -Value $($Path)
			} else {
				Set-Variable -Name 'FileSystemInfoObjects' -Value $($Path |
					Resolve-Path -ErrorAction SilentlyContinue |
				Get-Item)
			}

			# Now we loop over all objects
			foreach ($fsInfo in $FileSystemInfoObjects) {

				if (($Date -eq $null) -or ($Date -eq '')) {
					$Date = Get-Date
				}

				# Set the Access time
				if ($AccessTime) {
					$fsInfo.LastAccessTime = $Date
				}

				# Set the Last Write time
				if ($WriteTime) {
					$fsInfo.LastWriteTime = $Date
				}

				# Set the Creation time
				if ($CreationTime) {
					$fsInfo.CreationTime = $Date
				}

				# On, no parameter given?
				# We set all time stamps!
				if (-not ($AccessTime -and $ModificationTime -and $CreationTime)) {
					$fsInfo.CreationTime = $Date
					$fsInfo.LastWriteTime = $Date
					$fsInfo.LastAccessTime = $Date
				}
			}
		} elseif (-not $NoCreate) {
			# Let us create the file for ya!
			Set-Content -Path $Path -Value $null
			Set-Variable -Name 'fsInfo' -Value $($Path |
				Resolve-Path -ErrorAction SilentlyContinue |
			Get-Item)

			# OK, now we set the date to the given one
			# We ignore all given parameters here an set all time stamps!
			# If you want to change it, re-run the command!
			if (($Date -ne $null) -and ($Date -ne '')) {
				Set-Variable -Name 'Date' -Value $(Get-Date)
				$fsInfo.CreationTime = $Date
				$fsInfo.LastWriteTime = $Date
				$fsInfo.LastAccessTime = $Date
			}
		}
	}
}

function ConvertTo-UnixDate {
	<#
			.SYNOPSIS
			Convert from DateTime to Unix date

			.DESCRIPTION
			Convert from DateTime to Unix date

			.PARAMETER Date
			Date to convert

			.PARAMETER Utc
			Default behavior is to convert Date to universal time.
			Set this to false to skip this step.

			.EXAMPLE
			PS C:\> ConvertTo-UnixDate -Date (Get-date)
			1458205878

			Description
			-----------
			Convert from UTC DateTime to Unix date

			.EXAMPLE
			PS C:\> ConvertTo-UnixDate -Date (Get-date) -UTC $False
			1458209488

			Description
			-----------
			Convert from non UTC DateTime to Unix date

			.NOTES
			Adopted parts of Warren F. (RamblingCookieMonster)

			.LINK
			Source http://stackoverflow.com/questions/10781697/convert-unix-time-with-powershell
			Source http://powershell.com/cs/blogs/tips/archive/2012/03/09/converting-unix-time.aspx
	#>

	[OutputType([int])]
	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[DateTime]$Date = (Get-Date),
		[Parameter(Position = 1)]
		[bool]$UTC = $True
	)

	BEGIN {
		# Do we use UTC as Time-Zone?
		if ($UTC) {
			$Date = $Date.ToUniversalTime()
		}
	}

	PROCESS {
		$unixEpochStart = (New-Object -TypeName DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc))
		[int]($Date - $unixEpochStart).TotalSeconds
	}
}

function ConvertFrom-UnixDate {
	<#
			.SYNOPSIS
			Convert from Unix time to DateTime

			.DESCRIPTION
			Convert from Unix time to DateTime and make it human readable again

			.PARAMETER Date
			Date to convert, in Unix / Epoch format

			.PARAMETER Utc
			Default behavior is to convert Date to universal time.
			Set this to false to Return local time.

			.EXAMPLE
			PS C:\> ConvertFrom-UnixDate -Date 1458205878
			Thursday, March 17, 2016 9:11:18 AM

			Description
			-----------
			Convert from a given Unix time string to a UTC DateTime format
			Formated based on the local PowerShell Culture!

			.EXAMPLE
			PS C:\> ConvertFrom-UnixDate -Date 1458205878 -UTC $False
			Thursday, March 17, 2016 9:11:18 AM

			Description
			-----------
			Convert from a given Unix time string to a non UTC DateTime format
			Formated based on the local PowerShell Culture!

			.EXAMPLE
			PS C:\> Set-Culture -culture "de-DE" | ConvertFrom-UnixDate -Date 1458205878
			Donnerstag, 17. März 2016 09:11:18

			Description
			-----------
			Use our Set-Culture to dump the info in US English

			.EXAMPLE
			PS C:\> Set-Culture -culture "en-GB" | ConvertFrom-UnixDate -Date 1458205878
			17 March 2016 09:11:18

			Description
			-----------
			Use our Set-Culture to dump the info in plain (UK) English

			.EXAMPLE
			PS C:\>  Set-Culture -culture "fr-CA" | ConvertFrom-UnixDate -Date 1458205878
			17 mars 2016 09:11:18

			Description
			-----------
			Use our Set-Culture to dump the info in Canadian French

			.EXAMPLE
			PS C:\> ConvertFrom-UnixDate -Date (Get-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion' | Select-Object -ExpandProperty InstallDate)
			20. Juli 2015 13:24:00

			Description
			-----------
			Read the Install date of the local system (Unix time string)
			and converts it to a human readable string

			Formated based on the local PowerShell Culture!

			.EXAMPLE
			PS C:\> ConvertFrom-UnixDate -Date (Get-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion' | Select-Object -ExpandProperty InstallDate) | New-TimeSpan | Select-Object -ExpandProperty Days
			431

			Description
			-----------
			Read the Install date (Unix time string) and converts it to DateTime,
			extracts the days

			.NOTES
			Adopted parts of Warren F. (RamblingCookieMonster)

			.LINK
			Source http://stackoverflow.com/questions/10781697/convert-unix-time-with-powershell
			Source http://powershell.com/cs/blogs/tips/archive/2012/03/09/converting-unix-time.aspx
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 0,
		HelpMessage = 'Date to convert, in Unix / Epoch format')]
		[int]$Date,
		[Parameter(Position = 1)]
		[bool]$UTC = $True
	)

	BEGIN {
		# Create the Object
		$unixEpochStart = (New-Object -TypeName DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc))

		# Default is UTC
		$output = ($unixEpochStart.AddSeconds($Date))
	}

	PROCESS {
		# Convert to non UTC?
		if (-not $UTC) {
			# OK, let us use the local time
			$output = ($output.ToLocalTime())
		}
	}

	END {
		# Dump
		Write-Output -InputObject $output
	}
}

function ConvertFrom-UrlEncoded {
	<#
			.SYNOPSIS
			Decodes a UrlEncoded string.

			.DESCRIPTION
			Decodes a UrlEncoded string.

			Input can be either a positional or named parameters of type string or
			an array of strings.

			The Cmdlet accepts pipeline input.

			.PARAMETER InputObject
			A description of the InputObject parameter.

			.EXAMPLE
			PS C:\> ConvertFrom-UrlEncoded 'http%3a%2f%2fwww.d-fens.ch'
			http://www.d-fens.ch

			Description
			-----------
			Encoded string is passed as a positional parameter to the Cmdlet.

			.EXAMPLE
			PS C:\> ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch'
			http://www.d-fens.ch

			Description
			-----------
			Encoded string is passed as a named parameter to the Cmdlet.

			.EXAMPLE
			PS C:\>  ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch', 'http%3a%2f%2fwww.dfch.biz%2f'
			http://www.d-fens.ch
			http://www.dfch.biz/

			Description
			-----------
			Encoded strings are passed as an implicit array to the Cmdlet.

			.EXAMPLE
			PS C:\> ConvertFrom-UrlEncoded -InputObject @("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f")
			http://www.d-fens.ch
			http://www.dfch.biz/

			Description
			-----------
			Encoded strings are passed as an explicit array to the Cmdlet.

			.EXAMPLE
			PS C:\> @("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded
			http://www.d-fens.ch
			http://www.dfch.biz/

			Description
			-----------
			Encoded strings are piped as an explicit array to the Cmdlet.

			.EXAMPLE
			PS C:\> "http%3a%2f%2fwww.dfch.biz%2f" | ConvertFrom-UrlEncoded
			http://www.dfch.biz/

			Description
			-----------
			Encoded string is piped to the Cmdlet.

			.EXAMPLE
			PS C:\> $r = @("http%3a%2f%2fwww.d-fens.ch", 0, "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded
			PS C:\> $r
			http://www.d-fens.ch
			0
			http://www.dfch.biz/

			Description
			-----------
			In case one of the passed strings is not a UrlEncoded encoded string,
			the plain string is returned. The pipeline will continue to execute
			and all strings are returned.

			.LINK
			Online Version: http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertFrom-UrlEncoded/
	#>

	[CmdletBinding(ConfirmImpact = 'None',
			HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertFrom-UrlEncoded/',
	SupportsShouldProcess)]
	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				HelpMessage = 'Add help message for user',
				ValueFromPipeline,
		Position = 0)]
		[ValidateNotNullOrEmpty()]
		$InputObject
	)

	BEGIN {
		Add-Type -AssemblyName System.Web
		$datBegin = [datetime]::Now
		[String]$fn = ($MyInvocation.MyCommand.Name)
		$OutputParameter = $null
	}

	PROCESS {
		foreach ($Object in $InputObject) {
			$fReturn = $False
			$OutputParameter = $null

			$OutputParameter = [Web.HttpUtility]::UrlDecode($InputObject)
			$OutputParameter
		}
		$fReturn = $True
	}

	END {
		$datEnd = [datetime]::Now
	}
}

function ConvertTo-UrlEncoded {
	<#
			.SYNOPSIS
			Encode a string

			.DESCRIPTION
			Encode a string

			.PARAMETER InputObject
			String to encode

			.EXAMPLE
			PS C:\> ConvertTo-UrlEncoded -InputObject 'http://enatec.io'
			http%3a%2f%2fenatec.io

			.NOTES
			Adopted from the ConvertFrom-UrlEncoded command

			.LINK
			ConvertFrom-UrlEncoded
	#>

	[CmdletBinding(ConfirmImpact = 'None',
	SupportsShouldProcess)]
	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user',
				ValueFromPipeline,
				ValueFromPipelineByPropertyName,
		Position = 0)]
		[String]$InputObject
	)

	BEGIN {
		Add-Type -AssemblyName System.Web
		[String]$fn = $MyInvocation.MyCommand.Name
	}

	PROCESS {
		$fReturn = $False
		$OutputParameter = $null

		$OutputParameter = [Web.HttpUtility]::UrlEncode($InputObject)
	}

	END {
		Write-Output -InputObject $OutputParameter
	}
}

function Get-TinyURL {
	<#
			.SYNOPSIS
			Get a Short URL

			.DESCRIPTION
			Get a Short URL using the TINYURL.COM Service

			.PARAMETER URL
			Long URL

			.EXAMPLE
			PS C:\> Get-TinyURL -URL 'http://enatec.io'
			http://tinyurl.com/jfnh8re

			Description
			-----------
			Request the TINYURL for http://enatec.io
			In this example the Return is http://tinyurl.com/jfnh8re

			.NOTES
			Still a beta Version!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = 'Long URL')]
		[ValidateNotNullOrEmpty()]
		[Alias('URL2Tiny')]
		[String]$url
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name 'tinyURL' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		try {
			# Request
			Set-Variable -Name 'tinyURL' -Value $(Invoke-WebRequest -Uri "http://tinyurl.com/api-create.php?url=$url" | Select-Object -ExpandProperty Content)

			# Do we have the TinyURL?
			if (($tinyURL)) {
				# Dump to the Console
				Write-Output -InputObject ('{0}' -f $tinyURL)
			} else {
				# Aw Snap!
				throw
			}
		} catch {
			# Something bad happed
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
		} finally {
			# Cleanup
			Remove-Variable -Name tinyURL -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}
}

function Get-IsGdURL {
	<#
			.SYNOPSIS
			Get a Short URL

			.DESCRIPTION
			Get a Short URL using the IS.GD Service

			.PARAMETER URL
			Long URL

			.EXAMPLE
			PS C:\> Get-IsGdURL -URL 'http://enatec.io'
			http://is.gd/FkMP5v

			Description
			-----------
			Request the IS.GD for http://enatec.io
			In this example the Return is http://is.gd/FkMP5v

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = 'Long URL')]
		[ValidateNotNullOrEmpty()]
		[Alias('URL2GD')]
		[String]$url
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name 'isgdURL' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		try {
			# Request
			Set-Variable -Name 'isgdURL' -Value $(Invoke-WebRequest -Uri "http://is.gd/api.php?longurl=$url" | Select-Object -ExpandProperty Content)

			# Do we have the short URL?
			if (($isgdURL)) {
				# Dump to the Console
				Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
			} else {
				# Aw Snap!
				throw
			}
		} catch {
			# Something bad happed
			Write-Output -InputObject 'Whoopsie... Houston, we have a problem!'
		} finally {
			# Cleanup
			Remove-Variable -Name isgdURL -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}
}

function Get-TrImURL {
	<#
			.SYNOPSIS
			Get a Short URL

			.DESCRIPTION
			Get a Short URL using the TR.IM Service

			.PARAMETER URL
			Long URL

			.EXAMPLE
			PS C:\> Get-TrImURL -URL 'http://enatec.io'

			Description
			-----------
			Request the tr.im for http://enatec.io

			.NOTES
			The service is off line at the moment!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = 'Long URL')]
		[ValidateNotNullOrEmpty()]
		[Alias('URL2Trim')]
		[String]$url
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name 'trimURL' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		try {
			# Request
			Set-Variable -Name 'trimURL' -Value $(Invoke-WebRequest -Uri "http://api.tr.im/api/trim_simple?url=$url" | Select-Object -ExpandProperty Content)

			# Do we have a trim URL?
			if (($trimURL)) {
				# Dump to the Console
				Write-Output -InputObject ('{0}' -f $trimURL)
			} else {
				# Aw Snap!
				throw
			}
		} catch {
			# Something bad happed
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
		} finally {
			# Cleanup
			Remove-Variable -Name trimURL -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}
}

function Get-LongURL {
	<#
			.SYNOPSIS
			Expand a Short URL

			.DESCRIPTION
			Expand a Short URL via the untiny.me
			This service supports all well known short URL services!

			.PARAMETER URL
			Short URL

			.EXAMPLE
			PS C:\> Get-LongURL -URL 'http://cutt.us/KX5CD'
			http://enatec.io

			Description
			-----------
			Get the Long URL (http://enatec.io) for a given Short URL

			.NOTES
			This service supports all well known short URL services!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				Position = 0,
		HelpMessage = 'Short URL')]
		[ValidateNotNullOrEmpty()]
		[Alias('URL2Exapnd')]
		[String]$url
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name 'longURL' -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}

	PROCESS {
		try {
			# Request
			Set-Variable -Name 'longURL' -Value $(Invoke-WebRequest -Uri "http://untiny.me/api/1.0/extract?url=$url&format=text" | Select-Object -ExpandProperty Content)

			# Do we have the long URL?
			if (($longURL)) {
				# Dump to the Console
				Write-Output -InputObject ('{0}' -f $longURL)
			} else {
				# Aw Snap!
				throw
			}
		} catch {
			# Something bad happed
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber)
		} finally {
			# Cleanup
			Remove-Variable -Name longURL -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
		}
	}
}

function Invoke-WordCounter {
	<#
			.SYNOPSIS
			Word, line, character, and byte count

			.DESCRIPTION
			The wc utility displays the number of lines, words, and bytes
			contained in each input file, or standard input (if no file is
			specified) to the standard output.
			A line is defined as a string of characters delimited by a <newline>
			character.
			Characters beyond the final <newline> character will not be
			included in the line count.

			.EXAMPLE
			PS C:\> Invoke-WordCounter

			Description
			-----------
			Word, line, character, and byte count

			.PARAMETER object
			The input File, Object, or Array

			.NOTES
			Make PowerShell a bit more like *NIX!

			TODO: Parameter needs o be fixed (Read from Pipe)

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([int])]
	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')][Alias('File')]
		$Object
	)

	BEGIN {
		# initialize counter for counting number of data from
		$counter = 0
	}

	# Process is invoked for every pipeline input
	PROCESS {
		if ($_) { $counter++ }
	}

	END {
		# if "wc" has an argument passed, ignore pipeline input
		if ($Object) {
			if (Test-Path -Path $Object) {
				(Get-Content -Path $Object | Measure-Object).Count
			} else {
				($Object | Measure-Object).Count
			}
		} else {
			$counter
		}
	}
}

function Invoke-Which {
	<#
			.SYNOPSIS
			Locate a program file in the user's path

			.DESCRIPTION
			Make PowerShell more Uni* like by set an alias to the existing
			Get-Command command let

			.PARAMETER command
			Locate a program file in the path

			.EXAMPLE
			PS C:\> Invoke-Which nuget.exe
			C:\scripts\tools\nuget.exe

			Description
			-----------
			Locate a program file in the user's path

			.EXAMPLE
			PS C:\> which nuget.exe
			C:\scripts\tools\nuget.exe

			Description
			-----------
			Locate a program file in the user's path

			.NOTES
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,
		HelpMessage = 'Locate a program file in the path')]
		[ValidateNotNullOrEmpty()]
		$command
	)

	PROCESS {
		# Easy: Just use Get-Command ;-)
		(Get-Command -All -Name $command).Definition
	}
}

function Invoke-Whoami {
	<#
			.SYNOPSIS
			Shows the windows login info

			.DESCRIPTION
			Make PowerShell a bit more like *NIX! Shows the Login info as you
			might know it from Unix/Linux

			.EXAMPLE
			PS C:\> Invoke-Whoami
			BART\josh

			Description
			-----------
			Login (User) Josh on the system named BART

			.EXAMPLE
			PS C:\> whoami
			BART\josh

			Description
			-----------
			Login (User) Josh on the system named BART

			.NOTES
			Make PowerShell a bit more like *NIX!

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	[CmdletBinding()]
	param ()

	PROCESS {
		# Call the NET function
		[Security.Principal.WindowsIdentity]::GetCurrent().Name
	}
}


function Get-ComputerGPOs {
	<#
			.SYNOPSIS
			Get computer applied group policies

			.DESCRIPTION
			This function shows computer applied group policies as shown inside the EventLog

			.EXAMPLE
			PS C:\> Get-ComputerGPOs
			List of applicable Group Policy objects:

			Local Group Policy

			Description
			-----------
			Get computer applied group policies

			.EXAMPLE
			PS C:\> Get-ComputerGPOs
			List of applicable Group Policy objects:

			Local Group Policy
			Default Domain Policy
			Default Domain Controllers Policy

			Description
			-----------
			Get computer applied group policies

			.EXAMPLE
			PS C:\> Get-ComputerGPOs
			List of applicable Group Policy objects:

			No relevant Microsoft-Windows-GroupPolicy objects found.

			Description
			-----------
			Get computer applied group policies

			.NOTES
			Credits goes to ControlUp by Smart-X
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Filters by Event Id '4004' (workstations) or '4006' (servers) and the computer name
		$Query = "*[System[(EventID='4004') or (EventID='4006')]]"
	}

	PROCESS {
		try {
			# Gets the last (most recent) event matching the criteria by $Query
			$Event = (Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "$Query" -MaxEvents 1 -ErrorAction Stop)
			$ActivityId = $Event.ActivityId.Guid
		} catch {
			Write-Warning -Message "Could not find relevant events in the Microsoft-Windows-GroupPolicy/Operational log. `nThe default log size (4MB) may not be large enough for the volume of data saved in it. Please increase the log size to support older messages."

			# Capture any failure and display it in the error section
			# The Exit with Code 1 shows any calling App that there was something wrong
			break
		}

		try {
			# Looks for Event Id '5312' with the relevant 'Activity Id'
			$Message = (Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "*[System[(EventID='5312')]]" -ErrorAction Stop | Where-Object -FilterScript { $_.ActivityId -eq $ActivityId })
		} catch {
			$Message = (New-Object -TypeName PSObject)
			Add-Member -InputObject $Message -MemberType NoteProperty -Name 'Message' -Value 'No relevant Microsoft-Windows-GroupPolicy objects found.'
		}
	}

	END {
		# Displays the 'Message Property'
		Write-Output -InputObject $Message.Message
	}
}

function Get-UserProfileSize {
	<#
			.SYNOPSIS
			Calculate the user profile folder and sub-folders size

			.DESCRIPTION
			This function runs against the user profile folder and collects information
			about the number of files and file size.

			.EXAMPLE
			PS C:\> Get-UserProfileSize

			Description
			-----------
			Calculate the user profile folder and sub-folders size

			.EXAMPLE
			PS C:\> Get-UserProfileSize| Format-Table -AutoSize
			Description
			-----------
			Calculate the user profile folder and sub-folders size

			.NOTES
			Credits goes to ControlUp by Smart-X
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	[CmdletBinding()]
	param ()

	BEGIN {
		$ProfileRoot = $env:USERPROFILE
		$ItemSizeList = @()
		$ItemList = (Get-ChildItem -Path $ProfileRoot -Force -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property length -Sum -ErrorAction SilentlyContinue)
		$Aggregate = '{0:N2}' -f ($ItemList.sum / 1MB) + " MB `($($ItemList.Count) files`)"
	}

	PROCESS {
		if (Get-Item -Path "$ProfileRoot\Appdata\Local" -ErrorAction SilentlyContinue) {
			$ItemList = (Get-ChildItem -Path $ProfileRoot\Appdata\Local -Force -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property length -Sum -ErrorAction SilentlyContinue)
			$LocalSize = '{0:N2}' -f ($ItemList.sum / 1MB) + ' MB'
		}

		$ItemList = (Get-ChildItem -Path $ProfileRoot -Force -ErrorAction SilentlyContinue |
			Where-Object -FilterScript { $_.PSIsContainer } |
		Sort-Object)
		foreach ($i in $ItemList) {
			$Folder = New-Object -TypeName System.Object
			Add-Member -InputObject $Folder -MemberType NoteProperty -Name 'SubFolder Name' -Value $i.Name
			$Size = $null
			$SubFolderItemList = (Get-ChildItem -Path $i.FullName -Force -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property length -Sum -ErrorAction SilentlyContinue)
			$Size = [decimal]::round($SubFolderItemList.sum / 1MB)
			$FileSC = $SubFolderItemList.count
			Add-Member -InputObject $Folder -MemberType NoteProperty -Name 'Size (MB)' -Value $Size
			Add-Member -InputObject $Folder -MemberType NoteProperty -Name 'File Count' -Value $FileSC
			$ItemSizeList += $Folder
		}

		$ReportObject = (New-Object -TypeName PSObject)
		$ReportObject = ($ItemSizeList | Sort-Object -Property 'Size (MB)' -Descending)
	}

	END {
		Write-Output -InputObject ('Total profile Size: {0}' -f $Aggregate)
		Write-Output -InputObject ('AppData\Local Size: {0}' -f $LocalSize)
		Write-Output -InputObject $ReportObject
	}
}

function Get-GPUserCSE {
	<#
			.SYNOPSIS
			Lists every Group Policy Client Side Extension and their associated
			load time in milliseconds.

			.DESCRIPTION
			This script looks under the 'Group Policy Event Log' and lists every
			applied Group Policy Client Side Extensions.

			.PARAMETER Identity
			Type in the Positional argument of the Down-Level Logon Name (Domain\User)

			.EXAMPLE
			Get-GPUserCSE -Identity 'MyDomain\MyUser'

			CSE Name                  Time(ms) GPOs
			--------                  -------- ----
			Group Policy Registry          531 VSI User-V4, XenApp 6.5 User Env
			Registry                       296 Local Group Policy, Local Group Policy
			Citrix Group Policy            281 Local Group Policy, Local Group Policy
			Scripts                         93 VSI User-V4, VSI System-V4
			Folder Redirection              78 None
			Citrix Profile Management       16 None

			Group Policy Client Side Extensions with an error

			CSE Name                   Time(ms) ErrorCode GPOs
			--------                   -------- --------- ----
			Internet Explorer Branding       16       127 VSI User-V4, VSI System-V4

			.NOTES
			Credits goes to ControlUp by Smart-X
	#>

	Param(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user',
		ValueFromPipelineByPropertyName)]
		[String]
		$Identity
	)

	BEGIN {
		# XPath query used to get EventID id 4001.
		$Query = "*[EventData[Data[@Name='PrincipalSamName'] and (Data='$Identity')]] and *[System[(EventID='4001')]]"
	}

	PROCESS {
		try {
			[array]$Events = (Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "$Query" -ErrorAction Stop)
			$ActivityId = $Events[0].ActivityId.Guid
		} catch {
			Write-Warning -Message "Could not find relevant events in the Microsoft-Windows-GroupPolicy/Operational log.`nThe default log size (4MB) only supports user sessions that logged on a few hours ago.`nPlease increase the log size to support older sessions." -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}

		try {
			# Gets all events that match EventID 4016,5016,6016 and 7016 and correlated with the activity id of EventID 4001.
			$Query = @"
		*[System[(EventID='4016' or EventID='5016' or EventID='6016' or EventID='7016') and Correlation[@ActivityID='{$ActivityId}']]]
"@
			[array]$CSEarray = (Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "$Query" -ErrorAction Stop)
		} catch {
			Write-Warning -Message "Could not find relevant events in the Microsoft-Windows-GroupPolicy/Operational log.`nIt's seems like there are no Client Side Extensions applied to your session." -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}


		$output = @()

		# Run only for for EventID 4016 records.
		foreach ($i in ($CSEarray | Where-Object -FilterScript {$_.Id -eq '4016'})) {
			$obj = (New-Object -TypeName psobject)
			Add-Member -InputObject $obj -MemberType NoteProperty -Name Name -Value ($i.Properties[1] | Select-Object -ExpandProperty Value)
			Add-Member -InputObject $obj -MemberType NoteProperty -Name String -Value (($i.Properties[5] | Select-Object -ExpandProperty Value).trimend("`n") -replace "`n", ', ')

			# Every object in output has CSE Name and String of all the GPO Names.
			$output += $obj
		}
		# Run only for for EventID 5016,6016 and 7016 records.
		foreach ($i in ($CSEarray | Where-Object -FilterScript {$_.Id -ne '4016'})) {
			# Add the duration of the CSE to the object.
			$ReportObject = ($output |
				Where-Object -FilterScript {$_.Name -eq ($i.Properties[2] |
				Select-Object -ExpandProperty Value)} |
				Add-Member -MemberType NoteProperty -Name Time -Value ($i.Properties[0] |
			Select-Object -ExpandProperty Value))
			Write-Output -InputObject $ReportObject

			# Add the ErrorCode to the object
			$ReportObject = ($output |
				Where-Object -FilterScript {$_.Name -eq ($i.Properties[2] |
				Select-Object -ExpandProperty Value)} |
				Add-Member -MemberType NoteProperty -Name ErrorCode -Value ($i.Properties[1] |
			Select-Object -ExpandProperty Value))
			Write-Output -InputObject $ReportObject
		}
	}

	END {
		$TableFormat = @{
			Expression = {$_.Name}
			Label      = 'CSE Name'
		}, @{
			Expression = {$_.Time}
			Label      = 'Time(ms)'
		}, @{
			Expression = {$_.String}
			Label      = 'GPOs'
		}
		$TableFormatWithError = @{
			Expression = {$_.Name}
			Label      = 'CSE Name'
		}, @{
			Expression = {$_.Time}
			Label      = 'Time(ms)'
		}, @{
			Expression = {$_.ErrorCode}
			Label      = 'ErrorCode'
		}, @{
			Expression = {$_.String}
			Label      = 'GPOs'
		}

		$ReportObject = ($output |
			Where-Object -FilterScript {$_.ErrorCode -eq 0} |
			Sort-Object -Property Time -Descending |
		Format-Table -Property $TableFormat -AutoSize -Wrap)
		Write-Output -InputObject $ReportObject

		if (($output.ErrorCode | Measure-Object -Sum).Sum -ne 0) {
			Write-Output -InputObject 'Group Policy Client Side Extensions with an error'
			$ReportObject = ($output |
				Where-Object -FilterScript {$_.ErrorCode -ne 0} |
				Sort-Object -Property Time -Descending |
			Format-Table -Property $TableFormatWithError -AutoSize -Wrap)
			Write-Output -InputObject $ReportObject
		}

		$TotalSeconds = (($output |
				ForEach-Object -Process {$_.Time} |
				Measure-Object -Sum |
		Select-Object -ExpandProperty Sum)/1000)

		$ReportObject = "Total Duration:`t" + '{0:N2}' -f $TotalSeconds + ' Seconds'

		Write-Output -InputObject $ReportObject
	}
}

function Get-CertificateExpiration {
	<#
			.SYNOPSIS
			Certificate Expiration Check

			.DESCRIPTION
			Certificate Expiration Check

			.PARAMETER threshold
			Days the certificates should be valid

			.EXAMPLE
			PS C:\> Get-CertificateExpiration -threshold '200'
			Issuer               Subject                 NotAfter            Expires In (Days)
			------               -------                 --------            -----------------
			CN=CONTOSO-INTERN-CA CN=casrv-01.contoso.com 25.12.2016 18:15:48               156

			Description
			-----------
			Check for certificates expiring within the next '200' days

			.EXAMPLE
			PS C:\> Get-CertificateExpiration | Format-Table -AutoSize
			Issuer               Subject                 NotAfter            Expires In (Days)
			------               -------                 --------            -----------------
			CN=CONTOSO-INTERN-CA CN=casrv-01.contoso.com 25.12.2016 18:15:48               156

			Description
			-----------
			Check for certificates expiring within year (the default) with a formated list
	#>

	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[ValidateNotNullOrEmpty()]
		[int]$threshold = '365'
	)

	BEGIN {
		# Set deadline date
		$deadline = ((Get-Date).AddDays($threshold))
	}

	PROCESS {
		try {
			# Get the certificates
			$Certs = (Get-ChildItem -Path Cert:\LocalMachine\My -ErrorAction Stop |
				Where-Object -FilterScript { $_.notafter -lt $deadline } |
				Select-Object -Property issuer, subject, notafter, @{
					Label      = 'Expires In (Days)'
					Expression = { ($_.NotAfter - (Get-Date)).Days }
			})
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction stop

			# Capture any failure and display it in the error section
			# The Exit with Code 1 shows any calling App that there was something wrong
			exit 1
		} catch {
			# Did not see this one coming!
			Write-Error -Message 'Unable to find certificates.' -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}

	}

	END {
		if ($Certs) {
			Write-Output -InputObject $Certs
		} else {
			Write-Output -InputObject ('There are no certificates expiring in {0} days.' -f $threshold)
		}
	}
}

function Get-MappedDrives {
	<#
			.SYNOPSIS
			Get a list of users mapped network drives

			.DESCRIPTION
			When run against a user session, it will report the drive letter and UNC path of the user's mapped drives.

			.EXAMPLE
			PS C:\> Get-MappedDrives

			Drive                                                       UNC Share
			-----                                                       ---------
			Z:                                                          \\MIASRV09\Home

			Description
			-----------
			Get a list of users mapped network drives

			.EXAMPLE
			PS C:\> Get-MappedDrives | Format-Table -AutoSize

			Drive UNC Share
			----- ---------
			Z:    \\MIASRV09\Home

			Description
			-----------
			Get a formated list of users mapped network drives
	#>

	[CmdletBinding(SupportsShouldProcess)]
	[OutputType([Management.Automation.PSCustomObject])]
	param ()

	PROCESS {
		try {
			$Drives = (Get-WmiObject -Class Win32_MappedLogicalDisk -ErrorAction Stop | Select-Object -Property @{
					Name       = 'Drive'
					Expression = { $_.Name }
				}, @{
					Name       = 'UNC Share'
					Expression = { $_.ProviderName }
			})
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction stop

			# Capture any failure and display it in the error section
			# The Exit with Code 1 shows any calling App that there was something wrong
			exit 1
		} catch {
			# Did not see this one coming!
			Write-Error -Message 'Unable to get mapped drives' -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}
	}

	END {
		if ($Drives -ne $null) {
			Write-Output -InputObject $Drives
		} else {
			Write-Output -InputObject 'No mapped drives present in this user''s session.'
		}
	}
}

function Get-RegistryKeyPropertiesAndValues {
	<#
			.SYNOPSIS
			This function is used here to retrieve registry values while omitting the PS properties

			.DESCRIPTION
			This function is used here to retrieve registry values while omitting the PS properties

			.PARAMETER Path
			Path to check (within the registry)

			.EXAMPLE
			Get-RegistryKeyPropertiesAndValues -path 'HKCU:\Volatile Environment'

			Description
			-----------

			.EXAMPLE
			# Get the user profile path, while escaping special characters because we are going to use the -match operator on it
			$Profilepath = [regex]::Escape($env:USERPROFILE)

			# List all folders
			$RedirectedFolders = (Get-RegistryKeyPropertiesAndValues -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' | Where-Object -FilterScript {$_.RedirectedLocation -notmatch "$Profilepath"})
			if ($RedirectedFolders) {
			$RedirectedFolders
			} else {
			Write-Output -InputObject 'No folders are redirected for this user'
			}

			Description
			-----------
			List redirected user folders

			.LINK
			http://www.ScriptingGuys.com/blog

			.LINK
			http://stackoverflow.com/questions/13350577/can-powershell-get-childproperty-get-a-list-of-real-registry-keys-like-reg-query
	#>

	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
		HelpMessage = 'Path to check (within the registry)')]
		[String]$Path
	)

	BEGIN {
		Push-Location
		Set-Location -Path $Path
	}

	PROCESS {
		Get-Item -Path . |
		Select-Object -ExpandProperty property |
		ForEach-Object -Process {
			New-Object -TypeName psobject -Property @{
				'Folder'           = $_
				'RedirectedLocation' = (Get-ItemProperty -Path . -Name $_).$_
			}
		}
	}

	END {
		Pop-Location
	}
}

function Get-StartupInfo {
	<#
			.SYNOPSIS
			Get all  Programs from the Auto Start

			.DESCRIPTION
			Get all  Programs from the Auto Start

			.EXAMPLE
			PS C:\> Get-StartupInfo

			StartupItems
			------------
			None

			Description
			-----------
			Get all  Programs from the Auto Start, in this case there are none!

			.EXAMPLE
			PS C:\> Get-StartupInfo

			StartupItems
			------------
			AcWin7Hlpr
			EssentialsTrayApp
			HotKeysCmds
			IgfxTray
			LENOVO.TPKNRRES
			Persistence
			SmartAudio

			Description
			-----------
			Get all  Programs from the Auto Start, in this example on a Lenovo ThinkPad

			.NOTES
			Based on Get-SystemStatus by Patrick G (No copyright or license where applied)

			.LINK
			http://poshcode.org/6460
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Cleanup
		$StartupInfoReport = @()

		try {
			# Get the Startup Items
			$StartupInfoItems = @(Get-CimInstance -ClassName Win32_startupCommand | Select-Object -ExpandProperty name -ErrorAction Stop -WarningAction SilentlyContinue)
			# Sort the Info we have
			$StartupInfoItems = ($StartupInfoItems |
				Sort-Object |
			Get-Unique -AsString)
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		} catch {
			Write-Error -Message ('Failed to get Startup Items. The error was: {0}' -f ($Error[0])) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		}
	}

	PROCESS {
		if ($StartupInfoItems) {
			foreach ($StartupInfoItem in $StartupInfoItems) {
				if (($StartupInfoItem -ne 'Sidebar') -and ($StartupInfoItem -ne '')) {
					# Create a new Object
					$retObj = (New-Object -TypeName System.Object)

					# Fill the new object
					Add-Member -InputObject $retObj -MemberType NoteProperty -Name StartupItems -Value $StartupInfoItem

					# Append the Data
					$StartupInfoReport += $retObj
				}
			}
		}

		if (-not ($StartupInfoReport)) {
			# Create a new Object
			$retObj = (New-Object -TypeName System.Object)

			# Fill the new object
			Add-Member -InputObject $retObj -MemberType NoteProperty -Name StartupItems -Value 'None'

			# Append the Data
			$StartupInfoReport += $retObj
		}
	}

	END {
		# Return what we have
		Write-Output -InputObject $StartupInfoReport -NoEnumerate
	}
}

function Get-DriveInfo {
	<#
			.SYNOPSIS
			Get Drive Information

			.DESCRIPTION
			Get Drive Information

			.EXAMPLE
			PS C:\> Get-DriveInfo

			DriveLetter FreeSpaceGB TotalDriveCapacityGB PercentFree
			----------- ----------- -------------------- -----------
			C:                  165                  233          71

			Description
			-----------
			Get Drive Information

			.EXAMPLE
			PS C:\> Get-DriveInfo | Format-List

			DriveLetter          : C:
FreeSpaceGB          : 165
TotalDriveCapacityGB : 233
PercentFree          : 71

			Description
			-----------
			Get Drive Information in a formated list

			.EXAMPLE
			PS C:\> Get-DriveInfo

			DriveLetter FreeSpaceGB TotalDriveCapacityGB PercentFree
			----------- ----------- -------------------- -----------
			C:                  218                  283          77
			D:                 1495                 2048          73
			E:                 1867                 2048          91

			Description
			-----------
			Get Drive Information, Multiple drives


			.EXAMPLE
			PS C:\> Get-DriveInfo | Format-List

			DriveLetter          : C:
			FreeSpaceGB          : 218
			TotalDriveCapacityGB : 283
			PercentFree          : 77

			DriveLetter          : D:
			FreeSpaceGB          : 1495
			TotalDriveCapacityGB : 2048
			PercentFree          : 73

			DriveLetter          : E:
			FreeSpaceGB          : 1863
			TotalDriveCapacityGB : 2048
			PercentFree          : 91

			Description
			-----------
			Get Drive Information in a formated list, Multiple drives

			.NOTES
			Based on Get-SystemStatus by Patrick G (No copyright or license where applied)

			.LINK
			http://poshcode.org/6460
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Cleanup
		$DriveInfoReport = @()

		try {
			# Get the Info
			$Drives = (Get-WmiObject -Query "SELECT * from win32_logicaldisk where DriveType = '3'" -ErrorAction Stop -WarningAction SilentlyContinue)
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		} catch {
			Write-Error -Message ('Failed to get Drive Info. The error was: {0}' -f ($Error[0])) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		}
	}

	PROCESS {
		foreach ($Drive in $Drives) {
			if ($Drive.size -gt 1073741823) {
				# Create a new Object
				$retObj = (New-Object -TypeName System.Object)

				# Fill the new object
				Add-Member -InputObject $retObj -MemberType NoteProperty -Name DriveLetter -Value $($Drive.DeviceID)
				Add-Member -InputObject $retObj -MemberType NoteProperty -Name FreeSpaceGB -Value $($Drive.Freespace / 1GB -as [int])
				Add-Member -InputObject $retObj -MemberType NoteProperty -Name TotalDriveCapacityGB -Value $($Drive.size / 1GB -as [int])
				Add-Member -InputObject $retObj -MemberType NoteProperty -Name PercentFree -Value $(($Drive.Freespace / 1GB -as [int]) / ($Drive.size / 1GB -as [int]) * 100 -as [int])

				# Append the Data
				$DriveInfoReport += $retObj
			}
		}
	}

	END {
		# Dump the Information
		Write-Output -InputObject $DriveInfoReport -NoEnumerate
	}
}

function Get-NetworkCardInfo {
	<#
			.SYNOPSIS
			Get Networking Info

			.DESCRIPTION
			Get Networking Info

			.EXAMPLE
			PS C:\> Get-NetworkCardInfo | Format-List

			NIC            : Intel(R) PRO/1000 MT Network Connection
			DHCPEnabled    : True
			IPAddress      : 10.211.55.5
			DefaultGateway : 10.211.55.1

			Description
			-----------
			Get Networking Info

			.EXAMPLE
			PS C:\> Get-NetworkCardInfo

			NIC                                         DHCPEnabled IPAddress      DefaultGateway
			---                                         ----------- ---------      --------------
			Intel(R) 82567LF Gigabit Network Connection        True 192.168.178.35 {192.168.178.1, fe80::a96:d7ff:feb2:6bcd}

			Description
			-----------
			Get Networking Info

			.EXAMPLE
			PS C:\> Get-NetworkCardInfo | Format-List

			NIC            : Intel(R) 82567LF Gigabit Network Connection
			DHCPEnabled    : True
			IPAddress      : 192.168.178.35
			DefaultGateway : {192.168.178.1, fe80::a96:d7ff:feb2:6bcd}

			Description
			-----------
			Get Networking Info

			.EXAMPLE
			PS C:\> Get-NetworkCardInfo

			NIC                                                 DHCPEnabled IPAddress                       DefaultGateway
			---                                                 ----------- ---------                       --------------
			Intel(R) 82574L Gigabit Netw...                           False 192.168.178.2                   {192.168.178.1, fe80::a96:d7...

			Description
			-----------
			Get Networking Info

			.EXAMPLE
			PS C:\> Get-NetworkCardInfo | Format-List

			NIC            : Intel(R) 82574L Gigabit Network Connection
			DHCPEnabled    : False
			IPAddress      : 192.168.178.2
			DefaultGateway : {192.168.178.1, fe80::a96:d7ff:feb2:6bcd}

			Description
			-----------
			Get Networking Info

			.NOTES
			Based on Get-SystemStatus by Patrick G (No copyright or license where applied)

			.LINK
			http://poshcode.org/6460
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Cleanup
		$NicInfoReport = @()

		try {
			# Get the Info
			$NICs = (Get-WmiObject -Namespace root\CIMV2 -Class Win32_NetworkAdapterConfiguration -ErrorAction Stop -WarningAction SilentlyContinue)
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		} catch {
			Write-Error -Message ('Failed to get Network Card Info. The error was: {0}' -f ($Error[0])) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		}
	}

	PROCESS {
		foreach ($NIC in $NICs) {
			if ($NIC.IPAddress -ne $null) {
				# Create a new Object
				$retObj = (New-Object -TypeName System.Object)

				Add-Member -InputObject $retObj -MemberType NoteProperty -Name NIC -Value $($NIC.description)
				Add-Member -InputObject $retObj -MemberType NoteProperty -Name DHCPEnabled -Value $($NIC.DHCPENABLED)
				Add-Member -InputObject $retObj -MemberType NoteProperty -Name IPAddress -Value $($NIC.IPADDRESS[0])
				Add-Member -InputObject $retObj -MemberType NoteProperty -Name DefaultGateway -Value $($NIC.DefaultIPGateway)

				# Append the Data
				$NicInfoReport += $retObj
			}
		}
	}

	END {
		# Dump the Information
		Write-Output -InputObject $NicInfoReport -NoEnumerate
	}
}

function Get-SystemInfo {
	<#
			.SYNOPSIS
			Get System Information

			.DESCRIPTION
			Get System Information

			.EXAMPLE
			PS C:\> Get-SystemInfo

			SerialNumber       : Not Available
			BIOSManufacturer   : Parallels Software International Inc.
			BIOSVersion        : PRLS   - 1
			ComputerModel      : Parallels Virtual Platform
			SystemType         : x64-based PC
			NumberOfProcessors : 1
			OperatingSystem    : Microsoft Windows 7 Enterprise
			BuildNumber        : 7601
			LastRebootTime     : 2016-08-04 18:31

			Description
			-----------
			Get System Information

			.EXAMPLE
			PS C:\> Get-SystemInfo

			SerialNumber       : Not Available
			BIOSManufacturer   : American Megatrends Inc.
			BIOSVersion        : {WDCorp - 1072009, 4.6.5, American Megatrends - 4028D}
			ComputerModel      : WDBWVL0080KBK-20
			SystemType         : x64-based PC
			NumberOfProcessors : 1
			OperatingSystem    : Microsoft Windows Server 2012 R2 Essentials
			BuildNumber        : 9600
			LastRebootTime     : 2016-07-25 15:00

			Description
			-----------
			Get System Information

			.EXAMPLE
			PS C:\> Get-SystemInfo

			SerialNumber       : Not Available
			BIOSManufacturer   : LENOVO
			BIOSVersion        : {LENOVO - 2160, Ver 1.00PARTTBLX}
			ComputerModel      : 647314G
			SystemType         : x64-based PC
			NumberOfProcessors : 1
			OperatingSystem    : Microsoft Windows 7 Enterprise
			BuildNumber        : 7601
			LastRebootTime     : 2016-07-30 01:13

			Description
			-----------
			Get System Information

			.NOTES
			Based on Get-SystemStatus by Patrick G (No copyright or license where applied)

			.LINK
			http://poshcode.org/6460
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Cleanup
		$SystemInfoReport = @()

		try {
			# Get the relevant information about the System
			$InfoSystemData = (Get-WmiObject -Class win32_systemenclosure -ErrorAction Stop -WarningAction SilentlyContinue)
			$InfoBiosData = (Get-WmiObject -Class win32_bios -ErrorAction Stop -WarningAction SilentlyContinue)
			$InfoComputerModel = (Get-WmiObject -Class Win32_ComputerSystem -ErrorAction Stop -WarningAction SilentlyContinue)
			$InfoOperatingSystemData = (Get-WmiObject -Class Win32_OperatingSystem -ErrorAction Stop -WarningAction SilentlyContinue)
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		} catch {
			Write-Error -Message ('Failed to get System Information. The error was: {0}' -f ($Error[0])) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		}
	}

	PROCESS {
		# Create a new Object
		$retObj = (New-Object -TypeName System.Object)

		<#
				# Fill the new object
		#>

		# Serial Number Information
		if ((-not ($InfoSystemData.SerialNumber)) -or (($InfoSystemData.SerialNumber) -eq ' ') -or (($InfoSystemData.SerialNumber) -eq 'PASS')) {
			# Prevent strange stuff and NULL pointer exceptions
			$SerialNumber = 'Not Available'
		} else {
			# Serial seems to be OK!
			$SerialNumber = $InfoSystemData.SerialNumber
		}

		Add-Member -InputObject $retObj -MemberType NoteProperty -Name SerialNumber -Value $SerialNumber

		# BIOS Manufacturer Information
		Add-Member -InputObject $retObj -MemberType NoteProperty -Name BIOSManufacturer -Value $($InfoBiosData.Manufacturer)

		# BIOS Version information
		Add-Member -InputObject $retObj -MemberType NoteProperty -Name BIOSVersion -Value $($InfoBiosData.BIOSVersion)

		# Computer Model Information
		Add-Member -InputObject $retObj -MemberType NoteProperty -Name ComputerModel -Value $($InfoComputerModel.Model)

		# Computer Type Information
		Add-Member -InputObject $retObj -MemberType NoteProperty -Name SystemType -Value $($InfoComputerModel.SystemType)

		# CPU Information
		Add-Member -InputObject $retObj -MemberType NoteProperty -Name NumberOfProcessors -Value $($InfoComputerModel.NumberOfProcessors)

		# Operating System Information
		Add-Member -InputObject $retObj -MemberType NoteProperty -Name OperatingSystem -Value $($InfoOperatingSystemData.CAPTION)

		# Operating System Build Information
		Add-Member -InputObject $retObj -MemberType NoteProperty -Name BuildNumber -Value $($InfoOperatingSystemData.BuildNumber)

		# Transform the Uptime Info (Yeah, a bit more complex)
		$RebootYear = $InfoOperatingSystemData.lastBootUpTime[0] + $InfoOperatingSystemData.lastBootUpTime[1] + $InfoOperatingSystemData.lastBootUpTime[2] + $InfoOperatingSystemData.lastBootUpTime[3]
		$RebootMonth = $InfoOperatingSystemData.lastBootUpTime[4] + $InfoOperatingSystemData.lastBootUpTime[5]
		$RebootDay = $InfoOperatingSystemData.lastBootUpTime[6] + $InfoOperatingSystemData.lastBootUpTime[7]
		$RebootHour = $InfoOperatingSystemData.lastBootUpTime[8] + $InfoOperatingSystemData.lastBootUpTime[9]
		$RebootMinute = $InfoOperatingSystemData.lastBootUpTime[10] + $InfoOperatingSystemData.lastBootUpTime[11]
		$LastRebootTime = "$RebootYear-$RebootMonth-$RebootDay $RebootHour" + ':' + "$RebootMinute"

		Add-Member -InputObject $retObj -MemberType NoteProperty -Name LastRebootTime -Value $LastRebootTime

		# Append the Data
		$SystemInfoReport += $retObj
	}

	END {
		# Return what we have
		Write-Output -InputObject $SystemInfoReport -NoEnumerate
	}
}

function Get-AntiVirusInfo {
	<#
			.SYNOPSIS
			Get Anti Virus Products and Status

			.DESCRIPTION
			Get Anti Virus Products and Status

			.EXAMPLE
			PS C:\> Get-AntiVirusInfo

			AntiVirusProduct                        DefinitionStatus                        RealTimeProtection
			----------------                        ----------------                        ------------------
			McAfee VirusScan Enterprise             Up to date                              Enabled

			Description
			-----------
			Get Anti Virus Products and Status

			.EXAMPLE
			PS C:\> Get-AntiVirusInfo | fl

			AntiVirusProduct   : McAfee VirusScan Enterprise
			DefinitionStatus   : Up to date
			RealTimeProtection : Enabled

			Description
			-----------
			Get Anti Virus Products and Status as formated list

			.EXAMPLE
			PS C:\> Get-AntiVirusInfo

			WARNING: Make sure that a AntiVirus Product is installed and supported by your plattform!
			Get-AntiVirusInfo : Failed to get AntiVirus Product Info. The error was: Invalid namespace "root\SecurityCenter2"
			At line:71 char:1
			+ Get-AntiVirusInfo
			+ ~~~~~~~~~~~~~~~~~
			+ CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
			+ FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,Get-AntiVirusInfo

			Description
			-----------
			Get Anti Virus Products and Status

			.NOTES
			Based on Get-SystemStatus by Patrick G (No copyright or license where applied)

			.LINK
			http://poshcode.org/6460
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Cleanup
		$AntiVirusProductReport = @()

		try {
			$AntiVirusProductInfo = (Get-WmiObject -Namespace root\SecurityCenter2 -Class AntiVirusProduct -ErrorAction Stop -WarningAction SilentlyContinue)
		} catch {
			Write-Warning -Message 'Make sure that a AntiVirus Product is installed and supported by your plattform!'
			Write-Error -Message ('Failed to get AntiVirus Product Info. The error was: {0}' -f ($Error[0])) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		}
	}

	PROCESS {
		foreach ($AntiVirusProduct in $AntiVirusProductInfo) {
			# Create a new Object
			$retObj = (New-Object -TypeName System.Object)

			# Fill the new object
			Add-Member -InputObject $retObj -MemberType NoteProperty -Name AntiVirusProduct -Value $($AntiVirusProduct.displayname)

			switch ($AntiVirusProduct.productState) {
				'262144' { $DefinitionStatus = 'Up to date'
				$RealTimeProtection = 'Disabled' }
				'262160' { $DefinitionStatus = 'Out of date'
				$RealTimeProtection = 'Disabled' }
				'266240' { $DefinitionStatus = 'Up to date'
				$RealTimeProtection = 'Enabled' }
				'266256' { $DefinitionStatus = 'Out of date'
				$RealTimeProtection = 'Enabled' }
				'393216' { $DefinitionStatus = 'Up to date'
				$RealTimeProtection = 'Disabled' }
				'393232' { $DefinitionStatus = 'Out of date'
				$RealTimeProtection = 'Disabled' }
				'393488' { $DefinitionStatus = 'Out of date'
				$RealTimeProtection = 'Disabled' }
				'397312' { $DefinitionStatus = 'Up to date'
				$RealTimeProtection = 'Enabled' }
				'397328' { $DefinitionStatus = 'Out of date'
				$RealTimeProtection = 'Enabled' }
				'397584' { $DefinitionStatus = 'Out of date'
				$RealTimeProtection = 'Enabled' }
				'397568' { $DefinitionStatus = 'Up to date'
				$RealTimeProtection = 'Enabled' }
				'393472' { $DefinitionStatus = 'Up to date'
				$RealTimeProtection = 'Disabled' }
				default { $DefinitionStatus = 'Unknown'
				$RealTimeProtection = 'Unknown' }
			}

			Add-Member -InputObject $retObj -MemberType NoteProperty -Name DefinitionStatus -Value $DefinitionStatus
			Add-Member -InputObject $retObj -MemberType NoteProperty -Name RealTimeProtection -Value $RealTimeProtection

			# Append the Data
			$AntiVirusProductReport += $retObj
		}
	}

	END {
		# Dump the Information
		Write-Output -InputObject $AntiVirusProductReport -NoEnumerate
	}
}

function Get-DefenderStatusInfo {
	<#
			.SYNOPSIS
			Get Windows Defender Status

			.DESCRIPTION
			Get Windows Defender Status

			.EXAMPLE
			PS C:\> Get-DefenderStatusInfo

			DefenderStatus
			--------------
			Not running

			Description
			-----------
			Get Windows Defender Status

			.EXAMPLE
			PS C:\> Get-DefenderStatusInfo | Format-List

			DefenderStatus : Not running

			Description
			-----------
			Get Windows Defender Status

			.EXAMPLE
			PS C:\> Get-DefenderStatusInfo

			Get-DefenderStatusInfo : Failed to get DefenderStatus Info. The error was: Cannot find any service with service name
			'windefend'.
			At line:41 char:1
			+ Get-DefenderStatusInfo
			+ ~~~~~~~~~~~~~~~~~~~~~~
			+ CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
			+ FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,Get-DefenderStatusInfo

			Description
			-----------
			Get Windows Defender Status

			.NOTES
			Based on Get-SystemStatus by Patrick G (No copyright or license where applied)

			.LINK
			http://poshcode.org/6460
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	[CmdletBinding()]
	param ()

	BEGIN {
		# Cleanup
		$DefenderStatusReport = @()

		try {
			$DefenderStatusInfo = (Get-Service -Name windefend  -ErrorAction Stop -WarningAction SilentlyContinue)
		} catch {
			Write-Error -Message ('Failed to get DefenderStatus Info. The error was: {0}' -f ($Error[0])) -ErrorAction stop

			# Still here? Make sure we are done!
			break
		}
	}

	PROCESS {
		# Create a new Object
		$retObj = (New-Object -TypeName System.Object)

		if ($DefenderStatusInfo.Status -match 'stop') {
			Add-Member -InputObject $retObj -MemberType NoteProperty -Name DefenderStatus -Value 'Not running'
		} else {
			Add-Member -InputObject $retObj -MemberType NoteProperty -Name DefenderStatus -Value 'Running'
		}

		# Append the Data
		$DefenderStatusReport += $retObj
	}

	END {
		# Dump the Information
		Write-Output -InputObject $DefenderStatusReport -NoEnumerate
	}
}

function Test-Port {
	<#
			.SYNOPSIS
			Test ports on computer

			.DESCRIPTION
			Test TCP or UDP ports on computer

			.PARAMETER ComputerName
			The computer name or IP address to query, can be array

			.PARAMETER PortNumber
			Integer value of port to test, default 135 for RPC, can be array

			.PARAMETER TCP
			Test TCP Connection

			.PARAMETER UDP
			Test UDP Connection

			.PARAMETER Timeout
			Time in milliseconds to timeout connection

			.EXAMPLE
			Test-Port localhost

			ComputerName                                                               Port                               Connected
			------------                                                               ----                               ---------
			localhost                                                                   135                                    True

			Description
			-----------
			Checks if TCP port 135 open on localhost

			.EXAMPLE
			Test-Port localhost | fl

			ComputerName : localhost
			Port         : 135
			connected    : True

			Description
			-----------
			Checks if TCP port 135 open on localhost an return a formated list.

			.EXAMPLE
			"MIADOMDC01" | Test-Port

			ComputerName                                                               Port                               Connected
			------------                                                               ----                               ---------
			MIADOMDC01                                                                  135                                    True

			Description
			-----------
			Checks if TCP port 135 open on Server MIADOMDC01

			.EXAMPLE
			Test-Port -ComputerName 'NYCAPPWEB01','NYCAPPWEB02' -Port 80,443 -TCP

			ComputerName                                                               Port                               Connected
			------------                                                               ----                               ---------
			NYCAPPWEB01                                                                  80                                    True
			NYCAPPWEB01                                                                 443                                    True
			NYCAPPWEB02                                                                  80                                    True
			NYCAPPWEB02                                                                 443                                    True

			Description
			-----------
			Checks if TCP ports 80 and 443 are open on 'NYCAPPWEB01' and 'NYCAPPWEB02'

			.EXAMPLE
			Test-Port -ComputerName '10.10.16.17' -PortNumber 161 -UDP

			ComputerName                                                               Port                               Connected
			------------                                                               ----                               ---------
			10.10.16.17.                                                                161                                   False

			Description
			-----------
			Check if UDP port 161 is open on '10.10.16.17'

			.NOTES
			This function contains a lot of work from the following People:
			- Ben H.
			- Chad Miller

			This new function replaced the following:
			- Test-TCPPort
			- Get-TcpPortStatus
			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues

			.LINK
			http://poshcode.org/6442
			http://poshcode.org/2392
	#>

	[CmdletBinding(DefaultParameterSetName = 'TCP',
			ConfirmImpact = 'Low',
	SupportsShouldProcess)]
	[OutputType([Management.Automation.PSCustomObject])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				ValueFromPipelineByPropertyName,
				Position = 0,
		HelpMessage = 'The computer name or IP address to query, can be array')]
		[ValidateNotNullOrEmpty()]
		[Alias('Server', 'target')]
		[String[]]$ComputerName,
		[ValidateNotNullOrEmpty()]
		[Int32[]]$PortNumber = 135,
		[Parameter(ParameterSetName = 'TCP')]
		[switch]$TCP,
		[Parameter(ParameterSetName = 'UDP')]
		[switch]$UDP
	)

	BEGIN {
		# Cleanup
		$TestPortReport = @()
	}

	PROCESS {
		# Loop over the List of targets
		foreach ($Computer in $ComputerName) {
			foreach ($Port in $PortNumber) {
				if ($pscmdlet.ShouldProcess($Computer, ('Testing port {0}' -f $Port))) {
					# Create return object
					$retObj = (New-Object -TypeName psobject)
					Add-Member -InputObject $retObj -MemberType NoteProperty -Name ComputerName -Value $Computer
					Add-Member -InputObject $retObj -MemberType NoteProperty -Name Port -Value $Port

					# TCP handler
					if (($pscmdlet.ParameterSetName) -eq 'TCP') {
						Write-Verbose -Message ('Processing {0} TCP' -f $Computer)

						$sock = (New-Object -TypeName System.Net.Sockets.Socket -ArgumentList $([Net.Sockets.AddressFamily]::InterNetwork), $([Net.Sockets.SocketType]::Stream), $([Net.Sockets.ProtocolType]::Tcp))

						try {
							Write-Verbose -Message ('Open socket to {0}' -f $Port)
							$sock.Connect($Computer, $Port)

							Write-Verbose -Message 'Returning Connection Status'
							Add-Member -InputObject $retObj -MemberType NoteProperty -Name connected -Value $sock.Connected

							Write-Verbose -Message ('Closing socket to {0}' -f $Port)
							$sock.Close()
						} catch {
							Write-Verbose -Message $Error[0]

							Add-Member -InputObject $retObj -MemberType NoteProperty -Name connected -Value $False
						}
					}

					# UDP handler
					if (($pscmdlet.ParameterSetName) -eq 'UDP') {
						$sock = (New-Object -TypeName System.Net.Sockets.Socket -ArgumentList $([Net.Sockets.AddressFamily]::InterNetwork), $([Net.Sockets.SocketType]::Dgram), $([Net.Sockets.ProtocolType]::Udp))

						try {
							Write-Verbose -Message ('Open socket to {0}' -f $Port)
							$sock.Connect($Computer, $Port)

							Write-Verbose -Message 'Returning Connection Status'
							Add-Member -InputObject $retObj -MemberType NoteProperty -Name connected -Value $sock.Connected

							Write-Verbose -Message ('Closing socket to {0}' -f $Port)
							$sock.Close()
						} catch {
							Write-Verbose -Message $Error[0]

							Add-Member -InputObject $retObj -MemberType NoteProperty -Name connected -Value $False
						}
					}

					# Append the Data
					$TestPortReport += $retObj
				}
			}
		}
	}

	END {
		# Dump the Information
		Write-Output -InputObject $TestPortReport -NoEnumerate
	}
}

function Get-SysIPInfo {
	<#
			.SYNOPSIS
			Get information about the IP Configuration

			.DESCRIPTION
			Get information about the IP Configuration

			The following Info will be reported:
			IP Address
			Subnet
			Gateway
			DNS servers
			MAC address

			.PARAMETER ComputerName
			One or more computers to check.
			The default is the local computer.

			.EXAMPLE
			PS C:\> Get-SysIPInfo

			ComputerName  : JHW7PSDEV
			IPAddress     : 10.211.55.5
			SubnetMask    : 255.255.255.0
			Gateway       : 10.211.55.1
			IsDHCPEnabled : True
			DNSServers    : 10.211.55.1
			MACAddress    : 00:1C:42:39:9F:6E
			Description
			-----------
			Get information about the IP Configuration with DHCP enabled

			.NOTES
			Found the basic idea somewhere on the Internet.
			Have no (more) idea where and when it was :-(

			SORRY for stealing the idea without any pride!

			TODO: Any idea how to get rid of the WMI call?
	#>

	[OutputType([psobject])]
	param
	(
		[Parameter(ValueFromPipeline,
		ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[string[]]$ComputerName = $env:COMPUTERNAME
	)

	BEGIN {
		# Cleanup
		$SysIPInfoReport = $null
		$SysIPInfo = $null

		# Create an empty Object
		$SysIPInfoReport = @()
	}

	PROCESS {
		foreach ($Computer in $ComputerName) {
			if (Test-Connection -ComputerName $Computer -Count 1 -ErrorAction 0) {
				try {
					$Networks = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer -ErrorAction Stop | Where-Object -FilterScript { $_.IPEnabled })
				} catch {
					Write-Warning -Message ('Unable to querying {0}' -f $Computer) -WarningAction Continue
				}

				foreach ($Network in $Networks) {
					# Create a Temp Object
					$SysIPInfo = (New-Object -TypeName PSObject)

					# Add the Values to the new Temp Object
					Add-Member -InputObject $SysIPInfo -MemberType NoteProperty -Name ComputerName -Value $($Computer.ToUpper())
					Add-Member -InputObject $SysIPInfo -MemberType NoteProperty -Name IPAddress -Value $(if ($Network.IpAddress[0]) { $Network.IpAddress[0] } else { 'Unknown' })
					Add-Member -InputObject $SysIPInfo -MemberType NoteProperty -Name SubnetMask -Value $(if ($Network.IPSubnet[0]) { $Network.IPSubnet[0] } else { 'Unknown' })
					Add-Member -InputObject $SysIPInfo -MemberType NoteProperty -Name Gateway -Value $(if ($Network.DefaultIPGateway) { $Network.DefaultIPGateway } else { 'Unknown' })
					Add-Member -InputObject $SysIPInfo -MemberType NoteProperty -Name IsDHCPEnabled -Value $(if ($Network.DHCPEnabled) { $True } else { $False })
					Add-Member -InputObject $SysIPInfo -MemberType NoteProperty -Name DNSServers -Value $(if ($Network.DNSServerSearchOrder) { $Network.DNSServerSearchOrder } else { 'Unknown' })
					Add-Member -InputObject $SysIPInfo -MemberType NoteProperty -Name MACAddress -Value $(if ($Network.MACAddress) { $Network.MACAddress } else { 'Unknown' })

					# Append the Info
					$SysIPInfoReport += $SysIPInfo
				}
			}
		}
	}

	END {
		# Dump the Info to the Screen
		Write-Output -InputObject $SysIPInfoReport -NoEnumerate
	}
}

function Set-FullRightsForUser {
	<#
			.SYNOPSIS
			Grant FullControl Permission to User or Group on File or Folder

			.DESCRIPTION
			Grant FullControl Permission to User or Group on File or Folder

			.PARAMETER File
			Please specify one, or more, File or directories

			.PARAMETER Identity
			Please specify one, or more, User- or Group-Names

			.EXAMPLE
			PS C:\> Set-FullRightsForUser -File 'C:\temp\foo\ADPassMon.app.zip' -Identity 'Josh'

			Josh has now FullControl Permission for C:\temp\foo\ADPassMon.app.zip

			Description
			-----------
			Grant FullControl Permission for 'C:\temp\foo\ADPassMon.app.zip' to User 'Josh'

			.EXAMPLE
			PS C:\> Set-FullRightsForUser -File 'C:\temp\foo\ADPassMon.app.zip' -Identity 'Josh' -WhatIf

			What if: Performing the operation "Grant FullControl Permission to josh" on target "C:\temp\foo\ADPassMon.app.zip".

			Description
			-----------
			Dry Run: Grant FullControl Permission for 'C:\temp\foo\ADPassMon.app.zip' to User 'Josh'

			.EXAMPLE
			PS C:\> Set-FullRightsForUser -File 'C:\temp\bar\ADPassMon.app.zip' -Identity 'Josh'

			WARNING: No such File or Directory: C:\temp\bar\ADPassMon.app.zip

			Description
			-----------
			The given File 'C:\temp\bar\ADPassMon.app.zip' does NOT exist!

			.NOTES
			Internal Helper function
	#>

	[CmdletBinding(ConfirmImpact = 'Medium',
	SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 1,
		HelpMessage = 'Please specify one, or more, Files or directories')]
		[Alias('File', 'directory', 'directories')]
		[string[]]$files,
		[Parameter(Mandatory,
				ValueFromPipeline,
				Position = 2,
		HelpMessage = 'Please specify one, or more, User- or Group-Names')]
		[Alias('User', 'UserName', 'Group', 'GroupName')]
		[string]$Identity
	)

	BEGIN {
		# Creates the new ACL Object
		$FullControlPermission = (New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList ($Identity, 'FullControl', 'Allow'))
	}

	PROCESS {
		# Loop over the given Files
		foreach ($File in $files) {
			# Want to do a Dry Run?
			if ($pscmdlet.ShouldProcess("$File", "Grant FullControl Permission to $Identity")) {
				# Does the file exist?
				if (Test-Path -Path $File) {
					try {
						# Get the existing ACL
						$ACLAttribute = (Get-Acl -Path $File -ErrorAction stop)

						Write-Debug -Message ('Existing ACL for {0} = {1}' -f $File, $ACLAttribute.Access)

						# Set the new ACL
						$ACLAttribute.SetAccessRule($FullControlPermission)

						# Apply the new ACL
						$null = (Set-Acl -Path $File -AclObject $ACLAttribute -ErrorAction stop)

						# Get the existing ACL
						$ACLAttributeNew = (Get-Acl -Path $File -ErrorAction stop)

						Write-Debug -Message ('New ACL for {0} = {1}' -f $File, $ACLAttributeNew.Access)

						# Inform about it
						Write-Output -InputObject ('{0} has now FullControl Permission for {1}' -f $Identity, $File)
					} catch {
						# Something went wrong!
						Write-Warning -Message ('Unable to set FullControl Permission for {0} on {1}' -f $Identity, $File)
					}
				} else {
					# Whoopsie... A classic 404
					Write-Warning -Message ('No such File or Directory: {0}' -f $File)
				}
			}
		}
	}
}

function Get-FailedServicesInfo {
	<#
			.SYNOPSIS
			Find failed Services and give a human readable info about the failure

			.DESCRIPTION
			Find failed Services and give a human readable info about the failure

			.PARAMETER ComputerName
			One, or more, computers to check. The default is the local host.

			.EXAMPLE
			PS C:\> Get-FailedServicesInfo

			ComputerName : DEFFMDC01
			Service      : RaMgmtSvc
			Startmode    : Auto
			State        : Stopped
			Exitcode     : 1075
			Message      : The dependency service does not exist or has been marked for deletion.

			ComputerName : DEFFMDC01
			Service      : WseEmailSvc
			Startmode    : Auto
			State        : Stopped
			Exitcode     : 1067
			Message      : The process terminated unexpectedly.

			Description
			-----------
			Find failed Services and give a human readable info about the failure

			.EXAMPLE
			PS C:\> Get-FailedServicesInfo | Format-Table -AutoSize

			ComputerName Service     Startmode State   Exitcode Message
			------------ -------     --------- -----   -------- -------
			DEFFMDC01    RaMgmtSvc   Auto      Stopped     1075 The dependency service does not exist or has been marked for deletion.
			DEFFMDC01    WseEmailSvc Auto      Stopped     1067 The process terminated unexpectedly.

			Description
			-----------
			Find failed Services and give a human readable info about the failure
			Get it as a formated Table

			.EXAMPLE
			PS C:\> Get-FailedServicesInfo -ComputerName 'DEFFMDC01' | Format-Table -AutoSize

			ComputerName Service     Startmode State   Exitcode Message
			------------ -------     --------- -----   -------- -------
			DEFFMDC01    RaMgmtSvc   Auto      Stopped     1075 The dependency service does not exist or has been marked for deletion.
			DEFFMDC01    WseEmailSvc Auto      Stopped     1067 The process terminated unexpectedly.

			Description
			-----------
			Find failed Services and give a human readable info about the failure
			This time we execute it on a remote system.

			.NOTES
			TODO: Optimize the calls to gain more speed!
	#>

	[OutputType([psobject])]
	param
	(
		[Parameter(ValueFromPipeline,
		Position = 1)]
		[string[]]$ComputerName = $env:COMPUTERNAME
	)

	BEGIN {
		# Cleanup
		$FailedServiceInfo = $null
		$Computer = $null
		$SingleService = $null
		$AllServices = $null

		# Create a new Reporting Object
		$FailedServiceInfo = @()
	}

	PROCESS {

		foreach ($Computer in $ComputerName) {
			if (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {
				try {
					# Cleanup
					$AllServices = $null


					# Get all Stopped Services
					# TODO: Any idea how to get rid of the SMI call here?
					$AllServices = (Get-WmiObject -Class Win32_Service -Filter "State='Stopped'" -ComputerName $Computer -ErrorAction Stop -WarningAction Continue)

					# Loop over all Services we found above
					foreach ($SingleService in $AllServices) {
						if (!(($SingleService.exitcode -eq 0) -or ($SingleService.exitcode -eq 1077))) {
							# Cleanup
							$ExitCodeInfo = $null

							# Get the Error Details.
							# TODO: Is there a better way to get this?
							$ExitCodeInfo = (& "$env:windir\system32\net.exe" helpmsg $($SingleService.Exitcode))

							# Create a new Temp Object
							$retObj = New-Object -TypeName PSObject -Property @{
								ComputerName = $($Computer)
							}

							# Append info to the new Temp Object
							Add-Member -InputObject $retObj -MemberType NoteProperty -Name Service -Value $(if ($SingleService.Name) { $SingleService.Name } else { 'Unknown' })
							Add-Member -InputObject $retObj -MemberType NoteProperty -Name Startmode -Value $(if ($SingleService.Startmode) { $SingleService.Startmode } else { 'Unknown' })
							Add-Member -InputObject $retObj -MemberType NoteProperty -Name State -Value $(if ($SingleService.State) { $SingleService.State } else { 'Unknown' })
							Add-Member -InputObject $retObj -MemberType NoteProperty -Name Exitcode -Value $(if ($SingleService.Exitcode) { $SingleService.Exitcode } else { 'Unknown' })
							Add-Member -InputObject $retObj -MemberType NoteProperty -Name Message -Value $(if ($ExitCodeInfo[1]) { $ExitCodeInfo[1] } else { 'Unknown' })

							# Append the Temp Object to the Report
							$FailedServiceInfo += $retObj
						}
					}
				} catch {
					# Whoopsie... Something went wrong here!
					Write-Error -Message 'Unable query service status' -WarningAction Continue
				}
			} else {
				# Dead computer!
				Write-Error -Message ('{0} is not reachable!' -f $Computer) -WarningAction Continue
			}
		}
	}

	END {
		# DUMP the Report
		Write-Output -InputObject $FailedServiceInfo -NoEnumerate
	}
}
function Test-NetworkConnection {
	<#
			.SYNOPSIS
			Check if the System have a working Network connection

			.DESCRIPTION
			Check if the System have a working Network connection.
			An optional Test for a working Internet Connection is also possible.

			.PARAMETER Internet
			Also check the Internet connectivity.

			.EXAMPLE
			PS C:\> Test-NetworkConnection

			NetworkAvailible InternetAccess
			---------------- --------------
			            True unchecked

			Description
			-----------
			Check if the System have a working Network connection

			.EXAMPLE
			PS C:\> Test-NetworkConnection | Format-List

			NetworkAvailible : True
			InternetAccess   : unchecked

			Description
			-----------
			Check if the System have a working Network connection.
			Report as List instead of a table

			.EXAMPLE
			PS C:\> Test-NetworkConnection -Internet

			NetworkAvailible InternetAccess
			---------------- --------------
			            True           True

			Description
			-----------
			Check if the System have a working Network connection.
			Also check the Internet connectivity.

			.EXAMPLE
			PS C:\> Test-NetworkConnection -Internet | Format-List

			NetworkAvailible : True
			InternetAccess   : True

			Description
			-----------
			Check if the System have a working Network connection
			Also check the Internet connectivity. Report as List instead of a table

			.LINK
			http://msdn.microsoft.com/en-us/library/vstudio/system.net.networkinformation.networkinterface

			.NOTES
			TODO: Find a better way for older systems to figure out if they have a working internet connection.
	#>

	[OutputType([PSObject])]
	[CmdletBinding()]
	param
	(
		[switch]$Internet
	)

	BEGIN {
		# Cleanup
		$NetworksStatusReport = $null
		$NetworkAvailable = $null
		$InternetStatus = $null
	}

	PROCESS {
		# Get all Infos we need
		if ([Net.NetworkInformation.NetworkInterface]::GetIsNetworkAvailable()) {
			$NetworkAvailable = $True
			if ($Internet) {
				try {
					# Needs Windows 8.1, or newer!
					Write-Debug -Message 'Use DotNET to figure out if we have Internet Access'
					$null = ([Windows.Networking.Connectivity.NetworkInformation, Windows, ContentType = WindowsRuntime])
					$InternetStatus = ([Windows.Networking.Connectivity.NetworkInformation]::GetInternetConnectionProfile().GetNetworkConnectivityLevel())
					if ($InternetStatus -eq 'InternetAccess') {
						$InternetStatus = $True
					} else {
						$InternetStatus = $False
					}
				} catch {
					# Fall back and try a old school ping (Will not work in every enterprise environment)
					# TODO: Is there another way to find the info on older systems?
					Write-Debug -Message 'Try to ping the Google Nameserver by IP'
					$InternetStatus = (Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet)
				}

			} else {
				$InternetStatus = 'unchecked'
			}
		} else {
			$NetworkAvailable = $False
		}

		# Create a new Object
		$NetworksStatusReport = (New-Object -TypeName PSObject)
		Add-Member -InputObject $NetworksStatusReport -MemberType NoteProperty -Name NetworkAvailible -Value $(if ($NetworkAvailable) { $NetworkAvailable } else { 'Unknown' })
		Add-Member -InputObject $NetworksStatusReport -MemberType NoteProperty -Name InternetAccess -Value $(if ($InternetStatus) { $InternetStatus } else { 'Unknown' })
	}

	END {
		# DUMP the Info
		Write-Output -InputObject $NetworksStatusReport -NoEnumerate
	}
}

function Get-TCPConnectionsActive {
	<#
			.SYNOPSIS
			Get a list of active TCP connections

			.DESCRIPTION
			Get a list of active TCP connections

			.EXAMPLE
			PS C:\> Get-TCPConnectionsActive

			LocalAddress  : 10.211.55.5
			LocalPort     : 54076
			RemoteAddress : 216.58.214.99
			RemotePort    : 443
			Status        : Established
			Version       : IPv4

			Description
			-----------
			Get a list of active TCP connections

			.EXAMPLE
			PS C:\> Get-TCPConnectionsActive | Format-Table -AutoSize

			LocalAddress                LocalPort RemoteAddress               RemotePort      Status Version
			------------                --------- -------------               ----------      ------ -------
			fe80::8b3:b8b3:d593:ad94%12     64523 fe80::8b3:b8b3:d593:ad94%12       6602 Established IPv6

			Description
			-----------
			Get a list of active TCP connections

			.LINK
			https://msdn.microsoft.com/en-us/library/system.net.networkinformation.ipglobalproperties.getactivetcpconnections(v=vs.110).aspx

			.LINK
			Get-TCPConnectionsListening

			.NOTES
			TODO: Try to find a alternative to the DotNET with native PowerShell
	#>

	BEGIN {
		# Cleanup
		$Netstats = $null
	}

	PROCESS {
		try {
			$TCPProperties = ([Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties())
			$Connections = ($TCPProperties.GetActiveTcpConnections())

			foreach ($Connection in $Connections) {
				if ($Connection.LocalEndPoint.AddressFamily -eq 'InterNetwork') {
					$IPType = 'IPv4'
				} else {
					$IPType = 'IPv6'
				}

				# Create a new Object
				$Netstats = (New-Object -TypeName PSobject)

				# Fill the info to the new Object
				Add-Member -InputObject $Netstats -MemberType NoteProperty -Name 'LocalAddress' -Value $(if ($Connection.Address) { $Connection.Address } elseif ($Connection.Address -eq '::' ) { 'Loopback' } else { 'Unknown' })
				Add-Member -InputObject $Netstats -MemberType NoteProperty -Name 'LocalPort' -Value $(if ($Connection.LocalEndPoint.Port) { $Connection.LocalEndPoint.Port } else { 'Unknown' })
				Add-Member -InputObject $Netstats -MemberType NoteProperty -Name 'RemoteAddress' -Value $(if ($Connection.RemoteEndPoint.Address) { $Connection.RemoteEndPoint.Address } else { 'Unknown' })
				Add-Member -InputObject $Netstats -MemberType NoteProperty -Name 'RemotePort' -Value $(if ($Connection.RemoteEndPoint.Port) { $Connection.RemoteEndPoint.Port } else { 'Unknown' })
				Add-Member -InputObject $Netstats -MemberType NoteProperty -Name 'Status' -Value $(if ($Connection.State) { $Connection.State } else { 'Unknown' })
				Add-Member -InputObject $Netstats -MemberType NoteProperty -Name 'Version' -Value $(if ($IPType) { $IPType } else { 'Unknown' })
			}
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		} catch {
			Write-Error -Message 'Unable to get the TCP connection info.' -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}
	}

	END {
		# DUMP the Info
		Write-Output -InputObject $Netstats -NoEnumerate
	}
}

function Get-TCPConnectionsListening {
	<#
			.SYNOPSIS
			Get a list of listening TCP ports and connections

			.DESCRIPTION
			Get a list of listening TCP ports and connections

			.EXAMPLE
			PS C:\> Get-TCPConnectionsListening

			LocalAddress                ListeningPort Version
			------------                ------------- -------
			fe80::8b3:b8b3:d593:ad94%12            53 IPv6

			Description
			-----------
			Get a list of listening TCP ports and connections

			.EXAMPLE
			PS C:\> Get-TCPConnectionsListening | Format-List

			LocalAddress  : Loopback
			ListeningPort : 49196
			Version       : IPv6

			Description
			-----------
			Get a list of listening TCP ports and connections

			.LINK
			https://msdn.microsoft.com/en-us/library/system.net.networkinformation.ipglobalproperties.getactivetcpconnections(v=vs.110).aspx

			.LINK
			Get-TCPConnectionsActive

			.NOTES
			TODO: Try to find a alternative to the DotNET with native PowerShell
	#>

	BEGIN {
		# Cleanup
		$Netstats = $null
	}

	PROCESS {
		try {
			$TCPProperties = [Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
			$Connections = $TCPProperties.GetActiveTcpListeners()
			foreach ($Connection in $Connections) {
				if ($Connection.LocalEndPoint.AddressFamily -eq 'InterNetwork') {
					$IPType = 'IPv4'
				} else {
					$IPType = 'IPv6'
				}

				# Create a new Object
				$Netstats = (New-Object -TypeName PSobject)

				Add-Member -InputObject $Netstats -MemberType NoteProperty -Name 'LocalAddress' -Value $(if ($Connection.Address) { if ($Connection.Address -eq '::') { 'Loopback' } else { $Connection.Address } } else { 'Unknown' })
				Add-Member -InputObject $Netstats -MemberType NoteProperty -Name 'ListeningPort' -Value $(if ($Connection.Port) { $Connection.Port } else { 'Unknown' })
				Add-Member -InputObject $Netstats -MemberType NoteProperty -Name 'Version' -Value $(if ($IPType) { $IPType } else { 'Unknown' })
			}
		} catch [System.Exception] {
			Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		} catch {
			Write-Error -Message 'Unable to get the TCP connection info.' -ErrorAction Stop

			# Still here? Make sure we are done!
			break
		}
	}

	END {
		# DUMP the Info
		Write-Output -InputObject $Netstats -NoEnumerate
	}
}

function Get-UserType {
	<#
			.SYNOPSIS
			Is the actual User a local or a domain user?

			.DESCRIPTION
			Is the actual User a local or a domain user?

			.EXAMPLE
			PS C:\> Get-UserType

			Type
			----
			Local

			Description
			-----------
			Is the actual User a local or a domain user?

			.EXAMPLE
			PS C:\> Get-UserType

			Type
			----
			Domain

			Description
			-----------
			Is the actual User a local or a domain user?

			.EXAMPLE
			PS C:\> (Get-UserType).Type
			Domain

			Description
			-----------
			Is the actual User a local or a domain user?

			.EXAMPLE
			if (((Get-UserType).Type) -eq 'Domain') {
			# Do something for a Domain User
			} elseif (((Get-UserType).Type) -eq 'Local') {
			# Do something for a Local User
			} else {
			Write-Error -Message 'Unknown User'
			break
			}

			Description
			-----------
			Use the function to control things based on the user type.

			.NOTES
			Internal Helper function
	#>

	[OutputType([PSObject])]
	[CmdletBinding()]
	param ()

	#Import Assembly
	Add-Type -AssemblyName System.DirectoryServices.AccountManagement

	$UserPrincipal = [DirectoryServices.AccountManagement.UserPrincipal]::Current

	if ($UserPrincipal.ContextType -eq 'Machine') {
		$UserType = New-Object -TypeName PSObject -Property @{
			Type = 'Local'
		}
	} elseif ($UserPrincipal.ContextType -eq 'Domain') {
		$UserType = New-Object -TypeName PSObject -Property @{
			Type = 'Domain'
		}
	}

	# DUMP the Report
	Write-Output -InputObject $UserType -NoEnumerate
}
#endregion Functions

#region ExportModuleStuff

# Get public function definition files.
if (Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public')) {
	$Public = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public') -Recurse -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |
		Where-Object -FilterScript { $_.psIsContainer -eq $False } |
		Where-Object -FilterScript { $_.Name -like '*.ps1' } |
	Where-Object -FilterScript { $_.Name -ne '.Tests.' })

	# Dot source the files
	foreach ($Import in @($Public)) {
		try {
			. $Import.fullname
		} catch {
			Write-Error -Message ('Failed to import Public function {0}: {1}' -f $Import.fullname, $_)
		}
	}
}

if ($LoadingModule) {
	Export-ModuleMember -Function '*' -Alias '*' -Cmdlet '*' -Variable '*'
}

if (Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Private')) {
	# Get public and private function definition files.
	$Private = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Private') -Recurse -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |
		Where-Object -FilterScript { $_.psIsContainer -eq $False } |
		Where-Object -FilterScript { $_.Name -like '*.ps1' } |
	Where-Object -FilterScript { $_.Name -ne '.Tests.' })

	foreach ($Import in @($Private)) {
		try {
			. $Import.fullname
		} catch {
			Write-Error -Message ('Failed to import Private function {0}: {1}' -f $Import.fullname, $_)
		}
	}
}

# End the Module Loading Mode
$LoadingModule = $False

# Return to where we are before we start loading the Module
Pop-Location

#endregion ExportModuleStuff

<#
		Execute some stuff here
#>
