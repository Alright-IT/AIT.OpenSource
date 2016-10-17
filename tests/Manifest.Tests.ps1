#requires -Version 3.0 -Modules Pester

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

Describe -Name "Check $($moduleName) Manifest" -Fixture {
	Context -Name "Manifest check for $($moduleName)" -Fixture {
		$manifestPath = ($moduleCall)
		$manifestHash = (Invoke-Expression -Command (Get-Content -Path $manifestPath -Raw))

		It -name "$($moduleName) have a valid manifest" -test { { $null = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop -WarningAction SilentlyContinue } | Should Not Throw
		}

		It -name "$($moduleName) have a valid Root Module" -test {
			$manifestHash.RootModule | Should Be "$moduleName.psm1"
		}

		It -name "$($moduleName) have no more ModuleToProcess entry" -test {
			$manifestHash.ModuleToProcess | Should BeNullOrEmpty
		}

		It -name "$($moduleName) have a valid description" -test {
			$manifestHash.Description | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) have a valid PowerShell Version Requirement" -test {
			$manifestHash.PowerShellVersion | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) have a valid PowerShell CLR Version Requirement" -test {
			$manifestHash.CLRVersion | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) have a valid author" -test {
			$manifestHash.Author | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) have a valid Company" -test {
			$manifestHash.CompanyName | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) have a valid guid" -test { {
				[guid]::Parse($manifestHash.Guid)
			} | Should Not throw
		}

		It -name "$($moduleName) have a valid copyright" -test {
			$manifestHash.CopyRight | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) have a valid Version" -test {
			$manifestHash.ModuleVersion | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) exports Functions" -test {
			$manifestHash.FunctionsToExport | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) exports Cmdlets" -test {
			$manifestHash.CmdletsToExport | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) exports Variables" -test {
			$manifestHash.VariablesToExport | Should Not BeNullOrEmpty
		}

		It -name "$($moduleName) exports Aliases" -test {
			$manifestHash.AliasesToExport | Should Not BeNullOrEmpty
		}

		It -name "Online Galleries: $($moduleName) have Categories" -test {
			$manifestHash.PrivateData.PSData.Category | Should Not BeNullOrEmpty
		}

		It -name "Online Galleries: $($moduleName) have Tags" -test {
			$manifestHash.PrivateData.PSData.Tags | Should Not BeNullOrEmpty
		}

		It -name "Online Galleries: $($moduleName) have a license URL" -test {
			$manifestHash.PrivateData.PSData.LicenseUri | Should Not BeNullOrEmpty
		}

		It -name "Online Galleries: $($moduleName) have a Project URL" -test {
			$manifestHash.PrivateData.PSData.ProjectUri | Should Not BeNullOrEmpty
		}

		It -name "Online Galleries: $($moduleName) have a Icon URL" -test {
			$manifestHash.PrivateData.PSData.IconUri | Should Not BeNullOrEmpty
		}

		It -name "Online Galleries: $($moduleName) have ReleaseNotes" -test {
			$manifestHash.PrivateData.PSData.ReleaseNotes | Should Not BeNullOrEmpty
		}

		It -name "NuGet: $($moduleName) have Info for Prerelease" -test {
			$manifestHash.PrivateData.PSData.IsPrerelease | Should Not BeNullOrEmpty
		}

		It -name "NuGet: $($moduleName) have Module Title" -test {
			$manifestHash.PrivateData.PSData.ModuleTitle | Should Not BeNullOrEmpty
		}

		It -name "NuGet: $($moduleName) have Module Summary" -test {
			$manifestHash.PrivateData.PSData.ModuleSummary | Should Not BeNullOrEmpty
		}

		It -name "NuGet: $($moduleName) have Module Language" -test {
			$manifestHash.PrivateData.PSData.ModuleLanguage | Should Not BeNullOrEmpty
		}

		It -name "NuGet: $($moduleName) have License Acceptance Info" -test {
			$manifestHash.PrivateData.PSData.ModuleRequireLicenseAcceptance | Should Not BeNullOrEmpty
		}
	}
}
