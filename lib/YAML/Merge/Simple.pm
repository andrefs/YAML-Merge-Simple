use strict;
use warnings;
package YAML::Merge::Simple;
use 5.006;
use Hash::Merge::Simple;
use YAML::XS;

# ABSTRACT: Recursively merge two or more YAMLs, simply

use vars qw/ @ISA @EXPORT_OK /;
require Exporter;
@ISA = qw/ Exporter /;
@EXPORT_OK = qw/ merge merge_files /;


# This was stoled from Hash::Merge::Simple, which was inspired by Catalyst::Utils... thanks guys!
sub merge_files {
	shift unless -f $_[0]; # Take care of the case we're called like YAML::Merge::Simple->merge_files(...)
	my @hashes = map { YAML::XS::LoadFile $_ } @_;
	my $hash = Hash::Merge::Simple::merge(@hashes);
	return Dump $hash;
}

sub merge {
	shift unless ref $_[0]; # Take care of the case we're called like YAML::Merge::Simple->merge(...)
	my @hashes = map { YAML::XS::Load $_ } @_;
	my $hash = Hash::Merge::Simple::merge(@hashes);
	return Dump $hash;
}

1;
__END__
=pod

=head1 NAME

YAML::Merge::Simple - Recursively merge two or more YAMLs, simply


=head1 SYNOPSIS

    use YAML::Merge::Simple qw/ merge_files /;

    # a: 1
    my $yaml1 = shift;  
    
    # a: 100
    # b: 2
    my $yaml2 = shift;  
    
    # Merge with righthand hash taking precedence
    my $new_yaml = merge_files $yaml1,yaml2
    # $c (note: a: 100 has overridden a: 1)
    # a: 100
    # b: 2

=head1 DESCRIPTION

YAML::Merge::Simple will recursively merge two or more YAML files and return the result as a string with the content of a new YAML.

This is just a wrapper around Hash::Merge::Simple which uses YAML::XS to load the YAMLs into hashes, uses Hash::Merge::Simple to merge them  and them uses YAML::XS again to dump the resulting hash back to YAML:

=head1 USAGE

=head2 Hash::Merge::Simple::merge_files( $file1, $file2, $file3, ..., $fileN )

Merge $file1 through $fileN, with the nth-most (rightmost) YAML taking precedence.

Returns a string with the YAML content of the merge.

=head2 Hash::Merge::Simple::merge( $string1, $string2, $string3, ..., $stringN )

Merge $string1 through $stringN, with the nth-most (rightmost) YAML taking precedence.

Returns a string with the YAML content of the merge.

=head1 SEE ALSO

L<Hash::Merge::Simple>

=head1 ACKNOWLEDGEMENTS

This code is almost entirely based on the current implementation of L<Hash::Merge::Simple>:

Robert Krimen C<robertkrimen@gmail.com>

=cut

