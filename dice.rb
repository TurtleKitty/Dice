#!/usr/bin/env ruby


class Roll
    def initialize (n, d)
	@n = n
	@d = d
    end

    attr_reader :n
    attr_reader :d
end


class Polynomial
    def initialize (yarr)
	@coefficients = yarr
    end

    attr_reader :coefficients

    def self.mkroll (n)
	x = [0]

	(1..n).each do |i|
	    x[i] = 1
	end

	Polynomial.new(x)
    end

    def *(other)
	noob = []

	@coefficients.each_with_index do |xi, i|
	    other.coefficients.each_with_index do |yj, j|
		cell = i + j

		if noob[cell].nil?
		    noob[cell] = 0
		end

		noob[cell] += xi * yj
	    end
	end

	Polynomial.new(noob)
    end
end


def parse (args)
    rolls = []
    adder = 0

    args.each do |arg|
	if arg.match("d")
	    rolls.push(
		Roll.new(
		    *arg.split("d").map {|x| x.to_i }
		)
	    )
	else
	    adder += arg.to_i
	end
    end

    return [rolls, adder]
end


def histogram (n)
    num  = (0.5 + (500 * n));
    "#" * num
end


def main (args)
    rolls, constant = parse(args)

    min = 0
    max = 0
    combinations = 1;

    polys = []

    rolls.each do |roll|
	min += roll.n
	max += roll.n * roll.d
	combinations *= roll.d**roll.n

	(1..roll.n).each do |r|
	    polys.push( Polynomial.mkroll(roll.d) )
	end
    end

    biggun = Polynomial.new([1]) # identity

    polys.each do |p|
	biggun *= p
    end

    (min..max).each do |deg|
	coeff = biggun.coefficients[deg]

	if !(coeff.nil? or coeff == 0)
	    px    = coeff.to_f / combinations.to_f
	    hg    = histogram(px)
	    printf("%d\t\t%.5f\t\t%s\n", deg + constant, px, hg)
	end
    end
end


main(ARGV)


