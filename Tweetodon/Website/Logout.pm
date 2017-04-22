#!/usr/bin/perl -w

use strict;
use HTML::Template;
use Tweetodon::Website;

package Tweetodon::Website::Logout;
@Tweetodon::Website::Logout::ISA = qw(Tweetodon::Website);

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

	$self->{"set_cookie"} = ("session_id=");
}

1;
