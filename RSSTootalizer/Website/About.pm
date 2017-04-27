#!/usr/bin/perl -w

use strict;
use HTML::Template;
use RSSTootalizer::Website;

package RSSTootalizer::Website::About;
@RSSTootalizer::Website::About::ISA = qw(RSSTootalizer::Website);
use Data::Dumper;

sub requires_authentication {
	return 0;
}

sub fill_content {
	return 1;
}

sub prerender {
	my $self = shift;
	$self->{"template"} = "About";
	$self->{"content_type"} = "html";
	$self->{"params"}->{"currentmode"} = "About";
}

1;
