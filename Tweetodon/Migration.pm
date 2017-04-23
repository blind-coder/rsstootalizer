# vim: set foldmarker={,}:
use strict;
use Tweetodon::Base;

package Tweetodon::Migration;
@Tweetodon::Migration::ISA = qw(Tweetodon::Base);
use JSON;
use Data::Dumper;

sub dbTable :lvalue { "tokens"; }
sub orderBy :lvalue { "username ASC"; }

# Class functions

# Object methods

1;
