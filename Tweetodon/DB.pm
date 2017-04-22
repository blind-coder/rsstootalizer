# vim: set foldmarker={,}:
use strict;

package Tweetodon::DB;
use DBI;
use Data::Dumper;
use JSON;
our $DBH;

sub doINSERT {
	shift;
	DBInit();
	my ($SQL, @RESTARGS) = @_;
	my $ret2DhashRef = undef;

	my $sth = $DBH->prepare($SQL);
	if ($DBI::err) {
		&main::Error("SQL Error", "doINSERT prepare failed:\n'".$DBI::errstr."'\nSQL was: $SQL");
		return 0;
	}
	$sth->execute(@RESTARGS);
	if ($DBI::err) {
		&main::Error("SQL Error", "doINSERT execute failed:'".$DBI::errstr."'\nSQL was: $SQL\nRestargs:".Dumper(@RESTARGS));
		return 0;
	}
	$sth->finish();
	return 1;
}
sub doINSERThash {
	shift;
	DBInit();
	my $DB = shift;
	my %u = @_;
	my @RESTARGS;

	my $SQL = "INSERT INTO $DB (";
	my $VALUES = "";
	foreach (keys(%u)){
		$SQL .= "\`$_\`,";
		$VALUES .= "?,";
		push @RESTARGS, $u{$_};
	}
	$SQL =~ s/,$//;
	$VALUES =~ s/,$//;
	$SQL .= ") VALUES ($VALUES)";

	my $sth = $DBH->prepare($SQL);
	if ($DBI::err) {
		&main::Error("SQL Error", "doINSERThash prepare failed:\n'".$DBI::errstr."'\nSQL was: $SQL");
		return 0;
	}
	$sth->execute(@RESTARGS);
	if ($DBI::err) {
		&main::Error("SQL Error", "doINSERThash execute failed:'".$DBI::errstr."'\nSQL was: $SQL\nRestargs:".Dumper(@RESTARGS));
		return 0;
	}
	$sth->finish();
	return 1;
}
sub doSELECT {
	shift;
	DBInit();
	my ($SQL, @RESTARGS) = @_;
	my $ret2DhashRef = undef;

	my $sth = $DBH->prepare($SQL);
	if ($DBI::err) {
		&main::Error("doSELECT prepare failed", $DBI::errstr."\nSQL was: $SQL");
		return 0;
	}
	$sth->execute(@RESTARGS);
	if ($DBI::err) {  # abnormal execution / abnormal end of fetch?
		&main::Error("doSELECT prepare failed", $DBI::errstr."\nSQL was: $SQL\nRestargs:\n".Dumper(@RESTARGS));
		return 0;
	}
	$ret2DhashRef = $sth->fetchall_arrayref({});

	if ($DBI::err) {  # abnormal execution / abnormal end of fetch?
		&main::Error("doSELECT prepare failed", $DBI::errstr."\nSQL was: $SQL\nRestargs:\n".Dumper(@RESTARGS));
		return 0;
	}

	$sth->finish();
	return $ret2DhashRef;
}
sub doDELETE {
	my $this = shift;
	my ($SQL, @RESTARGS) = @_;
	my $ret2DhashRef = undef;

	my $sth = $DBH->prepare($SQL);
	if ($DBI::err) {
		&main::Error("SQL Error", "doDELETE prepare failed:\n'".$DBI::errstr."'\nSQL was: $SQL");
		return 0;
	}
	$sth->execute(@RESTARGS);
	if ($DBI::err) {
		&main::Error("SQL Error", "doDELETE execute failed:'".$DBI::errstr."'\nSQL was: $SQL\nRestargs:".Dumper(@RESTARGS));
		return 0;
	}
	$sth->finish();
	return 1;
}
sub doUPDATE {
	my $this = shift;
	my ($SQL, @RESTARGS) = @_;
	my $ret2DhashRef = undef;

	my $sth = $DBH->prepare($SQL);
	if ($DBI::err) {
		&main::Error("SQL Error", "doUPDATE prepare failed:\n'".$DBI::errstr."'\nSQL was: $SQL");
		return 0;
	}
	$sth->execute(@RESTARGS);
	if ($DBI::err) {
		&main::Error("SQL Error", "doUPDATE execute failed:'".$DBI::errstr."'\nSQL was: $SQL\nRestargs:".Dumper(@RESTARGS));
		return 0;
	}
	$sth->finish();
	return 1;
}
sub doUPDATEhash {
	my $this = shift;
	my $DB = shift;
	my $WHERE = shift;
	my %u = @_;
	my @RESTARGS;

	my $SQL = "UPDATE $DB SET ";
	foreach (keys(%u)){
		$SQL .= "`$_` = ?,";
		push @RESTARGS, $u{$_};
	}
	$SQL =~ s/,$//;
	$SQL .= " WHERE $WHERE";

	my $sth = $DBH->prepare($SQL);
	if ($DBI::err) {
		&main::Error("SQL Error", "doUPDATEhash prepare failed:\n'".$DBI::errstr."'\nSQL was: $SQL");
		return 0;
	}
	$sth->execute(@RESTARGS);
	if ($DBI::err) {
		&main::Error("SQL Error", "doUPDATEhash execute failed:'".$DBI::errstr."'\nSQL was: $SQL\nRestargs:".Dumper(@RESTARGS));
		return 0;
	}
	$sth->finish();
	return 1;
}

sub DBInit {
	unless (defined($DBH)){
		my $config = "";
		open CONFIG, "tweetodon.conf.json" or die "Cannot open ttiam.conf.json";
		{
			$/ = undef;
			$config = <CONFIG>;
		}
		close CONFIG;
		$config = decode_json($config);
		my $DSN = "DBI:mysql:database=".$config->{"mysql"}->{"database"}.
			":host=".$config->{"mysql"}->{"host"}.
			";mysql_emulated_prepare=1";
		$DBH = DBI->connect($DSN, $config->{"mysql"}->{"user"}, $config->{"mysql"}->{"pass"});
		unless ($DBH){
			main::Error("SQL Error", "Database Error", "Unable to connect to database '$DSN'!\nError: $DBI::errstr\n");
		}
	}
}

1;
