#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Module::Build;

my $builder = Module::Build->new(
     module_name => 'App::dingle',
     dist_version => '0.1.00',
     dist_author => [
	     'Mike Würfel <sknpp@cpan.org>'
     ],
     license => 'perl',
     dist_abstract => 'a commandline tool for a software generator',
     requires => {
          'perl' => '5.12.0',
	      'App::Rad' => '1.05',
	 	  'Config::General' => '',
	      'File::chdir' => '',
	      'File::Path' => '',
	      'File::Spec' => ''
     },
     build_requires => {
		 'Test::Output' => '1.0'
     }
);

$builder->create_build_script();
