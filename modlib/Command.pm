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
# Implementation of Command.
#
# @copy 2009, marcn;

## @class Command
# author: marcn
# @par
# The class command is the represantation of the command element in the xml test list. 
# A command object can be executed and evaluated
package Command;

use File::Temp;

use strict;
use warnings;
use utils;

use CheckList;

## @cmethod new
# constructs the command object
# @param $id id of the command
# @param $name of the command
# @param $path the path of the command
# @param $posChecks the positive checks (a CheckList)
# @param $negChecks the negative checks (a CheckList)
# @param @input a list with input Data
# @return the command object
sub new {
	my ($command, $id,$name,$path,$posChecks,$negChecks,@input) = @_;
	my $inputFile = 0;

	if((@input ne 0) or (@input)){
		$inputFile = File::Temp->new(TEMPLATE => 'inputXXXXX', DIR=> 'tmp', SUFFIX => '.tmp');
		$inputFile->safe_level( File::Temp::HIGH );
		
		if($^O !~ /win/i){
			$inputFile->unlink_on_destroy(0);
		}
		foreach my $tmpin (@input){
			print $inputFile $tmpin."\n";
		}	
	}


	
	my $self = {
		'id' => $id,
		'name' => $name,
		'path' => $path,
		'positiveChecks' => $posChecks,
		'negativeChecks' => $negChecks,
		'inputFile' => $inputFile
	};
	
	bless $self, $command;
	
	return $self;
}


## @method call
# executes the command and returns it's output
# @return the command output
sub call($){
	my ($command) = @_;
	
	my $tmpfile = $command->{'inputFile'};
	my $output = "";
	
	if($tmpfile ne 0){
		$output = `$command->{'path'} < $tmpfile 2>&1`;
	}else{
		$output = `$command->{'path'} 2>&1`;
	}

	&utils::writeLog($output,"output","command",$command->{'id'},$command->{'name'});
	return $output;
}


## @method evaluate
# Evaluates the given text string with the positive test and negative test values
# @param $text a text string usually the output of a command
# @return 1 if the evaluation was successfull, otherwise 0
sub evaluate($$){
	my ($command,$text) = @_;
	
	my $posChecks = $command->{'positiveChecks'};
	my $negChecks = $command->{'negativeChecks'};
	
	my @posChecks = $posChecks->getList();
	my @negChecks = $negChecks->getList();
		
	my $isSuccessfull = 1;
	my $isFailed = 0;
	
	foreach my $check (@posChecks){

		if($check eq ""){
			
		}elsif($text =~ qr/$check/){

		}else{
			$isSuccessfull = 0;
			&utils::writeLog("Positive Check '".$check."'","fail","command",$command->{'id'},$command->{'name'});

		}	
	}


	#if (@negChecks eq 0){
	#	$isFailed = 0;
	#}
	foreach my $check (@negChecks){

		if($check eq ""){

		}elsif($text !~ qr/$check/){

		}else{
			$isFailed = 1;
			&utils::writeLog("Negative Check '".$check."'","fail","command",$command->{'id'},$command->{'name'});

		}	
	}
	
	my $result = &utils::getResult($isFailed,0,$isSuccessfull);	
	
	&utils::writeLog(&utils::getSuccessString($result),"result","command",$command->{'id'},$command->{'name'});
	return $result;
}


## @method execute
#  executes the command and then evaluates if it was successfull
# @return 1 if the evaluation was successfull, otherwise 0
sub execute($){
	my ($command) = @_;	
	&utils::writeLog("","start","command",$command->{'id'},$command->{'name'});
	my $output = $command->call();
	my $value = $command->evaluate($output);
	&utils::writeLog("","stop","command",$command->{'id'},$command->{'name'});
	return $value;
}

## @method DESTROY
# destroy temp files
sub DESTROY{

}

return 1;