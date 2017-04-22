# vim: set foldmarker={,}:
use strict;
use Tweetodon::Base;

package Tweetodon::Entry;
@Tweetodon::Entry::ISA = qw(Tweetodon::Base);
use JSON;
use Data::Dumper;

sub dbTable :lvalue { "entries"; }
sub orderBy :lvalue { "posted_at ASC"; }

# Class functions

# Object methods

1;
