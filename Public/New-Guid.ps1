#!/usr/bin/env powershell
#requires -Version 1.0

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

if (($PSVersionTable.PSVersion.Major) -lt '5') {
	<#
			PowerShell older then Version 5 is found!
	#>

	function New-Guid {
		<#
				.SYNOPSIS
				Creates a new Guid object and displays it to the screen

				.DESCRIPTION
				Uses static System.Guid.NewGuid() method to create a new Guid object

				.EXAMPLE
				PS C:\> New-Guid
				Guid
				----
				fd6bd476-db80-44e7-ab34-47437adeb8e3

				Description
				-----------
				Creates a new Guid object and displays its GUI to the screen

				.EXAMPLE
				PS C:\> (New-Guid).guid
				fd6bd476-db80-44e7-ab34-47437adeb8e3

				Description
				-----------
				Creates a new Guid object and displays its GUI to the screen

				.NOTES
				This is just a quick & dirty helper function to generate GUID's
				this is neat if you need a new GUID for an PowerShell Module.

				If you have Visual Studio, you might find this function useless!

				PowerShell 5 has a function that does the same, we load this function only on older versions!

				.LINK
				https://github.com/Alright-IT/AIT.OpenSource

				.LINK
				https://github.com/Alright-IT/AIT.OpenSource/issues
		#>

		[OutputType([String])]
		[CmdletBinding()]
		param ()

		BEGIN {
			# Define object via NET
			[Guid]$guidObject = [Guid]::NewGuid()
		}

		PROCESS {
			# Dump the new Object
			Write-Output -InputObject $guidObject.Guid
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
