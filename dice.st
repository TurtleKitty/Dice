

Object subclass: Poly [
    | degree coeffz |

    Poly class [
	new: cz [
	    |rv|

	    rv := super new.
	    rv init: (cz size) coeffz: cz.
	    ^rv
	]

	mkroll: n [
	    |sv|

	    sv := Array new: n.
	    1 to: n do: [:i | sv at: i put: 1].
	    ^self new: sv
	]
    ]

    init: deg coeffz: cz [
	degree := deg.
	coeffz := cz.
	^self
    ]

    getDegree [ ^degree ]
    getCoeff: n [ ^coeffz at: n ]

    show [
	1 to: degree do: [:i| (coeffz at: i) printNl ]
    ]

    * otherPoly [
	| noob oDeg newD k |

	oDeg := otherPoly getDegree.
	newD := oDeg + degree.
	noob := Array new: newD.

	1 to: newD do: [:x| noob at: x put: 0].

	1 to: degree do: [:i|
	    1 to: oDeg do: [:j|
		k := i + j.
		noob at: k
		    put: (noob at: k) + ((coeffz at: i) * (otherPoly getCoeff: j)).
	    ]
	].

	^Poly new: noob
    ]

    / scalar [
	| noob |

	noob := Array new: degree.

	1 to: degree do: [:i|
	    noob at: i
		put: (self getCoeff: i) / scalar asFloat
	].

	^Poly new: noob
    ]
]

const  := 0.
combos := 1.
polys  := OrderedCollection new.

Smalltalk arguments do: [:arg|
    (arg =~ 'd')
    ifMatched: [:x|
	pair := arg subStrings: $d.
	num  := (pair at: 1) asInteger.
	die  := (pair at: 2) asInteger.

	combos := combos * (die raisedTo: num).

	1 to: num do: [:i|
	    polys add: (Poly mkroll: die)
	]
    ]
    ifNotMatched: [
	const := const + arg
    ]
].

bigpoly := Poly mkroll: 1.

polys do: [:poly|
    bigpoly := bigpoly * poly
].

bigpoly := bigpoly / combos.

1 to: (bigpoly getDegree) do: [:i|
    n  := i + const.
    p  := (bigpoly getCoeff: i).
    hg := (0.5 + (500 * p)) floor.
    n display. ' ' display.
    p display. ' ' display.
    hg display. ' ' displayNl.
    "And here is where the output will go..."
].

(Poly mkroll: 6) getCoeff: 1 displayNl

