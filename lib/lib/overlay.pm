package lib::overlay;
$lib::overlay::VERSION = '0.00_01';

use strict;

=head1 NAME

lib::overlay - Overlay additional code on module loading

=head1 SYNOPSIS

    use lib::overlay '_deprecated' => -warn;
    use lib::overlay '_Overlay', '_Vendor', '_Local';

=head1 DESCRIPTION

Say you have C<use lib '_deprecated'>.  Now C<use CGI;> will, after loading
F<CGI.pm>, also try to look F<_deprecated/CGI.pm> in C<@INC> and load them too.

Expect more documentation later. :-)

=cut

# each hook has a transformer, followed by any number of actions
my @pre_hooks;
my @post_hooks;

BEGIN {
    sub do_require { require $_[0] }
    *CORE::GLOBAL::require = sub (*) {
        run_hooks(\@pre_hooks, @_);
        do_require(@_);
        run_hooks(\@post_hooks, @_);
    };
}

sub run_hooks {
    my $hooks = shift;
    foreach my $hook (@$hooks) {
        my ($t, $a) = @{$hook}{'transform', 'action'};
        my @args = $t->(@_) or next;

        foreach my $action (@$a) {
            __PACKAGE__->can($action)->(@args);
        }
    }
}

sub import {
    my $class = shift;
    while (@_) {
        my $arg = shift;
        my @actions;
        if (@_ and $_[0] =~ /^-(\w+)/) {
            push @actions, "_$1"; shift;
            push @actions, shift if @_;
        }
        @actions = '_require' unless @actions;
        push @post_hooks, {
            transform => UNIVERSAL::isa($arg => 'CODE') ? $arg : sub { "$arg/$_[0]" },
            action => \@actions,
        }
    }
}

sub _require {
    local $@; eval { do_require $_[0] };
}

sub unimport {
}

1;

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2004 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
