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

# author: marcn
# tests the Group Class
use strict;
use warnings;

use lib "../modlib";
use utils;
use Group;

sub testGroup($$$$$$){
	my ($grp1,$grp2,$grp3,$grp4,$grp5,$grp6) = @_;
	
	#Create a logfile
	&utils::createLogfile("logGroup.txt");
		
	#Execute these groups and show the result
	print "grp1 erwarte 1: ".$grp1->execute()."\n";
	print "grp2 erwarte 1: ".$grp2->execute()."\n";
	print "grp3 erwarte 1: ".$grp3->execute()."\n";
	print "grp4 erwarte 1: ".$grp4->execute()."\n";
	print "grp5 erwarte 0: ".$grp5->execute()."\n";
	print "grp6 erwarte 0: ".$grp6->execute()."\n";
	#close the log
	&utils::closeLogfile();
}

return 1;