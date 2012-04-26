#!/usr/bin/perl


use strict;
use warnings;


sub mkroll ($) {
    my ($r) = @_;

    my @result;

    for my $i (1 .. $r->{die}) {
	push(@result, { coeff => 1, expon => $i });
    }

    return \@result;
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



