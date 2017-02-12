#!/usr/bin/perl -w

package websocket;

use strict;
use warnings;
use AnyEvent::WebSocket::Client 0.12;

our $connection;
my $client = AnyEvent::WebSocket::Client->new;

sub new {
   my $klassenname = shift;
   my $self = {};
   return bless $self, $klassenname;
}

sub connect{
  my $classname = shift;
  my $url = shift // "";
  if($url =~ /(?:(?:url=)|(?:\-U ))"([^"]*)"/){
    $connection = $client->connect($1)->recv; #ws://localhost:8080/CLITest
    return 1;
  }
  else {
    print 'connect (-U |url=)"<URL of BOese>"\n';
    return 0;
  }
}

sub send{
  my $classname = shift;
  my $msg = shift;
  $connection->send($msg);
  #print "\nWS Message: $msg\n\n";
}

sub disconnect{
  $connection->close;
}

sub loadAnswer{
  my $classname = shift;
  my $msgType = shift;
  my $dev = (shift) // "";
  if ($dev ne "") {$dev = "_".$dev;}
  $msgType++;
  my $s;
  open (DATEI, "./JSONAntworten/$msgType$dev.txt") or die $!;
  while(<DATEI>){
    $s .= $_;
  }
  #close (DATEI);
  return $s;
}