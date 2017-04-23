# vim: set foldmarker={,}:
use strict;
use RSSTootalizer::Base;

package RSSTootalizer::User;
@RSSTootalizer::User::ISA = qw(RSSTootalizer::Base);
use JSON;
use RSSTootalizer::Token;
use Data::Dumper;

sub dbTable :lvalue { "users"; }
sub orderBy :lvalue { "username"; }

# Class functions
sub authenticate {
	my $class = shift;

	my $session_id = $main::FORM{session_id};
	return 0 unless defined($session_id);
	my $user = $class->get_by("session_id", $session_id);
	return 0 unless $user;

	my $instance = $user->{data}->{instance};
	my $token = $user->{data}->{access_token};
	if ($token){
		open(DATA, "./verify_credentials.bash '$token' '$instance'|");
		my $reply;
		{
			local $/ = undef;
			$reply = <DATA>
		}
		close DATA;
		$reply = decode_json($reply);
		#{"error":"The access token is invalid"}
		if (!defined($$reply{username})){
			return 0;
		}
		$reply->{token} = $token;
		$reply->{instance} = $instance;
		return $class->new($reply);
	}
	return 0;
}

# Object methods

1;
