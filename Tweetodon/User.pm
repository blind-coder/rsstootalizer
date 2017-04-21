# vim: set foldmarker={,}:
use strict;
use Tweetodon::Base;

package Tweetodon::User;
@Tweetodon::User::ISA = qw(Tweetodon::Base);
use JSON;
use Tweetodon::Token;
use Data::Dumper;

sub dbTable :lvalue { "invalid"; }
sub orderBy :lvalue { "invalid"; }

# Class functions
sub authenticate {
	my $class = shift;

	my $username = $main::FORM{Username};
	$username =~ /^(.*?)@(.*)$/;
	my $instance = $2;
	my $token = Tweetodon::Token->get_by("username", $main::FORM{Username});
	if ($token){
		open(DATA, "./verify_token.bash '$token->{data}->{access_token}' '$instance'|");
		my $reply;
		{
			$/ = undef;
			$reply = <DATA>
		}
		close DATA;
		print STDERR "$reply\n";
		$reply = decode_json($reply);
		#{"error":"The access token is invalid"}
		if (defined($$reply{error})){
			return 0;
		}
		return $class->new($reply);
		#{"id":8225,"username":"b_playsgames","acct":"b_playsgames","display_name":"Ben Plays Games","locked":false,"created_at":"2017-04-18T18:10:51.707Z","followers_count":8,"following_count":0,"statuses_count":13,"note":"Playing games for fun and reduced backlog! Join me at <a href=\\"https://yt.benplaysgames.com/\\" rel=\\"nofollow noopener\\" target=\\"_blank\\"><span class=\\"invisible\\">https://</span><span class=\\"\\">yt.benplaysgames.com/</span><span class=\\"invisible\\"></span></a>","url":"https://toot.berlin/@b_playsgames","avatar":"https://toot.berlin/system/accounts/avatars/000/008/225/original/12899445370222cb.jpg?1492540236","avatar_static":"https://toot.berlin/system/accounts/avatars/000/008/225/original/12899445370222cb.jpg?1492540236","header":"https://toot.berlin/system/accounts/headers/000/008/225/original/0e643b731c89e5a2.jpg?1492540236","header_static":"https://toot.berlin/system/accounts/headers/000/008/225/original/0e643b731c89e5a2.jpg?1492540236"}
	}
	return 0;
}

# Object methods

1;
