package # no_index
  Dist::Zilla::Config::Slicer::Test::Less;
use Moose;
extends qw(
  Dist::Zilla::Config::Slicer::Test::Bundle
);

sub slicer_removal_attribute { 'scurvy_cur' }

__PACKAGE__->meta->make_immutable;
1;
