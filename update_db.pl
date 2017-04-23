#!/usr/bin/perl -w -I.

use strict;
use Data::Dumper;
use Tweetodon::Migration;

our $config = "";
open CONFIG, "tweetodon.conf.json" or die "Cannot open tweetodon.conf.json";
{
	$/ = undef;
	$config = <CONFIG>;
}
close CONFIG;
$config = decode_json($config);

# Force Unicode output
binmode STDERR, ":utf8";
binmode STDOUT, ":utf8";

my @migrations = glob ("migrations/*sql");
foreach my $migration (@migrations){
	print "Running migration $migration\n";
	if (!Tweetodon::Migration->get_by("name", $migration)){
		open (M, $migration);
		my $sql;
		{
			$/ = undef;
			$sql = <M>;
		}
		close M;
		Tweetodon::DB->doINSERT($sql);
		my %migdata;
		$migdata{name} = $migration;
		Tweetodon::Migration->create(%migdata);
	}
}
