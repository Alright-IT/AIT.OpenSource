function Compress-GZip {
	<#
			.SYNOPSIS
			GZip Compress (.gz)

			.DESCRIPTION
			A buffered GZip (.gz) Compress function that support pipelined input

			.PARAMETER FullName
			Input File

			.PARAMETER GZipPath
			Name of the GZ Archive

			.PARAMETER Force
			Enforce it?

			.Example
			Get-ChildItem .\NotCompressFile.xml | Compress-GZip

			Description
			-----------
			GZip Compress '.\NotCompressFile.xml' to '.\NotCompressFile.xml.gz'

			.Example
			Compress-GZip -FullName "C:\scripts\NotCompressFile.xml" -NewName "Compressed.xml.funkyextension"

			Description
			-----------
			GZip Compress "C:\scripts\NotCompressFile.xml" and generates the
			archive "Compressed.xml.funkyextension" instead of the default '.gz'

			.NOTES
			Copyright 2013 Robert Nees
			Licensed under the Apache License, Version 2.0

			.LINK
			http://sushihangover.blogspot.com
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				ValueFromPipelineByPropertyName,
		HelpMessage = 'Input File')]
		[Alias('PSPath')]
		[String]$FullName,
		[Parameter(Mandatory,ValueFromPipeline,
				ValueFromPipelineByPropertyName,
		HelpMessage = 'Name of the GZ Archive')]
		[Alias('NewName')]
		[String]$GZipPath,
		[switch]$Force
	)

	PROCESS {
		$_BufferSize = 1024 * 8
		if (Test-Path -Path $FullName -PathType Leaf) {
			# Be Verbose
			Write-Verbose -Message ('Reading from: {0}' -f $FullName)

			if ($GZipPath.Length -eq 0) {
				$tmpPath = (Get-ChildItem -Path $FullName)
				$GZipPath = (Join-Path -Path ($tmpPath.DirectoryName) -ChildPath ($tmpPath.Name + '.gz'))
			}

			if (Test-Path -Path $GZipPath -PathType Leaf -IsValid) {
				Write-Verbose -Message ('Compressing to: {0}' -f $GZipPath)
			} else {
				Write-Error -Message ('{0} is not a valid path/file' -f $FullName)
				return
			}
		} else {
			Write-Error -Message ('{0} does not exist' -f $GZipPath)
			return
		}

		if (Test-Path -Path $GZipPath -PathType Leaf) {
			if ($Force.IsPresent) {
				if ($pscmdlet.ShouldProcess("Overwrite Existing File @ $GZipPath")) {
					Set-FileTime -Path $GZipPath
				}
			}
		} else {
			if ($pscmdlet.ShouldProcess("Create new Compressed File @ $GZipPath")) {
				Set-FileTime -Path $GZipPath
			}
		}

		if ($pscmdlet.ShouldProcess("Creating Compress File @ $GZipPath")) {
			# Be Verbose
			Write-Verbose -Message 'Opening streams and file to save compressed version to...'

			$Input = (New-Object -TypeName System.IO.FileStream -ArgumentList (Get-ChildItem -Path $FullName).FullName, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read))
			$output = (New-Object -TypeName System.IO.FileStream -ArgumentList (Get-ChildItem -Path $GZipPath).FullName, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None))
			$gzipStream = (New-Object -TypeName System.IO.Compression.GzipStream -ArgumentList $output, ([IO.Compression.CompressionMode]::Compress))

			try {
				$buffer = (New-Object -TypeName byte[] -ArgumentList ($_BufferSize))
				while ($True) {
					$read = ($Input.Read($buffer, 0, ($_BufferSize)))
					if ($read -le 0) {
						break
					}
					$gzipStream.Write($buffer, 0, $read)
				}
			} finally {
				# Be Verbose
				Write-Verbose -Message 'Closing streams and newly compressed file'

				$gzipStream.Close()
				$output.Close()
				$Input.Close()
			}
		}
	}
}

function Expand-GZip {
	<#
			.SYNOPSIS
			GZip Decompress (.gz)

			.DESCRIPTION
			A buffered GZip (.gz) Decompress function that support pipelined input

			.PARAMETER FullName
			The input file

			.PARAMETER GZipPath
			Name of the GZip Archive

			.PARAMETER Force
			Enforce it?

			.Example
			Get-ChildItem .\locations.txt.gz | Expand-GZip -Verbose -WhatIf
			VERBOSE: Reading from: C:\scripts\PowerShell\locations.txt.gz
			VERBOSE: Decompressing to: C:\scripts\PowerShell\locations.txt
			What if: Performing the operation "Expand-GZip" on target "Creating Decompressed File @ C:\scripts\PowerShell\locations.txt".

			Description
			-----------
			Simulate GZip Decompress of archive 'locations.txt.gz'

			.Example
			Get-ChildItem .\locations.txt.gz | Expand-GZip

			Description
			-----------
			GZip Decompress 'locations.txt.gz' to 'locations.txt'

			.Example
			Expand-GZip -FullName 'locations.txt.gz' -NewName 'NewLocations.txt' instead of the default 'locations.txt'

			Description
			-----------
			GZip Decompress 'locations.txt.gz' to 'NewLocations.txt

			.NOTES
			Copyright 2013 Robert Nees
			Licensed under the Apache License, Version 2.0 (the "License");

			.LINK
			http://sushihangover.blogspot.com
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				ValueFromPipelineByPropertyName,
		HelpMessage = 'The input file')]
		[Alias('PSPath')]
		[String]$FullName,
		[Parameter(ValueFromPipeline,
		ValueFromPipelineByPropertyName)]
		[Alias('NewName')]
		[String]$GZipPath = $null,
		[switch]$Force
	)

	PROCESS {
		if (Test-Path -Path $FullName -PathType Leaf) {
			# Be Verbose
			Write-Verbose -Message ('Reading from: {0}' -f $FullName)

			if ($GZipPath.Length -eq 0) {
				$tmpPath = (Get-ChildItem -Path $FullName)
				$GZipPath = (Join-Path -Path ($tmpPath.DirectoryName) -ChildPath ($tmpPath.BaseName))
			}

			if (Test-Path -Path $GZipPath -PathType Leaf -IsValid) {
				Write-Verbose -Message ('Decompressing to: {0}' -f $GZipPath)
			} else {
				Write-Error -Message ('{0} is not a valid path/file' -f $GZipPath)
				return
			}
		} else {
			Write-Error -Message ('{0} does not exist' -f $FullName)
			return
		}
		if (Test-Path -Path $GZipPath -PathType Leaf) {
			if ($Force.IsPresent) {
				if ($pscmdlet.ShouldProcess("Overwrite Existing File @ $GZipPath")) {
					Set-FileTime -Path $GZipPath
				}
			}
		} else {
			if ($pscmdlet.ShouldProcess("Create new decompressed File @ $GZipPath")) {
				Set-FileTime -Path $GZipPath
			}
		}
		if ($pscmdlet.ShouldProcess("Creating Decompressed File @ $GZipPath")) {
			# Be Verbose
			Write-Verbose -Message 'Opening streams and file to save compressed version to...'

			$Input = (New-Object -TypeName System.IO.FileStream -ArgumentList (Get-ChildItem -Path $FullName).FullName, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read))
			$output = (New-Object -TypeName System.IO.FileStream -ArgumentList (Get-ChildItem -Path $GZipPath).FullName, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None))
			$gzipStream = (New-Object -TypeName System.IO.Compression.GzipStream -ArgumentList $Input, ([IO.Compression.CompressionMode]::Decompress))

			try {
				$buffer = (New-Object -TypeName byte[] -ArgumentList (1024))
				while ($True) {
					$read = ($gzipStream.Read($buffer, 0, 1024))
					if ($read -le 0) {
						break
					}
					$output.Write($buffer, 0, $read)
				}
			} finally {
				# Be Verbose
				Write-Verbose -Message 'Closing streams and newly decompressed file'

				$gzipStream.Close()
				$output.Close()
				$Input.Close()
			}
		}
	}
}

function Initialize-Modules {
	<#
			.SYNOPSIS
			Initialize PowerShell Modules

			.DESCRIPTION
			Initialize PowerShell Modules

			.NOTES
			Needs to be documented (Issue NETXDEV-23 opened)

			.EXAMPLE
			PS C:\> Initialize-Modules

			Description
			-----------
			Initialize PowerShell Modules

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		# is this a module?
		Get-Module |
		Where-Object -FilterScript { Test-Method -Module $_.Name -Function $_.Name } |
		ForEach-Object
		{
			# Define object
			Set-Variable -Name functionName -Value $($_.Name)

			# Show a verbose message
			Write-Verbose -Message ('Initializing Module {0}' -f $functionName)

			# Execute
			$null = Invoke-Expression -Command $functionName
		}
	}
}

function Invoke-NTFSFilesCompression {
	<#
			.SYNOPSIS
			Compress files with given extension older than given amount of time

			.DESCRIPTION
			The function is intended for compressing (using the NTFS compression)
			all files with particular extensions older than given time unit

			.PARAMETER Path
			The folder path that contain files. Folder path can be pipelined.

			.PARAMETER OlderThan
			The count of units that are base to comparison file age.

			.PARAMETER TimeUnit
			The unit of time that are used to count.

			The default time unit are minutes.

			.PARAMETER Extension
			The extension of files that will be processed.

			The default file extension is log.

			.PARAMETER OlderThan
			The count of units that are base to comparison file age.

			.EXAMPLE
			PS C:\> Invoke-NTFSFilesCompression -Path "C:\test" -OlderThan "20"

			Description
			-----------
			Compress files with extension log in folder 'c:\test' that are older
			than 20 minutes

			.EXAMPLE
			PS C:\> Invoke-NTFSFilesCompression -Path "C:\test" -OlderThan "1" -TimeUnit "hours" -Extension "txt"

			Description
			-----------
			Compress files with extension txt in folder 'c:\test' that are
			older than 1 hour

			.NOTES
			Based on an idea of  Wojciech Sciesinski
	#>

	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
		HelpMessage = 'The folder path that contain files. Folder path can be pipelined.')]
		[string[]]$Path,
		[Parameter(Mandatory,
		HelpMessage = 'The count of units that are base to comparison file age.')]
		[int]$OlderThan,
		[ValidateSet('minutes', 'hours', 'days', 'weeks')]
		[string[]]$TimeUnit = 'minutes',
		[string[]]$Extension = 'log'
	)

	BEGIN {
		$excludedfiles = 'temp.log', 'temp2.log', 'source.log'

		# translate action to numeric value required by the method
		switch ($TimeUnit) {
			'minutes' {
				$multiplier = 1
				break
			}
			'hours' {
				$multiplier = 60
				break
			}
			'days' {
				$multiplier = 1440
				break
			}
			'weeks' {
				$multiplier = 10080
				break
			}
		}

		$OlderThanMinutes = $($OlderThan * $multiplier)
		$compressolder = $(Get-Date).AddMinutes(- $OlderThanMinutes)
		$filterstring = '*.' + $Extension
		$files = (Get-ChildItem -Path $Path -Filter $filterstring)
	}

	PROCESS {
		ForEach ($i in $files) {
			if ($i.Name -notin $excludedfiles) {
				$filepathforquery = $($i.FullName).Replace('\', '\\')
				$File = (Get-WmiObject -Query "SELECT * FROM CIM_DataFile Where-Object Name='$filepathforquery'")

				if ((-not ($File.compressed)) -and $i.LastWriteTime -lt $compressolder) {
					Write-Verbose -Message ('Start compressing file {0}.name' -f $i)

					#Invoke compression
					$null = $File.Compress()
				} #End if
			} #End if
		}
	}
}

function Invoke-RemoteScript {
	<#
			.SYNOPSIS
			Invokes a existing script on a remote system

			.DESCRIPTION
			Invokes a existing script on a remote system

			.EXAMPLE
			PS C:\> Invoke-RemoteScript

			Description
			-----------
			Invokes a existing script on a remote system

			.PARAMETER Computer
			The remote computer to execute files on.

			.PARAMETER Folder
			Any folders (on the local computer) that need copied to the remote
			computer prior to execution

			.PARAMETER Script
			The Powershell script path (on the local computer) that needs
			executed on the remote computer

			.PARAMETER Drive
			The remote drive letter the script will be executed on and the
			folder will be copied to

			.NOTES
			Idea: http://www.leeholmes.com/blog/2009/11/20/testing-for-powershell-remoting-test-psremoting/

			.LINK
			Idea: http://www.leeholmes.com/blog/2009/11/20/testing-for-powershell-remoting-test-psremoting/
	#>

	[CmdletBinding(ConfirmImpact = 'None')]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
				ValueFromPipelineByPropertyName,
		HelpMessage = 'The remote computer to execute files on.')]
		[Alias('Computername')]
		[String]$Computer,
		[Parameter(Mandatory,
		HelpMessage = 'Any folders (on the local computer) that need copied to the remote computer prior to execution')]
		[Alias('FolderPath')]
		[String]$Folder,
		[Parameter(Mandatory,
		HelpMessage = 'The Powershell script path (on the local computer) that needs executed on the remote computer')]
		[Alias('ScriptPath')]
		[String]$Script,
		[Alias('RemoteDrive')]
		[String]$Drive = 'C'
	)

	BEGIN {
		# Helper function
		function Test-PsRemoting {
			param (
				[Parameter(Mandatory,HelpMessage = 'Add help message for user')]
				$ComputerName
			)

			try {
				$errorActionPreference = 'Stop'
				$result = Invoke-Command -ComputerName $ComputerName -ScriptBlock { 1 }
			} catch {
				Write-Verbose -Message $_
				Return $False
			}

			# What?
			if ($result -ne 1) {
				Write-Verbose -Message ('Remoting to {0} returned an unexpected result.' -f $ComputerName)
				Return $False
			}
			Return $True
		}

		# Be Verbose
		Write-Verbose -Message 'Validating prereqs for remote script execution...'

		if (-not (Test-Path -Path $Folder)) {
			throw 'Folder path does not exist'
		} elseif (-not (Test-Path -Path $Script)) {
			throw 'Script path does not exist'
		} elseif ((Get-ItemProperty -Path $Script).Extension -ne '.ps1') {
			throw 'Script specified is not a Powershell script'
		}

		$ScriptName = ($Script | Split-Path -Leaf)
		$RemoteFolderPath = ($Folder | Split-Path -Leaf)
		$RemoteScriptPath = "$Drive`:\$RemoteFolderPath\$ScriptName"
	}

	PROCESS {
		# Be Verbose
		Write-Verbose -Message ('Copying the folder {0} to the remote computer {1}...' -f $Folder, $Computer)

		Copy-Item -Path $Folder -Recurse -Destination "\\$Computer\$Drive" -Force

		# Be Verbose
		Write-Verbose -Message ('Copying the script {0} to the remote computer {1}...' -f $ScriptName, $Computer)

		Copy-Item -Path $Script -Destination "\\$Computer\$Drive\$RemoteFolderPath" -Force

		# Be Verbose
		Write-Verbose -Message ('Executing {0} on the remote computer {1}...' -f $RemoteScriptPath, $Computer)

		([WMICLASS]"\\$Computer\Root\CIMV2:Win32_Process").create("powershell.exe -File $RemoteScriptPath -NonInteractive -NoProfile")
	}
}

function New-Gitignore {
	<#
			.SYNOPSIS
			Create a new .gitignore file with my default settings

			.DESCRIPTION
			Downloads my default .gitignore from GitHub and creates it within
			the directory from Where-Object this function is called.

			.PARAMETER Source
			The Source for the .gitignore

			.EXAMPLE
			PS C:\scripts\PowerShell\test> New-Gitignore
			Creating C:\scripts\PowerShell\test\.gitignore
			C:\scripts\PowerShell\test\.gitignore successfully created.

			Description
			-----------
			The default: We downloaded the default .gitignore from GitHub

			.EXAMPLE
			PS C:\scripts\PowerShell\test\> New-Gitignore
			WARNING: You already have a .gitignore in this dir.
			Fetch a fresh one from GitHub?
			Removing existing .gitignore.
			Creating C:\scripts\PowerShell\test\.gitignore
			C:\scripts\PowerShell\test\.gitignore successfully created.

			Description
			-----------
			In this example we had an existing .gitignore and downloaded the
			default one from GitHub...

			.EXAMPLE
			PS C:\scripts\PowerShell\test> New-Gitignore
			WARNING: You already have a .gitignore in this dir.
			Fetch a fresh one from GitHub?
			Existing .gitignore will not be changed.

			Description
			-----------
			In this Example we had an existing .gitignore and we decided to
			stay with em!

			.NOTES
			TODO: Move the default .gitignore to enatec.io

			.LINK
			SourceFile https://raw.githubusercontent.com/Alright-IT/AIT.OpenSource/master/.gitignore

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[String]$Source = 'https://raw.githubusercontent.com/Alright-IT/AIT.OpenSource/master/.gitignore'
	)

	BEGIN {
		$GitIgnore = "$PWD\.gitignore"
	}

	PROCESS {
		if (Test-Path -Path $GitIgnore) {
			Write-Warning -Message 'You already have a .gitignore in this dir.'
			Write-Output -InputObject ''
			Write-Output -InputObject 'Fetch a fresh one from GitHub?'

			$Answer = ([Console]::ReadKey('NoEcho,IncludeKeyDown'))

			if ($Answer.Key -ne 'Enter' -and $Answer.Key -ne 'y') {
				Write-Output -InputObject ''
				Write-Output -InputObject 'Existing .gitignore will not be changed.'
				return
			}

			Write-Output -InputObject ''
			Write-Host -Object 'Removing existing .gitignore.'

			try {
				(Remove-Item -Path "$PWD\.gitignore" -Force -Confirm:$False -WarningAction SilentlyContinue -ErrorAction Stop) > $null 2>&1 3>&1
			} catch {
				Write-Output -InputObject ''
				Write-Output -InputObject ''
				Write-Warning -Message ('Unable to remove existing {0}\.gitignore' -f $PWD)
				break
			}
		}

		Write-Output -InputObject ''
		Write-Output -InputObject ('Creating {0}\.gitignore' -f $PWD)

		try {
			$WC = (New-Object -TypeName System.Net.WebClient)
			$WC.DownloadString($Source) | New-Item -ItemType file -Path $PWD -Name '.gitignore' -Force -Confirm:$False -WarningAction SilentlyContinue -ErrorAction Stop > $null 2>&1 3>&1

			Write-Output -InputObject ''
			Write-Output -InputObject ('{0}\.gitignore successfully created.' -f $PWD)
		} catch {
			Write-Output -InputObject ''
			Write-Output -InputObject ''
			Write-Warning -Message ('Unable to create {0}\.gitignore' -f $PWD)
		}
	}
}

function Open-InternetExplorer {
	<#
			.SYNOPSIS
			Workaround for buggy internetexplorer.application

			.DESCRIPTION
			This Workaround is neat, because the native implementation is unable to
			bring the new Internet Explorer Window to the front (give em focus).
			It needs his companion: Add-NativeHelperType

			.PARAMETER Url
			The URL you would like to open in Internet Explorer

			.PARAMETER Foreground
			Should the new Internet Explorer start in the foreground?

			The default is YES.

			.PARAMETER FullScreen
			Should the new Internet Explorer Session start in Full Screen

			The Default is NO

			.EXAMPLE
			PS C:\> Open-InternetExplorer -Url 'http://enatec.io' -FullScreen -InForeground

			Description
			-----------
			Start Internet Explorer in Foreground and fullscreen,
			it also opens http://enatec.io

			.EXAMPLE
			PS C:\> Open-InternetExplorer -Url 'https://portal.office.com'

			Description
			-----------
			Start Internet Explorer in Foreground with the URL
			https://portal.office.com

			.LINK
			Source: http://superuser.com/questions/848201/focus-ie-window-in-powershell

			.LINK
			Info: https://msdn.microsoft.com/en-us/library/windows/desktop/ms633539(v=vs.85).aspx

			.NOTES
			It needs his companion: Add-NativeHelperType
			Based on a snippet from Crippledsmurf
	#>

	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[String]$url = 'http://enatec.io',
		[Alias('fg')]
		[switch]$Foreground = $True,
		[Alias('fs')]
		[switch]$FullScreen = $False
	)
	BEGIN {
		# If we want to start in Foreground, we use our helper
		if ($Foreground) {Add-NativeHelperType}
	}

	PROCESS {
		# Initiate a new IE
		$internetExplorer = New-Object -ComObject 'InternetExplorer.Application'

		# The URL to open
		$internetExplorer.navigate($url)

		# Should is be Visible?
		$internetExplorer.Visible = $True

		# STart un fullscreen?
		$internetExplorer.FullScreen = $FullScreen

		# Here is the Magic!
		if ($Foreground) {[NativeHelper]::SetForeground($internetExplorer.HWND) > $null 2>&1 3>&1}
	}

	END {
		# Be verbose
		Write-Verbose -Message ('{0}' -f $internetExplorer)
	}
}

function Add-AppendPath {
	<#
			.SYNOPSIS
			Appends a given folder (Directory) to the Path

			.DESCRIPTION
			Appends a given folder (Directory) to the Path

			.EXAMPLE
			PS C:\> Add-AppendPath

			Description
			-----------
			Adds "C:\scripts\PowerShell\" (the default) to the Path

			.EXAMPLE
			PS C:\> Add-AppendPath -Path 'C:\scripts\batch\'

			Description
			-----------
			Adds 'C:\scripts\batch\' to the Path

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>
	param
	(
		[Parameter(ValueFromPipeline,
		Position = 0)]
		[ValidateNotNullOrEmpty()]
		[Alias('Folder')]
		[String]$Pathlist = 'C:\scripts\PowerShell\'
	)

	PROCESS {
		foreach ($Path in $Pathlist) {
			# Save the Path
			$OriginalPaths = ($env:Path)

			# Check if the given Folder is already in the Path!
			$ComparePath = ('*' + $Path + '*')

			if (-not ($OriginalPaths -like $ComparePath)) {
				# Nope, so we add the folder to the Path!
				$env:Path = ($env:Path + ';' + $BasePath)
			}

			# Cleanup
			$ComparePath = $null
			$OriginalPaths = $null
		}
	}
}

function Remove-FromPath {
	<#
			.SYNOPSIS
			Removes given Directory or Directories from the PATH

			.DESCRIPTION
			Removes given Directory or Directories from the PATH

			.PARAMETER Pathlist
			The PATH to remove

			.EXAMPLE
			PS C:\> Remove-FromPath -Pathlist 'C:\scripts\batch\'

			Description
			-----------
			Removes 'C:\scripts\batch\' from the Path

			.LINK
			Add-AppendPath

			.NOTES
			Just a little helper function
	#>

	param
	(
		[Parameter(Mandatory,HelpMessage = 'The PATH to remove')]
		[ValidateNotNullOrEmpty()]
		[String[]]$Pathlist
	)

	PROCESS {
		foreach ($Path in $Pathlist) {
			$Path = @() + $Path
			$paths = ($env:Path -split ';')
			$paths = ($paths | Where-Object -FilterScript { $Path -notcontains $_ })
			$env:Path = $paths -join ';'
		}
	}
}

function Out-ColorMatchInfo {
	<#
			.Synopsis
			Highlights MatchInfo objects similar to the output from grep.

			.Description
			Highlights MatchInfo objects similar to the output from grep.

			.PARAMETER match
			Matching word

			.EXAMPLE
			PS C:\> Out-ColorMatchInfo

			Description
			-----------
			Highlights MatchInfo objects similar to the output from grep.

			.NOTES
			modified by     : Joerg Hochwald
			last modified   : 2016-10-19

			.LINK
			Source http://poshcode.org/1095
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,
				ValueFromPipeline,
		HelpMessage = 'Matching word')]
		[Microsoft.PowerShell.Commands.MatchInfo]
		$Match
	)

	BEGIN {
		function Get-RelativePath
		{
			param
			(
				[Parameter(Mandatory,HelpMessage = 'Add help message for user')][string]
				$Path
			)

			$Path = $Path.Replace($PWD.Path, '')

			if ($Path.StartsWith('\') -and (-not $Path.StartsWith('\\'))) {$Path = $Path.Substring(1)}

			$Path
		}

		function Write-PathAndLine
		{
			param
			(
				[Parameter(Mandatory,HelpMessage = 'Add help message for user')][Object]
				$Match
			)

			Write-Host -Object (Get-RelativePath -Folder $Match.Path) -ForegroundColor White -NoNewline
			Write-Host -Object ':' -ForegroundColor Cyan -NoNewline
			Write-Host -Object $Match.LineNumber -ForegroundColor DarkYellow
		}

		function Write-HighlightedMatch
		{
			param
			(
				[Parameter(Mandatory,HelpMessage = 'Add help message for user')][Object]
				$Match
			)

			$index = 0

			foreach ($m in $Match.Matches)
			{
				Write-Host -Object $Match.Line.SubString($index, $m.Index - $index) -NoNewline
				Write-Host -Object $m.Value -ForegroundColor Red -NoNewline
				$index = $m.Index + $m.Length
			}

			if ($index -lt $Match.Line.Length) { Write-Host -Object $Match.Line.SubString($index) -NoNewline }
			''
		}
	}

	PROCESS {
		Write-PathAndLine -Match $Match

		$Match.Context.DisplayPreContext

		Write-HighlightedMatch -Match $Match

		$Match.Context.DisplayPostContext
		''
	}
}

# TODO: Rename!!!
function PoSHModuleLoader
{
	<#
			.SYNOPSIS
			Loads all Script modules

			.DESCRIPTION
			Loads all Script modules

			.NOTES
			Old function that we no longer use

			.EXAMPLE
			PS C:\> PoSHModuleLoader

			Description
			-----------
			Loads all Script modules

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		# Load some PoSH modules
		(Get-Module -ListAvailable |
			Where-Object -FilterScript { $_.ModuleType -eq 'Script' } |
		Import-Module -DisableNameChecking -Force -Scope Global -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	}
}

function Export-Session {
	<#
			.SYNOPSIS
			Export PowerShell session info to a file

			.DESCRIPTION
			This is a (very) poor man approach to save some session infos

			Our concept of session is simple and only considers:
			- history
			- The Export-Session

			But still can be very handy and useful. If you type in some sneaky
			commands, or some very complex things and you did not copied these to
			another file or script it can save you a lot of time if you need to
			do it again (And this is often the case)

			Even if you just want to dump it quick to copy it some when later to
			a documentation or script this might be useful.

			.EXAMPLE
			PS C:\> Export-Session

			Description
			-----------
			Export the history and the Export-Session to a default File like
			'session-2016040512.ps1session', dynamically generated based on
			Time/date

			.EXAMPLE
			PS C:\> Export-Session -sessionName 'C:\scripts\mySession'

			Description
			-----------
			Export the history and the Export-Session to the File
			'C:\scripts\mySession.ps1session'

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(ValueFromPipeline,
		Position = 1)]
		[ValidateNotNullOrEmpty()]
		[String]$sessionName = "session-$(Get-Date -Format yyyyMMddhh)"
	)

	BEGIN {
		# Define object
		Set-Variable -Name file -Value $(Get-SessionFile -sessionName $sessionName)
	}

	PROCESS {
		#
		(Get-Location).Path > "$File-pwd.ps1session"

		#
		Get-History | Export-Csv -Path "$File-hist.ps1session"
	}

	END {
		# Dump what we have
		Write-Output -InputObject ('Session {0} saved' -f $sessionName)
	}
}

function Import-Session
{
	<#
			.SYNOPSIS
			Import a PowerShell session info from file

			.DESCRIPTION
			This is a (very) poor man approach to restore some session infos

			Our concept of session is simple and only considers:
			- history
			- The current directory

			But still can be very handy and useful. If you type in some sneaky
			commands, or some very complex things and you did not copied these to
			another file or script it can save you a lot of time if you need
			to do it again (And this is often the case)

			Even if you just want to dump it quick to copy it some when later to a
			documentation or script this might be useful.

			.EXAMPLE
			PS C:\> Import-Session -sessionName 'session-2016101902'

			Description
			-----------
			Import the history and the export-session from the File
			'C:\scripts\mySession.ps1session'

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')]
		[ValidateNotNullOrEmpty()]
		[Alias('Session')]
		[String]$sessionName
	)

	BEGIN {
		# Define object
		Set-Variable -Name file -Value $(Get-SessionFile -sessionName $sessionName)
	}

	PROCESS {
		# What do we have?
		if (-not [io.file]::Exists("$File-pwd.ps1session"))
		{
			Write-Error -Message "Session file doesn't exist" -ErrorAction Stop
		}
		else
		{
			Set-Location -Path (Get-Content -Path "$File-pwd.ps1session")
			Import-Csv -Path "$File-hist.ps1session" | Add-History
		}
	}
}

function Get-SessionFile {
	<#
			.SYNOPSIS
			Restore PowerShell Session information

			.DESCRIPTION
			This command shows many PowerShell Session informations.

			.PARAMETER sessionName
			Name of the Session you would like to dump

			.EXAMPLE
			PS C:\> Get-SessionFile $O365Session
			C:\Users\adm.jhochwald\AppData\Local\Temp\[PSSession]Session2

			Description
			-----------
			Returns the Session File for a given Session

			.EXAMPLE
			PS C:\> Get-SessionFile
			C:\Users\adm.jhochwald\AppData\Local\Temp\

			Description
			-----------
			Returns the Session File of the running session, cloud be none!

			.NOTES
			This is just a little helper function to make the shell more flexible

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	[OutputType([String])]
	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')]
		[ValidateNotNullOrEmpty()]
		[Alias('Session')]
		[String]$sessionName
	)

	PROCESS {
		# DUMP
		Return ('{0}{1}' -f [io.path]::GetTempPath(), $sessionName)
	}
}

function Reset-Prompt {
	<#
			.SYNOPSIS
			Restore the Default Prompt

			.DESCRIPTION
			Restore the Default Prompt

			.EXAMPLE
			Josh@fra1w7vm01 /scripts/PowerShell/functions $ Reset-Prompt
			PS C:\scripts\PowerShell\functions>

			Description
			-----------
			If you modified the prompt before, this command restores the
			PowerShell default for you

			.NOTES
			Just a quick helper!

			Reset the prompt and the window title back to the defaults

			.LINK
			Set-LinuxPrompt
			Set-PowerPrompt

			.LINK
			Set-DefaultPrompt
			Set-ServicePrompt
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		if ($pscmdlet.ShouldProcess('Prompt', 'Restore the default')) {
			function Global:Prompt {
				<#
						.SYNOPSIS
						Set a default prompt

						.DESCRIPTION
						Set a default prompt

						.EXAMPLE
						PS C:\> prompt

						# Set a default prompt
				#>

				# Create a default prompt
				Write-Host -Object ('PS ' + (Get-Location) + '> ')

				# Blank
				Return ' '
			}

			<#
					Also Reset the Window Title
			#>
			# Are we elevated or administrator?
			if ((New-Object -TypeName Security.Principal.WindowsPrincipal -ArgumentList ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
				# Administrator Session!
				$Host.ui.RawUI.WindowTitle = 'Administrator: Windows PowerShell'
			} else {
				# User Session!
				$Host.ui.RawUI.WindowTitle = 'Windows PowerShell'
			}
		}
	}

	END {
		if ($pscmdlet.ShouldProcess('Prompt', 'Restore the default')) {
			# Execute!
			prompt
		}
	}
}

function Set-LinuxPrompt {
	<#
			.SYNOPSIS
			Make the Prompt more Linux (bash) like

			.DESCRIPTION
			Make the Prompt more Linux (bash) like

			.EXAMPLE
			PS C:\Windows\system32> Set-LinuxPrompt
			Josh@fra1w7vm01 /Windows/system32 #

			Description
			-----------
			The user 'Josh' executes the 'Set-LinuxPrompt' on the system
			'fra1w7vm01', the '#' shows that he did that in an
			elevated (started as Administrator) session.

			.EXAMPLE
			PS C:\Users\Josh> Set-LinuxPrompt
			Josh@fra1w7vm01 ~ $

			Description
			-----------
			The user 'Josh' executes the 'Set-LinuxPrompt' on the system
			'fra1w7vm01', the '$' shows that this is a non elevated (User) session.

			.NOTES
			Based on an idea of Tommy Maynard
			If you want a more colorful Prompt, take a look at the
			Set-PowerPrompt command

			.LINK
			Source http://tommymaynard.com/quick-learn-duplicate-the-linux-prompt-2016/

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues

			.LINK
			Set-PowerPrompt
			Reset-Prompt

			.LINK
			Set-DefaultPrompt
			Set-ServicePrompt
	#>

	[CmdletBinding()]
	param ()

	BEGIN {
		(Get-PSProvider -PSProvider FileSystem).Home = $env:USERPROFILE
	}

	PROCESS {
		if ($pscmdlet.ShouldProcess('Prompt', 'Set it to a Bash styled one')) {
			function Global:Prompt {
				# Are we elevated or administrator?
				if ((New-Object -TypeName Security.Principal.WindowsPrincipal -ArgumentList ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
					# Administrator Session!
					$Symbol = '#'
				} else {
					# User Session!
					$Symbol = '$'
				}

				if ($PWD.Path -eq $env:USERPROFILE) {
					$Location = '~'
				} elseif ($PWD.Path -like "*$env:USERPROFILE*") {
					$Location = ($PWD.Path -replace ($env:USERPROFILE -replace '\\', '\\'), '~' -replace '\\', '/')
				} else {
					$Location = "$(($PWD.Path -replace '\\', '/' -split ':')[-1])"
				}

				$Prompt = "$(${env:UserName}.ToLower())@$($env:COMPUTERNAME.ToLower()) $Location $Symbol "

				# Mirror the Prompt to the window title
				$Host.UI.RawUI.WindowTitle = ($Prompt)
				$Prompt
			}
		}
	}

	END {
		if ($pscmdlet.ShouldProcess('Prompt', 'Set it to a Bash styled one')) {
			# Execute!
			prompt
		}
	}
}

function Set-PowerPrompt {
	<#
			.SYNOPSIS
			Multicolored prompt with marker for windows started as Admin and
			marker for providers outside file system

			.DESCRIPTION
			Multicolored prompt with marker for windows started as Admin and
			marker for providers outside file system

			.EXAMPLE
			[Admin] C:\Windows\System32>

			Description
			-----------
			Multicolored prompt with marker for windows started as Admin and
			marker for providers outside file system

			.EXAMPLE
			[Registry] HKLM:\SOFTWARE\Microsoft\Windows>

			Description
			-----------
			Multicolored prompt with marker for windows started as Admin and
			marker for providers outside file system

			.EXAMPLE
			[Admin] [Registry] HKLM:\SOFTWARE\Microsoft\Windows>

			Description
			-----------
			Multicolored prompt with marker for windows started as Admin and
			marker for providers outside file system

			.NOTES
			Just an internal function to make my life easier!

			.LINK
			Source: http://www.snowland.se/2010/02/23/nice-powershell-prompt/

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues

			.LINK
			Set-LinuxPrompt
			Reset-Prompt

			.LINK
			Set-DefaultPrompt
			Set-ServicePrompt
	#>

	[CmdletBinding()]
	param ()

	PROCESS {
		if ($pscmdlet.ShouldProcess('Prompt', 'Set Multicolored')) {
			function Global:Prompt {
				[OutputType([String])]
				[CmdletBinding()]
				param ()

				# New nice WindowTitle
				$Host.UI.RawUI.WindowTitle = 'PowerShell v' + (Get-Host).Version.Major + '.' + (Get-Host).Version.Minor + ' (' + $PWD.Provider.Name + ') ' + $PWD.Path

				# Are we elevated or administrator?
				if ((New-Object -TypeName Security.Principal.WindowsPrincipal -ArgumentList ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
					# Admin-mark in WindowTitle
					$Host.UI.RawUI.WindowTitle = '[Admin] ' + $Host.UI.RawUI.WindowTitle

					# Admin-mark on prompt
					Write-Host -Object '[' -NoNewline -ForegroundColor DarkGray
					Write-Host -Object 'Admin' -NoNewline -ForegroundColor Red
					Write-Host -Object '] ' -NoNewline -ForegroundColor DarkGray
				}

				# Show provider name if you are outside FileSystem
				if ($PWD.Provider.Name -ne 'FileSystem') {
					Write-Host -Object '[' -NoNewline -ForegroundColor DarkGray
					Write-Host -Object $PWD.Provider.Name -NoNewline -ForegroundColor Gray
					Write-Host -Object '] ' -NoNewline -ForegroundColor DarkGray
				}

				# Split path and write \ in a gray
				$PWD.Path.Split('\') | ForEach-Object -Process {
					Write-Host -Object $_ -NoNewline -ForegroundColor Yellow
					Write-Host -Object '\' -NoNewline -ForegroundColor Gray
				}

				# Backspace last \ and write >
				Write-Host -Object "`b>" -NoNewline -ForegroundColor Gray

				Return ' '
			}
		}
	}

	END {
		if ($pscmdlet.ShouldProcess('Prompt', 'Set Multicolored')) {
			# Execute!
			prompt
		}
	}
}

function Write-ToLog {
	<#
			.SYNOPSIS
			Write Log to file and screen

			.DESCRIPTION
			Write Log to file and screen
			Each line has a UTC Time-stamp

			.PARAMETER LogFile
			Name of the Log-file

			.EXAMPLE
			PS C:\> Write-ToLog -LogFile 'C:\scripts\PowerShell\dummy.log'

			Description
			-----------
			Write Log to file and screen

			.NOTES
			Early Beta Version...
			Based on an idea/script of Michael Bayer

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource

			.LINK
			https://github.com/Alright-IT/AIT.OpenSource/issues
	#>

	param
	(
		[Parameter(Mandatory,HelpMessage = 'Name of the Logfile')]
		[Alias('Log')]
		[String]$LogFile
	)

	BEGIN {
		# No Logfile?
		if ($LogFile -ne '') {
			# UTC Time-stamp
			Set-Variable -Name 'UtcTime' -Value $((Get-Date).ToUniversalTime() | Get-Date -UFormat '%Y-%m-%d %H:%M (UTC)')

			# Check for the LogFile
			if (Test-Path -Path $LogFile) {
				# OK, we have a LogFile
				Write-Warning -Message ('{0} already exists' -f $LogFile)
				Write-Output -InputObject ('Logging will append to {0}' -f $LogFile)
			} else {
				# Create a brand new LogFile
				Write-Output -InputObject ('Logfile: {0}' -f $LogFile)
				$null = New-Item -Path $LogFile -ItemType file
			}

			# Here is our LogFile
			Set-Variable -Name 'MyLogFileName' -Scope Script -Value $($LogFile)

			# Create a start Header
			Add-Content -Path $Script:MyLogFileName -Value "Logging start at $UtcTime `n"
		}

		# Have a buffer?
		if (-not ($Script:MyLogBuffer)) {
			# Nope!
			$Script:MyLogBuffer = @()
		}
	}

	PROCESS {
		# UTC Time-stamp
		Set-Variable -Name 'UtcTime' -Value $((Get-Date).ToUniversalTime() | Get-Date -UFormat '%Y-%m-%d %H:%M:%S')

		# Create the Message Array
		$messages = @()

		# Fill the messages
		$messages += ('' + ($_ | Out-String)).TrimEnd().Split("`n")

		# Loop over the messages
		foreach ($Message in $messages) {
			# Write a line
			Set-Variable -Name 'LogMsg' -Value $($UtcTime + ': ' + ($Message -replace "`n|`r", '').TrimEnd())

			# Inform
			Write-Output -InputObject $LogMsg
			$Script:MyLogBuffer += $LogMsg
		}
	}

	END {
		try {
			# Dump the buffers
			$Script:MyLogBuffer | Add-Content -Path $Script:MyLogFileName
		} catch {
			# Whoopsie!
			Write-Error -Message ('Cannot write log into {0}' -f $MyLogFileName) -ErrorAction Stop
		}

		# Remove the Variable
		Remove-Variable -Name 'MyLogBuffer' -Scope Script -Force -Confirm:$False -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
	}
}

function Get-UserGPOs {
	<#
			.SYNOPSIS
			Outputs user applied group policies

			.DESCRIPTION
			This function shows user applied group policies as shown inside the EventLog

			.PARAMETER Identity
			Type in the Positional argument of the Down-Level Logon Name (Domain\User)

			.EXAMPLE
			PS C:\> Get-UserGPOs -Identity 'CONTOSO\JDoe'
			List of applicable Group Policy objects:

			CONTOSO

			Description
			-----------
			Get applied group policies for 'CONTOSO\JDoe'

			.EXAMPLE
			PS C:\> Get-UserGPOs -Identity 'CONTOSO\JDoe'
			WARNING: Could not find relevant events in the Microsoft-Windows-GroupPolicy/Operational log.
			The default log size (4MB) only supports user sessions that logged on a few hours ago.
			Please increase the log size to support older sessions.

			Description
			-----------
			The user 'CONTOSO\JDoe' has no Event-Log entries for the Group Policy.

			.NOTES
			Credits goes to ControlUp by Smart-X
	#>

	[OutputType([Management.Automation.PSCustomObject])]
	param
	(
		[Parameter(Mandatory,ValueFromPipeline,
				Position = 1,
		HelpMessage = 'Specifies an the user object.')]
		[ValidateNotNullOrEmpty()]
		[String]$Identity
	)

	BEGIN {
		# Defines to filter by Event Id '4007' and by an positional argument which 'ControlUp' provide based on context
		$Query = "*[EventData[Data[@Name='PrincipalSamName'] and (Data='$Identity')]] and *[System[(EventID='4007')]]"
	}

	PROCESS {
		try {
			# Gets all the events matching the criteria by $Query
			[array]$Events = (Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "$Query" -ErrorAction Stop)
			$ActivityId = ($Events[0].ActivityId.Guid)
		} catch {
			Write-Warning -Message "Could not find relevant events in the Microsoft-Windows-GroupPolicy/Operational log.`nThe default log size (4MB) only supports user sessions that logged on a few hours ago.`nPlease increase the log size to support older sessions."

			# Capture any failure and display it in the error section
			# The Exit with Code 1 shows any calling App that there was something wrong
			break
		}

		# Looks for Event Id '5312' with the relevant 'Activity Id' and stores it inside a variable
		try {
			$Message = (Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "*[System[(EventID='5312')]]" -ErrorAction Stop | Where-Object -FilterScript { $_.ActivityId -eq $ActivityId })
		} catch {
			$Message = (New-Object -TypeName PSObject)
			-MemberType Add-Member -InputObject Message -InputObject -MemberType -SecondValue NoteProperty -Name 'Message' -Value 'No relevant Microsoft-Windows-GroupPolicy objects found.'
		}

	}

	END {
		# Displays the 'Message Property'
		Write-Output -InputObject $Message.Message
	}
}

