# vim: set foldmarker={,}:
use strict;
use RSSTootalizer::Base;

package RSSTootalizer::App;
@RSSTootalizer::App::ISA = qw(RSSTootalizer::Base);
use JSON;
use Data::Dumper;

sub dbTable :lvalue { "apps"; }
sub orderBy :lvalue { "instance ASC"; }

# Class functions
sub get_or_create_by_instance {
	my $class = shift;
	my $instance = shift;

	my $app = RSSTootalizer::DB->doSELECT("SELECT * FROM apps WHERE instance = ?", $instance);
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
		RSSTootalizer::DB->doINSERT("INSERT INTO apps (instance, instance_id, instance_client_id, instance_client_secret) VALUES (?, ?, ?, ?)", $instance, $reply->{id}, $reply->{client_id}, $reply->{client_secret});

		$app = RSSTootalizer::DB->doSELECT("SELECT * FROM apps WHERE instance = ?", $instance);
		$app = $$app[0];
	}
	$class->new($app)
}

# Object methods

sub app {
	my $self = shift;
	my $retVal = RSSTootalizer::Application->get_by("id", $self->{"data"}->{"app_id"});
	return $retVal;
}

1;
