#!/usr/bin/perl -w

package create;

use writejson;

sub new {
   my $klassenname = shift;
   my $self = {};
   return bless $self, $klassenname;
}

sub DESTROY {
	my $self = shift;
}

sub create{
	$classname = shift;
	$object = lc (shift // "help");
	$params =  (shift // ""); 
	if($object =~ /^help$/) {openHelp("create.txt"); return "";}
	elsif($object =~ /^rule$/) {rule($params);}
	elsif($object =~ /^zone$/) {zone($params);}
	elsif($object =~ /^unit$/) {unit($params);}
	else {print "create object '$object' not possible\n"} 
}

sub rule{
	$p = shift;
	if ($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("createRule.txt");
		return "";
	}
	else {
		$permission = "";
		if ($p =~ s/(?:(?:permission=)|(?:\-p ))"([^"]*)"//) {
			$permission = $1;
		}
		else{
			print "Permission of new Rule: ";
			chomp($permission = <STDIN>);
		}
		$condition = "";
		if ($p =~ s/(?:(?:condition=)|(?:\-b ))"([^"]*)"//) { 
			$condition = $1;
		}
		else{
			print "Condition of new Rule: ";
			chomp($condition = <STDIN>);
		}
		$action = "";
		if ($p =~ s/(?:(?:action=)|(?:\-A ))"([^"]*)"//) {
			$action = $1;
		}
		else{
			print "Action of new Rule: ";
			chomp($action = <STDIN>);
		}
		$p =~ s/\s//g;
		if($p eq ""){
			$json = new writejson('json');
			$json->addHeader(90);
			$json->addCreateRule($permission,$condition,$action);
			return "90|".$json->jsonToString()."\n";
		}
		else {
			print "The params '$params' are not defined for create a rule, ERROR.\n";
			return "";
		}
	}
}

sub zone{ 
	$p = shift;
	if ($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("createRule.txt");
		return "";
	}
	else {
		$super = "";
		if ($p =~ s/(?:(?:superzoneid=)|(?:\-s ))"([^"]*)"//) {
			$super = $1;
		}
		else{
			print "SuperZone(Id) of new Zone: ";
			chomp($super = <STDIN>);
		}
		$name = "";
		if ($p =~ s/(?:(?:name=)|(?:\-n ))"([^"]*)"//) {
			$name = $1;
		}
		else{
			print "Name of the new Zone: ";
			chomp($name = <STDIN>);
		}
		$p =~ s/\s//g;
		if($p eq ""){
			$json = new writejson('json');
			$json->addHeader(92);
			$json->addCreateZone($super,$name);
			return "92|".$json->jsonToString()."\n";		
		}
		else {
			print "The params '$params' are not defined for create a rule, ERROR.\n";
			return "";
		}
	}
}

sub unit{
	$p = shift;
	if ($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("createRule.txt");
		return "";
	}
	else {
		$name = "";
		if ($p =~ s/(?:(?:name=)|(?:\-n ))"([^"]*)"//) {
			$name = $1;
		}
		else{
			print "Name of the new Unit: ";
			chomp($name = <STDIN>);
		}
		$symbol = "";
		if ($p =~ s/(?:(?:symbol=)|(?:\-S ))"([^"]*)"//) {
			$symbol = $1;
		}
		else{
			print "Symbol of new Unit: ";
			chomp($symbol = <STDIN>);
		}
		$p =~ s/\s//g;
		if($p eq ""){
			$json = new writejson('json');
			$json->addHeader(94);
			$json->addCreateUnit($name,$symbol);
			return "94|".$json->jsonToString()."\n";		
		}
		else {
			print "The params '$params' are not defined for create a Unit, ERROR.\n";
			return "";
		}
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

1;