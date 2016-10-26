# Alright-IT Open Source PowerShell Module

<!-- MarkdownTOC depth=3 autolink=true autoanchor=true bracket=round -->

- [General](#general)
- [Build Status](#build-status)
- [Version format](#version-format)
	- [Version labels](#version-labels)
- [General Repository Information](#general-repository-information)
	- [Fork and contribute?](#fork-and-contribute)
- [Trademarks](#trademarks)
- [Issues](#issues)
	- [Reporting security issues](#reporting-security-issues)
- [Feature Requests / Changes](#feature-requests--changes)
- [Reservation of Rights](#reservation-of-rights)
- [Changelog format](#changelog-format)
	- [Date format](#date-format)
	- [Changes](#changes)
	- [References](#references)
- [License](#license)
	- [License Terms](#license-terms)
	- [Agreement](#agreement)
	- [Warranty](#warranty)
- [Data privacy](#data-privacy)
- [Additional Information](#additional-information)

<!-- /MarkdownTOC -->

<a name="general"></a>
## General
This PowerShell Module contains a collection of Tool, functions and snippets.

Mostly developed, or adopted for internal use. However, we found that these were so useful that we decided to publish them.



<a name="build-status"></a>
## Build Status
Current Build Status (nearly in real time) from our build server.

![The Build Status is not available](http://build.net-experts.net/app/rest/builds/buildType:(id:AIT_OpenSource_Build)/statusIcon)

<a name="version-format"></a>
## Version format
We use a semantic version system that matches the Microsoft versioning policy for PowerShell.

Given a version number MAJOR.MINOR.PATCH.BUILD, increment the:

* **MAJOR** version major changes or functions that might be incompatible with several older versions of PowerShell or the target system (If applicable)
* **MINOR** version add functionality in a fully backward compatible manner
* **PATCH** version mostly bug fixes, optimizations, or refactoring
* **BUILD** the build number. This number is increased automatically by our (automated) Build processes

<a name="version-labels"></a>
### Version labels
Sometimes we add labels to as extension to the MAJOR.MINOR.PATCH.BUILD format.

This is mostly used for pre-Releases, Beta builds, or EAP (Early Access Program) Releases.

* **`Pre`** marks pre-Release
* **`Beta`** marks Beta Releases
* **`EAP`** marks EAP (Early Access Program) Releases

<a name="remarks"></a>
#### Remarks
Pre-Releases, Beta builds, or EAP (Early Access Program) Releases are not fully tested and might be unstable! You should not use them in a production environment.

It is ==highly recommended== to use them on a dedicated test system. However, due to the nature of PowerShell Modules, a fall-back should be easy.

<a name="general-repository-information"></a>
## General Repository Information
The branching structure follows the GIT-flow concept, defined by [Vincent Driessen](http://nvie.com/posts/a-successful-git-branching-model/)

<a name="master-branch"></a>
#### Master branch
The main branch where the source code of HEAD always reflects a production-ready state.

<a name="develop-branch"></a>
#### Develop branch
Consider this to be the main branch where the source code of HEAD always reflects a state with the latest delivered development changes for the next release. Some would call this the "*integration branch*".

<a name="feature-branches"></a>
#### Feature branches
These are used to develop new features for the upcoming or a distant future release. The essence of a feature branch is that it exists as long as the feature is in development, but will eventually be merged back into develop (to definitely add the new feature to the upcoming release) or discarded (in case of a disappointing experiment).

<a name="release-branches"></a>
#### Release branches
These branches support preparation of a new production release. By using this the develop branch is cleared to receive features for the next big release.

<a name="hotfix-branches"></a>
#### Hotfix branches
Hotfix branches are very much like release branches in that they are also meant to prepare for a new production release, albeit unplanned.

<a name="git-flow"></a>
#### GIT-flow
We use GIT-flow functions whenever possible to build patches, fixes or releases! That increases the number of branches, but it makes the tracking much easier and it is easier for us.

<a name="fork-and-contribute"></a>
### Fork and contribute?
You are welcome to contribute to this project.

Please read the [contribution guidelines](CONTRIBUTING.md).

<a name="trademarks"></a>
## Trademarks
Many (or nearly all) names of products and companies mentioned here are registered trademarks or trademarks of others.

<a name="issues"></a>
## Issues
Please report any issues that you find.

We highly appreciate any kind of feedback. We really do. So please help us to improve things and make better software ;-)

Due to the nature of PowerShell, there is another great way: Pull the source, fix it and contribute the source back to us (via a Pull Request).

Please use the [GitHub Issue-Tracker](https://github.com/Alright-IT/AIT.OpenSource/issues) for this project.

<a name="reporting-security-issues"></a>
### Reporting security issues
We take security seriously. If you discover any security issues, report them right away!

Please _DO NOT_ report them via a public issue, instead use the private [Support portal](http://support.aitlab.de) to open a Ticket!

Security reports are extremely appreciated, and we will name the source! Even so, we don't want them in public before they are fixed, and users have the chance to install a fixed version.

<a name="feature-requests--changes"></a>
## Feature Requests / Changes
Any kind of changes and/or Requests and/or Bug Reports has to be addressed via the [GitHub Issue-Tracker](https://github.com/Alright-IT/AIT.OpenSource/issues). For a guide to submitting good bug reports, please read [Painless Bug Tracking](http://www.joelonsoftware.com/articles/fog0000000029.html).

Please note that feature requests should be in a human understandable form of a agile user story.

Example:
*"As a <type of user>, I want <some goal> so that <some reason>."*

The more detailed you describe your requirements, the better. It makes it simpler for us to understand what you want, and it makes our planning a lot simpler.
This could increase the possibility that your request might be part of the development soon.

So please feel free to contribute your ideas in the system above. If the developers find these useful, they might plan an implementation in a future release. Even if not, they might be part of our backlog. We use Kanban as development method, that means we work permanently on backlogged items.

There is no guarantee that your request will be part of any future release just because you raised a request for it.

Please keep the following fact in mind: Only we, [Alright-IT GmbH](http://www.alright-it.com), are responsible for the development. There is no entitlement, claim or right to get something.

<a name="reservation-of-rights"></a>
## Reservation of Rights
Many parts, functions or source code fragments are based on the intellectual work, scripts or sources of others. Even if the source might not be a copy or direct clone, the function or even the idea might be inspired by the work of others.

**We deeply respect and acknowledge the intellectual work of others!**

Due to the nature of underlying scripting technology it’s hard and nearly impossible to track where ideas or even inspirations originally came from!

Whenever it is possible to track the source or idea or find out where it comes from, we will put the author, copyright and license (if exist) to the script.

<a name="changelog-format"></a>
## Changelog format
See **`CHANGELOG.md`**
You will find a detailed [Changelog](CHANGELOG.md) as part of the distribution.

For our Changelog, we follow these principles:

<a name="date-format"></a>
### Date format
We strictly use the following format: **`YYY-MM-DD`**

For example, `September 27, 2012` is represented as `2012-09-27`.

This format is also known as ISO 8601.

<a name="changes"></a>
### Changes
We group changes an describe there impact as follows:

* **`Added`** for new features or functionality
* **`Changed`** for changes in existing features or functionality
* **`Deprecated`** for features or functionality removed in upcoming releases
* **`Removed`** for deprecated features removed in this release
* **`Fixed`** for any bug fixes
* **`Refactored`** code optimisation, without changes to the function itself
* **`Security`** to invite users to upgrade in case of vulnerabilities

Sometimes we also use the following:

* **`Interim`** for workarounds and things with a short lifecycle
* **`Testing`** for features that have a early beta character and might not make it to a final release.

<a name="references"></a>
### References
Whenever possible, we will reference the [GitHub Issue-Tracker](https://github.com/Alright-IT/AIT.OpenSource/issues).
Sometimes you will find references like **`[AAT-1]`**, this is a link to our internal Jira instance. We will not open another issue on the [GitHub Issue-Tracker](https://github.com/Alright-IT/AIT.OpenSource/issues).

<a name="unreleased"></a>
#### Unreleased
We use **`[Unreleased]`** to show what we are working on for the next release.

This is an informal tag. Mostly because this is not finally tested or documented.

<a name="yanked-releases"></a>
#### Yanked Releases
Yanked releases are versions that had to be pulled because of a serious bug or even security issue.

We mark yanked Releases with **`[YANKED]`**

<a name="chore"></a>
#### Chore
A chore is a story or Release with no direct customer value, but simply needs to be done. This is often used if we change the documentation, change the structure of things or do architectural changes. This is a typical scrum/agile term.

We mark such releases with **`[Chore]`**

<a name="license"></a>
## License
We include a dedicated [License](LICENSE.md) with each distribution.

This is the **BSD-3-Clause** license.

<a name="license-terms"></a>
### License Terms
Copyright (c) 2016, Alright-IT GmbH
Copyright (c) 2015, Quality Software Ltd
Copyright (c) 2006-2015, Joerg Hochwald
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

<a name="agreement"></a>
### Agreement
By using the Software, you agree to the License, Terms and Conditions above!

<a name="warranty"></a>
### Warranty
We provide this software =="AS IS"==! There are ==no warranties== in any kind. No kidding, none means none!

<a name="in-plain-english"></a>
#### In plain english
You can use our software, you can change it and distribute it. Both for yourself, as hobby and even commercial. Do not steal! So please let our copyright notice and do not remove or change it.

So not use us, our names, or the name of our software for any marketing or advertising! Rename it and use your own name.

This is free software without any warranties. We provide it, you might use it.
If something goes wrong, there is no warranty! This should be clear, it is the heart and soul of open source software... But we need to include all this info with every release.

This is not negotiable! If you are unwilling to accept these easy terms, you should not use our software and delete it, sorry!

<a name="data-privacy"></a>
## Data privacy
We try a avoid any kind of Call Home! Even if some functions might use a dedicated AIT (Alright-IT) system or backend services. Please see the [AITLAB Site](https://www.aitlab.de) for more information.

<a name="additional-information"></a>
## Additional Information
Please view the Header information each each file, it might contain other Licensing and/or Copyright information(s). As an Example, the PowerShell Base Module is licensed under other terms and has another Copyright informations.

*Please Review each File/Directory for Licensing and/or Copyright information(s).*
