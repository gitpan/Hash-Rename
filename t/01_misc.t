#!/usr/bin/env perl

use warnings;
use strict;
use Hash::Rename;
use Test::More tests => 6;
use Test::Exception;


sub test_rename {
    my %args = @_;
    my %hash = (
        '-noforce' => 1,
        scheme     => 'http'
    );
    hash_rename %hash, %args;
    wantarray ? %hash : \%hash;
}


is_deeply(
    scalar(test_rename(prepend => '-')),
    { '--noforce' => 1, '-scheme' => 'http' },
    'prepend dash',
);

is_deeply(
    scalar(test_rename(append => '=')),
    { '-noforce=' => 1, 'scheme=' => 'http' },
    'append equal sign',
);

is_deeply(
    scalar(test_rename(prepend => '-', append => '=')),
    { '--noforce=' => 1, '-scheme=' => 'http' },
    'prepend and append',
);

is_deeply(
    scalar(test_rename(code => sub { s/^(?!-)/-/ })),
    { '-noforce' => 1, '-scheme' => 'http' },
    'code',
);

is_deeply(
    scalar(test_rename(code => sub { $_ = 'foo' })),
    { foo => 'http' },
    'code producing duplicates, no strict',
);

throws_ok {
    is_deeply(
        scalar(test_rename(strict => 1, code => sub { $_ = 'foo' })),
        { foo => 'http' },
        'code producing duplicates, no strict',
    );
}
    qr/duplicate result key \[foo\] from original key \[scheme\]/,
    'code producing duplicates, with strict',

