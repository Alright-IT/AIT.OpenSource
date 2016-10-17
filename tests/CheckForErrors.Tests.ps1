#requires -Version 3.0 -Modules Pester, Pester, Pester

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

<#
		.SYNOPSIS
		Pester Unit Test

		.DESCRIPTION
		Pester is a BDD based test runner for PowerShell.

		.EXAMPLE
		PS C:\> Invoke-Pester

		.NOTES
		PESTER PowerShell Module must be installed!

		modified by     : Joerg Hochwald
		last modified   : 2016-10-17

		.LINK
		Pester https://github.com/pester/Pester
#>

# Where are we?
$modulePath = (Split-Path -Parent -Path $MyInvocation.MyCommand.Path | Split-Path -Parent)
$moduleName = 'AIT.OpenSource'
$moduleCall = ($modulePath + '\' + $moduleName + '.psd1')

# Reload the Module
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Import-Module -Name $moduleCall -DisableNameChecking -Force -Scope Global -ErrorAction Stop -WarningAction SilentlyContinue

Describe -Name "Check $($moduleName) for errors" -Fixture {
	It -name "$($moduleName) is valid PowerShell (has no script errors)" -test {
		# Cleanup
		$errors = $null
		$content = $null

		# Read the File
		$content = (Get-Content -Path $moduleCall -ErrorAction Stop)

		# Check the File
		$null = [Management.Automation.PSParser]::Tokenize($content,[ref]$errors)

		# Should have no errors!
		$errors.Count | Should Be 0
	}
}
