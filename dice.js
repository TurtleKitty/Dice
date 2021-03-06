

var utils = require('util');

console.log( main() );


function cool_round (x, n) {
    var scalar = Math.pow(10, n);
    return Math.round( scalar * x ) / scalar;
}


function mkhg (x) {
    var num = Math.round(500 * x),
	result = []
    ;

    for (var i = 0; i < num; i++) {
	result.push("#");
    }

    return result.join("");
}


function main () {
    var args = parse(process.argv.splice(2)),
	polys = [],
	combinations = 1,
	bigpoly = [],
	min = 0,
	max = 0,
	output = "\n"
    ;

    args.rolls.forEach(
	function (e, i) {
	    min += e.num;
	    max += e.num * e.die;
	    combinations *= Math.pow(e.die, e.num);
	    polys = polys.concat( mkroll(e) );
	}
    );

    bigpoly = megamul(polys).map(
	function (x) {
	    return cool_round(x / combinations, 5);
	}
    );

    for (var exp = min; exp <= max; exp++) {
	output += utils.format(
	    "%d\t\t%d\t\t%s\n",
	    exp + args.const,
	    bigpoly[exp],
	    mkhg(bigpoly[exp])
	);
    }

    return output + "\n";
}


function parse (args) {
    var constant = 0;
	rolls = []
    ;

    args.forEach(
	function (arg) {
	    if (arg.match(/d/)) {
		var yarr = arg.split('d');
		    n	 = parseInt(yarr[0]),
		    d	 = parseInt(yarr[1])
		;

		rolls.push({ num : n, die : d });
	    }
	    else {
		constant += parseInt(arg);
	    }
	}
    );

    return {
	const : constant,
	rolls : rolls
    };
}


function mkroll (r) {
    var results = [];

    for (var i = 1; i <= r.num; i++) {
	var result = [];

	for (var j = 1; j <= r.die; j++) {
	    result[j] = 1;
	}

	results.push( result );
    }

    return results;
}


function poly_multiply (p1, p2) {
    var result = [];

    for (var i = 1; i < p1.length; i++) {
	for (var j = 1; j < p2.length; j++) {
	    var k = i + j;
	    var a = (p1[i] || 0) * (p2[j] || 0);
	    result[k]  = result[k] || 0;
	    result[k] += a;
	}
    }

    return result;
}


function megamul (polys) {
    var result = polys.shift();

    polys.forEach(
	function (p) {
	    result = poly_multiply(result, p);
	}
    );

    return result;
}


