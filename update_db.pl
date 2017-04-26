#!/usr/bin/perl -w -I.

use strict;
use Data::Dumper;
use RSSTootalizer::Migration;
use JSON;

sub Error {
	my $headline = shift;
	my $msg = shift;
	print "$headline: $msg\n";
}

our $config = "";
open CONFIG, "rsstootalizer.conf.json" or die "Cannot open rsstootalizer.conf.json";
{
	local $/ = undef;
	$config = <CONFIG>;
}
close CONFIG;
$config = decode_json($config);

# Force Unicode output
binmode STDERR, ":utf8";
binmode STDOUT, ":utf8";

my @migrations = glob ("migrations/*sql");
foreach my $migration (@migrations){
	my $sth = RSSTootalizer::DB->doSELECT("SELECT * FROM migrations WHERE name = ?", $migration);
	if (scalar(@$sth) == 0){
		print "Running migration $migration\n";
		open (M, "<", $migration);
		my $sql = "";
		while (<M>){
			chomp;
			$sql .= $_;
			if ($sql =~ /;/){
				RSSTootalizer::DB->doDELETE($sql); # Using doDELETE for lack of error handling...
				$sql = "";
			}
		}
		close M;
		my %migdata;
		$migdata{name} = $migration;
		RSSTootalizer::Migration->create(%migdata);
	} else {
		print "Migration $migration already done\n";
	}
}
