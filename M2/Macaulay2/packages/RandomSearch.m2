newPackage ("RandomSearch",
       	Version => "0.1", 
    	Date => "November 9, 2006",
    	Authors => {
	     {Name => "Mike Stillman", Email => "mike@math.cornell.edu"},
	     {Name => "David Eisenbud", Email => "de@msri.org"}
	     },
    	Headline => "random search for interesting examples",
    	DebuggingMode => false
    	)

export {search,
     randomBinomialFcn, 
     EMailAddress,
     AnnounceTime,
     MailInterval,
     Iterations,
     RandomSeed,
     FileName,
     RegularityBound,
     NumVariables,
     NumGenerators,
     randomSparseIdeal     
     }

seed := null;
header := null;
exampleFcn := null;
searchOpts := null;
lastdone := null;
lastemail := 0;

-- We must be careful to not send too many emails!
-- So we limit the number to one per searchOpts.MailInterval seconds.
appendToFile = (filename, str) -> ("!cat >>"|filename) << str << close

emailString = (str, subject, address) -> (
     if address =!= null then (
     	  appendToFile(tempfilename, str);
	  if currentTime() - lastemail >= searchOpts.MailInterval
	  then (
     	       run ("mail -s "|subject|" "|address|" <"|tempfilename);
     	       tempfilename << header << close;
	       lastemail = currentTime();
	       );
     ))

handleExample = (i,str) -> (
     F := "ex "|i|" "|str;
     -- display on screen
     << F << flush;
     -- append to example file
     appendToFile(examplefilename, F);
     -- email to user
     emailString(F, "found", searchOpts.EMailAddress);
     )

handleBad = (i) -> (
     F := "no examples found in last "|searchOpts.AnnounceTime|" seconds working on ex "|i|"\n";
     -- display on screen
     << F << flush;
     -- email to user
     emailString(F, "looking", searchOpts.EMailAddress);
     )

doLoop = (niterations) ->
  for i from 1 to niterations do (
     --if i % 10 === 0 then collectGarbage();
     if currentTime() - lastdone > searchOpts.AnnounceTime then (
	  << "doing i = " << i << endl;
     	  handleBad i;	  
       	  lastdone = currentTime();
       );
     str := exampleFcn();
     if str =!= null then (
	  handleExample(i,str);
	  lastdone = currentTime();
	  );
     )

search = method(Options => {
	  EMailAddress => null, --"mes15@cornell.edu",
	  AnnounceTime => 60*60*4, -- 4 hours (time in seconds)
	  MailInterval => 60*10, -- 10 minutes (time in seconds)
	  Iterations => 10000,
	  RandomSeed => null,
	  FileName => ""
	  })
	  
search(String,Function) := opts -> (head, fcn) -> (
     searchOpts = opts;
     exampleFcn = fcn;
     if opts.RandomSeed === null then
       seed = processID() * currentTime()
     else
       seed = opts.RandomSeed;
     setRandomSeed seed;
     tempfilename = temporaryFileName()|"-"|seed;
     header = head | "\n seed "|seed|" processID "|processID()|"\n";
     tempfilename << header << close;
     << "starting run of " << opts.Iterations << " examples" << endl;
     << header << flush;
     examplefilename = opts.FileName|"-"|processID();
     lastdone = currentTime();
     doLoop opts.Iterations;
     emailString("finished iteration\n", "done", searchOpts.EMailAddress);
     )

-- Test regularity and projective dimension of many ideals generated by quadrics
randomSparseIdeal = (B,r,n) -> (
     -- B is a list of monomials
     -- r is the size of each poly
     -- n is the number of polys
     -- returns an ideal
     S := ring B#0;
     ideal apply(n, j -> 
	  sum apply(r, i -> random coefficientRing S * B#(random(#B))))
     )

optsRandomBinomialFcn = {
	  RegularityBound => 11,
	  NumVariables => 10,
	  NumGenerators => 7,
	  Degree => 2,
	  CoefficientRing => ZZ/5
	  }
     
randomBinomialFcn = optsRandomBinomialFcn >> opts -> () -> (
     numvars := opts.NumVariables;
     numgenerators := opts.NumGenerators;
     deg := opts.Degree;
     kk := opts.CoefficientRing;
     regBound := opts.RegularityBound;
     R := kk[vars(0..numvars-1)];
     B := flatten entries basis(deg,R);
     fcn := () -> (
	  I := randomSparseIdeal(B,2,numgenerators);
	  r := regularity I;
	  if codim I < numgenerators and r >= regBound
	  then " regularity "|r|" "|toExternalString I|"\n"
	  else null);
     header := numgenerators|" polynomials of degree "|deg|" in "|toExternalString R;
     (header, fcn)
     )

beginDocumentation()

end
restart
load "/Users/mike/M2/Macaulay2/packages/RandomSearch.m2"

search splice (randomBinomialFcn(
	  NumVariables => 10,
	  NumGenerators => 7,
  	  Degree => 2,
          RegularityBound => 10,
	  CoefficientRing => ZZ/5),
  EMailAddress => "mes15@cornell.edu",
  MailInterval => 60*30,
  AnnounceTime => 60*1, 
  Iterations => 1000000,
  FileName => "blah"
  )
     
-- ideal (2*b*e+2*c*f,-e*h+i*j,-2*e^2-2*g^2,-c*e-g*h,-2*d*j,a*g-c*i)
load "/nfs/homes4/mike/M2/Macaulay2/packages/RandomSearch.m2"

-- regularity 12 ideal (2*f*h+e*i,-2*b^2-d*i,-a*g-2*i^2,2*e*g-2*d*h,-2*a*b-a*g,-2*d^2+a*i,-2*f^2-b*g)

-- Below this is MES test for memory leak, 10 Nov 2006
--load "/Users/mike/M2/Macaulay2/packages/RandomSearch.m2"

kk = ZZ/5
R = kk[vars(0..10-1)];
B = flatten entries basis(2,R);
J = ideal (h*i-2*d*j,g*i+2*i^2,d*g+2*h*j,f^2+2*a*i,b*f-2*g^2,c^2+h*j,b*c+2*c*f)
--betti res(J = randomSparseIdeal(B,2,7))
G = () -> (
     I := ideal flatten entries gens J;
     r := regularity I;
     if codim I < 7 and r >= 10
     then << (" regularity "|r|" "|toExternalString I|"\n")
     else null
     )

G1 = () -> (
     collectGarbage();
     I := ideal flatten entries gens J;
     r := regularity I;
     if codim I < 7 and r >= 10
     then << (" regularity "|r|" "|toExternalString I|"\n")
     else null
     )

H = () -> (
     I := ideal flatten entries gens J;
     C := res I;
     )

collectGarbage()
-- look at stash (4 slabs, 124.72 MB virtual) (amounts are in debug version)

time for i from 1 to 100 do (x := G(); if x =!= null then << x << flush)
collectGarbage()
-- at 274.59 MB, #slabs = 23566, gbvector alloc 221k

time for i from 1 to 1000 do (x := G(); if x =!= null then << x << flush)
collectGarbage()
-- at 590.84 MB, #slabs = 66731, gbvector alloc 624k

time for i from 1 to 1000 do (x := G(); if x =!= null then << x << flush)
collectGarbage()
-- at 723.59 MB, #slabs = 84449, gbvector alloc 788k

--------------------------------------
-- G1
collectGarbage()
-- look at stash (4 slabs, 124.72 MB virtual) (amounts are in debug version)

time for i from 1 to 100 do (x := G1(); if x =!= null then << x << flush)
collectGarbage()
-- at 124.84 MB, #slabs = 1348, gbvector alloc 13k

time for i from 1 to 1000 do (x := G1(); if x =!= null then << x << flush)
collectGarbage()
-- at 124.84 MB, #slabs = 1348, gbvector alloc 13k
