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

function global:Get-IsWin10 {
	# For some Workarounds!
	if ([Environment]::OSVersion.Version -ge (New-Object -TypeName 'Version' -ArgumentList 10, 0)) {
		Return $True
	} else {
		Return $False
	}
}

# Make this Shell clean!
function Clear-AllVariables {
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
if ((Get-Command -Name Set-RunEnv -ErrorAction SilentlyContinue)) {
	# Use our Core Module command
	Set-RunEnv
} else {
	# Enforce Terminal as Mode!
	Set-Variable -Name RunEnv -Scope Global -Value $('Terminal')
}

# This is our Base location
Set-Variable -Name BasePath -Scope Global -Value $('c:/scripts/PowerShell')

$IsNewModuleAvailable = (Get-Module -Name 'AIT.OpenSource' -ListAvailable)

if ($IsNewModuleAvailable) {
	if ((Get-Module -Name 'AIT.OpenSource')) {
		$null = (Remove-Module -Name 'AIT.OpenSource' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	}

	$null = (Import-Module -Name 'AIT.OpenSource' -Force -DisableNameChecking -NoClobber -Global)
} else {
	Write-Warning -Message 'Unable to find the Alright-IT Open Source PowerShell Module. Makes absolute no sense to continue!!!'

	break
}

# Make em English!
if ((Get-Command -Name Set-Culture -ErrorAction SilentlyContinue)) {
	try {
		Set-Culture -Culture 'en-US'
	} catch {
		# Do nothing!
		Write-Debug -Message 'We had an Error'
	}
}

#region WorkAround

# Search for all Alright-IT Modules
$MyModules = @((Get-Module -Name AIT.* -ListAvailable).Name)

# Loop over the List of modules
foreach ($MyModule in $MyModules) {
	# Search for Modules not exported correct
	if ((((Get-Module -Name $MyModule -ListAvailable).ModuleType) -eq 'Manifest') -and ((((Get-Module -Name $MyModule -ListAvailable).Version).ToString()) -eq '0.0')) {
		$null = (Import-Module -Name $MyModule -DisableNameChecking -Force -Scope Global -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
		$null = (Remove-Module -Name $MyModule -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	}
}

$null = (Remove-Module -Name 'AIT.Core' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)

#endregion WorkAround

# Gets back the default colors parameters
[console]::ResetColor()

# Change the Window
function global:Set-WinStyle {
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
function global:Set-RegularMode {
	BEGIN {
		# Reformat the Windows
		if ((Get-Command -Name Set-WinStyle -ErrorAction SilentlyContinue)) {
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
function global:Set-LightMode {
	BEGIN {
		# Reformat the Windows
		if ((Get-Command -Name Set-WinStyle -ErrorAction SilentlyContinue)) {
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
if ((Get-Command -Name Add-AppendPath -ErrorAction SilentlyContinue)) {
	try {
		Add-AppendPath -Pathlist $BasePath
	} catch {
		# Do nothing!
		Write-Warning -Message ('Could not append {0} to the Path!' -f $BasePath)
	}
}

# Configure the CONSOLE itself
if ($host.Name -eq 'ConsoleHost') {
	# Console Mode

	# Set the Environment variable
	if (-not ($RunEnv)) { Set-Variable -Name RunEnv -Scope Global -Value $('Terminal') }

	# Style the Window
	if ((Get-Command -Name Set-RegularMode -ErrorAction SilentlyContinue)) {
		# Set the Default Mode!
		$null = (Set-RegularMode)
	}
} elseif (($host.Name -eq 'Windows PowerShell ISE Host') -and ($psISE)) {
	# Yeah, we run within the ISE

	# Set the Environment variable
	if (-not ($RunEnv)) {
		# We are in a Console!
		Set-Variable -Name RunEnv -Scope Global -Value $('Terminal')
	}

	# Style the Window
	if ((Get-Command -Name Set-LightMode -ErrorAction SilentlyContinue)) {
		# Set the Default Mode!
		$null = (Set-RegularMode)
	}
} elseif ($host.Name -eq 'PrimalScriptHostImplementation') {
	# Oh, we running in a GUI - Ask yourself why you run the profile!
	Write-Debug -Message 'Running a a GUI based Environment and execute a Console Profile!'

	# Set the Environment variable
	if (-not ($RunEnv)) { Set-Variable -Name RunEnv -Scope Global -Value $('GUI') }
} else {
	# Not in the Console, not ISE... Where to hell are we?
	Write-Debug -Message 'Unknown!'
}

# Set the Defaults
if (Get-Command -Name Set-DefaultPrompt -ErrorAction SilentlyContinue) {
	Set-DefaultPrompt
}

# Where the windows Starts
Set-Location -Path $BasePath

# Display some infos
function Get-ProfileInfo {
	PROCESS {
		''
		('Today is: ' + $((Get-Date -Format 'yyyy-MM-dd') + ' ' + (Get-Date -Format 'HH:mm:ss')))
		''
		# Skip for now!
		if ((Get-Command -Name Get-AITVersion -ErrorAction SilentlyContinue)) {
			#Dump the Version info
			Get-AITVersion
		}
		''
	}
}

# The Message of the Day (MOTD) function
function Get-ProfileMOTD {
	PROCESS {
		# Display Disk Informations
		# We try to display regular Disk only, no fancy disk drives
		foreach ($HD in (Get-WmiObject -Query 'SELECT * from win32_logicaldisk where DriveType = 3')) {
			# Free Disk Space function
			Set-Variable -Name Free -Value $($HD.FreeSpace / 1GB -as [int])
			Set-Variable -Name Total -Value $($HD.Size / 1GB -as [int])

			# How much Disk Space do we have here?
			if ($Free -le 5) {
				# Less then 5 GB available - WARN!
				Write-Host -Object ('Drive {0} has {1}GB of {2}GB available' -f $HD.DeviceID, ($Free), ($Total)) -ForegroundColor 'Yellow'
			} elseif ($Free -le 2) {
				# Less then 2 GB available - WARN a bit more aggressive!!!
				Write-Host -Object ('Drive {0} has {1}GB of {2}GB available' -f $HD.DeviceID, ($Free), ($Total)) -ForegroundColor 'Red'
			} else {
				# Regular Disk Free Space- GREAT!
				# With more then 5 GB available
				Write-Host -Object ('Drive {0} has {1}GB of {2}GB available' -f $HD.DeviceID, ($Free), ($Total))
			}
		}

		Write-Host -Object ''

		if ((Get-Command -Name Get-Uptime -ErrorAction SilentlyContinue)) {
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
if (Get-Command -Name tryAutoLogin -ErrorAction SilentlyContinue) {
	# Lets try the new command
	(Get-tryAutoLogin)
} elseif (Get-Command -Name Invoke-AuthO365 -ErrorAction SilentlyContinue) {
	# Fall-back to the old and manual way
	(Invoke-AuthO365)
}

# Enable strict mode
<#
		Set-StrictMode -Version Latest
#>

# Where are we?
if ($host.Name -eq 'ConsoleHost') {
	# Console Mode - Make a clean screen
	[Console]::Clear()
	[Console]::SetWindowPosition(0, [Console]::CursorTop)

	# Is this a user or an Admin account?
	# This has nothing to do with the user / User rights!
	# We look for the Session: Is it started as Admin, or not!
	if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
		# Make the Name ALL Lower case
		$MyUserInfo = ($env:Username.ToUpper())

		# This is a regular user Account!
		Write-Host -Object ('Entering PowerShell as {0} with User permissions on {1}' -f $MyUserInfo, $env:COMPUTERNAME) -ForegroundColor 'White'
	} else {
		# Make the Name ALL Lower case
		$MyUserInfo = ($env:Username.ToUpper())

		# This is an elevated session!
		Write-Host -Object ('Entering PowerShell as {0} with Admin permissions on {1}' -f $MyUserInfo, $env:COMPUTERNAME) -ForegroundColor 'Green'
	}

	# Show infos
	if (Get-Command -Name Get-ProfileInfo -ErrorAction SilentlyContinue) {
		Get-ProfileInfo
	}

	# Show message of the day
	if (Get-Command -Name Get-ProfileMOTD -ErrorAction SilentlyContinue) {
		# This is the function from above.
		# If you want, you might use Get-MOTD here.
		Get-ProfileMOTD
	}
} elseif (($host.Name -eq 'Windows PowerShell ISE Host') -and ($psISE)) {
	# Yeah, we run within the ISE
	# We do not support this Environment :)
	Write-Debug -Message 'ISE Found!'
} elseif ($host.Name -eq 'PrimalScriptHostImplementation') {
	# Oh, we running in a GUI
	# We do not support this Environment :)
	Write-Debug -Message 'GUI App'
} elseif ($host.Name -eq 'DefaultHost') {
	# Look who is using our PowerShell Web Proxy Server...
	# We do not support this Environment :)
	Write-Debug -Message 'Default Host!'
} elseif ($host.Name -eq 'ServerRemoteHost') {
	Clear-Host

	if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
		# Make the Name ALL Lower case
		$MyUserInfo = ($env:Username.ToUpper())

		# This is a regular user Account!
		Write-Host -Object ('Entering PowerShell as {0} with User permissions on {1}' -f $MyUserInfo, $env:COMPUTERNAME) -ForegroundColor 'White'
	} else {
		# Make the Name ALL Lower case
		$MyUserInfo = ($env:Username.ToUpper())

		# This is an elevated session!
		Write-Host -Object ('Entering PowerShell as {0} with Admin permissions on {1}' -f $MyUserInfo, $env:COMPUTERNAME) -ForegroundColor 'Green'
	}

	# Support for Remote was added a while ago.
	if (Get-Command -Name Get-MOTD -ErrorAction SilentlyContinue) {
		Get-MOTD
	}

	# Use this to display the Disk Info
	if (Get-Command -Name Get-ProfileMOTD -ErrorAction SilentlyContinue) {
		# Blank Line
		Write-Output -InputObject ''

		Get-ProfileMOTD
	}
} else {
	# Not in the Console, not ISE... Where to hell are we right now?
	Write-Debug -Message 'Unknown!'
}

if (Get-Command -Name Get-Quote -ErrorAction SilentlyContinue) {
	# Print a Quote
	(Get-Quote)
}

# Try to check the Credentials
if ((Get-Command -Name Test-Credential -ErrorAction SilentlyContinue)) {
	try {
		$IsCredValid = (Test-Credential)
	} catch {
		# Prevent "The server could not be contacted." Error
		Write-Debug -Message 'We had an Error'
	}

	if (($IsCredValid -eq $False) -and (-not ($Environment -eq 'Development'))) {
		Write-Warning -Message 'Looks like your Credentials are not correct!!!'

		try {
			# Remove saved credentials!
			if (Get-Command -Name Remove-PSCredential -ErrorAction SilentlyContinue) { $null = (Remove-PSCredential) }

			# Ask for Credentials...
			(Invoke-AuthO365)

			try {
				if (Get-Command -Name Export-PSCredential -ErrorAction SilentlyContinue) { $null = (Export-PSCredential) }
			} catch { Write-Debug -Message 'Could not export Credentials!' }
		} catch { Write-Debug -Message 'Houston we have a problem!' }
	}
}

# Do a garbage collection
if (Get-Command -Name Invoke-GC -ErrorAction SilentlyContinue) { (Invoke-GC) }
