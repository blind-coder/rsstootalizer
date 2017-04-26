#!/usr/bin/perl -w

use strict;
use HTML::Template;
use RSSTootalizer::Website;

package RSSTootalizer::Website::Login;
@RSSTootalizer::Website::Login::ISA = qw(RSSTootalizer::Website);

sub requires_authentication {
	return 0;
}

sub fill_content {
	return 1;
}

sub prerender {
	my $self = shift;
	$self->{"template"} = "Login";
	$self->{"content_type"} = "html";
	$self->{"params"}->{"currentmode"} = "Login";

	$self->{"params"}->{"instance"} = $main::FORM{"last_instance"};
}

1;
