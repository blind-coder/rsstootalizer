#!/usr/bin/perl -w

use strict;
use HTML::Template;
use RSSTootalizer::Website;

package RSSTootalizer::Website::Logout;
@RSSTootalizer::Website::Logout::ISA = qw(RSSTootalizer::Website);

sub requires_authentication {
	return 0;
}

sub fill_content {
	return 1;
}

sub prerender {
	my $self = shift;
	$self->{"template"} = "Logout";
	$self->{"content_type"} = "html";
	$self->{"params"}->{"currentmode"} = "Logout";

	$self->{"set_cookie"} = ("session_id=");
	my $user = RSSTootalizer::User->authenticate();
	if ($user){
		# RSSTootalizer::DB->doUPDATE("UPDATE users SET session_id = 'invalid' WHERE ID = ?", $user->{data}->{ID});
		$user->{data}->{session_id} = "invalid";
		$user->save();
	}
}

1;
