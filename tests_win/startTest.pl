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
# tests the classes
use lib "../modlib";
use utils;
#use Command;

#use CheckList;
use testGroup;
use testCommand;
use testPart;
use testTest;
use testTestlist;


#Create 4 Positive checks
my $pos1 = CheckList->new("Verzeichnis von","testCommand.pm");
#my $pos2 = CheckList->new("Microsoft Windows","Version");
my $pos2 = CheckList->new('Windows\s+\[Version .+\]');
my $pos3 = CheckList->new("kopiert");
my $pos4 = CheckList->new("");

#Create a negative check
my $neg1 = CheckList->new("");
my $neg2 = CheckList->new("Version");

#create an automated input
my $in = ("n");


#Create 4 commands
my $cmd1 = Command->new(1,"Show Directory","dir",$pos1,$neg1);
my $cmd2 = Command->new(2,"Show Version","ver",$pos2,$neg1);
my $cmd3 = Command->new(3,"Copy file", "copy testcopy.txt saft.txt",$pos3,$neg2);
my $cmd4 = Command->new(4,"Delete file", "del saft.txt /P",$pos4,$neg1,$in);
my $cmd5 = Command->new(5,"Delete file", "del saft.txt /P",$pos3,$neg1,$in);
my $cmd6 = Command->new(6,"Show Version","ver",$pos4,$neg2);

&testCommand($cmd1,$cmd2,$cmd3,$cmd4,$cmd5,$cmd6);

#Create 4 groups
my $grp1 = Group->new(1,"SimpleGroup",1,1,($cmd1,$cmd2,$cmd3,$cmd4));
my $grp2 = Group->new(2,"SerialGroup",1,3,($cmd1,$cmd2,$cmd3,$cmd4));
my $grp3 = Group->new(3,"ParallelGroup",3,1,($cmd1,$cmd2,$cmd3,$cmd4));
my $grp4 = Group->new(4,"SuperGroup",3,3,($cmd1,$cmd2,$cmd3,$cmd4));
my $grp5 = Group->new(5,"SuperGroupFail",3,3,($cmd1,$cmd3,$cmd6,$cmd4));
my $grp6 = Group->new(6,"SimpleGroupFail",1,1,($cmd1,$cmd3,$cmd4,$cmd5));

#&testGroup($grp1,$grp2,$grp3,$grp4,$grp5,$grp6);

my $prt1 = Part->new("body",0,$grp3,$grp2);
my $prt2 = Part->new("body",0,$grp5,$grp4);
my $prt3 = Part->new("body",0,$grp1,$grp2,$grp3,$grp4);

#&testPart($prt1,$prt2,$prt3);

#&testTest();

#&testTestlist();
