#!/usr/bin/env powershell
#requires -Version 3.0

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

PROCESS {
	if (-not (Get-AdminUser)) {
			Write-Warning -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.'

			break
	} else {
		# Set a compatibility Alias
		(Set-Alias -Name ValidateEmailAddress -Value Approve-MailAddress -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Validate-Email -Value Approve-MailAddress -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name convert-fromBinHex -Value ConvertFrom-BinHex -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name convert-toBinHex -Value ConvertTo-BinHex -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name IsSmtpMessageAlive -Value Get-TcpPortStatus -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name CheckTcpPort -Value Get-TcpPortStatus -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Validate-Xml -Value Confirm-XMLisValid -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name To-hex -Value ConvertTo-hex -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name df -Value Get-FreeDiskSpace -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name pause -Value Get-Pause -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name top -Value Get-TopProcesses -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name uptime -Value Get-Uptime -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name uuidgen -Value Get-uuid -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name uuidgen -Value Get-uuid -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name grep -Value Select-String -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name head -Value Invoke-PowerHead -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Help -Value Invoke-PowerHelp -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name IgnoreSslTrust -Value Set-IgnoreSslTrust -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name NotIgnoreSslTrust -Value Set-NotIgnoreSslTrust -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name NotIgnoreSslTrust -Value Set-NotIgnoreSslTrust -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name run-psgc -Value Invoke-GC -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name run-gc -Value Invoke-GC -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name vi -Value Invoke-VisualEditor -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name vim -Value Invoke-VisualEditor -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Get-AtomicTime -Value Get-NtpTime -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name append-classpath -Value Invoke-AppendClassPath -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name JavaLove -Value Invoke-JavaLove -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name ll -Value Invoke-PowerLL -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Load-Pester -Value Reload-PesterModule -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Load-Test -Value Reload-PesterModule -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name man -Value Invoke-PowerHelp -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name md -Value Invoke-MakeDirectory -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name mkdir -Value Invoke-MakeDirectory -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name ls -Value Get-MyLS -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name myls -Value Get-MyLS -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name pgrep -Value Find-String -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name rdp -Value Invoke-RDPSession -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name AcceptProtocolViolation -Value Set-AcceptProtocolViolation -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Set-TextEncoding -Value Set-Encoding -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name sudo -Value Invoke-WithElevation -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name time -Value Measure-Command -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name touch -Value Set-FileTime -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name unique -Value Get-Unique -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name uniq -Value Get-Unique -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name ConvertFrom-UnixTime -Value ConvertFrom-UnixDate -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Send-Command -Value Invoke-Command -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Explore -Value Invoke-WindowsExplorer -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name tail -Value Invoke-Tail -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name wc -Value Invoke-WordCounter -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name which -Value Invoke-Which -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name whoami -Value Invoke-Whoami -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Check-IPaddress -Value Invoke-CheckIPaddress -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Check-SessionArch -Value Invoke-CheckSessionArch -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Clean-SysInfo -Value Invoke-CleanSysInfo -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Load-CommandHistory -Value Import-CommandHistory -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Reload-Module -Value Invoke-ReloadModule -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Reload-PesterModule -Value Invoke-ReloadPesterModule -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Test-TCPPort -Value Test-Port -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
		(Set-Alias -Name Get-TcpPortStatus -Value Test-Port -Option AllScope -Scope Global -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
	}
}
