# vim: set foldmarker={,}:
use strict;
use RSSTootalizer::Base;

package RSSTootalizer::Feed;
@RSSTootalizer::Feed::ISA = qw(RSSTootalizer::Base);
use JSON;
use Data::Dumper;
use RSSTootalizer::Filter;
use RSSTootalizer::Entry;
use XML::Feed;
use URI;

sub dbTable :lvalue { "feeds"; }
sub orderBy :lvalue { "url ASC"; }

# Class functions
sub get_by_user_instance {
	my $class = shift;

	my $user = shift;
	my $instance = shift;
	my $retVal = RSSTootalizer::DB->doSELECT("SELECT * FROM ".$class->dbTable." WHERE username = ? AND instance = ? ORDER BY ".$class->orderBy, $user, $instance);

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
		RSSTootalizer::Entry->create(%ne);
	}
}

# Object methods
sub filters {
	my $self = shift;
	my $filters = RSSTootalizer::DB->doSELECT("SELECT * FROM filters WHERE feed_id = ? ORDER BY ID ASC", $self->{data}->{ID});

	my @retVal;
	foreach my $r (@$filters){
		push @retVal, RSSTootalizer::Filter->new($r);
	}
	return @retVal;
}
sub fetch_entries {
	my $self = shift;

	$XML::Feed::MULTIPLE_ENCLOSURES = 1;
	return XML::Feed->parse(URI->new($self->{data}->{url}));
}
sub entry_by {
	my $self = shift;
	my $key = shift;
	my $value = shift;

	my $sth = RSSTootalizer::DB->doSELECT("SELECT * FROM entries WHERE feed_id = ? AND $key = ?", $self->{data}->{ID}, $value);
	my @retVal;
	foreach my $r (@$sth){
		push @retVal, RSSTootalizer::Entry->new($r);
	}
	return @retVal;
}
sub user {
	my $self = shift;
	my $sth = RSSTootalizer::DB->doSELECT("SELECT * FROM users WHERE username = ? and instance = ?", $self->{data}->{username}, $self->{data}->{instance});
	$sth = $$sth[0];
	return RSSTootalizer::User->new($sth);
}

1;
