#!/usr/bin/perl -w

package confirm;

use writejson;

sub new {
   my $klassenname = shift;
   my $self = {};
   return bless $self, $klassenname;
}

sub DESTROY {
	my $self = shift;
}

sub confirm{
	$classname = shift;
	$object = lc (shift // "help");
	$params =  (shift // ""); 
	if($object =~ /^(?:help)|(?:\-h)$/) {openHelp("confirm.txt"); return "";}
	elsif($object =~ /^connector$/) {connector($params);}
	elsif($object =~ /^device$/) {device($params);}
	elsif($object =~ /^devicecomponent$/) {devicecomponent($params);}
	else {print "confirm object '$object' not found\n"} 
}

sub connector{
	$p = shift;
	if ($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("confirmConnector.txt");
		return "";
	}
	else {
		if ($p =~ s/id=([1-9]\d*)//) {
			$id = $1;
		}
		else{
			print "Id of to be confirmed device: "; #Standard Global Zone?
			chomp($id = <STDIN>); #Eingabe prüfen!!!
		}
		$p =~ s/\s//g;
		if($p eq ""){
			print "Connector with Id '$id' confirmed";
			$json = new writejson('json');
			$json->addHeader(82);
			$json->addConfirmConnector($id);
			return $json->jsonToString();		
		}
		else {
			print "The params '$params' are not defined for confirm connector, ERROR.\n";
			return "";
		}
	}
}

sub device{
	$p = shift;
	if ($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("confirmDevice.txt");
		return "";
	}
	else {
		$id = "";
		if ($p =~ s/id=([1-9]\d*)//) {
			$id = $1;
		}
		else{
			print "Id of to be confirmed device: "; #Standard Global Zone?
			chomp($id = <STDIN>); #Eingabe prüfen!!!
		}
		$zone = "";
		if ($p =~ s/(?:(?:zoneid=)|(?:\-z ))([1-9]\d*)//) {
			$zone = $1;
		}
		else{
			print "To be assigned Zone(Id): "; #Standard Global Zone?
			chomp($zone = <STDIN>); #Eingabe prüfen!!!
		}
		$p =~ s/\s//g;
		if($p eq ""){
			print "Device with Id '$id' confirmed";
			$json = new writejson('json');
			$json->addHeader(82);
			$json->addConfirmDevice($id, $zone);
			return $json->jsonToString();		
		}
		else {
			print "The params '$params' are not defined for confirm device, ERROR.\n";
			return "";
		}
	}
}

sub devicecomponent{ 
	$p = shift;
	if ($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("confirmDeviceComponent.txt");
		return "";
	}
	else {
		$id = "";
		if ($p =~ s/id=([1-9]\d*)//) {
			$id = $1;
		}
		else{
			print "Id of to be confirmed device: ";
			chomp($id = <STDIN>); #Eingabe prüfen!!!
		}
		$unit = "";
		if ($p =~ s/(?:(?:unitid=)|(?:\-u ))([1-9]\d*)//) {
			$unit = $1;
		}
		else{
			print "To be assigned Unit(Id): ";
			chomp($unit = <STDIN>); #Eingabe prüfen!!!
		}
		$name = "";
		if ($p =~ s/(?:(?:name=)|(?:\-n ))"([^"]*)"//) {
			$name = $1;
		}
		else{
			print "To be assigned Name: ";
			chomp($name = <STDIN>);
		}
		$p =~ s/\s//g;
		if($p eq ""){
			print "DeviceComponent with Id '$id' confirmed";
			$json = new writejson('json');
			$json->addHeader(82);
			$json->addConfirmDeviceComponent($id, $unit, $name);
			return $json->jsonToString();				
		}
		else {
			print "The params '$params' are not defined for confirm devicecomponent, ERROR.\n";
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