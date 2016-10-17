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

if (($PSVersionTable.PSVersion.Major) -lt '5') {
	<#
			PowerShell older then Version 5 is found!
	#>

	function Expand-CompressedItem {
		<#
				.SYNOPSIS
				It expands a compressed archive or container.

				.DESCRIPTION
				It expands a compressed archive or container.

				Currently only ZIP files are supported.
				Per default, the content of the ZIP is expanded in the current directory.
				If an item already exists, you will be visually prompted to overwrite it, skip it, or to have a second copy of the item expanded.
				This is due to the mechanism how this is implemented (via Shell.Application).

				.PARAMETER InputObject
				It specifies the archive to expand. You can either pass this parameter as a path and name to the archive or as a FileInfo object.
				You can also pass an array of archives to the parameter.
				In addition, you can pipe a single archive or an array of archives to this parameter as well.

				.PARAMETER Path
				It specifies the destination path where to expand the archive.
				By default, this is the current directory.

				.PARAMETER Format
				A description of the Format parameter.

				.EXAMPLE
				PS C:\> Expands an archive 'mydata.zip' to the current directory.

				Description
				-----------
				Expand-CompressedItem mydata.zip

				.EXAMPLE
				PS C:\> Expand-CompressedItem mydata.zip -Confirm

				Description
				-----------
				It expands an archive 'mydata.zip' to the current directory and prompts for every item to be extracted.

				.EXAMPLE
				PS C:\> Get-ChildItem Y:\Source\*.zip | Expand-CompressedItem -Path Z:\Destination -Format ZIP -Confirm

				Description
				-----------
				You can also pipe archives to the Cmdlet.
				Enumerate all ZIP files in 'Y:\Source' and passes them to the Cmdlet.
				Each item to be extracted must be confirmed.

				.EXAMPLE
				PS C:\> Expand-CompressedItem "Y:\Source\data1.zip","Y:\Source\data2.zip"

				Description
				-----------
				It expands the archives 'data1.zip' and 'data2.zip' to the current directory.

				.EXAMPLE
				PS C:\> @("Y:\Source\data1.zip","Y:\Source\data2.zip") | Expand-CompressedItem

				Description
				-----------
				It expands archives 'data1.zip' and 'data2.zip' to the current directory.

				.NOTES
				This is just a adopted version of the function find here:
				http://dfch.biz/biz/dfch/PS/System/Utilities/biz.dfch.PS.System.Utilities.psd1/

				.LINK
				Online Version: http://dfch.biz/biz/dfch/PS/System/Utilities/Expand-CompressedItem/
		#>

		[CmdletBinding()]
		PARAM (
			[ValidateScript( {
						Test-Path -Path ($_)
			} )]
			[Parameter(Mandatory,HelpMessage = 'It specifies the archive to expand.', ValueFromPipeline, Position = 0)]
			[String]$InputObject,
			[ValidateScript( {
						Test-Path -Path ($_)
			} )]
			[Parameter(Position = 1)]
			[IO.DirectoryInfo] $Path = $PWD.Path,
			[ValidateSet('default', 'ZIP')]
			[String] $Format = 'default'
		)

		BEGIN  {
			# Currently only ZIP is supported
			switch($Format) {
				'ZIP'
				{
					# We use the Shell to extract the ZIP file. If using .NET v4.5 we could have used .NET classes directly more easily.
					$ShellApplication = (New-Object -ComObject Shell.Application)
				}
				default
				{
					# We use the Shell to extract the ZIP file. If using .NET v4.5 we could have used .NET classes directly more easily.
					$ShellApplication = (New-Object -ComObject Shell.Application)
				}
			}

			$CopyHereOptions = 4 + 1024 + 16

			# Cleanup
			$OutputParameter = $null
		}

		PROCESS {
			foreach($Object in $InputObject) {
				$Object = (Get-Item -Path $Object)
				if($PSCmdlet.ShouldProcess( ("Extract '{0}' to '{1}'" -f $Object.Name, $Path.FullName) )) {
					$CompressedObject = $ShellApplication.NameSpace($Object.FullName)

					foreach($Item in $CompressedObject.Items()) {
						if($PSCmdlet.ShouldProcess( ("Extract '{0}' to '{1}'" -f $Item.Name, $Path.FullName) )) {
							$ShellApplication.Namespace($Path.FullName).CopyHere($Item, $CopyHereOptions)
						}
					}
				}
			}

			Write-Output -InputObject $OutputParameter
		}

		END {
			# Cleanup
			if($ShellApplication) {
				$ShellApplication = $null
			}
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
