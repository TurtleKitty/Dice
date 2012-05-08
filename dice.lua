#!/usr/bin/env lua


function main (argv)
    rolls, constant = parse(argv)

    polys = mkpolys(rolls)

    combinations = 1;

    biggun = { 1 }
 
    for i, x in pairs(polys) do
	biggun = polymul(biggun, x)
    end
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


function mkpolys (rolls)
    local polys = {}

    for d, n in pairs(rolls) do
	for i = 1, n do
	    local p = {}

	    for j = 1, d do
		p[j] = 1
	    end

	    table.insert(polys, p)
	end
    end

    return polys
end


function polymul (x, y)
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
