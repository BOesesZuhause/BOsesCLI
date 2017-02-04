#!/usr/bin/perl -w

use lib ('Switch-2.17');
use Switch;

package request;

sub new {
   my $klassenname = shift;
   my $selbst = {};
   return bless $selbst, $klassenname;
}

sub request{
	$classname = shift;
	$component = lc shift; #anderen namen finden
	$param = lc shift; 
	switch ($component){
		case /^device$/ {device($param); last}
		#cases für restliche Komponenten
		case/^.*$/ {print "Component not found"} 
	}
}

sub device{
	$p = shift;
#	print "$params \n";
	if($p =~ /^$/){
		#auf eingabe warten
	}
	switch ($p){
		case /^(?:(?:list)|(?:\-l))$/ {
			#Alle devices auflisten
			last
		}
		case /^(?:(?:help)|(?:\-h))$/ {
			#hilfe von request device (vllt zurückspringen vor switch?)
			last
		}
		case /^id=[1-9]\d*$/ {
			print "angekommen \n";
			#device mit der ID X auflisten
			last
		}
		#cases für die Spalten von device
		case /^(?:(?:unconfirmed)|(?:\-u))$/ {
			#alle unconfirmed devices auflisten
			last
		}
		case /^(?:(?:confirmed)|(?:\-c))$/ {
			#alle confirmed devices auflisten
			last
		}
		case /^(?:(?:metadata)|(?:\-m))$/ {
			#Metadaten eines devices auspucken
			last
		}
		case /^.*$/{
			print "fehler in req dev switch \n";
		}
	}
}

sub test{
	foreach(@_){
		print "$_ \n"
	}
	$classname = shift;
	$component = lc shift;
	$param = lc shift;
	print "classname: $classname \n";
	print "Komponente: $component \n";
	print "Parameter: $param \n";
}

1;