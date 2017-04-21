# vim: set foldmarker={,}:
use strict;
use Tweetodon::Base;

package Tweetodon::Account;
@Tweetodon::Account::ISA = qw(Tweetodon::Base);
use JSON;
use Tweetodon::Application;
use Data::Dumper;

sub dbTable :lvalue { "accounts"; }
sub orderBy :lvalue { "username ASC"; }

# Class functions
# Object methods
sub application {
	my $self = shift;
	my $retVal = Tweetodon::Application->get_by("id", $self->{"data"}->{"application_id"});
	return $retVal;
}

1;
