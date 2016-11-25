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
	if (-not (Get-AdminUser)) 
	{
		Write-Warning -Message 'This function needs Admin rights. Restart in an Elevated PowerShell.'

		break
	}
	else 
	{
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

# SIG # Begin signature block
# MIIZXgYJKoZIhvcNAQcCoIIZTzCCGUsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUE0oinZDe15DreQnX1CX/+m6O
# ns2gghPvMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
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
# BDEWBBQO0uiWqhLjwe4xS92Q2P2M1KlDlDANBgkqhkiG9w0BAQEFAASCAQAgQbOk
# XWlZgAHdO20w5HRlZlH5F6Lp6V/lStyhwDXOCFPAL8oeJEiu8vZUVIEShuaSLb0t
# FWa7+SCQsnD+G/j5JzmpgETtzrgNbKi/MHEEA039Y6Z8qhieS2RddHfsTsnnyQ9I
# XN1ysbVWY+zA7k9hRnRPAsSm4zAxMkG4t5Y5K/6+9LLa6SYVpwl6AecrowZw4nR4
# 6YIxvWOvPbrYso0P5gAN2U1m385xPy9nEH+0nZDic3+D58NRpNeuDbq1s09nV47m
# kN+MT3xGJ8FtRi4DAjqyD6bi4zmVJ3LTIzcOJnmHLfuraPShaZtIaqKE7y0o8RAR
# 83BZS2c1aQ4Z5g8doYICojCCAp4GCSqGSIb3DQEJBjGCAo8wggKLAgEBMGgwUjEL
# MAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMT
# H0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzICEhEh1pmnZJc+8fhCfukZ
# zFNBFDAJBgUrDgMCGgUAoIH9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
# KoZIhvcNAQkFMQ8XDTE2MTEyNTIwMzc0MFowIwYJKoZIhvcNAQkEMRYEFLI5xFcZ
# gxYr7pw7tV+xrSX73HXJMIGdBgsqhkiG9w0BCRACDDGBjTCBijCBhzCBhAQUY7gv
# q2H1g5CWlQULACScUCkz7HkwbDBWpFQwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoT
# EEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gVGltZXN0YW1w
# aW5nIENBIC0gRzICEhEh1pmnZJc+8fhCfukZzFNBFDANBgkqhkiG9w0BAQEFAASC
# AQBvCouKPSNSq/bHsBvEg7tq6rqKPp4KoX0B1RD/LLJIi934MZsmb2XoOe70KV3T
# MMaemWJx87jypanCGWCzOLnEFKWlkii9t9BUukzwjFBQKPU6gIBfsFFGvtyQzFjF
# QW8bO+Uz2omHvL/9623+lbLNc49YfF7+tf7jvWsBGZtiSkO3+1CGZRqNPNMrBKWc
# ml6bqiwaENrLDaWzwAsdsgJD58gQkk4tNOZ9LX1dlD4Y9TNMKalJApMDRWz+Tyj6
# QG6UzwJphUX+qJZEjOSvN07TkUnV2UbWApmT5a/pWqDHDa+uI/LA+ONLGQFF3dpc
# thjCdxWhn2Iw5QvRw6GBli1m
# SIG # End signature block
