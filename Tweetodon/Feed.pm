# vim: set foldmarker={,}:
use strict;
use Tweetodon::Base;

package Tweetodon::Feed;
@Tweetodon::Feed::ISA = qw(Tweetodon::Base);
use JSON;
use Data::Dumper;
use Tweetodon::Filter;
use Tweetodon::Entry;
use XML::Feed;
use URI;

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
sub create_and_fetch {
	my $class = shift;
	my %data = @_;

	my $self = $class->create(%data);
	my $feeddata = $self->fetch_entries();
	foreach my $entry ($feeddata->items){
		my %ne;
		$ne{feed_id} = $self->{data}->{ID};
		$ne{entry_link} = $entry->link();
		Tweetodon::Entry->create(%ne);
	}
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

sub fetch_entries {
	my $self = shift;

	$XML::Feed::MULTIPLE_ENCLOSURES = 1;
	return XML::Feed->parse(URI->new($self->{data}->{url}));
}

1;
