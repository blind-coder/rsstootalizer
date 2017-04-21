#!/usr/bin/perl -w
# vim: set foldmarker={,}:

use strict;
use HTML::Template;
use Tweetodon::DB;
use Tweetodon::Feed;
use Tweetodon::Website;

package Tweetodon::Website::Dashboard;
use Data::Dumper;
@Tweetodon::Website::Dashboard::ISA = qw(Tweetodon::Website);

sub requires_authentication {
	return 1;
}

sub fill_content {
	my $class = shift;
	my $output = shift;
	my @feeds = Tweetodon::Feed->get_by_user_instance($main::CURRENTUSER->{data}->{acct}, $main::FORM{instance});

	my @param_feeds;
	my $count = 0;
	foreach my $feed (@feeds){
		my %r;
		$count++;
		$r{"count"} = $count;
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
