package Dist::Zilla::PluginBundle::ConfigSlicer;
# ABSTRACT: Load another bundle and override its plugin configurations
use Moose;

extends 'Dist::Zilla::PluginBundle::Filter';
with qw(
  Dist::Zilla::Role::PluginBundle::Config::Slicer
);

__PACKAGE__->meta->make_immutable;
1;

=for test_synopsis __END__

=head1 SYNOPSIS

  ; in your dist.ini:

  [@ConfigSlicer]
  -bundle = @Classic
  -remove = PodVersion
  -remove = Manifest
  option = for_classic
  ManifestSkip.skipfile = something.weird

=head1 DESCRIPTION

This plugin bundle actually wraps and modifies another plugin bundle.
It extends L<< C<@Filter>|Dist::Zilla::PluginBundle::Filter >>
and additionally consumes
L<Dist::Zilla::Role::PluginBundle::Config::Slicer|Dist::Zilla::Role::PluginBundle::Config::Slicer>
so that any plugin options will be passed in.

This way you can override the plugin configuration
for any bundle that doesn't consume 
L<Dist::Zilla::Role::PluginBundle::Config::Slicer|Dist::Zilla::Role::PluginBundle::Config::Slicer>
as if it did!

=head1 SEE ALSO

=for :list
* L<Dist::Zilla::PluginBundle::Filter
* L<Dist::Zilla::Role::PluginBundle::Config::Slicer

=cut
