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
# Implementation of Test.
#
# @copy 2009, marcn;

## @class Test
# author: marcn
# @par
# Class Representation of a single test
# A test can be executed
package Test;

use strict;
use warnings;
use Part;
use utils;

## @cmethod new
# constructs the test object
# @param $id the id
# @param $name the name
# @param $timeout a timeout
# @param $body body (a Part object)
# @param $head head (a Part object)
# @param $tail tail (a Part object)
# @return the test object
sub new {
	my ($test,$id,$name,$timeout,$body,$head,$tail) = @_;
	if(!defined($head)){
		$head = "";
	}
	if(!defined($tail)){
		$tail = "";
	}
	
	
	my $self = {
		'id' => $id,
		'name' => $name,
		'timeout' => $timeout,
		'head' => $head,
		'body' => $body,
		'tail' => $tail
	};
	
	bless $self, $test;
	
	return $self;
}

## @method execute
# executes the test
# @return 1 if the evaluation was successfull, otherwise 0
sub execute($){
	my ($test) = @_;	
	my $pid;
	my $aborted = 0;
	
	my ($failed,$warnings,$success) = (0,0,0);
	
	$SIG{ALRM} = sub{
		kill 9, $pid;
		&utils::writeLog("Aborted after a Timeout of $test->{'timeout'} Seconds","aborted","test","",$test->{'name'});
		$aborted = 1;
	};
	
	&utils::writeLog("","start","test",$test->{'id'},$test->{'name'});
	my ($sec,$min,$hour,$yday) = localtime(time);
	$pid = fork();
	if ($pid) {
		alarm "$test->{'timeout'}";
		waitpid($pid,0);
		alarm 0;
		my $duration = &utils::diffTime($sec,$min,$hour,$yday);

		my @data = ("0,0,0");
		if($aborted eq 0){
			open OUTPT, "<tmp/output".$test->{'id'}."tmp";
			@data = <OUTPT>;
			close OUTPT;
		}
		unlink "tmp/output".$test->{'id'}."tmp";
		
		($failed,$warnings,$success) = split(/,/, $data[0]);
		
		my $result = &utils::getResult($failed,$warnings,$success);
		
		&utils::writeLog(&utils::getSuccessString($result),"result","test",$test->{'id'},$test->{'name'},$duration);
		&utils::writeLog("","stop","test",$test->{'id'},$test->{'name'});
		return $result;
	}else{
		my @partList = ();
		my $head = $test->{'head'};
		my $body = $test->{'body'};
		my $tail = $test->{'tail'};
		my ($headResult,$bodyResult,$tailResult) = 0;
		if($head ne ""){
			push (@partList, $head);
		}
		
		push (@partList, $body);
		
		if($tail ne ""){
			push (@partList, $tail);
		}
		
		($failed,$warnings,$success) = &utils::executeList(@partList);
		
		open OUTPT, ">tmp/output".$test->{'id'}."tmp";
		print OUTPT "$failed,$warnings,$success";
		close OUTPT;
		exit;
		

	}

}



return 1;