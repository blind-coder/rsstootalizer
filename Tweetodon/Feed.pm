# vim: set foldmarker={,}:
use strict;
use Tweetodon::Base;

package Tweetodon::Feed;
@Tweetodon::Feed::ISA = qw(Tweetodon::Base);
use JSON;
use Data::Dumper;
use Tweetodon::Filter;

sub dbTable :lvalue { "feeds"; }
sub orderBy :lvalue { "url ASC"; }

# Class functions
sub get_by_user_instance {
	my $class = shift;

	my $user = shift;
	my $instance = shift;
	my $retVal = Tweetodon::DB->doSELECT("SELECT * FROM ".$class->dbTable." WHERE username = ? AND instance = ? ORDER BY ".$class->orderBy, $user, $instance);

	my @retVal;
	foreach my $r (@$retVal){
		push @retVal, $class->new($r);
	}

	return @retVal;
}

# Object methods
sub filters {
	my $self = shift;
	my $filters = Tweetodon::DB->doSELECT("SELECT * FROM filters WHERE feed_id = ? ORDER BY ID ASC", $self->{data}->{ID});

	my @retVal;
	foreach my $r (@$filters){
		push @retVal, Tweetodon::Filter->new($r);
	}
	return @retVal;
}

1;
