#!/usr/bin/perl -w

use strict;
use HTML::Template;
use Tweetodon::Website;
use Tweetodon::App;
use Tweetodon::Token;
use Tweetodon::User;

package Tweetodon::Website::OAuthLogin;
@Tweetodon::Website::OAuthLogin::ISA = qw(Tweetodon::Website);
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

	my $app = Tweetodon::App->get_or_create_by_instance($instance);
	$self->{params}->{instance_redirect_uri} = $main::config->{app}->{redirect_uris};
	$self->{params}->{instance_client_id} = $app->{data}->{instance_client_id};
	$self->{params}->{instance} = $instance;
	$self->{params}->{token_is_valid} = "false";

	my $token = $main::FORM{token};

	if (defined($token)){
		#open(DATA, "./verify_credentials.bash '$token' '$instance'|");
		#my $reply;
		#{
		#$/ = undef;
		#$reply = <DATA>;
		#}
		#close DATA;
		#$reply = decode_json($reply);
		if (Tweetodon::User->authenticate()){
			$self->{params}->{token_is_valid} = "true";
		}
		# {"error":"The access token is invalid"}
	}
}

1;
