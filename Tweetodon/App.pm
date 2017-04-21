# vim: set foldmarker={,}:
use strict;
use Tweetodon::Base;

package Tweetodon::App;
@Tweetodon::App::ISA = qw(Tweetodon::Base);
use JSON;
use Data::Dumper;

sub dbTable :lvalue { "apps"; }
sub orderBy :lvalue { "instance ASC"; }

# Class functions
sub get_or_create_by_instance {
	my $class = shift;
	my $instance = shift;

	my $app = Tweetodon::DB->doSELECT("SELECT * FROM apps WHERE instance = ?", $instance);
	$app = $$app[0];
	unless (defined($app)){
		open(DATA, "./register_app.bash '$main::config->{app}->{client_name}' '$main::config->{app}->{redirect_uris}' '$main::config->{app}->{website}' '$instance'|");
		my $reply = "";
		{
			$/ = undef;
			$reply = <DATA>;
		}
		close DATA;

		$reply = decode_json($reply);
		Tweetodon::DB->doINSERT("INSERT INTO apps (instance, instance_id, instance_client_id, instance_client_secret) VALUES (?, ?, ?, ?)", $instance, $reply->{id}, $reply->{client_id}, $reply->{client_secret});

		$app = Tweetodon::DB->doSELECT("SELECT * FROM apps WHERE instance = ?", $instance);
		$app = $$app[0];
	}
	$class->new($app)
}

# Object methods

sub app {
	my $self = shift;
	my $retVal = Tweetodon::Application->get_by("id", $self->{"data"}->{"app_id"});
	return $retVal;
}

1;
