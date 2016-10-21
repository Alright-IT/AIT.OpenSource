@{
	# Script module or binary module file associated with this manifest.
	RootModule = 'AIT.OpenSource.psm1'

	# Version number of this module.
	ModuleVersion = '1.0.0.5'

	# ID used to uniquely identify this module
	GUID = '3a74cdbe-0255-4878-83ee-2e9d69772740'

	# Author of this module
	Author = 'Alright-IT GmbH'

	# Company or vendor of this module
	CompanyName = 'Alright-IT GmbH'

	# Copyright statement for this module
	Copyright = '(c) Alright-IT GmbH. All rights reserved.'

	# Description of the functionality provided by this module
	Description = 'Alright-IT PowerShell Open Source Tools, Functions and useful snippets'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '4.0'

	# Name of the Windows PowerShell host required by this module
	# PowerShellHostName = ''

	# Minimum version of the Windows PowerShell host required by this module
	#PowerShellHostVersion = ''

	# Minimum version of Microsoft .NET Framework required by this module
	# DotNetFrameworkVersion = ''

	# Minimum version of the common language runtime (CLR) required by this module
	CLRVersion = '4.0'

	# Processor architecture (None, X86, Amd64) required by this module
	#ProcessorArchitecture = ''

	# Modules that must be imported into the global environment prior to importing this module
	#RequiredModules = @()

	# Assemblies that must be loaded prior to importing this module
	#RequiredAssemblies = @()

	# Script files (.ps1) that are run in the caller's environment prior to importing this module.
	#ScriptsToProcess = @()

	# Type files (.ps1xml) to be loaded when importing this module
	#TypesToProcess = @()

	# Format files (.ps1xml) to be loaded when importing this module
	#FormatsToProcess = @()

	# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
	#NestedModules = @()

	# Functions to export from this module
	FunctionsToExport = '*'

	# Cmdlets to export from this module
	CmdletsToExport = '*'

	# Variables to export from this module
	VariablesToExport = '*'

	# Aliases to export from this module
	AliasesToExport = '*'

	# List of all modules packaged with this module
	#ModuleList = @()

	# List of all files packaged with this module
	#FileList = @()

	# Private data to pass to the module specified in RootModule/ModuleToProcess
	PrivateData = @{
		# PSData is module packaging and gallery metadata embedded in PrivateData
		# It's for rebuilding PowerShellGet (and PoshCode) NuGet-style packages
		# We had to do this because it's the only place we're allowed to extend the manifest
		# https://connect.microsoft.com/PowerShell/feedback/details/421837
		PSData = @{
			# The primary categorization of this module (from the TechNet Gallery tech tree).
			Category = "Scripting Techniques"
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('PowerShell','ToolsTools')
			# A URL to the license for this module.
			LicenseUri = 'https://raw.githubusercontent.com/Alright-IT/AIT.OpenSource/master/docs/LICENSE'
			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/Alright-IT/AIT.OpenSource'
			# A URL to an icon representing this module.
			IconUri = 'http://www.alright-it.com/media/AIT_logo-1.jpg'
			# ReleaseNotes of this module
			ReleaseNotes = 'See changelog.md in docs directory'
			# External dependent modules of this module
			#ExternalModuleDependencies = ''
			# Indicates this is a pre-release/testing version of the module.
			IsPrerelease = 'false'
			# enaTEC: Module Title for NuGet
			ModuleTitle = 'Alright-IT PowerShell Open Source Tools, Functions and useful snippets'
			# enaTEC: Module Summary for NuGet
			ModuleSummary = 'Alright-IT PowerShell Open Source Tools, Functions and useful snippets'
			# enaTEC: Module Language for NuGet
			ModuleLanguage = 'en-US'
			# enaTEC: Module RequireLicenseAcceptance for NuGet
			ModuleRequireLicenseAcceptance = 'false'
		}
	 }

	# HelpInfo URI of this module
	#HelpInfoURI = ''

	# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
	#DefaultCommandPrefix = ''
}
