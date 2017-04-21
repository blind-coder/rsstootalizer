#!/usr/bin/perl -w
# vim: set foldmarker={,}:

use strict;
use HTML::Template;
use Tweetodon::DB;
use Tweetodon::Website;

package Tweetodon::Website::Dashboard;
use Data::Dumper;
@Tweetodon::Website::Dashboard::ISA = qw(Tweetodon::Website);

sub requires_authentication {
	return 1;
}
sub prerender {
	my $self = shift;
	$self->{"template"} = "Dashboard";
	$self->{"content_type"} = "html";
	$self->{"params"}->{"currentmode"} = "Dashboard";
}

1;
