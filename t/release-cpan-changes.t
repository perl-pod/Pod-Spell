#!perl

BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}


use strict;
use warnings;

use Test::More 0.96;
eval 'use Test::CPAN::Changes';

plan skip_all => "Test::CPAN::Changes required for this test" if $@;

subtest 'changes_ok' => sub {
    changes_file_ok('Changes');
};
done_testing();
