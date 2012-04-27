#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;


print main();


sub main {
    my $args = parse(\@ARGV);

    my @polys;

    my $combinations = 1;

    for my $r (@{ $args->{rolls} }) {
	$combinations *= $r->{die} ** $r->{num};
	push(@polys, @{ mkroll($r) });
    }

    my $bigpoly = poly_simplify( megamul(\@polys) );

    for my $term (@$bigpoly) {
	$term->{expon} += $args->{const};
	$term->{coeff} /= $combinations;
    }

    my $output = "\n";

    for my $term (sort { $a->{expon} <=> $b->{expon} } @$bigpoly) {
	$output .= sprintf("%-8d%.5f\n", $term->{expon}, $term->{coeff});
    }

    return $output . "\n";
}


sub mkroll ($) {
    my ($r) = @_;

    my @results;

    for my $i (1 .. $r->{num}) {
	my @result;

	for my $i (1 .. $r->{die}) {
	    push(@result, { coeff => 1, expon => $i });
	}

	push @results, \@result;
    }

    return \@results;
}


sub poly_simplify {
    my ($p) = @_;

    my %yash;

    for my $term (@$p) {
	$yash{ $term->{expon} } //= 0;
	$yash{ $term->{expon} }  += $term->{coeff};
    }

    my @rez;

    for my $exp (sort { $b <=> $a } keys %yash) {
	push(@rez, { coeff => $yash{$exp}, expon => $exp });
    }

    return \@rez;
}


sub poly_multiply ($$) {
    my ($p1, $p2) = @_;

    my @result;

    for my $i (@$p1) {
	for my $j (@$p2) {
	    push(@result, {
		coeff => $i->{coeff} * $j->{coeff},
		expon => $i->{expon} + $j->{expon},
	    });
	}
    }

    return \@result;
}


sub megamul {
    my ($polys) = @_;

    my $result = shift(@$polys);

    for my $p (@$polys) {
	$result = poly_multiply($result, $p);
    }

    return $result;
}


sub parse ($) {
    my ($args) = @_;

    my $constant = 0;
    my @rolls;

    for my $t (@$args) {
	if ($t =~ /d/) {
	    my ($n, $d) = split('d', $t);
	    push(@rolls, { num => $n, die => $d });
	}
	else {
	    $constant += $t;
	}
    }

    return {
	const => $constant,
	rolls => \@rolls
    };
}


sub sum ($) {
    my ($list) = @_;

    my $sum = 0;

    for my $item (@$list) {
	$sum += $item;
    }

    return($sum);
}


1;



