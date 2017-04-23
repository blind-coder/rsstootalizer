# vim: set foldmarker={,}:
use strict;
use RSSTootalizer::Base;

package RSSTootalizer::Migration;
@RSSTootalizer::Migration::ISA = qw(RSSTootalizer::Base);
use JSON;
use Data::Dumper;

sub dbTable :lvalue { "migrations"; }
sub orderBy :lvalue { "created_at ASC"; }

# Class functions

# Object methods

1;
