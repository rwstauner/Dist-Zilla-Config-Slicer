# vim: set ts=2 sts=2 sw=2 expandtab smarttab:
use strict;
use warnings;

package Dist::Zilla::Role::PluginBundle::Config::Slicer;
# ABSTRACT: Pass Portions of Bundle Config to Plugins

use Dist::Zilla::Config::Slicer ();
use Moose::Role;

requires 'bundle_config';

# TODO: around add_bundle => sub { ($self, $bundle, $payload) = @_; $slicer->merge([$bundle, _bundle_class($bundle), $payload || {}]);

around bundle_config => sub {
  my ($orig, $class, $section) = @_;

  my @plugins = $orig->($class, $section);

  my $slicer = Dist::Zilla::Config::Slicer->new({
    config => $section->{payload},
  });

  $slicer->merge($_) for @plugins;

  return @plugins;
};

1;

=head1 SYNOPSIS

  # in Dist::Zilla::PluginBundle::MyBundle

  with (
    'Dist::Zilla::Role::PluginBundle', # or PluginBundle::Easy
    'Dist::Zilla::Role::PluginBundle::Config::Slicer'
  );

  # Config::Slicer should probably be last
  # (unless you're doing something more complex)

=head1 DESCRIPTION

This role enables your L<Dist::Zilla> Plugin Bundle
to accept configuration customizations for the plugins it will load
and merge them transparently.

  # dist.ini
  [@MyBundle]
  option = 1
  Included::Plugin.attribute = overwrite value
  AnotherPlug.array[0] = append value
  AnotherPlug.array[1] = append another value

See L<Config::MVP::Slicer/CONFIGURATION SYNTAX> for details
on how the configurations are handled.

This role adds a method modifier to C<bundle_config>,
which is the method that the root C<PluginBundle> role requires,
and that C<PluginBundle::Easy> wraps.

After C<bundle_config> is called
the modifier will update the returned plugin configurations
with any values that were customized in the main bundle config.

Most of the work is done by L<Dist::Zilla::Config::Slicer>
(a subclass of L<Config::MVP::Slicer>).
Check out those modules if you want the same functionality
but don't want to consume this role in your bundle.

=head1 SEE ALSO

=for :list
* L<Config::MVP::Slicer>
* L<Dist::Zilla>
* L<Dist::Zilla::Config::Slicer>
* L<Dist::Zilla::Role::PluginBundle>
* L<Dist::Zilla::Role::PluginBundle::Easy>
* L<Dist::Zilla::PluginBundle::ConfigSlicer>

=cut
