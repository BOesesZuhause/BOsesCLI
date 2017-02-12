#!/usr/bin/perl -w

package writejson;

sub new {
	my $klassenname = shift;
	my $self = {};
	return bless $self, $klassenname;
}

$string = "{";

$tmpId = -4221;

sub DESTROY {
	my $self = shift;
}

sub addHeader {
	$classname = shift;
	$conId = "";
	open (DATEI, "connectorID.txt") or die $!;
	   @rows = <DATEI>;
	   $conId = $rows[0];
	close (DATEI);
	$msgType = shift;
	$status = 0;
	$timestamp = time;
	$string .= "\"Header\":{\"ConnectorId\":$conId,\"MessageType\":$msgType,\"Status\":$status,\"Timestamp\":$timestamp}";
}

sub addIsUserRequest {
	$string .= ",\"IsUserRequest\":true";
}

sub addDeviceIds {
	$classname = shift;
	$deviceIds = shift;
	$string .= ",\"DeviceIds\":[$deviceIds]";
}

sub addConnectorIds {
	$classname = shift;
	$connectorIds = shift;
	$string .= ",\"ConnectorIds\":[$connectorIds]";
}

sub addConfirmConnector {
	$classname = shift;
	$connectorIds = shift;
	$string .= ",\"TmpConnectors\":[$connectorIds],\"TmpDevices\":[],\"TmpDeviceComponents\":[]";
}

sub addConfirmDevice {
	$classname = shift;
	$deviceId = shift;
	$zoneId = shift;
	$tmpDevice = "{\"DeviceTmpId\":$deviceId,\"ZoneId\":$zoneId}";
	$string .= ",\"TmpConnectors\":[],\"TmpDevices\":[$tmpDevice],\"TmpDeviceComponents\":[]";
}

sub addConfirmDeviceComponent {
	$classname = shift;
	$devCompId = shift;
	$unitId = shift;
	$name = shift;
	$tmpDevComp = "{\"ComponentTmpId\":$devCompId,\"UnitID\":$unitId,\"name\":\"$name\"}";
	$string .= ",\"TmpConnectors\":[],\"TmpDevices\":[],\"TmpDeviceComponents\":[$tmpDevComp]";
}

sub addCreateRule {
	$classname = shift;
	$per = shift;
	$con = shift;
	$act = shift;
	$string .= ",\"Rules\":[{\"TempRuleId\":$tmpId,\"Active\":true,\"Permissions\":\"$per\",\"Conditions\":\"$con\",\"Actions\":\"$act\"}]";
}

sub addCreateZone {
	$classname = shift;
	$super = shift;
	$name = shift;
	$string .= ",\"Zones\":[{\"ZoneId\":-1,\"TempZoneId\":$tmpId,\"SuperZoneId\":$super,\"ZoneName\":\"$name\"}]";
}

sub addCreateUnit {
	$classname = shift;
	$name = shift;
	$symbol = shift;
	$string .= ",\"Units\":[{\"UnitId\":-1,\"TempUnitId\":$tmpId,\"UnitName\":\"$name\",\"UnitSymbol\":\"$symbol\"}]";
}

sub jsonToString {
	$string .= "}";
	return $string;
}

1;