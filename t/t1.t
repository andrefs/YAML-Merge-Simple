#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 4;
use YAML::Merge::Simple qw/merge merge_files/;
use YAML::XS;

my $yaml1  = 't/yaml1';
my $yaml2  = 't/yaml2';
my $yaml3  = 't/yaml3';
my $yaml12 = 't/yaml12';
my $yaml23 = 't/yaml23';
my $yaml32 = 't/yaml32';
my ($got_yaml,$expected_hash);

$got_yaml = YAML::Merge::Simple->merge_files($yaml1,$yaml2);
$expected_hash = YAML::XS::LoadFile($yaml12);
is_deeply(YAML::XS::Load($got_yaml),$expected_hash,"Test simple merge");

$got_yaml = YAML::Merge::Simple::merge_files($yaml2,$yaml3);
$expected_hash = YAML::XS::LoadFile($yaml23);
is_deeply(YAML::XS::Load($got_yaml),$expected_hash,"Test more complex merge");

$got_yaml = YAML::Merge::Simple::merge_files($yaml3,$yaml2);
$expected_hash = YAML::XS::LoadFile($yaml32);
is_deeply(YAML::XS::Load($got_yaml),$expected_hash,"Test reverse more complex merge");

my $str1 = q{
a: x
y:
  z: 4
};

my $str2 = q{
a:
  k: l
  j: n
y:
  z: 3
  d: 9
t:
  r: 1
};

my $str3 = q{
o: 1
t: 0
};

$got_yaml = YAML::Merge::Simple::merge($str1,$str2,$str3);
$expected_hash = {
	a => {
		j => "n",
		k => "l"
	},
	o => 1,
	t => 0,
	y => {
		d => 9,
		z => 3
	},
};
is_deeply(YAML::XS::Load($got_yaml),$expected_hash,"Test merge 3 strings");
