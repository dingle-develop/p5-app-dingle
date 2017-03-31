use Test::More tests => 2;

use 5.012;
use FindBin;
use File::Spec;

SKIP: {
    eval "use File::Temp qw{ tempdir }";
    skip "File::Temp not installed", 3 if $@;

    my ($dir) = tempdir(CLEANUP => 1);
    diag("using temporary program directory '$dir' to test functionality");

    my $filename = File::Spec->catfile( $FindBin::Bin,'..','dingle');
    my $ret = `$^X $filename sitelib`;
    is( $ret, "No config found.\n" );

    my $config = File::Spec->catfile( $dir,'site-lib-test.conf' );
    my $sitelib = File::Spec->catdir( $dir,'site-lib' );
    my $contents = <<__EOT__;
    
directoryname = $sitelib

<github giftnuss>
  <repo p5-ho-class>
    HO::abstract
    HO::accessor
    HO::class
  </repo>
</github>

__EOT__

    open(my $fh, ">", $config);
    print $fh $contents;
    close $fh;
   
    $ret = `$^X $filename sitelib --config=$config`;
    
    my $check = File::Spec->catfile($sitelib,'p5-ho-class','lib','HO','class.pm');
    ok( -f $check, "sitelib installed");
}

__END__
