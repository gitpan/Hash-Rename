package Hash::Rename;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.03';
use Exporter qw(import);
our @EXPORT = ('hash_rename');

sub hash_rename (\%@) {
    my ($hash, %args) = @_;
    my %new_hash;
    for my $key (sort keys %$hash) {
        my $orig_key = $key;
        $key = $args{prepend} . $key if defined $args{prepend};
        $key = $key . $args{append}  if defined $args{append};
        if (defined $args{code}) {
            ref $args{code} eq 'CODE'
              || die "'code' value is not a CODE reference";
            local $_ = $key;
            $args{code}->();
            $key = $_;
        }
        die "duplicate result key [$key] from original key [$orig_key]\n"
          if defined($args{strict}) && exists $new_hash{$key};
        $new_hash{$key} = $hash->{$orig_key};
    }
    %$hash = %new_hash;
}
1;
__END__

=head1 NAME

Hash::Rename - Rename hash keys

=head1 SYNOPSIS

    use Hash::Rename;

    my %hash = (
        '-noforce' => 1,
        scheme     => 'http'
    );
    hash_rename %hash, code => sub { s/^(?!-)/-/ };

=head1 DESCRIPTION

Using this module you can rename a hash's keys in place.

=head1 FUNCTIONS

=over 4

=item C<hash_rename>

This function is automatically exported. It takes a hash to rename and another
hash of instructions on how to rename they keys.

The syntax is like this:

    hash_rename %hash, key1 => 'value1', keys2 => 'value2';

The following instructions are supported:

=over 4

=item C<prepend>

    hash_rename %hash, prepend => '-';

The given value is prepended to each hash key.

=item C<append>

    hash_rename %hash, append => '-';

The given value is appended to each hash key.

=item C<code>

    hash_rename %hash, code => sub { s/^(?!-)/-/ };

Each hash key is localized to C<$_> and subjected to the code. Its new value
is the result of C<$_> after the code has been executed.

=item C<strict>

If present and set to a true value, the resulting keys are checked for
duplicates. C<hash_rename()> will die if it detects a duplicate resulting hash
key. They keys of the hash to change are processed in alphabetical order.

=back

If several instructions are given, they are processed in the order in which
they are described above. So you can have:

    hash_rename %hash, prepend => '-', append => '=';

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://search.cpan.org/dist/Hash-Rename/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2009 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

