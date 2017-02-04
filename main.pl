#!/usr/bin/perl -w

package main;

use help;
use request;

$b = 1;
$helper = new help;
$requester = new request('request');

while($b){
	print "BOesesCli: ";
	chomp($eingabe = <stdin>);
	$eingabe = lc $eingabe;
	#lc mach lowercase
	$eingabe =~ s/^ *(\w.*\w) *$/$1/; #alle Leerzeichen vor und nachdem Befehl löschen
	if($eingabe eq "exit"){
		$b=0;
	}
	elsif($eingabe =~ m/^((help)|(-h))$/){
		print "$eingabe\n";
		$helper->ausgabe();
	}
	elsif($eingabe =~ /^request (\w+) (.*)/){
		$requester->request($1, $2);
	}
	elsif($eingabe =~ /^send/){

	}
	elsif($eingabe =~ /^confirm/){

	}
	elsif($eingabe =~ /^list/){ #was will ich damit bezwecken?

	}
	else{
		print "Befehl $eingabe nicht gefunden \n"; 
	}
}

sub helpausgabe{
	print "Falsche Methode: Hier sollen alle Befehle ausgegeben werden!!! \n"
}