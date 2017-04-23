# vim: set foldmarker={,}:
use strict;
use RSSTootalizer::Base;

package RSSTootalizer::Entry;
@RSSTootalizer::Entry::ISA = qw(RSSTootalizer::Base);
use JSON;
use Data::Dumper;

sub dbTable :lvalue { "entries"; }
sub orderBy :lvalue { "posted_at ASC"; }

# Class functions

# Object methods

1;
