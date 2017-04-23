# vim: set foldmarker={,}:
use strict;
use RSSTootalizer::Base;

package RSSTootalizer::Account;
@RSSTootalizer::Account::ISA = qw(RSSTootalizer::Base);
use JSON;
use RSSTootalizer::Application;
use Data::Dumper;

sub dbTable :lvalue { "accounts"; }
sub orderBy :lvalue { "username ASC"; }

# Class functions
# Object methods
sub application {
	my $self = shift;
	my $retVal = RSSTootalizer::Application->get_by("id", $self->{"data"}->{"application_id"});
	return $retVal;
}

1;
