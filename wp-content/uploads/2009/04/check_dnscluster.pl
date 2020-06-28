#!/usr/bin/perl

######################
#
#  Simple DNS resolver
#  
#  Lars Eik, Tønsberg Kommune
# 2006-09-12
# 
# Converted to nagios-check
# Lars Age Kamfjord, Tønsberg Kommune
# 2009-04-24
#
# Of course license is GNU GPL, v3 (or later if you wish it)
######################

use warnings;
use strict;
use Net::DNS;
use Getopt::Long;

my $i=0;
my @list;
#my $host = shift or die "No argument given to resolve\n";
#my $host = shift;
my ($host, @server, $address, $help);
GetOptions(
  "H|host=s"    => \$host,
  "s|server=s"  => \@server,
  "A|address=s"   => \$address,
);

#print $address;
#print $server;

#unless ( defined $host ) { 
#	$host = 'tscluster.ped.local'; 
#}
my $retstatus = "NOT IN CLUSTER";
my $returnvalue = "1";
#print "Looking for $host:\n";
#my $res = Net::DNS::Resolver->new;
my $res = Net::DNS::Resolver->new(
  nameservers => \@server,
  recurse     => 0,
  debug       => 0,
);

my $query = $res->search($address);

if ($query) {
  foreach my $rr ($query->answer) {
  next unless $rr->type eq "A";  
#  print $rr->address . "\n";
#  print $rr->address." ($address)\n";
  if($rr->address eq $host) {
     $retstatus = "OK: $host";
     $returnvalue = "0";
  } ## End if (rr-address eq address)     
    } ## End foreach
} ## End if query

print $retstatus."\n";
exit $returnvalue;
#return $returnvalue;

#print "Found: " . @list . "\n";

