package Foo_Bar_Moose_Immutable;

use Moose::Tiny qw{ foo bar baz };

__PACKAGE__->meta->make_immutable;
1;
