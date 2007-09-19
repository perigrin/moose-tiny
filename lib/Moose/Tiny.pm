package Moose::Tiny;
use strict;
our $VERSION = '0.0.1';
use Moose 0.26;

sub import {
    my $CALLER = caller();
    
    strict->import;
    warnings->import;

    Moose->import({into => $CALLER});
    # we should never export to main
    return if $CALLER eq 'main';
    Moose::init_meta( $CALLER, shift );

    my $meta = $CALLER->meta;
    {
    no warnings; # in case we get undef perl complains
    $meta->add_attribute( $_ => { reader => $_, init_arg => $_ } )
      for grep {
        defined and !ref and /^[^\W\d]\w*$/s
          or die "Invalid accessor name '$_'";
      } @_;
    }
    return 1;
}

no Moose;
1;    # Magic true value required at end of module
__END__

=head1 NAME

Moose::Tiny - Why Should Object::Tiny get all the Fun


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

None. Moose::Tiny currently exports what Moose itself exports. Simply call it with a list of attribute names and it will create 
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

Well I was looking at Object::Tiny's docs and realized that Moose wasn't even in the argument. I felt bad. So I decided hey I could make this work.

Object::Tiny has a bunch of statistics to show why it is better than Class::Accessor::Fast. Here are some statistics of our own.

=over

=item Moose::Tiny is 8% shorter to type than Object::Tiny

That's right, Moose is one less letter than Object, and since otherwise the APIs are identical that's an 8% savings overall.

=item Moose::Tiny brings you the full power of Moose

If you buy now you get C<with>, C<around>, C<after>, C<before> and several other goodies as well! Call now operators are standing by.

=back

Really that's all I got. Since you get all the Moose metaobject goodness our memory footprint is probably a fair bit larger ... but hey 8% savings when you're typing the code out!

=head1 CAVEATS

Moose works differently from Object::Tiny. Most importantly moose won't auto-vivify attribute slots, so if you don't define it in the command line it won't exist in the instance data structure, even if you pass a value to new(); Object::Tiny doesn't document this behavior but it is tested.

Also attribute slots in Moose are always created even if they're undefined. This behavior *may* change in the future, it's undocumented in Moose, but Object::Tiny expect that if you haven't populated an attribute, that attribute doesn't exist in the instance data structure. This is also not really documented, but is tested for.

=head1 DEPENDENCIES

Moose obviously.

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

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
