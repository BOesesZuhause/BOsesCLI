#!/usr/bin/perl -w

package request;

use writejson;

sub new {
   my $klassenname = shift;
   my $self = {};
   return bless $self, $klassenname;
}

sub DESTROY {
	my $self = shift;
}

sub request{
	$classname = shift;
	$object = lc (shift // "help");
	$param =  (shift // "help"); 
	if($object =~ /^(?:help)|(?:\-h)$/) {openHelp("request.txt"); return "";}
	elsif($object =~ /^device$/) {device($param);}
	elsif($object =~ /^devicecomponent$/) {devicecomponent($param);}
	elsif($object =~ /^connector$/) {connector($param);}
	elsif($object =~ /^zone$/) {zone($param);}
	elsif($object =~ /^rule$/) {rule($param);}
	elsif($object =~ /^unit$/) {unit($param);}
	elsif($object =~ /^unconfirmed$/) {unconfirmed($param);}
	else {print "requested object '$object' not found\n"} 
}

sub device{ #rdy
	$p = shift // "help";
	$filter = "";
	if($p =~ /^(?:all)|(?:\-a)$/) {
		$filter = "";
	}
	elsif($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("requestDevice.txt");
		return "";
	}
	elsif($p =~ /^id=([1-9]\d*)$/) {
		$filter = '"DeviceId"\s*:\s*'.$1;
	}
	#cases für die Spalten von device
	elsif($p =~ /^(?:(?:zoneid=)|(?:\-z ))([1-9]\d*)$/) {
		$filter = '"ZoneId"\s*:\s*'.$1;
	}
	elsif($p =~ /^(?:(?:connectorid=)|(?:\-C ))([1-9]\d*)$/) {
		$filter = '"connectorId"\s*:\s*'.$1;
	}
	else {
		print "The param '$p' is not defined for request device\n";
		return "";
	}
	$json = new writejson('json');
	$json->addHeader(50);
	$json->addIsUserRequest();
	return "$filter|50|".$json->jsonToString();
}

sub devicecomponent{ 
	$p = shift // "help";
	$filter = '';
	$p =~ /^(\S*)\s*(.*)/;
	$p1 = $1;
	$p2 = $2 // "";
	$dev = 0;
	if($p1 =~ /^deviceid=([1-9]\d*)$/) {
		$dev = $1;
		if($p2 =~ /^(?:all)|(?:\-a)$/) {
			$filter = '';
		}
		elsif($p =~ /^(?:help)|(?:\-h)$/) {
			openHelp("requestDeviceComponent.txt");
			return "";
		}
		elsif($p =~ /^id=([1-9]\d*)$/) {
			$filter = '"DeviceComponentId"\s*:\s*'.$1;
		}
		else {
			print "The param '$param' is not defined for request deviceComponent\n";	
			return "";	
		}
	}
	elsif($p1 =~ /^(?:help)|(?:\-h)$/) {
		openHelp("requestDeviceComponent.txt");
		return "";		
	}
	else {
		print "The param '$param' is not defined for request deviceComponent\n";		
		return "";
	}
	$json = new writejson('json');
	$json->addHeader(52);
	$json->addDeviceIds($dev);
	return "$filter|52|$dev|".$json->jsonToString();
}

sub zone{ #rdy
	$p = shift // "help";
	$filter = '';
	if($p =~ /^(?:all)|(?:\-a)$/) {
		$filter = '';
	}
	elsif($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("requestZone.txt");
		return "";
	}
	elsif($p =~ /^id=([1-9]\d*)$/) {
		$filter = '"ZoneId"\s*:\s*'.$1;
	}
	#cases für die Spalten von zone
	elsif($p =~ /^(?:(?:superzoneid=)|(?:\-s ))([1-9]\d*)$/) {
		$filter = 'SuperZoneId"\s*:\s*'.$1;
	}
	else {
		print "The param '$param' is not defined for request zone\n";	
		return "";	
	}
	$json = new writejson('json');
	$json->addHeader(57);
	return "$filter|57|".$json->jsonToString();
}

sub rule{
	$p = shift // "help";
	$filter = '';
	if($p =~ /^(?:all)|(?:\-a)$/) {
		$filter = '';
	}
	elsif($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("requestRule.txt");
		return "";
	}
	elsif($p =~ /^id=([1-9]\d*)$/) {
		$filter = '"RuleId"\s*:\s*'.$1;
	}
	else {
		print "The param '$param' is not defined for request rule\n";	
		return "";	
	}
	$json = new writejson('json');
	$json->addHeader(59);
	return "$filter|59|".$json->jsonToString();
}

sub unit{
	$p = shift // "help";
	$filter = '';
	if($p =~ /^(?:all)|(?:\-a)$/) {
		$filter = '';
	}
	elsif($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("requestUnit.txt");
		return "";
	}
	elsif($p =~ /^id=([1-9]\d*)$/) {
		$filter = '"UnitId"\s*:\s*'.$1;
	}
	else {
		print "The param '$param' is not defined for request unit\n";	
		return "";	
	}
	$json = new writejson('json');
	$json->addHeader(61);
	return "$filter|61|".$json->jsonToString();
}

sub unconfirmed{
	$p = shift // "help";
	$filter = '';
	if($p =~ /^(?:all)|(?:\-a)$/) {
		$filter = '';
	}
	elsif($p =~ /^(?:help)|(?:\-h)$/) {
		openHelp("requestUnconfirmed.txt");
		return "";
	}
	#cases für die Spalten von device
	elsif($p =~ /^(?:connector)|(?:\-C)/) {
		$filter = 'TmpConnectors';
	}
	elsif($p =~ /^(?:devicecomponent)|(?:\-d)/) {
		$filter = 'TmpDeviceComponents';
	}
	elsif($p =~ /^(?:device)|(?:\-D)/) {
		$filter = 'TmpDevices';
	}
	else {
		print "The param '$param' is not defined for request unconfirmed\n";		
		return "";
	}
	$json = new writejson('json');
	$json->addHeader(80);
	return "$filter|80|".$json->jsonToString();
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