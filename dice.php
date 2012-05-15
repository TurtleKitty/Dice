#!/usr/bin/php
<?php

echo main($argv);



function main ($args) {
    $params = parse($args);

    $polys = array();

    $combinations = 1;

    foreach ($params["rolls"] as $r) {
	$combinations *= pow($r["die"], $r["num"]);
	$polys = array_merge($polys, mkroll($r));
    }

    $bigpoly = megamul($polys);

    $final = array();

    foreach($bigpoly as $x) {
	$final[] = $x / $combinations;
    }

    $output = "\n";

    for($exp = 1; $exp < count($final); $exp++) {
	$coeff = $final[$exp];

	if ($coeff > 0) {
	    $output .= sprintf(
		"%d\t\t%.5f\t\t%s\n",
		$exp + $params["const"],
		$final[$exp],
		str_repeat("#", round(500 * $final[$exp]))
	    );
	}
    }

    return $output . "\n";
}


function parse ($args)  {
    $constant = 0;

    $rolls = array();

    foreach ($args as $t) {
	if (strpos($t, "d")) {
	    $yarr = explode("d", $t);
	    $rolls[] = array("num" => $yarr[0], "die" => $yarr[1]);
	}
	else {
	    $constant += $t;
	}
    }

    return array(
	"const" => $constant,
	"rolls" => $rolls
    );
}


function mkroll ($r) {
    $results = array();

    for ($i = 1; $i <= $r["num"]; $i++) {
	$result = array(0);

	for ($j = 1; $j <= $r["die"]; $j++) {
	    $result[$j] = 1;
	}

	$results[] = $result;
    }

    return $results;
}


function poly_multiply ($p1, $p2) {
    $ct1 = count($p1);
    $ct2 = count($p2);
    $result = array_fill(0, $ct1 + $ct2 - 1, 0);

    for ($i = 1; $i < $ct1; $i++) {
	for ($j = 1; $j < $ct2; $j++) {
	    $t1 = isset($p1[$i]) ? $p1[$i] : 0;
	    $t2 = isset($p2[$j]) ? $p2[$j] : 0;
	    $result[ $i + $j ] += $t1 * $t2;
	}
    }

    return $result;
}


function megamul ($polys) {
    $result = array_shift($polys);

    foreach($polys as $p) {
	$result = poly_multiply($result, $p);
    }

    return $result;
}


?>
