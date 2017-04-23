# vim: set foldmarker={,}:
use strict;

package RSSTootalizer::Base;
use JSON;
use Data::Dumper;
use RSSTootalizer::DB;
use Digest::MD5 qw(md5_hex);

# Class functions
sub all {
	my $class = shift;

	my $all = RSSTootalizer::DB->doSELECT("SELECT * FROM ".$class->dbTable." ORDER BY ".$class->orderBy);
	my @retVal;
	foreach my $object (@$all){
		$object = $class->new($object);
		push @retVal, $object;
	}
	return @retVal;
}
sub get_by {
	my $class = shift;

	my $key = shift;
	my $value = shift;
	my $retVal = RSSTootalizer::DB->doSELECT("SELECT * FROM ".$class->dbTable." WHERE ".$key." ".($value =~ /%/ ? "LIKE" : "=")." ?", $value);
	$retVal = $$retVal[0];

	return 0 unless defined($retVal);
	return $class->new($retVal);
}
sub create {
	my $class = shift;
	my %data = @_;

	RSSTootalizer::DB->doINSERThash($class->dbTable, %data);
	my $data = RSSTootalizer::DB->doSELECT("SELECT * FROM ".$class->dbTable." WHERE ID = LAST_INSERT_ID()");
	$data = $$data[0];
	return $class->get_by("ID", $$data{ID});
}
sub new {
	my $this = shift;
	my $data = shift;
	unless ($data){
		&main::Error("Invalid data call", "new() called without data!");
	}

	my $self = { "data" => $data };
	bless ($self, $this);
}

# Object methods
sub save {
	my $self = shift;

	if (exists($self->{"data"}->{"password"}) && "x".$self->{"data"}->{"password"} ne "x"){
		$self->{"data"}->{"password"} = md5_hex($self->{"data"}->{"ID"}.$self->{"data"}->{"password"});
	} else {
		delete $self->{"data"}->{"password"};
	}
	return RSSTootalizer::DB->doUPDATEhash($self->dbTable, "ID = ".$self->{"data"}->{"ID"}, %{$self->{"data"}});
}
sub delete {
	my $self = shift;

	return RSSTootalizer::DB->doDELETE("DELETE FROM ".$self->dbTable." WHERE ID = ?", $self->{data}->{ID});
}
1;
