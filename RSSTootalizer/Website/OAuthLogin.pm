#!/usr/bin/perl -w

use strict;
use HTML::Template;
use RSSTootalizer::Website;
use RSSTootalizer::App;
use RSSTootalizer::Token;
use RSSTootalizer::User;

package RSSTootalizer::Website::OAuthLogin;
@RSSTootalizer::Website::OAuthLogin::ISA = qw(RSSTootalizer::Website);
use Data::Dumper;
use JSON;

sub requires_authentication {
	return 0;
}

sub fill_content {
	return 1;
}

sub prerender {
	my $self = shift;
	my $instance = $main::FORM{inputInstance};
	$instance = $main::FORM{instance} unless defined($instance);

	$self->{"template"} = "OAuthLogin";
	$self->{"content_type"} = "html";
	$self->{"set_cookie"} = ("instance=".$instance);
	$self->{"params"}->{"currentmode"} = "OAuthLogin";

	my $app = RSSTootalizer::App->get_or_create_by_instance($instance);
	$self->{params}->{instance_redirect_uri} = $main::config->{app}->{redirect_uris};
	$self->{params}->{instance_client_id} = $app->{data}->{instance_client_id};
	$self->{params}->{instance} = $instance;
	$self->{params}->{token_is_valid} = "false";

	if (defined($main::FORM{session_id})){
		my $user = RSSTootalizer::User->authenticate();
		if ($user){
			$self->{params}->{token_is_valid} = "true";
			$self->{set_cookie} = ("last_instance=$instance; Max-Age=1209600");
		}
		# {"error":"The access token is invalid"}
	}
}

1;
