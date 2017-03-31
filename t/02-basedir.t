use Test::More tests => 4;

use 5.012;
use Cwd;
use FindBin;
use File::Spec;

SKIP: {
    eval "use File::Temp qw{ tempdir }";
    skip "File::Temp not installed", 4 if $@;

    my ($dir) = tempdir(CLEANUP => 1);
    diag("using temporary program directory '$dir' to test functionality");

    my $filename = File::Spec->catfile( $FindBin::Bin,'..','dingle');
    my $ret = `$^X $filename basedir`;
    is($ret, Cwd::cwd() . "\n", "Default basedir is Cwd::cwd()");
    
    SKIP: {
      eval "use Test::Output";
      skip "Test::Output not installed", 2 if $@;

      my ($out,$err) = Test::Output::output_from( sub {
          `$^X $filename basedir --basedir=/this/is/not/really/There`
      });
      is($out,'',"no output in error case");
      is($err,"Basedir '/this/is/not/really/There' not found.\n","basedir should exist");
    }
    
    {
      my $ret = `$^X $filename basedir --basedir=$dir`;
      chomp $ret;
      is($ret,$dir,"basedir argument");
    }  
}
