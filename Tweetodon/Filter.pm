# vim: set foldmarker={,}:
use strict;
use Tweetodon::Base;

package Tweetodon::Filter;
@Tweetodon::Filter::ISA = qw(Tweetodon::Base);
use JSON;
use Data::Dumper;
use URI::Escape;

sub dbTable :lvalue { "filters"; }
sub orderBy :lvalue { "ID ASC"; }

# Class functions

# Object methods
sub apply {
	my $self = shift;
	my $entry = shift;

	my $match = 1;
	my $arg = $self->{data}->{field};
	if ($arg eq "content"){
		$arg = $entry->content()->body;
	} else {
		$arg = $entry->$arg();
	}
	my $regex = uri_unescape($self->{data}->{regex});
	$regex =~ s,\\\\,\\,g;

	if ($self->{data}->{match} eq "positive"){
		if ($arg =~ /$regex/i){
			return 1;
		}
		return 0;
	} else {
		if ($arg !~ /$regex/i){
			return 1;
		}
		return 0;
	}
	return 0;
}

1;
