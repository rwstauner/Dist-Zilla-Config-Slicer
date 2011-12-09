# vim: set ts=2 sts=2 sw=2 expandtab smarttab:
use strict;
use warnings;

package Dist::Zilla::Role::PluginBundle::Config::Slicer;
# ABSTRACT: Pass Portions of Bundle Config to Plugins

use Dist::Zilla::Config::Slicer ();
use Moose::Role;

requires 'bundle_config';

# TODO: around add_bundle => sub { ($self, $bundle, $payload) = @_; $slicer->merge([$bundle, _bundle_class($bundle), $payload || {}]);

sub slicer_removal_attribute { '-remove' };
sub mvp_multivalue_args { $_[0]->slicer_removal_attribute };

around bundle_config => sub {
  my ($orig, $class, $section) = @_;

  # is it better to delete this or allow the bundle to see it?
  my $remove = $section->{payload}->{ $class->slicer_removal_attribute };

  my @plugins = $orig->($class, $section);

  my $slicer = Dist::Zilla::Config::Slicer->new({
    config => $section->{payload},
  });

  $slicer->merge($_) for @plugins;

  return @plugins unless $remove;

  # stolen 100% from @Filter (thanks rjbs!)
  require List::MoreUtils;
  for my $i (reverse 0 .. $#plugins) {
    splice @plugins, $i, 1 if List::MoreUtils::any(sub {
      $plugins[$i][1] eq Dist::Zilla::Util->expand_config_package_name($_)
    }, @$remove);
  }

  return @plugins;
};

1;

=for Pod::Coverage slicer_removal_attribute mvp_multivalue_args

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
  AnotherPlug.array[] = append value

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

=head1 REMOVING PLUGINS

Additionally this will remove any plugins specified
by the C<-remove> attribute
(like L<@Filter|Dist::Zilla::PluginBundle::Filter> does):

  [@MyBundle]
  -remove = PluginIDontWant
  -remove = OtherDumbPlugin

If you want to use C<-remove> for your own bundle
you can override the C<slicer_removal_attribute> sub
to define a different attribute name:

  # in your bundle package
  sub slicer_removal_attribute { 'scurvy_cur' }

B<NOTE>: If you overwrite C<mvp_multivalue_args>
you'll need to include the value of C<slicer_removal_attribute>
(C<-remove> by default) if you want to retain this functionality.
As always, patches and suggestions are welcome.

=head1 SEE ALSO

=for :list
* L<Config::MVP::Slicer>
* L<Dist::Zilla>
* L<Dist::Zilla::Config::Slicer>
* L<Dist::Zilla::Role::PluginBundle>
* L<Dist::Zilla::Role::PluginBundle::Easy>

=cut
