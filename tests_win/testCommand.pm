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
# tests the Command Class
use strict;
use warnings;

use lib "../modlib";
use utils;
use Command;

sub testCommand($$$$$$){
	my ($cmd1,$cmd2,$cmd3,$cmd4,$cmd5,$cmd6) = @_;

	#Create a logfile
	&utils::createLogfile("logCommand.txt");
	
	#Execute the commands and show the results
	print "cmd1 erwarte 1: ".$cmd1->execute()."\n";
	print "cmd2 erwarte 1: ".$cmd2->execute()."\n";
	print "cmd3 erwarte 1: ".$cmd3->execute()."\n";
	print "cmd4 erwarte 1: ".$cmd4->execute()."\n";
	print "cmd5 erwarte 0: ".$cmd5->execute()."\n";
	print "cmd6 erwarte 0: ".$cmd6->execute()."\n";
	
	#close the log
	&utils::closeLogfile();
}

return 1;