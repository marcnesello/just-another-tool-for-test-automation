Just Another Tool for Test Automation
Copyright (C) 2011 Marc Nesello

This file is part of Just Another Tool for Test Automation.

Just Another Tool for Test Automation is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

--------------------------------------------------------------------------------------------
Purpose
--------------------------------------------------------------------------------------------

This tool can be used for automated system tests of command line applications. 
Test lists are written in an xml-style syntax. 
The tool is developed in Perl with a portion of code in xml scheme to validate test lists.


This tool needs a perl interpreter. For Windows I recommend Strawberry Perl (http://strawberryperl.com/), because all necessary modules are installed with Strawberry Perl.

If you want to use another perl interpreter, ensure that following modules are installed:

XML::LibXML - (http://search.cpan.org/~pajas/XML-LibXML-1.70/LibXML.pod)
threads - (http://search.cpan.org/~jdhedden/threads-1.77/threads.pm)
File::Path - (http://search.cpan.org/~dland/File-Path-2.08/Path.pm)
File::Temp - (http://search.cpan.org/~tjenness/File-Temp-0.22/Temp.pm)

--------------------------------------------------------------------------------------------
1.Content
Files:
readme.txt - This file
gpl-2.0.txt - The GNU GPL v2
jatta.pl - The main program
jatta.xsd - The XML Schema file

Folders:
modlib - Contains the perl modules which are need to run jatta.pl
example_win - Contains example test files for Windows and example results and logs
example_linux - Contains example test files for Linux and example results and logs

2.Building the documentation
For rebuilding the documentation you need doxygen and as input_filter you need DoxyGen::Filter which processes the perl sources.

3.Usage
1.Write a Testlist
Write a testlist which is valid according to jatta.xsd. Example testlists are found in example_win and example_linux.

2.Start Just Another Tool for Test Automation
At your terminal type "perl jatta.pl FILENAME". Substitute FILENAME with the complete path to the test file.



