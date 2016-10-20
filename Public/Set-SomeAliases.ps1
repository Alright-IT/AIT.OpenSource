#!/usr/bin/env powershell
#requires -Version 2.0

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

<#
		.SYNOPSIS
		Set some aliases for this Module

		.DESCRIPTION
		Set some alias for convenience and to be compatible with older releases.

		.EXAMPLE
		PS C:\> Set-SomeAliases.ps1

		.NOTES
		Mostly for convenience
#>
[CmdletBinding()]
param ()

BEGIN {
	$SetAliasParams = @{
		Option        = 'AllScope'
		Scope         = 'Global'
		Force         = $True
		Confirm       = $false
		ErrorAction   = 'SilentlyContinue'
		WarningAction = 'SilentlyContinue'
	}
}

PROCESS {
	if (-not (Get-AdminUser)) {
		Write-Warning -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.'

		break
	} else {
		# Set a compatibility Alias
		$null = (Set-Alias -Name ValidateEmailAddress -Value Approve-MailAddress  @SetAliasParams)
		$null = (Set-Alias -Name Validate-Email -Value Approve-MailAddress  @SetAliasParams)
		$null = (Set-Alias -Name convert-fromBinHex -Value ConvertFrom-BinHex  @SetAliasParams)
		$null = (Set-Alias -Name convert-toBinHex -Value ConvertTo-BinHex  @SetAliasParams)
		$null = (Set-Alias -Name IsSmtpMessageAlive -Value Get-TcpPortStatus  @SetAliasParams)
		$null = (Set-Alias -Name CheckTcpPort -Value Get-TcpPortStatus  @SetAliasParams)
		$null = (Set-Alias -Name Validate-Xml -Value Confirm-XMLisValid  @SetAliasParams)
		$null = (Set-Alias -Name To-hex -Value ConvertTo-hex  @SetAliasParams)
		$null = (Set-Alias -Name df -Value Get-FreeDiskSpace  @SetAliasParams)
		$null = (Set-Alias -Name pause -Value Get-Pause  @SetAliasParams)
		$null = (Set-Alias -Name top -Value Get-TopProcesses  @SetAliasParams)
		$null = (Set-Alias -Name uptime -Value Get-Uptime  @SetAliasParams)
		$null = (Set-Alias -Name grep -Value Select-String  @SetAliasParams)
		$null = (Set-Alias -Name head -Value Invoke-PowerHead  @SetAliasParams)
		$null = (Set-Alias -Name Help -Value Invoke-PowerHelp  @SetAliasParams)
		$null = (Set-Alias -Name vi -Value Invoke-VisualEditor  @SetAliasParams)
		$null = (Set-Alias -Name vim -Value Invoke-VisualEditor  @SetAliasParams)
		$null = (Set-Alias -Name Get-AtomicTime -Value Get-NtpTime  @SetAliasParams)
		$null = (Set-Alias -Name append-classpath -Value Invoke-AppendClassPath  @SetAliasParams)
		$null = (Set-Alias -Name JavaLove -Value Invoke-JavaLove  @SetAliasParams)
		$null = (Set-Alias -Name ll -Value Invoke-PowerLL  @SetAliasParams)
		$null = (Set-Alias -Name Load-Pester -Value Reload-PesterModule  @SetAliasParams)
		$null = (Set-Alias -Name man -Value Invoke-PowerHelp  @SetAliasParams)
		$null = (Set-Alias -Name md -Value Invoke-MakeDirectory  @SetAliasParams)
		$null = (Set-Alias -Name mkdir -Value Invoke-MakeDirectory  @SetAliasParams)
		$null = (Set-Alias -Name ls -Value Get-MyLS  @SetAliasParams)
		$null = (Set-Alias -Name myls -Value Get-MyLS  @SetAliasParams)
		$null = (Set-Alias -Name pgrep -Value Find-String  @SetAliasParams)
		$null = (Set-Alias -Name rdp -Value Invoke-RDPSession  @SetAliasParams)
		$null = (Set-Alias -Name AcceptProtocolViolation -Value Set-AcceptProtocolViolation  @SetAliasParams)
		$null = (Set-Alias -Name Set-TextEncoding -Value Set-Encoding  @SetAliasParams)
		$null = (Set-Alias -Name sudo -Value Invoke-WithElevation  @SetAliasParams)
		$null = (Set-Alias -Name time -Value Measure-Command  @SetAliasParams)
		$null = (Set-Alias -Name touch -Value Set-FileTime  @SetAliasParams)
		$null = (Set-Alias -Name unique -Value Get-Unique  @SetAliasParams)
		$null = (Set-Alias -Name uniq -Value Get-Unique  @SetAliasParams)
		$null = (Set-Alias -Name ConvertFrom-UnixTime -Value ConvertFrom-UnixDate  @SetAliasParams)
		$null = (Set-Alias -Name Send-Command -Value Invoke-Command  @SetAliasParams)
		$null = (Set-Alias -Name Explore -Value Invoke-WindowsExplorer  @SetAliasParams)
		$null = (Set-Alias -Name tail -Value Invoke-Tail  @SetAliasParams)
		$null = (Set-Alias -Name wc -Value Invoke-WordCounter  @SetAliasParams)
		$null = (Set-Alias -Name which -Value Invoke-Which  @SetAliasParams)
		$null = (Set-Alias -Name whoami -Value Invoke-Whoami  @SetAliasParams)
		$null = (Set-Alias -Name Check-IPaddress -Value Invoke-CheckIPaddress  @SetAliasParams)
		$null = (Set-Alias -Name Check-SessionArch -Value Invoke-CheckSessionArch  @SetAliasParams)
		$null = (Set-Alias -Name Clean-SysInfo -Value Invoke-CleanSysInfo  @SetAliasParams)
		$null = (Set-Alias -Name Load-CommandHistory -Value Import-CommandHistory  @SetAliasParams)
	}
}
