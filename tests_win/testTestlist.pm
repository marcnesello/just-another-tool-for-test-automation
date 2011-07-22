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
# tests the Group Test
use strict;
use warnings;

use lib "../modlib";
use utils;
use Testlist;

sub testTestlist(){

	#Create 4 Positive checks
	my $pos1 = CheckList->new("Verzeichnis von","test.txt");
	my $pos2 = CheckList->new("1 Datei(en) kopiert");
	my $pos4 = CheckList->new("");
	
	my $pos42 = CheckList->new('Windows\s+\[Version .+\]');
	my $pos43 = CheckList->new('Verzeichnis von');
	
	#Create a negative check
	my $neg1 = CheckList->new("");
	my $neg2 = CheckList->new("test.txt");
	
	#create an automated input
	my $in = ("n");
	
	
	#Create 11 commands
	my $cmd0 = Command->new(0,"create directory","mkdir test",$pos4,$neg1);
	my $cmd1 = Command->new(1,"create file","echo. > test.txt",$pos4,$neg1);
	my $cmd2 = Command->new(2,"Remove file","del test\\test.txt",$pos4,$neg1);
	
	my $cmd3 = Command->new(3,"Show directory", "dir",$pos1,$neg1);
	my $cmd4 = Command->new(4,"Show other directory","dir test",$pos4,$neg2);
	my $cmd5 = Command->new(5,"Copy", "copy test.txt test\\test.txt",$pos4,$neg1);
	my $cmd6 = Command->new(6,"Check if file is copied","dir test",$pos1,$neg1); 
	my $cmd7 = Command->new(7,"Check if file is still there","dir",$pos1,$neg1); 
	
	my $cmd8 = Command->new(8,"Remove file", "del test.txt",$pos4,$neg1);
	my $cmd9 = Command->new(9,"Remove other file","del /P test\\test.txt",$pos4,$neg1,"j"); 
	my $cmd10 = Command->new(10,"Remove directory","rmdir test",$pos4,$neg1); 
	
	#Two new commands
	my $cmd42 = Command->new(42,"Just check version","ver",$pos42,$neg1);
	my $cmd43 = Command->new(43,"Just show dir","dir",$pos43,$neg1);
	
	#Create 3 groups
	my $grp1 = Group->new(1,"Prepare",1,1,($cmd0,$cmd1,$cmd2));
	my $grp2 = Group->new(2,"The Test",1,1,($cmd3,$cmd4,$cmd5,$cmd6,$cmd7));
	my $grp3 = Group->new(3,"Cleanup",1,1,($cmd8,$cmd9,$cmd10));
	
	#Group For fail test
	my $grp4 = Group->new(4,"The Test",1,1,($cmd3,$cmd4,$cmd6,$cmd7));
	
	#Another good group
	my $grp5 = Group->new(5,"a Test",3,3,($cmd42,$cmd43));

	#Make 3 parts
	my $prt1 = Part->new("head",0,$grp1);
	my $prt2 = Part->new("body",0,$grp2);
	my $prt3 = Part->new("tail",0,$grp3);
	
	#Create part which fails
	my $prt4 = Part->new("body",0,$grp4);
	
	#Another good part
	my $prt5 = Part->new("body",0,$grp5);

	#create the test ans execute it
	my $test = Test->new("1","Ultimate Test",0,$prt2,$prt1,$prt3);
	my $tst1 = Test->new("3","Another Test",0,$prt5);
	#print $tst1->execute();
	#Create test which should fail and execute it
	my $tst2 = Test->new("2","Ultimate Test which fails",0,$prt4,$prt1,$prt3);
	
	my $lst2 = Testlist->new("Ultimate failing test",0,"logTestlist2.txt",$test,$tst2);
	print "lst2 expects 0: ".$lst2->execute()."\n";
	
	#Create testlist which will success and one which fails
	#my $lst1 = Testlist->new("Ultimate test list",0,"logTestlist.txt",$test,$tst1);
	#print "lst1 expects 1: ".$lst1->execute()."\n";	





}

return 1;