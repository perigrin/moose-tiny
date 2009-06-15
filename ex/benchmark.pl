#!/usr/bin/perl

BEGIN {
    $DB::single = 1;
}

use Object::Tiny            ();
use Class::Accessor::Fast   ();
use Foo_Bar_Accessor        ();
use Foo_Bar_Accessor2       ();
use Foo_Bar_Tiny            ();
use Foo_Bar_Tiny2           ();
use Foo_Bar_Moose           ();
use Foo_Bar_Moose2          ();
use Foo_Bar_Moose_Immutable ();
use Benchmark ':all';

print "\nBenchmarking constructor plus accessors...\n";

cmpthese(
    1000000,
    {
        'moose' => '
        my $object = Foo_Bar_Moose->new(
            foo => 1,
            bar => 2,
            baz => 4,
        );
        $object->foo;
        $object->bar;
        $object->baz;
    ',
        'immutable' => '
        my $object = Foo_Bar_Moose_Immutable->new(
            foo => 1,
            bar => 2,
            baz => 4,
        );
        $object->foo;
        $object->bar;
        $object->baz;
    ',
        'tiny' => '
        my $object = Foo_Bar_Tiny->new(
            foo => 1,
            bar => 2,
            baz => 4,
        );
        $object->foo;
        $object->bar;
        $object->baz;
    ',
        'accessor' => '
        my $object = Foo_Bar_Accessor->new( {
            foo => 1,
            bar => 2,
            baz => 4,
        } );
        $object->foo;
        $object->bar;
        $object->baz;
    ',
    }
);

sleep 1;
print "\nBenchmarking constructor alone...\n";

cmpthese(
    1000000,
    {
        'moose' => '
        Foo_Bar_Moose->new(
            foo => 1,
            bar => 2,
            baz => 4,
        );
    ',
        'immutable' => '
        Foo_Bar_Moose_Immutable->new(
            foo => 1,
            bar => 2,
            baz => 4,
        );
    ',

        'tiny' => '
        Foo_Bar_Tiny->new(
            foo => 1,
            bar => 2,
            baz => 4,
        );
    ',
        'accessor' => '
        Foo_Bar_Accessor->new( {
            foo => 1,
            bar => 2,
            baz => 4,
        } );
    ',
    }
);

sleep 1;
print "\nBenchmarking accessors alone...\n";

my $moose = Foo_Bar_Moose->new(
    foo => 1,
    bar => 2,
    baz => 4,
);
my $immutable = Foo_Bar_Moose_Immutable->new(
    foo => 1,
    bar => 2,
    baz => 4,
);

my $tiny = Foo_Bar_Tiny->new(
    foo => 1,
    bar => 2,
    baz => 4,
);

my $accessor = Foo_Bar_Tiny->new(
    {
        foo => 1,
        bar => 2,
        baz => 3,
    }
);

cmpthese(
    1000,
    {
        'moose' => sub {
            foreach ( 1 .. 1000 ) {
                $moose->foo;
                $moose->bar;
                $moose->baz;
            }
        },
        'immutable' => sub {
            foreach ( 1 .. 1000 ) {
                $immutable->foo;
                $immutable->bar;
                $immutable->baz;
            }
        },
        'tiny' => sub {
            foreach ( 1 .. 1000 ) {
                $tiny->foo;
                $tiny->bar;
                $tiny->baz;
            }
        },
        'accessor' => sub {
            foreach ( 1 .. 1000 ) {
                $accessor->foo;
                $accessor->bar;
                $accessor->baz;
            }
        },
    }
);
