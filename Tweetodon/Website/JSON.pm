#!/usr/bin/perl -w
# vim: set foldmarker={,}:

use strict;
use Tweetodon::DB;
use Tweetodon::Account;
use Tweetodon::Identity;
use Tweetodon::Website;

package Tweetodon::Website::JSON;
@Tweetodon::Website::JSON::ISA = qw(Website);
use Data::Dumper;
use JSON;
use MIME::Base64 qw(encode_base64);

sub requires_authentication {
	return 1;
}
sub fill_content {
	return 1;
}
sub prerender {
	my $self = shift;
	$self->{"template"} = "error";
	$self->{"content_type"} = "json";
	$self->{"params"}->{"currentmode"} = "JSON";

	my $submode = $main::FORM{r};
	$self->$submode();
}

sub SaveSettings {
	my $self = shift;

	$self->{"template"} = "Settings_Save";
	foreach my $k (keys %{$main::CURRENTUSER->{"data"}}, "password"){
		next if $k eq "login";

		if (exists($main::FORM{$k})){
			$main::CURRENTUSER->{"data"}->{$k} = $main::FORM{$k};
		}
	}
	if (!$main::CURRENTUSER->save()){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = $DBI::errstr;
	} else {
		$self->{"params"}->{"status"} = "OK";
		$self->{"params"}->{"msg"} = "Saved successfully";
	}
}

sub identity_accounts {
	my $self = shift;
	if ((!$main::CURRENTUSER->has_privilege("useradmin")) && ($main::CURRENTUSER->{"data"}->{"id"} != $main::FORM{"id"})){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "accounts";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my @accounts;
	my $i = Tweetodon::Identity->get_by("id", $main::FORM{"id"});
	foreach my $a ($i->accounts()){
		my %account;
		foreach my $k (keys %{$a->{"data"}}){
			$account{$k} = $a->{"data"}->{$k};
		}
		push @accounts, \%account;
	}
	$self->{"params"}->{"accounts"} = \@accounts;
}

sub applications_all {
	my $self = shift;
	if (!$main::CURRENTUSER->has_privilege("superuser")){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "applications_all";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my @applications;
	foreach my $a (Tweetodon::Application->all()){
		my %application;
		foreach my $k (keys %{$a->{"data"}}){
			$application{$k} = $a->{"data"}->{$k};
		}
		$application{"b64_configuration"} = encode_base64($a->{"data"}->{"configuration"}, "");
		push @applications, \%application;
	}
	$self->{"params"}->{"applications"} = \@applications;
}
sub application_by_id {
	my $self = shift;
	if (!$main::CURRENTUSER->has_privilege("superuser")){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "application";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my $a = Tweetodon::Application->get_by("id", $main::FORM{"id"});
	foreach my $k (keys %{$a->{"data"}}){
		$self->{"params"}->{$k} = $a->{"data"}->{$k};
	}
	$self->{"params"}->{"b64_configuration"} = encode_base64($a->{"data"}->{"configuration"}, "");
	$self->{"params"}->{"options"} = encode_json($a->get_handler()->configuration_options());
}
sub application_save {
	my $self = shift;
	if (!$main::CURRENTUSER->has_privilege("superuser")){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "error";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my $a;
	if ($main::FORM{"id"} eq "new"){
		# TODO
		# my %data;
		# $data{"login"} = $main::FORM{"login"};
		# $u = Tweetodon::Application->create(%data);
	} else {
		$a = Tweetodon::Application->get_by("id", $main::FORM{"id"});
	}

	foreach my $k (keys %{$a->{"data"}}){
		if (exists($main::FORM{$k}) && "x".$main::FORM{$k} ne "x"){
			$a->{"data"}->{$k} = $main::FORM{$k};
		}
	}
	$a->save();
}
sub application_import_accounts {
	my $self = shift;
	if (!$main::CURRENTUSER->has_privilege("superuser")){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "application_import_accounts";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my $a = Tweetodon::Application->get_by("id", $main::FORM{"id"});
	my @accounts;
	foreach my $acc ($a->get_handler()->import_accounts_from_application()){
		my %account;
		print STDERR Dumper($acc);
		$account{"username"} = $$acc{"username"};
		$account{"disabled"} = $$acc{"disabled"};
		push @accounts, \%account;
	}
	$self->{"params"}->{"accounts"} = \@accounts;
}

sub users_all {
	my $self = shift;
	if (!$main::CURRENTUSER->has_privilege("useradmin")){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "users_all";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my @users;
	my $count = 0;
	foreach my $u (Tweetodon::User->all()){
		my %user;
		foreach my $k (keys %{$u->{"data"}}){
			next if $k eq "password";
			$user{$k} = $u->{"data"}->{$k};
		}
		push @users, \%user;
		$count++;
	}
	$self->{"params"}->{"users"} = \@users;
	$self->{"params"}->{"count"} = $count;
}
sub user_by_id {
	my $self = shift;
	if ((!$main::CURRENTUSER->has_privilege("useradmin")) && ($main::CURRENTUSER->{"data"}->{"id"} != $main::FORM{"id"})){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "user";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my $u = Tweetodon::User->get_by("id", $main::FORM{"id"});
	foreach my $k (keys %{$u->{"data"}}){
		next if $k eq "password";
		$self->{"params"}->{$k} = $u->{"data"}->{$k};
	}
}
sub user_save {
	my $self = shift;
	if ((!$main::CURRENTUSER->has_privilege("useradmin")) && ($main::CURRENTUSER->{"data"}->{"id"} != $main::FORM{"id"})){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "error";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my $u;
	if ($main::FORM{"id"} eq "new"){
		my %data;
		$data{"login"} = $main::FORM{"login"};
		$u = Tweetodon::User->create(%data);
	} else {
		$u = Tweetodon::User->get_by("id", $main::FORM{"id"});
	}
	delete $main::FORM{"id"};
	foreach my $k (keys %{$u->{"data"}}){
		if (exists($main::FORM{$k}) && "x".$main::FORM{$k} ne "x"){
			$u->{"data"}->{$k} = $main::FORM{$k};
		}
	}
	$u->save();
}
sub user_identities {
	my $self = shift;
	if ((!$main::CURRENTUSER->has_privilege("useradmin")) && ($main::CURRENTUSER->{"data"}->{"id"} != $main::FORM{"id"})){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "identities";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my @identities;
	my $u = Tweetodon::User->get_by("id", $main::FORM{"id"});
	foreach my $id ($u->identities()){
		my %identity;
		foreach my $k (keys %{$id->{"data"}}){
			$identity{$k} = $id->{"data"}->{$k};
		}
		push @identities, \%identity;
	}
	$self->{"params"}->{"identities"} = \@identities;
}

sub identities_save {
	my $self = shift;
	if ((!$main::CURRENTUSER->has_privilege("useradmin")) && ($main::CURRENTUSER->{"data"}->{"id"} != $main::FORM{"id"})){
		$self->{"params"}->{"status"} = "Error";
		$self->{"params"}->{"msg"} = "You are not allowed to perform this operation.";
		return 1;
	}
	$self->{"template"} = "error";
	$self->{"params"}->{"status"} = "OK";
	$self->{"params"}->{"msg"} = "";

	my $user = Tweetodon::User->get_by("id", $main::FORM{"id"});
	foreach my $id ($user->identities()){
		if (exists($main::FORM{$id->{"data"}->{"id"}})){
			$id->{"data"}->{"description"} = $main::FORM{$id->{"data"}->{"id"}};
			$id->save();
		}
	}
	if (exists($main::FORM{"new"})){
		my %data;
		$data{user_id} = $user->{"data"}->{"id"};
		$data{description} = $main::FORM{"new"};
		Tweetodon::Identity->create(%data);
	}
}

1;
