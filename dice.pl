#!/usr/bin/perl

use strict;
use warnings;

use List::AllUtils;

print main();


sub main {
    my $args = parse(\@ARGV);

    my @polys;

    my $combinations = 1;

    for my $r (@{ $args->{rolls} }) {
	$combinations *= $r->{die} ** $r->{num};
	push(@polys, @{ mkroll($r) });
    }

    my $bigpoly = megamul(\@polys);
    my @final	= map { $_ / $combinations } @$bigpoly;

    my $min = List::AllUtils::firstidx { defined($_) && $_ > 0 } @final;
    my $max = $#final;

    my $output = "\n";

    for my $exp ($min .. $max) {
	$output .= sprintf(
	    "%-10d%-10.5f%-48s\n",
	    $exp + $args->{const},
	    $final[$exp],
	    "#" x sprintf("%.0f", 500 * $final[$exp])
	);
    }

    return $output . "\n";
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


sub mkroll ($) {
    my ($r) = @_;

    my @results;

    for my $i (1 .. $r->{num}) {
	my @result;

	for my $j (1 .. $r->{die}) {
	    $result[$j] = 1;
	}

	push @results, \@result;
    }

    return \@results;
}


sub poly_multiply ($$) {
    my ($p1, $p2) = @_;

    my @result;

    for (my $i = 0; $i < @$p1; $i++) {
	for (my $j = 0; $j < @$p2; $j++) {
	    my $t1 = $p1->[$i] // 0;
	    my $t2 = $p2->[$j] // 0;
	    $result[ $i + $j ] += $t1 * $t2;
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


1;

