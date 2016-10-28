# Alright-IT Open Source Contribution Guide

This is a guide for everyone interested in contributing to our open source projects. It's based on well known community workflows.

You are encouraged to fork our open source repositories and make adjustments according to your own preferences. If you really want to contribute, you should consider a Pull request.

<!-- MarkdownTOC depth=3 autolink=true autoanchor=true bracket=round -->

- [General Bug Report](#general-bug-report)
	- [Reporting security issues](#reporting-security-issues)
- [Asking Questions](#asking-questions)
- [Contributing Code](#contributing-code)
	- [Version number](#version-number)
- [General Repository Information](#general-repository-information)
- [License](#license)
	- [License Terms](#license-terms)
	- [Your Name](#your-name)
- [Further reading](#further-reading)

<!-- /MarkdownTOC -->

<a name="general-bug-report"></a>
## General Bug Report

If you report a bug, please try to:

* Perform a web / GitHub search to avoid creating a duplicate ticket.
* Include enough information to reproduce the problem.
* Mention the exact version (including our Build) of the project causing you problems, as well as any related software and versions (such as operating system, PowerShell version, dotNET Version, etc.).
* Test against the latest version of the project (and if possible also the master branch) to see if the problem has already been fixed.
* Include as many information as possible and needed to understand the issue.
* Include a link to a gist you provided (if applicable).

For a guide to submitting good bug reports, please read [Painless Bug Tracking](http://www.joelonsoftware.com/articles/fog0000000029.html).

<a name="reporting-security-issues"></a>
### Reporting security issues

We take security seriously. If you discover any security issues, report them right away!

Please _DO NOT_ report them via the public [GitHub Issue-Tracker](https://github.com/Alright-IT/AIT.OpenSource/issues), instead use the private [AITLAB Support Portal](http://support.aitlab.de) to open a Ticket!

Security reports are extremely appreciated, and we will name the source! Even so, we don't want them in public before they are fixed, and users have the chance to install a fixed version.

<a name="asking-questions"></a>
## Asking Questions

Depending on the nature and urgency of your question, pick one of the following channels for it:

* Search the web for it, you've done that already, right?
* Project Mailing List (if existing)
* Project IRC Channel (if existing)
* StackOverflow
* GitHub Issues from this and other projects
* Any major PowerShell related site

Do not email us directly, unless you want to inquiry about commercial support or have a very good reason.

<a name="contributing-code"></a>
## Contributing Code

If you want to contribute code, please try to:

* Follow the same coding style as used in the project. Pay attention to the usage of tabs, spaces, newlines and brackets. Try to copy the aesthetics the best you can.
* Add an automated test that verifies your change. Look at the existing [Pester](https://github.com/pester/Pester) based test suite to get an idea for the kind of tests I like. If you do not provide a test, explain why.
* Write [good commit messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html), explain what your patch does, and why it is needed.
* Keep it simple: Any patch that changes a lot of code or is difficult to understand should be discussed before you put in the effort. We can discuss that right here in the Issue tracker.

Once you have tried the above, create a GitHub pull request to notify me of your changes.

<a name="version-number"></a>
### Version number

You do not need to change the version or build number. You can increase the version, but you should leave the build number untouched. Our internal build system will take care about that and your change will be overwritten anyway!

Please see the [README](README.md) file for further information about our versioning schema.

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

<a name="license"></a>
## License

Please specify your license terms! This only applies for new modules and/or scripts. You are not allowed to change the license terms of the existing code!

Please use a valid license, best one that is approved by the Free Software Foundation.

If you do not specify any License Terms, we apply the following default:

<a name="license-terms"></a>
### License Terms

Copyright (c) 2016, Alright-IT GmbH
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#### BSD-3-Clause
This is the **BSD-3-Clause** license.

<a name="your-name"></a>
### Your Name

We will publish your name to mention you as the contributor. If you don't want that, please let us know.

<a name="further-reading"></a>
## Further reading

You might also read these two blog posts about contributing code:

* [Open Source Contribution Etiquette](http://tirania.org/blog/archive/2010/Dec-31.html) by Miguel de Icaza
* [Don’t “Push” Your Pull Requests](https://www.igvita.com/2011/12/19/dont-push-your-pull-requests/) by Ilya Grigorik
