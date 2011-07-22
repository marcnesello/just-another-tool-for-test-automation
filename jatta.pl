#!/usr/bin/perl

#Just Another Tool for Test Automation
#Copyright (C) 2011  Marc Nesello
#
#This file is part of Just Another Tool for Test Automation.
#
#Just Another Tool for Test Automation is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 2 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.


use strict;
use warnings;

use lib "./modlib";
use listParser;
use Testlist;
use File::Path;
use File::Temp;

print "Open JATTA  Copyright (C) 2011 Marc Nesello \n\nThis program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.\nThis is free software, and you are welcome to redistribute it\nunder certain conditions; type `show c' for details.\n";

unless($ARGV[0]) {
	die "Open JATTA needs an argument. Usage: perl jatta.pl <TESTLIST>|show [w|c]";
}

print "\n\n";

if($ARGV[0] eq "show"){
	unless($ARGV[1]){
		die "Open JATTA needs a second argument if using show. Usage: perl jatta.pl <TESTLIST>|show [w|c]";
	}
	if($ARGV[1] eq "w"){
		print "NO WARRANTY\n\n11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.\nEXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM \"AS IS\" WITHOUT WARRANTY OF ANY KIND,\nEITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.\nTHE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.\nSHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.\n\n12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE,\nBE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE\nOR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),\nEVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.";
	}
	if($ARGV[1] eq "c"){
		print "3.  You may copy and distribute the Program (or a work based on it, under Section 2) in object code or executable form under the terms of Sections 1 and 2 above provided that you also do one of the following:\n\na) Accompany it with the complete corresponding machine-readable source code, which must be distributed under the terms of Sections 1 and 2 above on a medium customarily used for software interchange; or,\n\nb) Accompany it with a written offer, valid for at least three years, to give any third party, for a charge no more than your cost of physically performing source distribution, a complete machine-readable copy of the corresponding source code, to be distributed under the terms of Sections 1 and 2 above on a medium customarily used for software interchange; or,\n\nc) Accompany it with the information you received as to the offer to distribute corresponding source code. (This alternative is allowed only for noncommercial distribution and only if you received the program in object code or executable form with such an offer, in accord with Subsection b above.) ";
	}
	exit(1);
}

#Get test list file name
my $testlistFile = $ARGV[0]; 

print "Starting JATTA- Just Another Tool for Test Automation\n";
print "------------------------------------------------------\n";

#Create subdir temp
&File::Path::make_path("tmp"); 

#Parse the testlist file
my $testlist = &listParser::parseFile($testlistFile);

#Execute the testlist
$testlist->execute();

#Check if System is Windows, if not windows remove tmp dir
if($^O !~ /win/i){

	&File::Path::remove_tree("tmp", safe => 0);
}

print "\n\nJATTA finished\n";