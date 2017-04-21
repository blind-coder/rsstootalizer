#!/usr/bin/perl -w

use strict;
use HTML::Template;
use Tweetodon::Website;
use Tweetodon::App;
use Tweetodon::Token;
use Tweetodon::DB;

package Tweetodon::Website::Callback;
@Tweetodon::Website::Callback::ISA = qw(Tweetodon::Website);
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
	$self->{"template"} = "Callback";
	$self->{"content_type"} = "html";
	$self->{"params"}->{"currentmode"} = "Callback";

	my $instance = $main::FORM{instance};

	my $app = Tweetodon::App->get_or_create_by_instance($instance);

	open(DATA, "./process_code.bash '$app->{data}->{instance_client_id}' '$app->{data}->{instance_client_secret}' '$main::FORM{code}' '$main::config->{app}->{redirect_uris}' '$instance'|");
	my $reply;
	{
		$/ = undef;
		$reply = <DATA>;
	}
	close DATA;
	$reply = decode_json($reply);

	$self->{"set_cookie"} = ("token=".$reply->{access_token});
	# Tweetodon::DB->doINSERT("INSERT INTO tokens (access_token, token_type, scope, created_at, username) VALUES (?, ?, ?, ?, ?)", $reply->{access_token}, $reply->{token_type}, $reply->{scope}, $reply->{created_at}, $main::FORM{Username});
	#{"access_token":"9615e561d0cf3cb54799ecc381f10b059e781dac2b180e708dcd66683c1cdb81","token_type":"bearer","scope":"read write","created_at":1492718172}
}

1;
