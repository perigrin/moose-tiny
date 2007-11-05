#!/usr/bin/perl

# Simple tests for a simple module
use strict;

BEGIN {
    $|  = 1;
    $^W = 1;
}

use Test::More tests => 12;

# Define a class
SCOPE: {
    eval "
	package Bar;

	sub new {
		my \$class = shift;
		return bless { \@_ }, \$class;
	}

	package Foo;

	\@Foo::ISA = 'Bar';

	use Moose::Tiny qw{ foo bar };
	";
    ok( !$@, 'Created package without error' );
}

# Create a trivial object
SCOPE: {
    my $empty = Foo->new;
    isa_ok( $empty, 'Foo' );
    isa_ok( $empty, 'Bar' );
    ok( !$empty->isa('Moose::Tiny'), 'Is not an Moose::Tiny' );
    is( scalar( keys %$empty ), 0, 'Empty object is empty' );
}

# Create a real object
SCOPE: {
    my $object = Foo->new( foo => 1, bar => 2, baz => 3 );
    isa_ok( $object, 'Foo' );
    isa_ok( $object, 'Bar' );
    is( scalar( keys %$object ), 2, 'Object contains expected elements' );
    is( $object->foo,            1, '->foo ok' );
    is( $object->bar,            2, '->bar ok' );
    eval { $object->baz; };
    ok( $@, '->bar returns an error' );
    is( $object->{baz}, undef, '->{baz} does not contain value' );
}
