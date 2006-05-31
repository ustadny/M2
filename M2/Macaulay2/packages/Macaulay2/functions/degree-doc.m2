--- status: DRAFT
--- author(s): M. Stillman
--- notes: 

document {
     Key => "xdegree (old)",
     Headline => "the degree",
     TT "degree X", " -- returns the degree of a polynomial, vector, 
     matrix, monomial, or module.",
     PARA{},
     "The degree may be an integer, or a vector of integers.  The length
     of that vector is referred to as the 'number of degrees', and is
     provided by ", TO "degreeLength", ".",
     PARA{},
     EXAMPLE {
	  "R = ZZ/101[x,y,z]",
      	  "degree (x^2+y^2)^5",
      	  "F = R^{2,3,4}",
      	  "v = F_2",
      	  "degree v",
	  },
     "The degree of a module of finite length is the same as its length.",
     EXAMPLE "degree cokernel symmetricPower ( 2, vars R )",
     PARA{},
     "Implemented with a method of the same name."
     }

undocumented {
	  (degree, MonomialIdeal),
	  (degree, CoherentSheaf),
	  (degree, ZZ),
	  (degree, QQ),
	  (degree, RRR),
	  (degree, CCC),
	  (degree, RR),
	  (degree, CC)
	  }

document { 
     Key => degree,
     "Degree is a common name, meaning different things for different 
     kinds of mathematical objects.  In Macaulay 2, there are currently three
     related, yet different notions of degree: ",
     HEADER3 "Degree of polynomials or vectors of such",
	  UL {
	  TO (degree,RingElement),
	  TO (degree,Vector),
	  TO (degree,RingElement,RingElement),
	  TO (degree,ProjectiveHilbertPolynomial)
	  },
	  HEADER3 "Degree of ideals, varieties and modules",
	  UL {
	  TO (degree,Ideal),
	  TO (degree,Ring),
	  TO (degree,Module),
	  TO (degree,ProjectiveVariety)
	  },
	  HEADER3 "Degree of homomorphisms",
	  UL {
	  TO (degree,Matrix),
	  TO (degree,ChainComplexMap),
	  TO (degree,GradedModuleMap)
	  },
     SeeAlso => {degreeLength, degreesRing, "multigraded polynomial rings"}
     }
document { 
     Key => (degree,ProjectiveVariety),
     Usage => "degree X",
     Inputs => { "X" },
     Outputs => {
	  ZZ => {"the degree of ", TT "X"}
	  },
     EXAMPLE {
	  "S = ZZ/32003[x,y,z];",
	  "I = ideal(x^4-4*x*y*z^2-z^4-y^4);",
	  "R = S/I;",
	  "X = variety I",
	  "degree X"
	  },
     "The degree of a projective variety ", TT "X = V(I) = Proj R", " is the degree
     of the homogeneous coordinate ring ", TT "R = S/I", " of ", TT "X", ".",
     EXAMPLE {
          "degree X == degree I",
	  "degree X == degree R"
	  },
     SeeAlso => {(degree,Ideal),variety, "varieties"}
     }
document { 
     Key => (degree,ProjectiveHilbertPolynomial),
     Usage => "degree f",
     Inputs => {
	  "f" => {"usually returned via ", TO "hilbertPolynomial"}
	  },
     Outputs => {
	  ZZ => "the degree of any graded module having this hilbert polynomial"
	  },
     "This degree is obtained from the Hilbert polynomial ", TT "f", " as follows:
     if ", TT "f = d z^e/e! + lower terms in z", ", then ", TT "d", " is returned.
     This is the lead coefficient of the highest", TT "P^e", " in the ", TO ProjectiveHilbertPolynomial,
     " display.",
     EXAMPLE {
	  "R = QQ[a..d];",
	  "I = ideal(a^3, b^2, a*b*c);",
	  "F = hilbertPolynomial I",
	  "degree F"
	  },
     "The degree of this polynomial may be recovered using ", TO dim, ":",
     EXAMPLE {
	  "dim F"
	  },
     "The dimension as a projective variety is also one less that the Krull dimension of ", TT "R/I",
     EXAMPLE {
	  "(dim I - 1, degree I)"
	  },
     SeeAlso => {hilbertPolynomial}
     }
document { 
     Key => (degree,Ideal),
     Usage => "degree I",
     Inputs => {
	  "I" => "in a polynomial ring or quotient of a polynomial ring"
	  },
     Outputs => {
	  ZZ => {"the degree of the zero set of ", TT "I"}
	  },
     "The degree of an ideal ", TT "I", " in a ring ", TT "S", " is the degree of the module 
     ", TT "S/I", ".  See ", TO (degree,Module), " for more details.",
     EXAMPLE {
	  "S = QQ[a..f];",
	  "I = ideal(a^195, b^195, c^195, d^195, e^195);",
	  "degree I",
	  "degree(S^1/I)",
	  },
     "If the ideal is not homogeneous, then the degree returned is the degree of the
     ideal of initial monomials (which is homogeneous).  If the monomial order is 
     a degree order (the default), this is the same as the degree of the 
     projective closure of the zero set of ", TT "I", ".",
     EXAMPLE {
	  "I = intersect(ideal(a-1,b-1,c-1),ideal(a-2,b-1,c+1),ideal(a-4,b+7,c-3/4));",
	  "degree I"
	  },
     SeeAlso => {dim, codim, genus, genera, hilbertSeries, reduceHilbert, poincare, hilbertPolynomial}
     }
document { 
     Key => (degree,Module),
     Usage => "degree M",
     Inputs => {
	  "M" => "over a polynomial ring or quotient of a polynomial ring, over a field k"
	  },
     Outputs => {
	  ZZ => {"the degree of ", TT "M"}
	  },
     "We assume that ", TT "M", " is a graded module over a singly graded 
     polynomal ring or a quotient of a polynomial ring, 
     over a field ", TT "k", ".",
     PARA{},
     "If ", TT "M", " is finite dimensional over ", TT "k", ", the degree of ", TT "M", " is its dimension over ", TT "k", ".  Otherwise, 
     the degree of ", TT "M", " is the integer ", TT "d", " such that the hilbert polynomial of ", TT "M", "
     has the form ", TT "z |--> d z^e/e! + lower terms in z.",
     EXAMPLE {
	  "R = ZZ/101[x,y,z];",
	  "degree cokernel symmetricPower ( 2, vars R )"
	  },
     Caveat => {"The degree in multigraded rings is not defined.  If the base ring is ZZ, it is likely
	  that the answer is not what you would expect.  Similarly, if the degrees of the variables
	  are not all one, the answer is harder to interpret."},
     SeeAlso => {hilbertPolynomial}
     }
document { 
     Key => (degree,Ring),
     Usage => "degree R",
     Inputs => {
	  "R" => "a quotient of a polynomial ring"
	  },
     Outputs => {
	  ZZ => {"the degree of ",  TT "R"}
	  },
     "If ", TT "R = S/I", ", where ", TT "S", " is a polynomial ring, then the degree of ", TT "R", " is
     by definition the degree of ", TT "I", ", or the degree of the ", TT "S", "-module ", TT "R", ".",
     "  See ", TO (degree,Module), " for more details.",
     EXAMPLE {
	  "R = QQ[a..d]/(a*d-b*c, b^2-a*c, c^2-b*d)",
	  "degree R",
	  },
     SeeAlso => {(degree,Module)}
     }
document { 
     Key => {(degree,Matrix),
	  (degree,ChainComplexMap),
	  (degree,GradedModuleMap)},
     Headline => "",
     Usage => "",
     Inputs => {
	  },
     Outputs => {
	  },
     Consequences => {
	  },     
     "description",
     EXAMPLE {
	  },
     Caveat => {},
     SeeAlso => {}
     }
document { 
     Key => {(degree,RingElement),(degree,Vector)},
     Usage => "degree f",
     Inputs => {
	  "f" => {"a ", TO2(RingElement, "ring element"), 
	       "or ", TO2(Vector, "vector")}
	  },
     Outputs => {
	  List => {"the degree or multidegree of ", TT "f"}
	  },
     "In Macaulay2, the degree of a polynomial is a list of integers.
     This is to accomodate polynomial rings having multigradings.  The 
     usual situation is when the ring has the usual grading: each variable has
     length 1.",
     EXAMPLE {
	  "R = QQ[a..d];",
	  "degree (a^3-b-1)^2",
	  },
     "When not dealing with multigraded rings, obtaining the degree as a number
     is generally more convenient:",
     EXAMPLE {
	  "first degree (a^3-b-1)^2"
	  },
     EXAMPLE {
	  "S = QQ[a..d,Degrees=>{1,2,3,4}];",
	  "first degree (a+b+c^3)"
	  },
     EXAMPLE {
	  "T = QQ[a..d,Degrees=>{{0,1},{1,0},{-1,1},{3,4}}];",
	  "degree c",
	  },
     "In a multigraded ring, the degree of a polynomial whose terms
     have different degrees is perhaps non-intuitive: it is the 
     maximum (in each of the component degree) over each term:",
     EXAMPLE {
	  "degree c^5",
	  "degree d",
	  "degree (c^5+d)"
	  },
     Caveat => {},
     SeeAlso => {isHomogeneous, degreeLength}
     }
document { 
     Key => (degree,RingElement,RingElement),
     Headline => "degree with respect to a variable",
     Usage => "degree(f,x)",
     Inputs => {
	  "f" => {"in a polynomial ring ", TT "R"},
	  "x" => {"a variable in the same ring"},
	  },
     Outputs => {
	  ZZ => {"highest power of ", TT "x", " occuring in ", TT "f"}
	  },
     EXAMPLE {
	  "R = QQ[a..d];",
	  "degree(a*b^5+b^7-3*a^10-3, b)"
	  },
     Caveat => {},
     SeeAlso => {}
     }




///
R = QQ[a..d,Degrees=>{{0,1},{1,0},{-1,1},{-2,1}}]
I = ideal(a,c)
hf = poincare I
T_0 * oo
use ring oo
hf % (1-T_0)

factor oo
degree I

///

 -- doc1.m2:512:     Key => degreeLength,
 -- doc6.m2:361:     Key => degreesRing,
 -- doc6.m2:572:     Key => degreesMonoid,
 -- overviewB.m2:270:     Key => "dimension, codimension, and degree",
 -- overviewC.m2:1312:     Key => "degree and multiplicity of a module",

end


document { 
     Key => (degree,CoherentSheaf),
     Usage => "",
     Inputs => {
	  },
     Outputs => {
	  },
     "I suggest that we remove this function.",
     "The degree of the underlying module.",
     EXAMPLE {
	  R = QQ[a..d]
	  I = comodule ideal(a^2,b^2,c^2,d^2)
	  F = sheaf I
	  degree F
	  degree HH^0(F(>=0))
	  },
     Caveat => {},
     SeeAlso => {}
     }
