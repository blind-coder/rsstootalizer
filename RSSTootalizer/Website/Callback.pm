#!/usr/bin/perl -w

use strict;
use HTML::Template;
use RSSTootalizer::Website;
use RSSTootalizer::App;
use RSSTootalizer::Token;

package RSSTootalizer::Website::Callback;
@RSSTootalizer::Website::Callback::ISA = qw(RSSTootalizer::Website);
use Data::Dumper;
use UUID::Tiny;
use Digest::SHA qw(sha256_base64);
use JSON;
use RSSTootalizer::DB;

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
	my $app = RSSTootalizer::App->get_or_create_by_instance($instance);

	open(DATA, "./process_code.bash '$app->{data}->{instance_client_id}' '$app->{data}->{instance_client_secret}' '$main::FORM{code}' '$main::config->{app}->{redirect_uris}' '$instance'|");
	my $reply;
	{
		$/ = undef;
		$reply = <DATA>;
	}
	close DATA;
	$reply = decode_json($reply);
	if (!defined($$reply{access_token})){
		main::Error("Login error", "There was an error logging you in!");
		return 0;
	}

	my $token = $$reply{access_token};
	open(DATA, "./verify_credentials.bash '$token' '$instance'|");
	{
		$/ = undef;
		$reply = <DATA>
	}
	close DATA;
	$reply = decode_json($reply);
	if (!defined($$reply{acct})){
		main::Error("Login error", "There was an error logging you in!");
		return 0;
	}

	my $session_id = UUID::Tiny::create_UUID_as_string(UUID_V5, time().$$reply{acct});

	RSSTootalizer::DB->doINSERT("INSERT INTO users (username, username_sha256, instance, instance_sha256, access_token, session_id) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE access_token=?, session_id=?", $$reply{acct}, sha256_base64($$reply{acct}), $instance, sha256_base64($instance), $token, $session_id, $token, $session_id);

	$self->{"set_cookie"} = ("session_id=".$session_id);
}

1;
