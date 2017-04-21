#!/usr/bin/perl -w

use strict;
use HTML::Template;
use Tweetodon::Website;
use Tweetodon::App;
use Tweetodon::Token;

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
	$self->{"template"} = "OAuthLogin";
	$self->{"content_type"} = "html";
	$self->{"set_cookie"} = ("Username=".$main::FORM{inputUsername});
	$self->{"params"}->{"currentmode"} = "OAuthLogin";

	my ($username, $instance);
	$main::FORM{inputUsername} =~ /^(.*?)@(.*)$/;
	$username = $1;
	$instance = $2;

	my $app = Tweetodon::App->get_or_create_by_instance($instance);
	my $token = Tweetodon::Token->get_by("username", $main::FORM{inputUsername});
	print STDERR Dumper($token);

	unless ($token){
		$self->{params}->{instance_redirect_uri} = $main::config->{app}->{redirect_uris};
		$self->{params}->{instance_client_id} = $app->{data}->{instance_client_id};
		$self->{params}->{instance} = $instance;
	}
}

1;
