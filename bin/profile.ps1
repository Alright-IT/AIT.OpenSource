#!/usr/bin/env powershell

#requires -Version 3.0

#region Info
<#
		Support: https://github.com/Alright-IT/AIT.OpenSource/issues
#>
#endregion Info

#region License
<#
		Copyright (c) 2016, Alright-IT GmbH
		All rights reserved.

		Redistribution and use in source and binary forms, with or without
		modification, are permitted provided that the following conditions are met:

		1. Redistributions of source code must retain the above copyright notice,
		this list of conditions and the following disclaimer.

		2. Redistributions in binary form must reproduce the above copyright notice,
		this list of conditions and the following disclaimer in the documentation
		and/or other materials provided with the distribution.

		3. Neither the name of the copyright holder nor the names of its contributors
		may be used to endorse or promote products derived from this software without
		specific prior written permission.

		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
		AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
		IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
		ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
		LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
		DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
		OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
		CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
		OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
		OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

		By using the Software, you agree to the License, Terms and Conditions above!
#>

<#
		This is a third party Software!

		The developer of this Software is NOT sponsored by or affiliated with
		Microsoft Corp (MSFT) or any of it's subsidiaries in any way

		The Software is not supported by Microsoft Corp (MSFT)!

		More about Alright-IT GmbH http://www.alright-it.com & http://www.aitlab.de
#>
#endregion License

<#
		.SYNOPSIS
		PowerShell Profile Example

		.DESCRIPTION
		Alright-IT example Profile Script for PowerShell Session Login

		Again, this is just an example,
		you might want to adopt a few things for yourself.

		.NOTES
		This is just an example!
		It contains some stuff that we at Alright-IT find useful to have, you can and should customize this profile to fit to your custom needs!

		Please note:
		If you get the Alright-IT PowerShell Toolbox distribution, you will get this file with every release, so please rename yours!

		.LINK
		Support Site https://github.com/Alright-IT/AIT.OpenSource/issues

		.LINK
		http://www.alright-it.com

		.LINK
		http://www.aitlab.de
#>

[CmdletBinding()]
param ()

function global:Get-IsWin10 
{
	# For some Workarounds!
	if ([Environment]::OSVersion.Version -ge (New-Object -TypeName 'Version' -ArgumentList 10, 0)) {Return $True} else {Return $False}
}

# Make this Shell clean!
function Clear-AllVariables 
{
	# Delete all variables that exists
	$null = (Remove-Variable -Name * -Scope Local -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	$null = (Remove-Variable -Name * -Scope Local -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)

	$null = (Remove-Variable -Name * -Scope Script -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	$null = (Remove-Variable -Name * -Scope Script -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)

	$null = (Remove-Variable -Name * -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	$null = (Remove-Variable -Name * -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
}

Clear-AllVariables

# By default, when you import Microsoft's ActiveDirectory PowerShell module which
# ships with Server 2008 R2 (or later) and is a part of the free RSAT tools,
# it will import AD command lets and also install an AD: PowerShell drive.
#
# If you do not want to install that drive set the variable to 0
$env:ADPS_LoadDefaultDrive = 1

# Resetting Console Colors
[Console]::ResetColor()

# Get the Mode?
if ((Get-Command -Name Set-RunEnv -ErrorAction SilentlyContinue)) 
{
	# Use our Core Module command
	Set-RunEnv
}
else 
{
	# Enforce Terminal as Mode!
	Set-Variable -Name RunEnv -Scope Global -Value $('Terminal')
}

# This is our Base location
Set-Variable -Name BasePath -Scope Global -Value $('c:/scripts/PowerShell')

$IsNewModuleAvailable = (Get-Module -Name 'AIT.OpenSource' -ListAvailable)

if ($IsNewModuleAvailable) 
{
	if ((Get-Module -Name 'AIT.OpenSource')) {$null = (Remove-Module -Name 'AIT.OpenSource' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)}

	$null = (Import-Module -Name 'AIT.OpenSource' -Force -DisableNameChecking -NoClobber -Global)
}
else 
{
	Write-Warning -Message 'Unable to find the Alright-IT Open Source PowerShell Module. Makes absolute no sense to continue!!!'

	break
}

# Make em English!
if ((Get-Command -Name Set-Culture -ErrorAction SilentlyContinue)) 
{
	try {Set-Culture -Culture 'en-US'} catch 
	{
		# Do nothing!
		Write-Debug -Message 'We had an Error'
	}
}

#region WorkAround

# Search for all Alright-IT Modules
$MyModules = @((Get-Module -Name AIT.* -ListAvailable).Name)

# Loop over the List of modules
foreach ($MyModule in $MyModules) 
{
	# Search for Modules not exported correct
	if ((((Get-Module -Name $MyModule -ListAvailable).ModuleType) -eq 'Manifest') -and ((((Get-Module -Name $MyModule -ListAvailable).Version).ToString()) -eq '0.0')) 
	{
		$null = (Import-Module -Name $MyModule -DisableNameChecking -Force -Scope Global -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
		$null = (Remove-Module -Name $MyModule -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	}
}

$null = (Remove-Module -Name 'AIT.Core' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)

#endregion WorkAround

# Gets back the default colors parameters
[console]::ResetColor()

# Change the Window
function global:Set-WinStyle 
{
	PROCESS {
		Set-Variable -Name console -Value $($host.UI.RawUI)
		Set-Variable -Name buffer -Value $($console.BufferSize)

		$buffer.Width = 128
		$buffer.Height = 2000
		$console.BufferSize = ($buffer)

		Set-Variable -Name size -Value $($console.WindowSize)

		$size.Width = 128
		$size.Height = 50
		$console.WindowSize = ($size)
	}
}

# Make the Windows dark blue
function global:Set-RegularMode 
{
	BEGIN {
		# Reformat the Windows
		if ((Get-Command -Name Set-WinStyle -ErrorAction SilentlyContinue)) 
		{
			$null = (Set-WinStyle)
			$null = (Set-WinStyle)
		}
	}

	PROCESS {
		# Change Color
		Set-Variable -Name console -Value $($host.UI.RawUI)
		$console.ForegroundColor = 'Gray'
		$console.BackgroundColor = 'DarkBlue'
		$console.CursorSize = 10

		# Text
		Set-Variable -Name colors -Value $($host.PrivateData)
		$colors.VerboseForegroundColor = 'Yellow'
		$colors.VerboseBackgroundColor = 'DarkBlue'
		$colors.WarningForegroundColor = 'Yellow'
		$colors.WarningBackgroundColor = 'DarkBlue'
		$colors.ErrorForegroundColor = 'Red'
		$colors.ErrorBackgroundColor = 'DarkBlue'
	}

	END {
		# Clean screen
		[Console]::Clear()
		[Console]::SetWindowPosition(0, [Console]::CursorTop)
	}
}

# Make the window white
function global:Set-LightMode 
{
	BEGIN {
		# Reformat the Windows
		if ((Get-Command -Name Set-WinStyle -ErrorAction SilentlyContinue)) 
		{
			$null = (Set-WinStyle)
			$null = (Set-WinStyle)
		}
	}

	PROCESS {
		# Change Color
		Set-Variable -Name console -Value $($host.UI.RawUI)
		$console.ForegroundColor = 'black'
		$console.BackgroundColor = 'white'
		$console.CursorSize = 10

		# Text
		Set-Variable -Name colors -Value $($host.PrivateData)
		$colors.VerboseForegroundColor = 'blue'
		$colors.VerboseBackgroundColor = 'white'
		$colors.WarningForegroundColor = 'Magenta'
		$colors.WarningBackgroundColor = 'white'
		$colors.ErrorForegroundColor = 'Red'
		$colors.ErrorBackgroundColor = 'white'
	}

	END {
		# Clean screen
		[Console]::Clear()
		[Console]::SetWindowPosition(0, [Console]::CursorTop)
	}
}

# Include this to the PATH
if ((Get-Command -Name Add-AppendPath -ErrorAction SilentlyContinue)) 
{
	try {Add-AppendPath -Pathlist $BasePath} catch 
	{
		# Do nothing!
		Write-Warning -Message ('Could not append {0} to the Path!' -f $BasePath)
	}
}

# Configure the CONSOLE itself
if ($host.Name -eq 'ConsoleHost') 
{
	# Console Mode

	# Set the Environment variable
	if (-not ($RunEnv)) { Set-Variable -Name RunEnv -Scope Global -Value $('Terminal') }

	# Style the Window
	if ((Get-Command -Name Set-RegularMode -ErrorAction SilentlyContinue)) 
	{
		# Set the Default Mode!
		$null = (Set-RegularMode)
	}
}
elseif (($host.Name -eq 'Windows PowerShell ISE Host') -and ($psISE)) 
{
	# Yeah, we run within the ISE

	# Set the Environment variable
	if (-not ($RunEnv)) 
	{
		# We are in a Console!
		Set-Variable -Name RunEnv -Scope Global -Value $('Terminal')
	}

	# Style the Window
	if ((Get-Command -Name Set-LightMode -ErrorAction SilentlyContinue)) 
	{
		# Set the Default Mode!
		$null = (Set-RegularMode)
	}
}
elseif ($host.Name -eq 'PrimalScriptHostImplementation') 
{
	# Oh, we running in a GUI - Ask yourself why you run the profile!
	Write-Debug -Message 'Running a a GUI based Environment and execute a Console Profile!'

	# Set the Environment variable
	if (-not ($RunEnv)) { Set-Variable -Name RunEnv -Scope Global -Value $('GUI') }
}
else 
{
	# Not in the Console, not ISE... Where to hell are we?
	Write-Debug -Message 'Unknown!'
}

# Set the Defaults
if (Get-Command -Name Set-DefaultPrompt -ErrorAction SilentlyContinue) {Set-DefaultPrompt}

# Where the windows Starts
Set-Location -Path $BasePath

# Display some infos
function Get-ProfileInfo 
{
	PROCESS {
		''
		('Today is: ' + $((Get-Date -Format 'yyyy-MM-dd') + ' ' + (Get-Date -Format 'HH:mm:ss')))
		''
		# Skip for now!
		if ((Get-Command -Name Get-AITVersion -ErrorAction SilentlyContinue)) 
		{
			#Dump the Version info
			Get-AITVersion
		}
		''
	}
}

# The Message of the Day (MOTD) function
function Get-ProfileMOTD 
{
	PROCESS {
		# Display Disk Informations
		# We try to display regular Disk only, no fancy disk drives
		foreach ($HD in (Get-WmiObject -Query 'SELECT * from win32_logicaldisk where DriveType = 3')) 
		{
			# Free Disk Space function
			Set-Variable -Name Free -Value $($HD.FreeSpace / 1GB -as [int])
			Set-Variable -Name Total -Value $($HD.Size / 1GB -as [int])

			# How much Disk Space do we have here?
			if ($Free -le 5) 
			{
				# Less then 5 GB available - WARN!
				Write-Host -Object ('Drive {0} has {1}GB of {2}GB available' -f $HD.DeviceID, ($Free), ($Total)) -ForegroundColor 'Yellow'
			}
			elseif ($Free -le 2) 
			{
				# Less then 2 GB available - WARN a bit more aggressive!!!
				Write-Host -Object ('Drive {0} has {1}GB of {2}GB available' -f $HD.DeviceID, ($Free), ($Total)) -ForegroundColor 'Red'
			}
			else 
			{
				# Regular Disk Free Space- GREAT!
				# With more then 5 GB available
				Write-Host -Object ('Drive {0} has {1}GB of {2}GB available' -f $HD.DeviceID, ($Free), ($Total))
			}
		}

		Write-Host -Object ''

		if ((Get-Command -Name Get-Uptime -ErrorAction SilentlyContinue)) 
		{
			# Get the Uptime...
			Get-Uptime
		}

		Write-Host -Object ''
	}
}

# unregister events, in case they weren't unregistered properly before.
# Just error silently if they don't exist
Unregister-Event -SourceIdentifier ConsoleStopped -ErrorAction SilentlyContinue
Unregister-Event -SourceIdentifier FileCreated -ErrorAction SilentlyContinue
Unregister-Event -SourceIdentifier FileChanged -ErrorAction SilentlyContinue
Unregister-Event -SourceIdentifier TimerTick -ErrorAction SilentlyContinue

# Try the new auto connect feature or authenticate manual via Invoke-AuthO365
if (Get-Command -Name tryAutoLogin -ErrorAction SilentlyContinue) 
{
	# Lets try the new command
	(Get-tryAutoLogin)
} elseif (Get-Command -Name Invoke-AuthO365 -ErrorAction SilentlyContinue) 
{
	# Fall-back to the old and manual way
	(Invoke-AuthO365)
}

# Enable strict mode
<#
		Set-StrictMode -Version Latest
#>

# Where are we?
if ($host.Name -eq 'ConsoleHost') 
{
	# Console Mode - Make a clean screen
	[Console]::Clear()
	[Console]::SetWindowPosition(0, [Console]::CursorTop)

	# Is this a user or an Admin account?
	# This has nothing to do with the user / User rights!
	# We look for the Session: Is it started as Admin, or not!
	if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) 
	{
		# Make the Name ALL Lower case
		$MyUserInfo = ($env:Username.ToUpper())

		# This is a regular user Account!
		Write-Host -Object ('Entering PowerShell as {0} with User permissions on {1}' -f $MyUserInfo, $env:COMPUTERNAME) -ForegroundColor 'White'
	}
	else 
	{
		# Make the Name ALL Lower case
		$MyUserInfo = ($env:Username.ToUpper())

		# This is an elevated session!
		Write-Host -Object ('Entering PowerShell as {0} with Admin permissions on {1}' -f $MyUserInfo, $env:COMPUTERNAME) -ForegroundColor 'Green'
	}

	# Show infos
	if (Get-Command -Name Get-ProfileInfo -ErrorAction SilentlyContinue) {Get-ProfileInfo}

	# Show message of the day
	if (Get-Command -Name Get-ProfileMOTD -ErrorAction SilentlyContinue) 
	{
		# This is the function from above.
		# If you want, you might use Get-MOTD here.
		Get-ProfileMOTD
	}
}
elseif (($host.Name -eq 'Windows PowerShell ISE Host') -and ($psISE)) 
{
	# Yeah, we run within the ISE
	# We do not support this Environment :)
	Write-Debug -Message 'ISE Found!'
}
elseif ($host.Name -eq 'PrimalScriptHostImplementation') 
{
	# Oh, we running in a GUI
	# We do not support this Environment :)
	Write-Debug -Message 'GUI App'
}
elseif ($host.Name -eq 'DefaultHost') 
{
	# Look who is using our PowerShell Web Proxy Server...
	# We do not support this Environment :)
	Write-Debug -Message 'Default Host!'
}
elseif ($host.Name -eq 'ServerRemoteHost') 
{
	Clear-Host

	if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) 
	{
		# Make the Name ALL Lower case
		$MyUserInfo = ($env:Username.ToUpper())

		# This is a regular user Account!
		Write-Host -Object ('Entering PowerShell as {0} with User permissions on {1}' -f $MyUserInfo, $env:COMPUTERNAME) -ForegroundColor 'White'
	}
	else 
	{
		# Make the Name ALL Lower case
		$MyUserInfo = ($env:Username.ToUpper())

		# This is an elevated session!
		Write-Host -Object ('Entering PowerShell as {0} with Admin permissions on {1}' -f $MyUserInfo, $env:COMPUTERNAME) -ForegroundColor 'Green'
	}

	# Support for Remote was added a while ago.
	if (Get-Command -Name Get-MOTD -ErrorAction SilentlyContinue) {Get-MOTD}

	# Use this to display the Disk Info
	if (Get-Command -Name Get-ProfileMOTD -ErrorAction SilentlyContinue) 
	{
		# Blank Line
		Write-Output -InputObject ''

		Get-ProfileMOTD
	}
}
else 
{
	# Not in the Console, not ISE... Where to hell are we right now?
	Write-Debug -Message 'Unknown!'
}

if (Get-Command -Name Get-Quote -ErrorAction SilentlyContinue) 
{
	# Print a Quote
	(Get-Quote)
}

# Try to check the Credentials
if ((Get-Command -Name Test-Credential -ErrorAction SilentlyContinue)) 
{
	try {$IsCredValid = (Test-Credential)} catch 
	{
		# Prevent "The server could not be contacted." Error
		Write-Debug -Message 'We had an Error'
	}

	if (($IsCredValid -eq $False) -and (-not ($Environment -eq 'Development'))) 
	{
		Write-Warning -Message 'Looks like your Credentials are not correct!!!'

		try 
		{
			# Remove saved credentials!
			if (Get-Command -Name Remove-PSCredential -ErrorAction SilentlyContinue) { $null = (Remove-PSCredential) }

			# Ask for Credentials...
			(Invoke-AuthO365)

			try {if (Get-Command -Name Export-PSCredential -ErrorAction SilentlyContinue) { $null = (Export-PSCredential) }} catch { Write-Debug -Message 'Could not export Credentials!' }
		} catch { Write-Debug -Message 'Houston we have a problem!' }
	}
}

# Do a garbage collection
if (Get-Command -Name Invoke-GC -ErrorAction SilentlyContinue) { (Invoke-GC) }

# SIG # Begin signature block
# MIIZXgYJKoZIhvcNAQcCoIIZTzCCGUsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUOfdoVVa36pvvUqeGxiDp1QBE
# TSigghPvMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
# VzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNV
# BAsTB1Jvb3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0xMTA0
# MTMxMDAwMDBaFw0yODAxMjgxMjAwMDBaMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlO9l
# +LVXn6BTDTQG6wkft0cYasvwW+T/J6U00feJGr+esc0SQW5m1IGghYtkWkYvmaCN
# d7HivFzdItdqZ9C76Mp03otPDbBS5ZBb60cO8eefnAuQZT4XljBFcm05oRc2yrmg
# jBtPCBn2gTGtYRakYua0QJ7D/PuV9vu1LpWBmODvxevYAll4d/eq41JrUJEpxfz3
# zZNl0mBhIvIG+zLdFlH6Dv2KMPAXCae78wSuq5DnbN96qfTvxGInX2+ZbTh0qhGL
# 2t/HFEzphbLswn1KJo/nVrqm4M+SU4B09APsaLJgvIQgAIMboe60dAXBKY5i0Eex
# +vBTzBj5Ljv5cH60JQIDAQABo4HlMIHiMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMB
# Af8ECDAGAQH/AgEAMB0GA1UdDgQWBBRG2D7/3OO+/4Pm9IWbsN1q1hSpwTBHBgNV
# HSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFs
# c2lnbi5jb20vcmVwb3NpdG9yeS8wMwYDVR0fBCwwKjAooCagJIYiaHR0cDovL2Ny
# bC5nbG9iYWxzaWduLm5ldC9yb290LmNybDAfBgNVHSMEGDAWgBRge2YaRQ2XyolQ
# L30EzTSo//z9SzANBgkqhkiG9w0BAQUFAAOCAQEATl5WkB5GtNlJMfO7FzkoG8IW
# 3f1B3AkFBJtvsqKa1pkuQJkAVbXqP6UgdtOGNNQXzFU6x4Lu76i6vNgGnxVQ380W
# e1I6AtcZGv2v8Hhc4EvFGN86JB7arLipWAQCBzDbsBJe/jG+8ARI9PBw+DpeVoPP
# PfsNvPTF7ZedudTbpSeE4zibi6c1hkQgpDttpGoLoYP9KOva7yj2zIhd+wo7AKvg
# IeviLzVsD440RZfroveZMzV+y5qKu0VN5z+fwtmK+mWybsd+Zf/okuEsMaL3sCc2
# SI8mbzvuTXYfecPlf5Y1vC0OzAGwjn//UYCAp5LUs0RGZIyHTxZjBzFLY7Df8zCC
# BJ8wggOHoAMCAQICEhEh1pmnZJc+8fhCfukZzFNBFDANBgkqhkiG9w0BAQUFADBS
# MQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UE
# AxMfR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBHMjAeFw0xNjA1MjQwMDAw
# MDBaFw0yNzA2MjQwMDAwMDBaMGAxCzAJBgNVBAYTAlNHMR8wHQYDVQQKExZHTU8g
# R2xvYmFsU2lnbiBQdGUgTHRkMTAwLgYDVQQDEydHbG9iYWxTaWduIFRTQSBmb3Ig
# TVMgQXV0aGVudGljb2RlIC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCwF66i07YEMFYeWA+x7VWk1lTL2PZzOuxdXqsl/Tal+oTDYUDFRrVZUjtC
# oi5fE2IQqVvmc9aSJbF9I+MGs4c6DkPw1wCJU6IRMVIobl1AcjzyCXenSZKX1GyQ
# oHan/bjcs53yB2AsT1iYAGvTFVTg+t3/gCxfGKaY/9Sr7KFFWbIub2Jd4NkZrItX
# nKgmK9kXpRDSRwgacCwzi39ogCq1oV1r3Y0CAikDqnw3u7spTj1Tk7Om+o/SWJMV
# TLktq4CjoyX7r/cIZLB6RA9cENdfYTeqTmvT0lMlnYJz+iz5crCpGTkqUPqp0Dw6
# yuhb7/VfUfT5CtmXNd5qheYjBEKvAgMBAAGjggFfMIIBWzAOBgNVHQ8BAf8EBAMC
# B4AwTAYDVR0gBEUwQzBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0cHM6
# Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADAWBgNV
# HSUBAf8EDDAKBggrBgEFBQcDCDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vY3Js
# Lmdsb2JhbHNpZ24uY29tL2dzL2dzdGltZXN0YW1waW5nZzIuY3JsMFQGCCsGAQUF
# BwEBBEgwRjBEBggrBgEFBQcwAoY4aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNv
# bS9jYWNlcnQvZ3N0aW1lc3RhbXBpbmdnMi5jcnQwHQYDVR0OBBYEFNSihEo4Whh/
# uk8wUL2d1XqH1gn3MB8GA1UdIwQYMBaAFEbYPv/c477/g+b0hZuw3WrWFKnBMA0G
# CSqGSIb3DQEBBQUAA4IBAQCPqRqRbQSmNyAOg5beI9Nrbh9u3WQ9aCEitfhHNmmO
# 4aVFxySiIrcpCcxUWq7GvM1jjrM9UEjltMyuzZKNniiLE0oRqr2j79OyNvy0oXK/
# bZdjeYxEvHAvfvO83YJTqxr26/ocl7y2N5ykHDC8q7wtRzbfkiAD6HHGWPZ1BZo0
# 8AtZWoJENKqA5C+E9kddlsm2ysqdt6a65FDT1De4uiAO0NOSKlvEWbuhbds8zkSd
# wTgqreONvc0JdxoQvmcKAjZkiLmzGybu555gxEaovGEzbM9OuZy5avCfN/61PU+a
# 003/3iCOTpem/Z8JvE3KGHbJsE2FUPKA0h0G9VgEB7EYMIIFTDCCBDSgAwIBAgIQ
# FtT3Ux2bGCdP8iZzNFGAXDANBgkqhkiG9w0BAQsFADB9MQswCQYDVQQGEwJHQjEb
# MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRow
# GAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEjMCEGA1UEAxMaQ09NT0RPIFJTQSBD
# b2RlIFNpZ25pbmcgQ0EwHhcNMTUwNzE3MDAwMDAwWhcNMTgwNzE2MjM1OTU5WjCB
# kDELMAkGA1UEBhMCREUxDjAMBgNVBBEMBTM1NTc2MQ8wDQYDVQQIDAZIZXNzZW4x
# EDAOBgNVBAcMB0xpbWJ1cmcxGDAWBgNVBAkMD0JhaG5ob2ZzcGxhdHogMTEZMBcG
# A1UECgwQS3JlYXRpdlNpZ24gR21iSDEZMBcGA1UEAwwQS3JlYXRpdlNpZ24gR21i
# SDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK8jDmF0TO09qJndJ9eG
# Fqra1lf14NDhM8wIT8cFcZ/AX2XzrE6zb/8kE5sL4/dMhuTOp+SMt0tI/SON6BY3
# 208v/NlDI7fozAqHfmvPhLX6p/TtDkmSH1sD8AIyrTH9b27wDNX4rC914Ka4EBI8
# sGtZwZOQkwQdlV6gCBmadar+7YkVhAbIIkSazE9yyRTuffidmtHV49DHPr+ql4ji
# NJ/K27ZFZbwM6kGBlDBBSgLUKvufMY+XPUukpzdCaA0UzygGUdDfgy0htSSp8MR9
# Rnq4WML0t/fT0IZvmrxCrh7NXkQXACk2xtnkq0bXUIC6H0Zolnfl4fanvVYyvD88
# qIECAwEAAaOCAbIwggGuMB8GA1UdIwQYMBaAFCmRYP+KTfrr+aZquM/55ku9Sc4S
# MB0GA1UdDgQWBBSeVG4/9UvVjmv8STy4f7kGHucShjAOBgNVHQ8BAf8EBAMCB4Aw
# DAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDAzARBglghkgBhvhCAQEE
# BAMCBBAwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwIwKzApBggrBgEFBQcCARYd
# aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwQwYDVR0fBDwwOjA4oDagNIYy
# aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ29kZVNpZ25pbmdDQS5j
# cmwwdAYIKwYBBQUHAQEEaDBmMD4GCCsGAQUFBzAChjJodHRwOi8vY3J0LmNvbW9k
# b2NhLmNvbS9DT01PRE9SU0FDb2RlU2lnbmluZ0NBLmNydDAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuY29tb2RvY2EuY29tMCMGA1UdEQQcMBqBGGhvY2h3YWxkQGty
# ZWF0aXZzaWduLm5ldDANBgkqhkiG9w0BAQsFAAOCAQEASSZkxKo3EyEk/qW0ZCs7
# CDDHKTx3UcqExigsaY0DRo9fbWgqWynItsqdwFkuQYJxzknqm2JMvwIK6BtfWc64
# WZhy0BtI3S3hxzYHxDjVDBLBy91kj/mddPjen60W+L66oNEXiBuIsOcJ9e7tH6Vn
# 9eFEUjuq5esoJM6FV+MIKv/jPFWMp5B6EtX4LDHEpYpLRVQnuxoc38mmd+NfjcD2
# /o/81bu6LmBFegHAaGDpThGf8Hk3NVy0GcpQ3trqmH6e3Cpm8Ut5UkoSONZdkYWw
# rzkmzFgJyoM2rnTMTh4ficxBQpB7Ikv4VEnrHRReihZ0zwN+HkXO1XEnd3hm+08j
# LzCCBeAwggPIoAMCAQICEC58h8wOk0pS/pT9HLfNNK8wDQYJKoZIhvcNAQEMBQAw
# gYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
# BgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYD
# VQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTEzMDUw
# OTAwMDAwMFoXDTI4MDUwODIzNTk1OVowfTELMAkGA1UEBhMCR0IxGzAZBgNVBAgT
# EkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMR
# Q09NT0RPIENBIExpbWl0ZWQxIzAhBgNVBAMTGkNPTU9ETyBSU0EgQ29kZSBTaWdu
# aW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAppiQY3eRNH+K
# 0d3pZzER68we/TEds7liVz+TvFvjnx4kMhEna7xRkafPnp4ls1+BqBgPHR4gMA77
# YXuGCbPj/aJonRwsnb9y4+R1oOU1I47Jiu4aDGTH2EKhe7VSA0s6sI4jS0tj4CKU
# N3vVeZAKFBhRLOb+wRLwHD9hYQqMotz2wzCqzSgYdUjBeVoIzbuMVYz31HaQOjNG
# UHOYXPSFSmsPgN1e1r39qS/AJfX5eNeNXxDCRFU8kDwxRstwrgepCuOvwQFvkBoj
# 4l8428YIXUezg0HwLgA3FLkSqnmSUs2HD3vYYimkfjC9G7WMcrRI8uPoIfleTGJ5
# iwIGn3/VCwIDAQABo4IBUTCCAU0wHwYDVR0jBBgwFoAUu69+Aj36pvE8hI6t7jiY
# 7NkyMtQwHQYDVR0OBBYEFCmRYP+KTfrr+aZquM/55ku9Sc4SMA4GA1UdDwEB/wQE
# AwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBEG
# A1UdIAQKMAgwBgYEVR0gADBMBgNVHR8ERTBDMEGgP6A9hjtodHRwOi8vY3JsLmNv
# bW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDBx
# BggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29tb2RvY2Eu
# Y29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8v
# b2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAAI/AjnD7vjKO4ne
# DG1NsfFOkk+vwjgsBMzFYxGrCWOvq6LXAj/MbxnDPdYaCJT/JdipiKcrEBrgm7EH
# IhpRHDrU4ekJv+YkdK8eexYxbiPvVFEtUgLidQgFTPG3UeFRAMaH9mzuEER2V2rx
# 31hrIapJ1Hw3Tr3/tnVUQBg2V2cRzU8C5P7z2vx1F9vst/dlCSNJH0NXg+p+IHdh
# yE3yu2VNqPeFRQevemknZZApQIvfezpROYyoH3B5rW1CIKLPDGwDjEzNcweU51qO
# OgS6oqF8H8tjOhWn1BUbp1JHMqn0v2RH0aofU04yMHPCb7d4gp1c/0a7ayIdiAv4
# G6o0pvyM9d1/ZYyMMVcx0DbsR6HPy4uo7xwYWMUGd8pLm1GvTAhKeo/io1Lijo7M
# JuSy2OU4wqjtxoGcNWupWGFKCpe0S0K2VZ2+medwbVn4bSoMfxlgXwyaiGwwrFIJ
# kBYb/yud29AgyonqKH4yjhnfe0gzHtdl+K7J+IMUk3Z9ZNCOzr41ff9yMU2fnr0e
# bC+ojwwGUPuMJ7N2yfTm18M04oyHIYZh/r9VdOEhdwMKaGy75Mmp5s9ZJet87EUO
# eWZo6CLNuO+YhU2WETwJitB/vCgoE/tqylSNklzNwmWYBp7OSFvUtTeTRkF8B93P
# +kPvumdh/31J4LswfVyA4+YWOUunMYIE2TCCBNUCAQEwgZEwfTELMAkGA1UEBhMC
# R0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9y
# ZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxIzAhBgNVBAMTGkNPTU9ETyBS
# U0EgQ29kZSBTaWduaW5nIENBAhAW1PdTHZsYJ0/yJnM0UYBcMAkGBSsOAwIaBQCg
# eDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEE
# AYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJ
# BDEWBBTpC5kQxD0t+LQOl1uUWIe0fYHLTjANBgkqhkiG9w0BAQEFAASCAQCDjnfl
# yQ6Rj9oDLuFKvjXeGqec6Yv4JYKaXmOEQG6wk6JMtXk/CjrnVZ1OHxST72mCgzIF
# Em2WLkpbcarNAqoXsiXLiSwncy0ksv5mY90zPTBR7cTKwobI5fW6+GqucGsQGT/Q
# j92cJnWQvcZNpDU9oaU1H+se45EABidnHfWMmuD2s56yz6E7VKLCM4JnxW3ePZ+q
# Ikd95odT9fSc7cg15ZR9n5PbKZHwsOm0m/ufsnbZWUfVBAicQd+HWGEEcS5uUB3U
# FU9a0Zr2NdKtlz6+3YfDHX205qjI8NlSEJ6u15IfIDa8744L08JOK3V8KYnlVBw1
# mpj3HjFsy9JBcCDioYICojCCAp4GCSqGSIb3DQEJBjGCAo8wggKLAgEBMGgwUjEL
# MAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMT
# H0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzICEhEh1pmnZJc+8fhCfukZ
# zFNBFDAJBgUrDgMCGgUAoIH9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
# KoZIhvcNAQkFMQ8XDTE2MTEyNTIwMzM1MlowIwYJKoZIhvcNAQkEMRYEFPKvRpeh
# tirVdV30EIZSVJHHkU8nMIGdBgsqhkiG9w0BCRACDDGBjTCBijCBhzCBhAQUY7gv
# q2H1g5CWlQULACScUCkz7HkwbDBWpFQwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoT
# EEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gVGltZXN0YW1w
# aW5nIENBIC0gRzICEhEh1pmnZJc+8fhCfukZzFNBFDANBgkqhkiG9w0BAQEFAASC
# AQAaM/DR1WbuiB9KRw+qNdHEGSufRYFiOUdlR9bamjv3lXtRvn0G7kjZ8YbBC3cz
# Mro2x5UIMvhKEmBpDVg19RxJjeSEI46u2TD3uKYBNB067eoMhM/iiSzlD1ze+Fv6
# qfxFUP2f6J8/7tyPSFwK64wakv+rtpiP3YvVg3lUnLKi+4mGjLWFygHMo0Qlwgq0
# O3RYyMRgyp6aJkTSKMuADT7m1nP5UrMwczwSYkjKhTHbSs9xhgGEGZ/xKO7rLTm8
# t2ZQmjgmeY8XyhAf9z05/fwrze3gQKHh/K+vUGkQtA/CYKbsnVUjNmgul8bl2an0
# YyilJe/HhBxyMthkAw6BJREW
# SIG # End signature block
