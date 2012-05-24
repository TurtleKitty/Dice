

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


p := Poly new: #(1 1 1 1 1 1).
q := Poly mkroll: 6.
r := p * q.
r show.
(r / 36) show.

