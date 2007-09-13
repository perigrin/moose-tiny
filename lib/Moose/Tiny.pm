package Moose::Tiny;
use strict;
our $VERSION = '0.0.1';
use Moose;
use Moose::Object;
use Moose::Util::TypeConstraints;

my $CALLER;

# This is stole from Moose.pm ... find the inline comments there
sub _init_meta {
    my $class = $CALLER;
    subtype $class => as 'Object' => where { $_->isa($class) } =>
      optimize_as { blessed( $_[0] ) && $_[0]->isa($class) }
    unless find_type_constraint($class);

    my $meta;
    if ( $class->can('meta') ) {
        $meta = $class->meta();
        ( blessed($meta) && $meta->isa('Moose::Meta::Class') )
          || confess
"You already have a &meta function, but it does not return a Moose::Meta::Class";
    }
    else {
        $meta = Moose::Meta::Class->initialize($class);
        $meta->add_method(
            'meta' => sub {

                # re-initialize so it inherits properly
                Moose::Meta::Class->initialize( blessed( $_[0] ) || $_[0] );
            }
        );
    }
    $meta->superclasses('Moose::Object')
      unless $meta->superclasses();
}

sub import {
    return unless shift eq __PACKAGE__;
    $CALLER = caller();
    strict->import;
    warnings->import;

    # we should never export to main
    return if $CALLER eq 'main';
    _init_meta();

    my $meta = $CALLER->meta;

    $meta->add_attribute( $_ => { reader => $_, init_arg => $_ } )
      for grep {
        defined and !ref and /^[^\W\d]\w*$/s
          or die "Invalid accessor name '$_'";
      } @_;

    return 1;
}

no Moose;
1;    # Magic true value required at end of module
__END__

=head1 NAME

Moose::Tiny - Why Should Object::Tiny get all teh Fun


=head1 VERSION

This document describes Moose::Tiny version 0.0.1


=head1 SYNOPSIS

    # Define a class
    package Foo;

    use Moose::Tiny qw{ bar baz };

    1;


    # Use the class
    my $object = Foo->new( bar => 1 );

    print "bar is " . $object->bar . "\n";
  
  
=head1 DESCRIPTION

I was looking at Object::Tiny and thought, wow I bet I could do that really easily with Moose. I was right.

=head1 INTERFACE 

None. Moose::Tiny currently exports nothing, nor are there any methods you can 
call in it. Simply call it with a list of attribute names and it will create 
read only accessors for you.

    use Moose::Tiny qw(foo bar);
    
or a larger list

    use Moose::Tiny qw(
        item_font_face
        item_font_color
        item_font_size
        item_text_content
        item_display_time
        seperator_font_face
        seperator_font_color
        seperator_font_size
        seperator_text_content
    )

This will create a bunch of simple accessors, and set the inheritance to be the child of Moose::Object, just like if you'd created them with Moose itself.

=head1 WHY?

Well I was looking at Object::Tiny's docs and realized that Moose wasn't even in the argument. I felt bad. So I decided hey Moose is shorter to type than Object, I could make this work.

Object::Tiny has a bunch of statistics to show why it is better than Class::Accessor::Fast. Here are some statistics of our own.

=over

=item Moose::Tiny is 8% shorter to type than Object::Tiny

That's right, Moose is one less letter than Object, and since otherwise the APIs are identical that's an 8% savings overall.

=back

Really that's all I got. Moose::Tiny code is a touch bigger than Object::Tiny and since you get all the Moose metaobject goodness our memory footprint is probably a fair bit larger too ... but hey 8% savings when you're typing the code out!

=head1 CAVEATS

Moose works differently from Object::Tiny. Most importantly moose won't auto-vivify attribute slots, so if you don't define it in the command line it won't exist in the instance data structure, even if you pass a value to new(); Object::Tiny doesn't document this behavior but it is tested.

Also attribute slots in Moose are always created even if they're undefined. This behavior *may* change in the future, it's undocumented in Moose, but Object::Tiny expect that if you haven't populated an attribute, that attribute doesn't exist in the instance data structure. This is also not really documented, but is tested for.

=head1 DEPENDENCIES

Moose obviously.

=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-moose-tiny@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Chris Prather  C<< <perigrin@cpan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Chris Prather C<< <perigrin@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
