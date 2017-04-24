#!/usr/bin/perl -w
# vim: set foldmarker={,}:

use strict;
use HTML::Template;
use RSSTootalizer::DB;
use RSSTootalizer::Feed;
use RSSTootalizer::Filter;
use RSSTootalizer::Website;

package RSSTootalizer::Website::EditFeed;
use Data::Dumper;
@RSSTootalizer::Website::EditFeed::ISA = qw(RSSTootalizer::Website);

sub requires_authentication {
	return 1;
}

sub fill_content {
	my $class = shift;
	my $output = shift;
	my $feed = RSSTootalizer::Feed->get_by("ID", $main::FORM{id});
	unless ($feed){
		main::Error("Unknown feed", "This feed id is not known");
		return 1;
	}

	if ($feed->{data}->{username} ne $main::CURRENTUSER->{data}->{acct} or $feed->{data}->{instance} ne $main::FORM{instance}){
		main::Error("Unknown feed", "This feed id is not known");
		return 1;
	}

	if ($main::FORM{action} and "x".$main::FORM{action} eq "xsaveformat"){
		$feed->{data}->{format} = $main::FORM{format};
		$feed->save();
	}

	if ($main::FORM{action} and "x".$main::FORM{action} eq "xsave"){
		my @filters = $feed->filters();
		FILTER: foreach my $filter (@filters){
			if ($main::FORM{"delete_".$filter->{data}->{ID}}){
				$filter->delete();
				next FILTER;
			}
			foreach my $key (keys(%{$filter->{data}})){
				if ($key ne "ID" and $main::FORM{$key."_".$filter->{data}->{ID}}){
					$filter->{data}->{$key} = $main::FORM{$key."_".$filter->{data}->{ID}};
				}
			}
			$filter->save();
		}

		foreach my $key (grep(/^field_new/, keys(%main::FORM))){
			$key =~ /^field_new([1-9][0-9]*)$/;
			my $id = $1;
			my %newfilter;
			$newfilter{feed_id} = $main::FORM{id};
			$newfilter{field} = $main::FORM{"field_new".$id};
			$newfilter{regex} = $main::FORM{"regex_new".$id};
			$newfilter{type} = $main::FORM{"type_new".$id};
			$newfilter{match} = $main::FORM{"match_new".$id};
			my $nf = RSSTootalizer::Filter->create(%newfilter);
		}
	}

	my @param_entries;
	my @filters = $feed->filters();
	my $feeddata = $feed->fetch_entries();
	foreach my $entry ($feeddata->items){
		my %entry;
		$entry{title} = $entry->title();
		$entry{link} = $entry->link();
		$entry{content} = $entry->content()->body;
		$entry{author} = $entry->author();
		$entry{issued} = $entry->issued();
		$entry{modified} = $entry->modified();
		$entry{id} = $entry->id();
		$entry{tags} = join(", ", $entry->tags());

		$entry{class} = "red";
		foreach my $filter (@filters){
			if ($filter->apply($entry)){
				if ($filter->{data}->{type} eq "white"){
					$entry{class} = "green";
				} else {
					$entry{class} = "red";
				}
			}
		}
		push @param_entries, \%entry;
	}
	$output->param("ENTRIES", \@param_entries);

	my @param_filters;
	foreach my $filter (@filters){
		my %filter;
		$filter{ID} = $filter->{data}->{ID};
		$filter{regex} = $filter->{data}->{regex};
		$filter{field} = $filter->{data}->{field};
		$filter{type} = $filter->{data}->{type};
		$filter{match} = $filter->{data}->{match};
		push @param_filters, \%filter;
	}
	$output->param("FILTERS", \@param_filters);

	$output->param("url", $feed->{data}->{url});
	$output->param("feed_id", $feed->{data}->{ID});
	$output->param("format", $feed->{data}->{format});
	return 1;
}
sub prerender {
	my $self = shift;
	$self->{"template"} = "EditFeed";
	$self->{"content_type"} = "html";
	$self->{"params"}->{"currentmode"} = "EditFeed";
}

1;
