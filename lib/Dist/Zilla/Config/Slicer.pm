# vim: set ts=2 sts=2 sw=2 expandtab smarttab:
use strict;
use warnings;

package Dist::Zilla::Config::Slicer;
# ABSTRACT: Config::MVP::Slicer customized for Dist::Zilla

use Config::MVP::Slicer ();
use Dist::Zilla::Util 4 ();
use Moose;

extends 'Config::MVP::Slicer';

sub _build_match_package {
  # NOTE: Dist::Zilla::Util 4.3 claims this method "is likely to change go away"
  return sub { Dist::Zilla::Util->expand_config_package_name($_[0]) eq $_[1] };
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=for test_synopsis
my ($section, $plugin);

=head1 SYNOPSIS

  my $slicer = Dist::Zilla::Config::Slicer->new({
    config => $section->{payload},
  });
  
  $slicer->merge($plugin);

=head1 DESCRIPTION

This is a subclass of L<Config::MVP::Slicer>
that overrides the default
L<match_package|Config::MVP::Slicer/match_package>
to expand packages according to L<Dist::Zilla>'s rules.

=head1 SEE ALSO

=for :list
* L<Config::MVP::Slicer>
* L<Dist::Zilla::Role::PluginBundle::ConfigSlicer>

=cut
