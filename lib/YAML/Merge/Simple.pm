use strict;
use warnings;
package YAML::Merge::Simple;
use 5.006;
use Hash::Merge::Simple;
use YAML::XS;
use Data::Dump qw/dump/;

# ABSTRACT: Recursively merge two or more YAMLs, simply

use vars qw/ @ISA @EXPORT_OK /;
require Exporter;
@ISA = qw/ Exporter /;
@EXPORT_OK = qw/ merge clone_merge dclone_merge /;


# This was stoled from Hash::Merge::Simple, which was inspired by Catalyst::Utils... thanks guys!
sub merge (@);
sub merge (@) {
	my @yamls = map { YAML::XS::LoadFile $_ } @_;
	dump(\@yamls);
	my $hash = Hash::Merge::Simple::merge(@yamls);
	
	return Dump $hash;
}


#sub clone_merge {
#	my @yamls = map { Load $_ } @_;
#	my $hash = Hash::Merge::Simple::clone_merge(@yamls);
#    return Dump $hash;
#}
#
#
#sub dclone_merge {
#	my @yamls = map { Load $_ } @_;
#	my $hash = Hash::Merge::Simple::dclone_merge(@yamls);
#    return Dump $hash;
#}



1;
__END__
=pod

=head1 NAME

YAML::Merge::Simple - Recursively merge two or more YAMLs, simply


=head1 SYNOPSIS

    use YAML::Merge::Simple qw/ merge /;

	# a: 1
	my $yaml1 = shift;  

	# a: 100
	# b: 2
	my $yaml2 = shift;  
						
    # Merge with righthand hash taking precedence
    my $new_yaml = merge $yaml1,yaml2
    # $c (note: a: 100 has overridden a: 1)
	# a: 100
	# b: 2

=head1 DESCRIPTION

YAML::Merge::Simple will recursively merge two or more YAML files and return the result as a string with the content of a new YAML.

This is just a wrapper around Hash::Merge::Simple which uses YAML::XS to load the YAMLs into hashes, uses Hash::Merge::Simple to merge them  and them uses YAML::XS again to dump the resulting hash back to YAML:

=head1 USAGE

=head2 Hash::Merge::Simple->merge( $file1, $file2, $file3, ..., $fileN )

Merge $file1 through $fileN, with the nth-most (rightmost) YAML taking precedence.

Returns a string with the YAML content of the merge.

=head1 SEE ALSO

L<Hash::Merge::Simple>

=head1 ACKNOWLEDGEMENTS

This code is almost entirely based on the current implementation of L<Hash::Merge::Simple>:

Robert Krimen C<robertkrimen@gmail.com>

=cut

