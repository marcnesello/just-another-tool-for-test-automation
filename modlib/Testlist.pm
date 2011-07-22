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
# Implementation of Testlist.
#
# @copy 2009, marcn;

## @class Testlist
# author: marcn
# @par
# Class Representation of a testlist
# A testlist can be executed
package Testlist;

use strict;
use warnings;
use Test;
use utils;

## @cmethod new
# constructs the testlist object
# @param $name name of the testlist,
# @param $timeout the timeout, 0 means no timeout
# @param $logfile path of the logfile
# @param the list of the tests
# @return the testlist object
sub new {
	my ($testlist, $name, $timeout, $logfile, @tests) = @_;
	
	&utils::createLogfile($logfile);
	
	my $self = {
		'timeout' => $timeout,
		'tests' => [@tests],
		'logfile' => $logfile,
		'name' => $name
	};
	
	bless $self, $testlist;
	
	return $self;
}

## @method execute
# executes the test
# @return 1 if the evaluation was successfull, 2 if successfull with warning, otherwise 0
sub execute($){
	my ($testlist) = @_;	
	my $pid;
	my $aborted = 0;
	&utils::writeLog("","start","testlist","",$testlist->{'name'});
	$SIG{ALRM} = sub{
		kill 9, $pid;
		&utils::writeLog("Aborted after a Timeout of $testlist->{'timeout'} Seconds","aborted","testlist","",$testlist->{'name'});
		$aborted = 1;
	};
	print "Timeout : $testlist->{'timeout'}\n";

	my @testList = $testlist->getTests();
	
	my ($isFailed,$isWarning,$isSuccessfull) = (0,0,0);
	my $success = 0;
	


	my ($sec,$min,$hour,$yday) = localtime(time);
	$pid = fork();
	if ($pid) {
		alarm "$testlist->{'timeout'}";
		waitpid($pid,0);
		alarm 0;
		my $duration = &utils::diffTime($sec,$min,$hour,$yday);
		
		my @data = ("0,0,0");
		if($aborted eq 0){
			open OUTPT, "<tmp/outputList.tmp";
			@data = <OUTPT>;
			close OUTPT;
		}
		unlink "tmp/outputList.tmp";

		($isFailed,$isWarning,$isSuccessfull) = split(/,/, $data[0]);
		$success = &utils::getResult($isFailed,$isWarning,$isSuccessfull);


		&utils::writeLog(&utils::getSuccessString($success),"result","testlist","",$testlist->{'name'},$duration);
		&utils::writeLog("","stop","testlist","",$testlist->{'name'});
		
		&utils::printDiagram($isFailed,$isWarning,$isSuccessfull,$duration,$testlist->{'name'});
		&utils::writeLog("Log finished...");

		&utils::writeLog("Log saved at $testlist->{'logfile'}.log");
		&utils::writeLog("HTML Stats saved at $testlist->{'logfile'}.html");
		return $success;
	}else {
		($isFailed,$isWarning,$isSuccessfull) = &utils::executeList(@testList);	
		open OUTPT, ">tmp/outputList.tmp";
		print OUTPT "$isFailed,$isWarning,$isSuccessfull";
		close OUTPT;
		exit;
	}

	
}

## @method getTests
# returns the list of tests
# @return the list of tests
sub getTests($){
	my ($testlist) = @_;
	return @{$testlist->{'tests'}};
}

## @method DESTROY
# destroy testlist and close Logfile
sub DESTROY{
	&utils::closeLogfile();
}



return 1;