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
# tests the Part Class
use strict;
use warnings;

use lib "../modlib";
use utils;
use Part;

sub testPart($$$){
	my ($prt1,$prt2,$prt3) = @_;
	
	#Create a logfile
	&utils::createLogfile("logPart.txt");
	
	#Execute these parts and show the result
	print "prt1 erwarte 1: ".$prt1->execute()."\n";
	print "prt2 erwarte 0: ".$prt2->execute()."\n";
	print "prt3 erwarte 1: ".$prt3->execute()."\n";
	#close the log
	&utils::closeLogfile();
}

return 1;