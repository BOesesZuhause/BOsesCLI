#!/usr/bin/perl -w

package main;

use request;
use create;
use confirm;
use websocket;

$b = 1;
$requester = new request('request');
$creater = new create('create');
$confirmer = new confirm('confirm');
$ws = new websocket('websocket');
$connected = 0;

#must be connected

while($b){
	print "BOesesCli: ";
	chomp($eingabe = <STDIN>);
	$eingabe = $eingabe;
	$eingabe =~ s/^ *(\w.*\w) *$/$1/; #remove all whitespace before and after the command
	if($eingabe eq "exit"){
		$b=0;
	}
	elsif($eingabe eq "history"){
		open (DATEI, "history.txt") or die $!;
		   while(<DATEI>){
		     print $_;
		   }
		close (DATEI);
	}
	elsif($eingabe eq "clearhistory"){
		open (DATEI, ">history.txt") or die "can not write History";
	   	print DATEI "";
		close (DATEI);
	}
	elsif($eingabe eq ""){
		open (DATEI, "history.txt") or die $!;
		@lines = reverse <DATEI>;
		print $lines[0];
		close (DATEI);
	}
	elsif($eingabe =~ /^connect(?: (.*))?/){
		if($ws->connect($1)){$connected++;}
	}
	elsif($eingabe =~ /^disconnect/){
		$ws->disconnect();
		$connected = 0;
	}
	elsif($eingabe =~ m/^((help)|(-h))$/){
		openHelp("main.txt");
	}
	elsif($connected != 0 && $eingabe =~ /^request(?: (\w+))?(?: (.*))?/){ #request help
		$req = $requester->request($1, $2);
		if($req =~ /^([^\|]*)\|(\d+)\|(\d*)\|?({.*)/){
			$ws->send($4);
			if($2 == 80) {showUnconfirmedData($1, $ws->loadAnswer($2, $3))}
			elsif($2 == 52) {showDeviceComponentData($1, $ws->loadAnswer($2, $3))}
			else {showData($1, $ws->loadAnswer($2, $3))};
		}
	}
	elsif($connected != 0 && $eingabe =~ /^create(?: (\w+))?(?: (.*))?/){
		$cre = $creater->create($1, $2);
		if($cre =~ /^(\d+)\|({.*)/){
			$ws->send($2);
			isCreated($1, $ws->loadAnswer($1));
		}
	}
	elsif($connected != 0 && $eingabe =~ /^confirm(?: (\w+))?(?: (.*))?/){
		$con = $confirmer->confirm($1, $2);
		if ($con ne ""){
			$ws->send($con);
		}
	}
	else{
		print "Command '$eingabe' not found.\nOr you have to connect with BOese\n";
		$eingabe .= " !WRONG!" 
	}
	if ($eingabe ne "") {
		open (DATEI, ">>history.txt") or die "can not write History";
	   	print DATEI $eingabe."\n";
		close (DATEI);
	}
}

sub openHelp{
	$file = shift;
	print "\n";
	open (DATEI, "./HilfeTexte/$file") or die $!;
	   while(<DATEI>){
	     print $_;
	   }
	close (DATEI);
	print "\n\n";
}

sub showData{
	$filter = shift;
	$data = shift;
	$data =~ s/{\s*"Header"\s*:\s*{[^}]*}\s*,\s*"(\w*)"\s*:\s*\[//;
	print "$1 :\n";
	$data =~ /{([^}]*)}/;
	$names = $1;
	while ($names ne "") {
		$names =~ s/"([^"]*)"\s*:\s*(?:(?:"[^"]*")|(?:true)|(?:false)|(?:-?\d*.?\d*))\s*,?\s*//;
		print $1;
		$l = length $1;
		while ($l < 24) {
			print "\t";
			$l += 8;
		}
	}
	print "\n";
	while ($data ne "]}") {
		$data =~ s/{([^}]*)},?//;
		$values = $1;
		if ($values =~ qr/$filter/){
			while ($values ne "") {
				$values =~ s/"[^"]*"\s*:\s*(?:(?:"([^"]*)")|(true)|(false)|(-?\d*.?\d*))\s*,?\s*//;
				$l = 0;
				if($1){print $1; $l = length $1;}
				if($2){print $2; $l = length $2;}
				if($3){print $3; $l = length $3;}
				if($4){print $4; $l = length $4;}
				while ($l < 24) {
					print "\t";
					$l += 8;
				}
			}
			print "\n";
		}
	}
}

sub showDeviceComponentData{
	$filter = shift;
	$data = shift;
	$data =~ s/{\s*"Header"\s*:\s*{[^}]*}\s*,\s*"(\w*)"\s*:\s*(\d*),\s*"Components"\s*:\s*\[//;
	print "$1 $2 :\n";
	$data =~ /{([^}]*)}/;
	$names = $1;
	while ($names ne "") {
		$names =~ s/"([^"]*)"\s*:\s*(?:(?:"[^"]*")|(?:true)|(?:false)|(?:-?\d*.?\d*))\s*,?\s*//;
		print $1;
		$l = length $1;
		while ($l < 24) {
			print "\t";
			$l += 8;
		}
	}
	print "\n";
	while ($data ne "]}") {
		$data =~ s/{([^}]*)},?//;
		$values = $1;
		if ($values =~ qr/$filter/){
			while ($values ne "") {
				$values =~ s/"[^"]*"\s*:\s*(?:(?:"([^"]*)")|(true)|(false)|(-?\d*.?\d*))\s*,?\s*//;
				$l = 0;
				if($1){print $1; $l = length $1;}
				if($2){print $2; $l = length $2;}
				if($3){print $3; $l = length $3;}
				if($4){print $4; $l = length $4;}
				while ($l < 24) {
					print "\t";
					$l += 8;
				}
			}
			print "\n";
		}
	}
}

sub showUnconfirmedData{
	$filter = shift;
	$data = shift;
	$data =~ s/{\s*"Header"\s*:\s*{[^}]*}\s*,\s*//;
	while ($data ne "}") {
		$data =~ s/"([^"]*)":\[((?:{[^}]*}\s*,?\s*)*)\]\s*,?\s*//;
		$tmp = $1; #save $1, cause in IF-Clause $1 will be reset
		$tmps = $2; #save $2, cause in IF-Clause $2 will be reset
		if($tmp =~ qr/$filter/){
			print "$tmp :\n";
			$tmps =~ /{([^}]*)}/;
			$names = $1;
			while ($names ne "") {
				$names =~ s/"([^"]*)"\s*:\s*(?:(?:"[^"]*")|(?:true)|(?:false)|(?:-?\d*.?\d*))\s*,?\s*//;
				print $1;
				$l = length $1;
				while ($l < 24) {
					print "\t";
					$l += 8;
				}
			}
			print "\n";
			while ($tmps ne "") {
				$tmps =~ s/{([^}]*)},?//;
				$values = $1;
				while ($values ne "") {
					$values =~ s/"[^"]*"\s*:\s*(?:(?:"([^"]*)")|(true)|(false)|(-?\d*.?\d*))\s*,?\s*//;
					$l = 0;
					if($1){print $1; $l = length $1;}
					if($2){print $2; $l = length $2;}
					if($3){print $3; $l = length $3;}
					if($4){print $4; $l = length $4;}
					while ($l < 24) {
						print "\t";
						$l += 8;
					}
				}
				print "\n";
			}
			print "\n";
		}
	}
}

sub isCreated{
	$msgType = shift // ""; 
	$answer = shift // "";
	$msgType++;
	$answer =~ /"MessageType"\s*:\s*(\d*),/;
	if ($1 == $msgType){
		$answer =~ /{\s*("\w*Id"\s*:\s*\d*),/;
		print "Created with $1\n";
	}
	else{
		print "Creation failed\n";
	}
}