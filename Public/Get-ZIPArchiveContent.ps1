#!/usr/bin/env powershell
#requires -Version 3.0

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

if (($PSVersionTable.PSVersion.Major) -lt '5') {
	<#
			PowerShell older then Version 5 is found!
	#>

	function Get-ZIPArchiveContent {
		<#
				.SYNOPSIS
				Reading ZIP file contents without extracting it

				.DESCRIPTION
				Reading ZIP file contents without extracting it
				Use native DotNET to do so, you do NOT need any packer installed.

				.PARAMETER FileName
				Please specify one, or more, ZIP Archive to read.

				.EXAMPLE
				PS C:\> Get-ZIPArchiveContent -Archiv 'C:\temp\foo\ADPassMon.zip'

				CompressedLengthInKB   : 718
				FileExtn               : .icns
				UnCompressedLengthInKB : 753
				FileName               : AppIcon.icns
				ZipFileName            : ADPassMon.zip
				FullPath               : ADPassMon.app/Contents/Resources/AppIcon.icns

				Description
				-----------
				Reading ZIP file contents of 'C:\temp\foo\ADPassMon.zip'

				.EXAMPLE
				PS C:\> Get-ZIPArchiveContent -Archiv 'C:\temp\foo\ADPassMon.zip' -ExportCSV -CSVFile 'C:\temp\foo\test.csv'

				Description
				-----------
				Reading ZIP file contents of 'C:\temp\foo\ADPassMon.zip' and
				exports it to 'C:\temp\foo\test.csv'

				.NOTES
				This function uses dynamic parameters. As soon as you use the switch
				'-ExportCSV', the parameter '-CSVFile' is mandatory. If you do not
				specify it via the command line, the script will query for the
				information (like for any other mandatory parameter)

				The Dynamic Parameter section was stolen here:
				http://www.powershellmagazine.com/2014/05/29/dynamic-parameters-in-powershell/
		#>

		param
		(
			[Parameter(Mandatory,
					ValueFromPipeline,
					Position = 1,
			HelpMessage = 'Please specify one, or more, ZIP Archive to read.')]
			[string[]]$Archiv,
			[switch]$ExportCSV
		)

		DynamicParam {
			if ($ExportCSV) {
				# Create a new ParameterAttribute Object
				$CSVFileAttribute = (New-Object -TypeName System.Management.Automation.ParameterAttribute)
				$CSVFileAttribute.Position = 2
				$CSVFileAttribute.Mandatory = $True
				$CSVFileAttribute.HelpMessage = 'Please specify the CSV Filename'

				# Create an attributecollection object for the attribute we just created.
				$attributeCollection = (New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute])

				# Add our custom attribute
				$attributeCollection.Add($CSVFileAttribute)

				# Add our parameter specifying the attribute collection
				$ExportCSVFileParam = (New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ('CSVFile', [String], $attributeCollection))

				# Expose the name of our parameter
				$paramDictionary = (New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary)
				$paramDictionary.Add('CSVFile', $ExportCSVFileParam)

				return $paramDictionary
			}
		}

		BEGIN {
			# Dynamic Parameter Handling
			if ($paramDictionary.CSVFile.Value) {
				$CSVFile = $paramDictionary.CSVFile.Value
			}
			# Creates a new Object
			$ZipFileReporting = @()

			# Check the Microsoft DotNet Framework Version
			$dotnetversion = ([Environment]::Version)

			if (!($dotnetversion.Major -ge 4 -and $dotnetversion.Build -ge 30319)) {
				Write-Error -Message 'Microsoft DotNet Framework to old! Please install 4.5, or later.' -ErrorAction Stop

				# Still here? Make sure we are done!
				break
			}
		}

		PROCESS {
			# Import DotNET Compression library
			$null = (Add-Type -AssemblyName System.IO.Compression.FileSystem)

			# Loop over the Archives
			foreach ($zipfile in $Archiv) {
				if (Test-Path -Path $zipfile) {
					# Workaround: [IO.Compression.ZipFile] need a full File Path
					$ItemInfo = (Get-Item -Path  $zipfile)

					# Use the DotNET Compression library to get the content information
					$ArchiveFiles = [IO.Compression.ZipFile]::OpenRead($ItemInfo.FullName).Entries

					# Loop over each File in the Archive
					foreach ($ArchiveFile in $ArchiveFiles) {
						# Create a new Temp Object
						$ArchiveObject = New-Object -TypeName PSObject -Property @{
							FileName               = $($ArchiveFile.Name)
							FullPath               = $($ArchiveFile.FullName)
							CompressedLengthInKB   = ($ArchiveFile.CompressedLength/1KB).Tostring('00')
							UnCompressedLengthInKB = ($ArchiveFile.Length/1KB).Tostring('00')
							FileExtn               = ([IO.Path]::GetExtension($ArchiveFile.FullName))
							ZipFileName            = $($zipfile)
						}

						# Append the Temp Object to the Report
						$ZipFileReporting += $ArchiveObject
					}
				} else {
					Write-Warning -Message ('{0} not found!' -f $zipfile)
				}
			}

			END {
				if (-not ($ZipFileReporting)) {
					Write-Warning -Message 'Sorry, nothing to Report'
				} else {
					if ($CSVFile) {
						# Export the Info to a given CSV File
						try {
							$ZipFileReporting | Export-Csv -Path $CSVFile -NoTypeInformation
						} catch [System.Exception] {
							Write-Error -Message ('{0} - Line Number: {1}' -f $_.Exception.Message, $_.InvocationInfo.ScriptLineNumber) -ErrorAction Stop

							# Still here? Make sure we are done!
							break
						} catch {
							Write-Error -Message 'Unabel to export the output to CSV'
						}
					} else {
						# DUMP the Info
						Write-Output -InputObject $ZipFileReporting -NoEnumerate
					}
				}
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
