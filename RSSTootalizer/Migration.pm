# vim: set foldmarker={,}:
use strict;
use RSSTootalizer::Base;

package RSSTootalizer::Migration;
@RSSTootalizer::Migration::ISA = qw(RSSTootalizer::Base);
use JSON;
use Data::Dumper;

sub dbTable :lvalue { "tokens"; }
sub orderBy :lvalue { "username ASC"; }

# Class functions

# Object methods

1;
