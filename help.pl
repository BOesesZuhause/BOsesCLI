#!/usr/bin/perl -w

package help;

sub new {
   my $klassenname = shift;
   my $selbst = {};
   return bless $selbst, $klassenname;
}

sub ausgabe{
	print "Hier sollen alle Befehle ausgegeben werden!!! \n"
}