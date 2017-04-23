#!/usr/bin/perl -w
# vim: set foldmarker={,}:

use strict;
use HTML::Template;
use RSSTootalizer::DB;
use RSSTootalizer::Feed;
use RSSTootalizer::Website;

package RSSTootalizer::Website::Dashboard;
use Data::Dumper;
@RSSTootalizer::Website::Dashboard::ISA = qw(RSSTootalizer::Website);

sub requires_authentication {
	return 1;
}

sub fill_content {
	my $class = shift;
	my $output = shift;

	if ($main::FORM{inputURL}){
		my %nf;
		$nf{url} = $main::FORM{inputURL};
		$nf{username} = $main::CURRENTUSER->{data}->{acct};
		$nf{instance} = $main::FORM{instance};
		$nf{enabled} = "n";
		my $feed = RSSTootalizer::Feed->create_and_fetch(%nf);
	}

	my @feeds = RSSTootalizer::Feed->get_by_user_instance($main::CURRENTUSER->{data}->{acct}, $main::FORM{instance});
	my @param_feeds;
	my $count = 0;
	FEED: foreach my $feed (@feeds){
		if ($main::FORM{delete} and "x".$main::FORM{delete} eq "x".$feed->{data}->{ID}){
			$feed->delete();
			next FEED;
		}
		my %r;
		$count++;
		$r{"count"} = $count;
		if ($main::FORM{enable} and "x".$main::FORM{enable} eq "x".$feed->{data}->{ID}){
			$feed->{data}->{enabled} = "1";
			$feed->save();
		}
		if ($main::FORM{disable} and "x".$main::FORM{disable} eq "x".$feed->{data}->{ID}){
			$feed->{data}->{enabled} = "0";
			$feed->save();
		}
		foreach my $key (keys %{$feed->{data}}){
			$r{$key} = $feed->{data}->{$key};
		}
		push @param_feeds, \%r;
	}
	$output->param("FEEDS", \@param_feeds);
	return 1;
}
sub prerender {
	my $self = shift;
	$self->{"template"} = "Dashboard";
	$self->{"content_type"} = "html";
	$self->{"params"}->{"currentmode"} = "Dashboard";

	foreach my $key (keys %{$main::CURRENTUSER->{data}}){
		$self->{"params"}->{"acct_$key"} = $main::CURRENTUSER->{data}->{$key};
	}
}

1;
