#!/usr/bin/env lua


function main (argv)
    rolls, constant = parse(argv)

    for i, x in pairs(rolls) do
	print(i, x)
    end

    print(constant)
end


function parse (args)
    local pat   = "(%d+)d(%d+)"
    local rv    = {}
    local adder = 0;

    for i, xi in ipairs(arg) do
	if (string.find(xi, pat)) then
	    _, _, n, d = string.find(xi, pat)
	    rv[d] = rv[d] or 0
	    rv[d] = rv[d] + n
	else
	    adder = adder + xi
	end
    end

    return rv, adder
end


function poly_mul (x, y)
    local rv = {};

    for i, xi in ipairs(x) do
	for j, yj in ipairs(y) do
	    local cell = i + j
	    if rv[cell] == nil then
		rv[cell] = 0;
	    end

	    rv[cell] = rv[cell] + (xi * yj)
	end
    end

    return rv
end


main(arg)
