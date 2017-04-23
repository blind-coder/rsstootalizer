#!/usr/bin/perl -w -I.

use strict;
use Data::Dumper;
use URI::Escape;
use JSON;
use Tweetodon::Feed;
use Tweetodon::User;
use Tweetodon::Entry;

our $config = "";
open CONFIG, "tweetodon.conf.json" or die "Cannot open tweetodon.conf.json";
{
	$/ = undef;
	$config = <CONFIG>;
}
close CONFIG;
$config = decode_json($config);

sub Error {{{
	my $errormessage = "\nStack Trace:\n";

	my $i=0;
	while ((my @call_details = (caller($i++))) ){
		$errormessage .= $call_details[1].":".$call_details[2]." in function ".$call_details[3]."\n";
	}

	print STDERR $errormessage;
	exit(1);
}}}

# Force Unicode output
binmode STDERR, ":utf8";
binmode STDOUT, ":utf8";

my @feeds = Tweetodon::Feed->all();
FEED: foreach my $feed (@feeds){
	next FEED unless $feed->{data}->{enabled};
	my $entries = $feed->fetch_entries();
	ENTRY: foreach my $entry ($entries->items){
		my @seen_entries = $feed->entry_by("entry_link", $entry->link());
		next ENTRY if ((scalar @seen_entries) > 0);

		my %entry;
		$entry{title} = $entry->title();
		$entry{link} = $entry->link();
		$entry{content} = $entry->content()->body;
		$entry{author} = $entry->author();
		$entry{issued} = $entry->issued();
		$entry{modified} = $entry->modified();
		$entry{id} = $entry->id();
		$entry{tags} = join(", ", $entry->tags());

		my $user = $feed->user();
		my $status = $feed->{data}->{format};
		$status =~ s/{ID}/$entry{id}/g;
		$status =~ s/{Title}/$entry{title}/g;
		$status =~ s/{Link}/$entry{link}/g;
		$status =~ s/{Content}/$entry{content}/g;
		$status =~ s/{Author}/$entry{author}/g;
		$status =~ s/{Issued}/$entry{issued}/g;
		$status =~ s/{Modified}/$entry{modified}/g;
		$status =~ s/{Tags}/$entry{tags}/g;

		$status =~ s/'/"/g; # TODO

		open(DATA, "./post_status.bash '$user->{data}->{access_token}' '$user->{data}->{instance}' '$status'|");
		my $reply = "";
		{
			$/ = undef;
			$reply = <DATA>;
		}

		my %ne;
		$ne{feed_id} = $feed->{data}->{ID};
		$ne{entry_link} = $entry{link};
		Tweetodon::Entry->create(%ne);
	}
}
