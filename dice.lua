#!/usr/bin/env lua


function inspect (t)
    for i, xi in pairs(t) do
	print(i, xi) 
    end
end


function main (argv)
    local rolls, constant = parse(argv)

    local min = 0
    local max = 0
    local combinations = 1;
    for d,n in pairs(rolls) do
	min = min + n
	max = max + n * d
	combinations = combinations * d^n
    end

    local polys = mkpolys(rolls)

    local biggun = { 1 }
 
    for i, x in pairs(polys) do
	biggun = polymul(biggun, x)
    end

    for x = min, max+1 do
	local coeff = biggun[x]

	if coeff then
	    local px    = coeff / combinations
	    local hg    = histogram(px)
	    print( string.format("%d\t\t%.5f\t\t%s", x-1+constant, px, hg) )
	end
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

    for i, xi in pairs(x) do
	for j, yj in pairs(y) do
	    local cell = i + j
	    if rv[cell] == nil then
		rv[cell] = 0;
	    end

	    rv[cell] = rv[cell] + (xi * yj)
	end
    end

    return rv
end


function histogram (n)
    local num = (0.5 + (500 * n));

    local tmp = {}
    for i = 0, num do
	tmp[i] = "#"
    end

    return table.concat(tmp, "")
end


main(arg)


