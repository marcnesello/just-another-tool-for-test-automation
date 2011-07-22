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

## @file
# module listParser which parses an xml testlist file.
#
# @copy 2009, marcn;
use strict;
use warnings;

use XML::LibXML;

use lib "./modlib";
use Testlist;


package listParser;


## @method parseFile
# reads the xml file and parses it into a Testlist
# @return a Testlist object
sub parseFile($){
	my ($listfile) = @_;	
	
	my $parser = XML::LibXML->new();
	my $doc = $parser->parse_file( $listfile );



	#Check if the xml testlist is valid, die if it is not valid
	my $xmlschema = XML::LibXML::Schema->new( location => "jatta.xsd");

	$xmlschema->validate( $doc );

	
	my $listname ="";
	my $listtimeout = "";
	my $listlogfile = "";
	
	foreach my $testlist ($doc->findnodes('/testlist')){
		$listname = $testlist->attributes()->getNamedItem('name')->to_literal;
		$listtimeout = $testlist->attributes()->getNamedItem('timeout')->to_literal;
		$listlogfile = $testlist->attributes()->getNamedItem('logfile')->to_literal;	
	}

	
	my @tests = ();
	
	foreach my $test ($doc->findnodes('/testlist/test')){
		my $testid = $test->attributes()->getNamedItem('id')->to_literal;
		my $testname = $test->attributes()->getNamedItem('name')->to_literal;
		my $testtimeout = $test->attributes()->getNamedItem('timeout')->to_literal;

		
		my $body = parsePart($test,"body");
		my $head =  parsePart($test,"head");
		my $tail = parsePart($test,"tail");

		my $testObj = Test->new($testid,$testname,$testtimeout,$body,$head,$tail);
		push (@tests,$testObj);
	}	
	
	my $testlistObj = Testlist->new($listname,$listtimeout,$listlogfile,@tests);

	
	return $testlistObj;
}

## @method parsePart
# parses a body, tail or head element
# @param $test a test node from the parsed xml document
# @param $part the type of the part (body,tail,head)
# @return a Part object
sub parsePart($$){
	my ($test,$part) = @_;
	
	my @groupList = ();
	my $warnIfFailed = "0";
	foreach my $prt ($test->findnodes($part)){
		if($part ne "body"){
			$warnIfFailed = $prt->attributes()->getNamedItem('warnIfFailed');
			if (!defined($warnIfFailed)){
				$warnIfFailed = "0";
			}else{
				$warnIfFailed = $warnIfFailed->to_literal;
			}
		}else{
			$warnIfFailed = "0";
		}
		foreach my $group ($prt->findnodes('group')){
			my $groupid = $group->attributes()->getNamedItem('id')->to_literal;
			my $groupname = $group->attributes()->getNamedItem('name')->to_literal;
			my $parallel = $group->attributes()->getNamedItem('parallel');
			if (!defined($parallel)){
				$parallel = "1";
			}else{
				$parallel = $parallel->to_literal;
			}
			my $serial = $group->attributes()->getNamedItem('serial');	
			if (!defined($serial)){
				$serial = "1";
			}else{
				$serial = $serial->to_literal;
			}
			
			my @cmdList = ();
				
			foreach my $command ($group->findnodes('command')){
				my $cmdid = $command->attributes()->getNamedItem('id')->to_literal;
				my $cmdname = $command->attributes()->getNamedItem('name')->to_literal;
				my @posChecks = ();
				my @negChecks = ();
				my @inputs = ();
				
				my $path = "";
				foreach my $cmdpath ($command->findnodes('path')){
					$path = $cmdpath->to_literal;	
				}
					
				foreach my $posCheck ($command->findnodes('positiveCheck')){
					push (@posChecks,$posCheck->to_literal);
				}
					
				foreach my $negCheck ($command->findnodes('negativeCheck')){
					push (@negChecks,$negCheck->to_literal);
				}
					
				foreach my $input ($command->findnodes('inputData')){
					push (@inputs,$input->to_literal);
				}
					
				my $posList = CheckList->new(@posChecks);
				my $negList = CheckList->new(@negChecks);
					
				my $cmdObj = Command->new($cmdid,$cmdname,$path,$posList,$negList,@inputs);
				push (@cmdList,$cmdObj);	
			}
			
			my $groupObj = Group->new($groupid,$groupname,$parallel,$serial,@cmdList);		
			push (@groupList,$groupObj);
		}
	}
	my $partObj = Part->new("$part",$warnIfFailed,@groupList);
	return $partObj;
}

return 1;
