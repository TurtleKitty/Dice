#!/usr/bin/perl


use strict;
use warnings;


sub xdy ($$) {
    my ($num, $die) = @_;

    my $total = 0;

    for (1 .. $num) {
	$total += int(rand($die)) + 1;
    }

    return $total;
}


sub parse ($) {
    my ($dstring) = @_;

    my @rolls;

    for my $t ( split('\+', $dstring) ) {
	my ($n, $d) = split('d', $t);
	push(@rolls, { num => $n, die => $d });
    }

    return(\@rolls);
}


sub sum ($) {
    my ($list) = @_;

    my $sum = 0;

    for my $item (@$list) {
	$sum += $item;
    }

    return($sum);
}


sub monty_carlo {

}


1;



