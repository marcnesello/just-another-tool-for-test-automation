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
# Implementation of Group.
#
# @copy 2009, marcn;


## @class Group
# author: marcn
# @par
# The class groupis the represantation of the group element in the xml test list. 
# A group can be executed
package Group;

use strict;
use warnings;

use Command;
use utils;

use threads;
use threads::shared;

## @cmethod new
# constructs the group object
# @param $id id of the command
# @param $name of the command
# @param $parallel number of parallel execution
# @param $serial number of serial execution
# @param $commands a list of commands of the group 
# @return the group object
sub new {
	my ($group, $id, $name, $parallel,$serial,@commands) = @_;
	
	if($serial < 1){
		$serial = 1;
	}
	if($parallel < 1){
		$parallel = 1;
	}
	
	my $self = {
		'id' => $id,
		'name' => $name,
		'parallel' => $parallel,
		'serial' => $serial,
		'commands' => [@commands]
	};
	
	bless $self, $group;
	
	return $self;
}


## @method execute
# executes the group and then evaluates if it was successfull
# @return 1 if the evaluation was successfull, otherwise 0
sub execute($){
	my ($group) = @_;	
	my $message = "";
	if ($group->{'parallel'} > 1){
		$message = "This Group has $group->{'parallel'} parallel threads.";
	}
	$message = $message."\n This Group will be executed $group->{'serial'} time(s).";
	&utils::writeLog($message,"start","group",$group->{'id'},$group->{'name'});
	my @commandList = $group->getCommands();
	
my ($isFailed,$isWarning,$isSuccessfull) = (0,0,0);
	

	my @resultList = ();
	
	for(my $i=0; $i < $group->{'serial'}; $i++ ){
	my @threadList = ();	
		if($group->{'parallel'} <= 1){
			($isFailed,$isWarning,$isSuccessfull) = &utils::executeList(@commandList);
			
		}else{
			for(my $k=0; $k < $group->{'parallel'}; $k++){
				foreach my $command (@commandList){
					my $thread = threads->create(sub{$command->execute();});

					push (@threadList, $thread);
				}			
			}		
		}
		foreach my $thr (@threadList){
			my $tmpresult = $thr->join();

			push (@resultList,$tmpresult);
		}
	}

	foreach my $result (@resultList){
		if ($result ne 1){
			$isFailed = 1;
		}elsif($result eq 1){
			$isSuccessfull = 1;
		}
	}

	my $result = &utils::getResult($isFailed,0,$isSuccessfull);	
	
	&utils::writeLog(&utils::getSuccessString($result),"result","group",$group->{'id'},$group->{'name'});
	&utils::writeLog("","stop","group",$group->{'id'},$group->{'name'});
	return $result;

}


## @method getCommands
# returns the list of commands
# @return the list of commands
sub getCommands($){
	my ($group) = @_;
	return @{$group->{'commands'}};
}



return 1;