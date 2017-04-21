#!/usr/bin/perl -w -I.

use strict;
use Data::Dumper;
use HTML::Template;
use URI::Escape;
use JSON;
use Tweetodon::User;

our %FORM;
our $CURRENTUSER;

our $config = "";
open CONFIG, "tweetodon.conf.json" or die "Cannot open tweetodon.conf.json";
{
	$/ = undef;
	$config = <CONFIG>;
}
close CONFIG;
$config = decode_json($config);

sub Error {{{
	my $errorheadline = shift;
	my $errormessage = shift;
	$errormessage .= "\nStack Trace:\n";

	my $i=0;
	while ((my @call_details = (caller($i++))) ){
		$errormessage .= $call_details[1].":".$call_details[2]." in function ".$call_details[3]."\n";
	}

	my $output;
	if ($FORM{"mode"} eq "JSON"){
		$output = HTML::Template->new(filename => "error.json", path => "static/templates", die_on_bad_params=>0);
		print "Content-Type: text/plain;charset=utf8\n\n";
		$errormessage =~ s/\n/\\n/g;
	} else {
		$output = HTML::Template->new(filename => "Error.html", path => "static/templates", die_on_bad_params=>0);
		print "Content-Type: text/html;charset=utf8\n\n";
	}
	$output->param(status => $errorheadline, msg => $errormessage);

	print $output->output();

	exit(1);
}}}
sub populateAddToFORM {{{
	my $key = shift;
	my $value = shift;
	$key =~ s/\+/ /g;
	$key = uri_unescape($key);
	$key =~ s/\[\]$//;
	$value =~ s/\+/ /g;
	$value = uri_unescape($value);
	if (exists($FORM{$key}) && $key ne "mode"){
		if (ref($FORM{$key}) ne 'ARRAY'){
			my $x = $FORM{$key};
			delete $FORM{$key};
			@{$FORM{$key}} = ($x);
		}
		push @{$FORM{$key}}, $value;
	} else {
		$FORM{$key} = $value;
	}
}}}
sub populateGetFields {{{
	my $tmpStr = "";
	if (defined($ENV{'QUERY_STRING'})){
		$tmpStr = "".$ENV{"QUERY_STRING"};
	}
  my @parts = split(/\&/, $tmpStr);
  foreach my $part (@parts) {
    my ($key, $value) = split(/\=/, $part);
    &populateAddToFORM($key, $value);
  }
}}}
sub populatePostFields {{{
	return unless (exists($ENV{"CONTENT_LENGTH"}));
	my $tmpStr;
	read(STDIN, $tmpStr, $ENV{"CONTENT_LENGTH"});
	my @parts = split( /\&/, $tmpStr );
	foreach my $part (@parts) {
		my ($key, $value) = split( /\=/, $part );
		&populateAddToFORM($key, $value);
	}
}}}
sub populateCookieFields {{{
	my $tmpStr = "";
	if (defined($ENV{'HTTP_COOKIE'})){
		$tmpStr = "".$ENV{"HTTP_COOKIE"};
	}
  my @parts = split(/;/, $tmpStr);
  foreach my $part (@parts) {
    my ($key, $value) = split(/\=/, $part);
		$key =~ s/^ //;
    &populateAddToFORM($key, $value);
  }
}}}
sub CheckCredentials {
	$CURRENTUSER = Tweetodon::User->authenticate();
	if ($CURRENTUSER){
		return 1;
	}

	return 0;
}

$FORM{"mode"} = "Login";
&populateGetFields();
&populatePostFields();
&populateCookieFields();

# Force Unicode output
binmode STDERR, ":utf8";
binmode STDOUT, ":utf8";

my $object;

# TODO: This is a very bad solution but not as bad as an uncontrolled eval...
# The @main::modules array holds a list of all permissible values of the $main::FORM{"mode"} variable.
# If the value is not in this array, the request is not processed and an error is displayed.
my @modules = ("Login", "OAuthLogin", "Dashboard", "Callback", "JSON");

if (! grep {$_ eq $FORM{mode}} @modules) {
	Error("Validation Error", "$FORM{mode} is not a valid module");
}

my $x = "Tweetodon::Website::$FORM{mode}";
eval "use $x; 1" || Error("Parse Error", "Could not include $x: $@");
eval { $object=$x->new(); } || Error("Functional Error", "This function is not implemented yet ('".$FORM{mode}."').");
if ($object->requires_authentication()) { # Mode requires user to be logged in?
	unless (CheckCredentials()) {
		$x = "Tweetodon::Website::Login";
		eval "use $x; 1" || Error("Parse Error", "Could not include $x: $@");
		eval { $object=$x->new(); } || Error("Functional Error", "This function is not implemented yet ('".$FORM{mode}."').");
	}
}

$object->render();
