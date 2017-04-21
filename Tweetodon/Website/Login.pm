#!/usr/bin/perl -w

use strict;
use HTML::Template;
use Tweetodon::Website;

package Tweetodon::Website::Login;
@Tweetodon::Website::Login::ISA = qw(Tweetodon::Website);

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
}

1;
