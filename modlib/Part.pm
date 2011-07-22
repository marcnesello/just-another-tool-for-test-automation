#!/usr/bin/perl

## @file
# Implementation of Part .
#
# @copy 2010, marcn;

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



## @class Part
# author: marcn
# @par
# This class represents the head, body and teil objects which are similar
# A part can be executed
package Part;

use strict;
use warnings;
use Group;
use utils;

## @cmethod new 
# constructs the part object
# @param $partType either body, tail or head
# @param $warnIfFailed attribute from xml file
# @param @groups list of group objects
# @return the part object
sub new {
	my ($part,$partType,$warnIfFailed,@groups) = @_;
	
	my $self = {
		'type' => $partType,
		'groups' => [@groups],
		'warnIfFailed' => $warnIfFailed
	};
	
	bless $self, $part;
	
	return $self;
}


## @method execute
# executes the part
# @return 1 if the evaluation was successfull, otherwise 0
sub execute($){
	my ($part) = @_;	
	
	my @groupList = $part->getGroups();
	
	my $success = 0;

	&utils::writeLog("","start",$part->{'type'},$part->{'id'},$part->{'name'});
	if(@groupList > 0){
		my ($isFailed,$isWarning,$isSuccessfull) = &utils::executeList(@groupList);
		$success = &utils::getResult($isFailed,0,$isSuccessfull);
	}else{
		$success = 1;	
	}



	if(($success eq 0) and ($part->{'warnIfFailed'} eq 1)){
		$success = 2;
	}

	
	&utils::writeLog(&utils::getSuccessString($success),"result",$part->{'type'},$part->{'id'},$part->{'name'});
	&utils::writeLog("","stop",$part->{'type'},$part->{'id'},$part->{'name'});
	
	
	return $success;
}

## @method getGroups
# returns the list of groups
# @return the list of groups
sub getGroups($){
	my ($part) = @_;
	return @{$part->{'groups'}};
}


return 1;