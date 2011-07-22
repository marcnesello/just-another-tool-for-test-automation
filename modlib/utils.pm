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
# module utils with helper functions and the logfile functions
#
# @copy 2009, marcn;
use strict;
use warnings;

use POSIX qw(strftime);

package utils;

my $logfile;
my $statfile;


my $color = 0;


## @method executeList
# executes all elements of the list
# @param @list a list of elements which implement the method execute 
# @return number of successfull, successfull with warning, and failed tests
sub executeList($){
	my (@list) = @_;
	
	my $isFailed = 0;
	my $isSuccessfull = 0;
	my $isWarning = 0;

	foreach my $element (@list){

			my $result = $element->execute();
			if ($result eq 1){
				$isSuccessfull = $isSuccessfull + 1;

			}elsif($result eq 2){
				$isWarning = $isWarning + 1;
			}else{
				$isFailed = $isFailed + 1;
			}
		}
	#print "END";
	return ($isFailed,$isWarning,$isSuccessfull);#getResult($isFailed,$isSuccessfull);
}


## @method getResult
# determines if the result is successfull
# @param $isFailed number of failed tests
# @param $isWarning number of tests with warning
# @param $isSuccessfull number of successfull tests 
# @return 1 is successfull, 2 for warning and otherwise 0
sub getResult($$$){
	my($isFailed,$isWarning,$isSuccessfull) = @_;
	my $success = 0;
	if(($isSuccessfull > 0) and ($isWarning eq 0) and ($isFailed eq 0)){
		$success = 1;
	}elsif(($isWarning > 0) and ($isFailed eq 0)){
		$success = 2;
	}else{
		$success = 0;
	}	
	return $success;
}

## @method getSuccessString
# returns a string represantation for the result
# @param $success 1 for fail and 0 if not, 2 for success with warning
# @return SUCCESSFULL is successfull, WARNING if warning and otherwise NOT SUCCESSFULL
sub getSuccessString($){
	my ($success) = @_;
	if ($success eq 1){
		return "SUCCESSFULL";
	}elsif($success eq 2){
		return "WARNING";
	}else{
		return "NOT SUCCESSFULL";
	}
}

## @method createLogfile
# creates a logfile and the html statistics file
# @param $filepath the path of the logfile
sub createLogfile($){
	my ($filepath) = @_;
	
	open LOGFILE,">$filepath".".log";
	print "Write Log to $filepath.log\n";
	$logfile = *LOGFILE;
	writeLog("Log started...");
	open STATFILE, ">$filepath".".html";
	print STATFILE "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">
<html xmlns=\"http://www.w3.org/1999/xhtml\">
<head>
<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"/>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=ISO-8859-1\" />
<title>Test statistics</title>
</head>
<body>
<h1>Test results</h1>
<p>Details see Logfile <i>$filepath.log</i></p>\n";
$statfile = *STATFILE;
}


## @method writeLog
# writes the message to the log and important messages to screen
# @param $message the message which shall be written to the log
# @param $logtype the log type (output,warning,result,fail,start,stop,duration,aborted)
# @param $type object type (group,command,test,testlist)
# @param $id the id of the object which wants to print into log
# @param $name the name of the object which wants to print into the log
sub writeLog($){
	my ($message,$logtype,$type,$id,$name,$duration) = @_;
	
	my @monname = ("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC");
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$min = &addZero($min);
	$sec = &addZero($sec);
	$hour = &addZero($hour);
	$mday = &addZero($mday);
	
	if (!defined($id)){
		$id = "";
	}else{
		$id = "ID $id";
	}
	if (!defined($name)){
		$name = "";
	}else{
		$name = "'$name'";
	}

	print $logfile $mday.". ".$monname[$mon]." ".($year + 1900)." - ".$hour.":".$min.":".$sec."\n";
	print $mday.". ".$monname[$mon]." ".($year + 1900)." - ".$hour.":".$min.":".$sec."\n";
	if(!defined($logtype)){
	}
	elsif($logtype eq "output"){
		print $logfile "Output of the $type $id $name:\n";
		print "Output of the $type $id $name:\n";
	}elsif($logtype eq "warning"){
		print $logfile "WARNING\n";
		print "WARNING\n";	
	}elsif($logtype eq "result"){
		if ($type =~ /(test|testlist)/){
			print "The duration of the of the $type $id $name was: $duration\n";
			print $logfile "The duration of the of the $type $id $name was: $duration\n";
			
			if($type eq "test"){

				print $statfile "<h2>$id: $name</h2>\n";
				if ($message =~ /not successfull/i){
					print $statfile "<p>Result: <b style=\"color:red\">$message</b>\n";
				}elsif($message =~ /warning/i){
					print $statfile "<p>Result: <b style=\"color:orange\">$message</b>\n";				
				}else{
					print $statfile "<p>Result: <b style=\"color:green\">$message</b>\n";
				}
				print $statfile "<br />Duration: <b>$duration</b>\n";
				print $statfile "</p>\n";
			}
		}
		print $logfile "The result of the $type $id $name is ";
		print "The result of the $type $id $name is ";


	}elsif($logtype eq "fail"){
		print $logfile "$type $id $name failed at ";
		print "$type $id $name failed at ";
	
	}elsif($logtype eq "start"){
		print $logfile "$type $id $name started: ";
		print "$type $id $name started: ";
		if ($type eq "test"){
			if($color eq 0){
				$color = 1;
				print $statfile "<div style=\"background-color:grey\">";
			}else{
				$color = 0;
				print $statfile "<div style=\"background-color:lightgrey\">";
			}
		}

	}elsif($logtype eq "stop"){
		print $logfile "$type $id $name finished: ";
		print "$type $id $name finished: ";
		if($type eq "test"){
			print $statfile "</div>";
		}

	}elsif($logtype eq "time"){
		print $logfile "$type $id $name. Duration was ";
		print "$type $id $name. Duration was ";

	}elsif($logtype eq "aborted"){
		if($type eq "test"){
			print $statfile "<p><b>$message</b></p>";

		}
		print $logfile "$type $id $name aborted:  ";
		print "$type $id $name aborted: \n ";

	}
	print $logfile $message;
	print $logfile "\n-------------------------------------------------------\n";
	print $message;
	print "\n-------------------------------------------------------\n";
}


## @method closeLogfile
# closes the logfile and html file
sub closeLogfile(){
	close $logfile;
	close $statfile;
}

## @method printDiagram
# @param $failed number of failed tests
# @param $warning number of tests with warning
# @param $success number of tests with Success
# draws the diagram into the html file
sub printDiagram($$$$$){
	my ($failed,$warning,$success,$duration,$name) = @_;
	print $statfile "<hr />\n";
	print $statfile "<h2>TESTLIST RESULT for $name </h2>\n";
	print $statfile "<table>\n";
	print $statfile "<tr>\n";
	print $statfile "<td><b>SUCCESSFULL</b></td>";
	for (my $i = 0; $i < $success; $i++){
		print $statfile "<td style=\"color:green;background-color:green\">XXX</td>";	
	}
	print $statfile "<td>$success</td>\n";
	print $statfile "</tr>\n";
	print $statfile "<tr>\n";
	print $statfile "<td><b>WARNING</b></td>";
	for (my $i = 0; $i < $warning; $i++){
		print $statfile "<td style=\"color:orange;background-color:orange\">XXX</td>";	
	}
	print $statfile "<td>$warning</td>\n";
	print $statfile "</tr>\n";
	print $statfile "<tr>\n";
	print $statfile "<td><b>FAILED</b></td>";
	for (my $i = 0; $i < $failed; $i++){
		print $statfile "<td style=\"color:red;background-color:red\">XXX</td>";	
	}
	print $statfile "<td>$failed</td>\n";
	print $statfile "</tr>\n";
	print $statfile "</table>\n";
				
	my $result = &utils::getResult($failed,$warning,$success);


	if ($result eq 1){
		print $statfile "<p>Testlist Result: <b style=\"color:green\">SUCCESSFULL</b>\n";	
	}elsif($result eq 2){
		print $statfile "<p>Testlist Result: <b style=\"color:orange\">WARNING</b>\n";				
	}else{
		print $statfile "<p>Testlist Result: <b style=\"color:red\">FAILED</b>\n";
	}
	print $statfile "<br />Duration: <b>$duration</b>\n";
	print $statfile "</p>\n";
	print $statfile "</body>
					</html>";
}

## @method addZero
# adds a leading zero to the given number if smaller than 10
# @param $num a number
sub addZero($){
	my ($num) = @_;
	if ($num < 10){
		$num = "0$num";
	}
	return $num;
}
## @method diffTime
# Calculates the difference betwenn the current time and the given time
# @param $sec Seonds
# @param $min Minutes
# @param $hour Hours
# @param $yday Day in Year
# @return The Difference in Days Hours:Minutes:Seconds
sub diffTime($){
	my($sec,$min,$hour,$yday) = @_;
	
	my($nsec,$nmin,$nhour,$nyday) = localtime(time);
	
	my $diffsecs = $nsec - $sec;
	my $diffmins = $nmin - $min;
	if($diffsecs < 0){
		$diffmins = $diffmins - 1;
		$diffsecs = 60 + $diffsecs;
	}
	
	my $diffhours = $nhour - $hour;
	if($diffmins < 0){
		$diffhours = $diffhours - 1;
		$diffmins = 60 + $diffmins;
	}
	
	my $diffdays = $nyday - $yday;
	if($diffhours < 0){
		$diffdays = $diffdays - 1;
		$diffhours = 24 + $diffhours;
	}
	
	return "$diffdays Days $diffhours Hours $diffmins Minutes and $diffsecs Seconds";
}

return 1;