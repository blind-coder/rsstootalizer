#!/usr/bin/perl -w
# vim: set foldmarker={,}:

use strict;
use HTML::Template;

package Tweetodon::Website;
use Data::Dumper;

sub requires_authentication {
	return 1;
}
sub fill_generic_content {
	my $self = shift;
	my $output = shift;

	my ($DAY, $MONTH, $YEAR) = (localtime)[3,4,5];
	$YEAR += 1900;                                
	$MONTH++;                                     
	if ($MONTH < 10){                             
		$MONTH = "0$MONTH";                         
	}                                             
	if ($DAY < 10){                               
		$DAY = "0$DAY";                             
	}                                             
	$output->param("currentdate.day", $DAY);    
	$output->param("currentdate.month", $MONTH);
	$output->param("currentdate.year", $YEAR);  

	$output->param($self->{"params"});
}
sub fill_content {
	&main::Error("Not implemented", "The function fill_content is not implemented in ".caller()."!");
}
sub prerender {
	my $self = shift;
	$self->{"template"} = "NotImplemented";
	$self->{"content_type"} = "html";
}
sub render {
	my $self = shift;

	$self->prerender();

	my $output = HTML::Template->new(filename => $self->{"template"}.".".$self->{"content_type"}, path => "static/templates", die_on_bad_params => 0);
	$self->fill_generic_content($output);
	$self->fill_content($output);

	for ($self->{"content_type"}){
		if (/^html$/){
			print "Content-Type: text/html;charset=utf8\n";
		} elsif (/^json$/){
			print "Content-Type: text/plain;charset=utf8\n";
		}
	}
	foreach ($self->{"set_cookie"}){
		print "Set-Cookie: $_\n" if defined($_);
	}
	print "\n";

	print $output->output();
}
sub new {
	my $class = shift;

	my $self = { params => {} };
	bless ($self, $class);
}

1;
