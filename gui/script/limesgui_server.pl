#!/usr/bin/env perl

my $guipath;
my $libpath;


BEGIN {
    $ENV{CATALYST_SCRIPT_GEN} = 40;
    my $libpath = $ENV{'LIMESLIB'};
    my $guipath = $ENV{'LIMESGUI'};

    unless ($guipath && $libpath)
    {
        print "ERROR: Necessary path information missing. (Did you define LIMESLIB and LIMESGUI in ENV?)\n";
        exit(0);
    }

    print "Using lib-path: $libpath\nUsing gui-path: $guipath\n";

    unshift(@INC,"$libpath/lib/");
    unshift(@INC,"$guipath");



}

use Catalyst::ScriptRunner;
Catalyst::ScriptRunner->run('LimesGUI', 'Server');

1;

=head1 NAME

limesgui_server.pl - Catalyst Test Server

=head1 SYNOPSIS

limesgui_server.pl [options]

   -d --debug           force debug mode
   -f --fork            handle each request in a new process
                        (defaults to false)
   -? --help            display this help and exits
   -h --host            host (defaults to all)
   -p --port            port (defaults to 3000)
   -k --keepalive       enable keep-alive connections
   -r --restart         restart when files get modified
                        (defaults to false)
   -rd --restart_delay  delay between file checks
                        (ignored if you have Linux::Inotify2 installed)
   -rr --restart_regex  regex match files that trigger
                        a restart when modified
                        (defaults to '\.yml$|\.yaml$|\.conf|\.pm$')
   --restart_directory  the directory to search for
                        modified files, can be set multiple times
                        (defaults to '[SCRIPT_DIR]/..')
   --follow_symlinks    follow symlinks in search directories
                        (defaults to false. this is a no-op on Win32)
   --background         run the process in the background
   --pidfile            specify filename for pid file

 See also:
   perldoc Catalyst::Manual
   perldoc Catalyst::Manual::Intro

=head1 DESCRIPTION

Run a Catalyst Testserver for this application.

=head1 AUTHORS

Catalyst Contributors, see Catalyst.pm

=head1 COPYRIGHT

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

