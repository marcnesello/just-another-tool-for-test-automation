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
# Implementation of CheckList.
#
# @copy 2009, marcn;

## @class CheckList
# author: marcn
# @par
# capsules a list for positive and negative checks
# A test can be executed
package CheckList;

use strict;
use warnings;

## @cmethod new
# constructs the checkList object
# @param @checks list of checks
# @return the stringList object
sub new {
	my ($checkList,@checks) = @_;

	my $self = {
		'list' => [@checks],
	};
	
	bless $self, $checkList;
	
	return $self;
}

## @method getList
# returns the list
# @return the list
sub getList($){
	my ($checkList) = @_;
	return @{$checkList->{'list'}};
}

return 1;