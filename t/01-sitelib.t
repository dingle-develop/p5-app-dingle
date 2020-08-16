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
    like( $ret, qr/Config file '.*' not found.\n/ );

    my $config = File::Spec->catfile( $dir,'site-lib-test.conf' );
    my $sitelib = File::Spec->catdir( $dir,'site-lib' );
    my $contents = <<__EOT__;
    
directoryname = site-lib

<github p5-ho-develop>
  <repo class>
    HO::abstract
    HO::accessor
    HO::class
  </repo>
</github>

__EOT__

    open(my $fh, ">", $config);
    print $fh $contents;
    close $fh;
   
    $ret = `$^X $filename sitelib --basedir="$dir" --config=$config`;
    my $check = File::Spec->catfile($sitelib,'class','lib','HO','class.pm');
    ok( -f $check, "sitelib installed");
}

__END__
