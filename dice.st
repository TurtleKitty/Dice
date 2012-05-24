

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
	1 to: degree do: [:i| i display. ' ' display. (coeffz at: i) displayNl ]
    ]

    * other [
	| noob oDeg newD k |

	(other isNumber)
	    ifTrue: [
		"scalar"
		noob := Array new: degree.
		1 to: degree do: [:i| noob at: i put: (coeffz at: i) * other ].
		^Poly new: noob.
	    ]
	    ifFalse: [
		"Poly"
		oDeg := other getDegree.
		newD := oDeg + degree.
		noob := Array new: newD.

		1 to: newD do: [:x| noob at: x put: 0].

		1 to: degree do: [:i|
		    1 to: oDeg do: [:j|
			k := i + j.
			noob at: k
			    put: (noob at: k) + ((coeffz at: i) * (other getCoeff: j)).
		    ]
		].

		^Poly new: noob
	    ]
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
	const := const + arg asInteger
    ]
].

bigpoly := 1.

polys do: [:poly|
    bigpoly := poly * bigpoly.
].

bigpoly := bigpoly / combos.

floatFormatter := [:x| ((x roundTo: 0.00001) * 1e5) rounded / 1e5 ].

histogram := [:x|
    n	 := (0.5 + (500 * x)) floor.
    hg	 := ''.
    mark := $# asString. 
    1 to: n do: [:i| hg := hg, mark ].
    hg
].

tb := Character tab asString.
nl := Character lf asString.
tt := tb, tb.

output := nl.

1 to: (bigpoly getDegree) do: [:i|
    num  := const + i.
    pr   := (bigpoly getCoeff: i).

    (pr > 0) ifTrue: [
	hig := histogram value: pr.
	prf := (floatFormatter value: pr) asString.
	
	output := (output, num asString, tt, prf, tt, hig, nl).
    ].
].

output displayNl.



