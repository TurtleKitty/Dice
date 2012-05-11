#!/usr/bin/python

import re
import string
import sys


class Polynomial:
    def __init__(self, yarr):
	self.data = yarr
	self.deg  = len(yarr) - 1

    @classmethod
    def mkroll(self, d):
	yarr	= [1 for i in range(d+1)]
	yarr[0] = 0;
	return Polynomial(yarr)

    def mul(self, other):
	noob = [0 for i in range(self.deg + other.deg + 1)]
	for i, x in enumerate(self.data):
	    for j, y in enumerate(other.data):
		noob[i+j] += x * y
	return Polynomial(noob)


def main():
    sys.argv.pop(0)

    rolls, constant = parse(sys.argv)
    combos = 1
    polys  = []

    print rolls
    for r in rolls:
	n = r[0]
	d = r[1]
	combos *= d**n
	for i in range(n):
	    polys.append( Polynomial.mkroll(d) )

    biggun = Polynomial([1]) # unit poly

    for p in polys:
	biggun = biggun.mul(p)

    results = map(lambda x: float(x)/combos, biggun.data)

    for x, px in enumerate(results):
	if px > 0:
	    print "{0:d}\t\t{1:.5n}\t\t{2:s}".format(x + constant, round(px, 5), histogram(px))


def parse(args):
    adder = 0
    rolls = []
    for x in args:
	if re.search('[^\-0-9d]', x):
	    print "wtf"
	elif x.find("d") == -1:
	    adder += int(x)
	else:
	    rv = x.split("d")
	    rv[0] = int(rv[0])
	    rv[1] = int(rv[1])
	    rolls.append(rv)

    return rolls, adder


def histogram(n):
    num = int(0.5 + (500 * n));
    return "".join(["#" for i in range(num)])


main()

