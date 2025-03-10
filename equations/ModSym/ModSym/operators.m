freeze;
 
/****-*-magma-* EXPORT DATE: 2004-03-08 ************************************
                                                                            
                   HECKE:  Modular Symbols in Magma                          
                            William A. Stein                                 
                                                                            
   FILE: operators.m (Hecke and other operators)                            

   02/15/03: WAS -- Exported HeckeImages and HeckeImagesAll.   

   02/15/03: WAS -- deleted old version of XXXTnSparse.

   Revision 1.22 2004/01/03 William
   Improved AtkinLehnerSign so it works even when
   the W_q are not all scalars.  

   Revision 1.21  2002/08/25 19:39:47  was
   Add a little support for multichar spaces.

   Revision 1.20  2002/02/19 02:31:25  was
   ...?

   Revision 1.19  2001/09/15 19:26:15  was
   There is definitely a bug in operators.m when the characteristic is p.
   Sometimes Hecke operators don't commute.  Switching to NOT using Heilbronn
   matrices, does not fix the problem; in fact it makes the problem occur.
   However, switching to using heilbronn matrices "fixed" the problem.
   I will have to resolve this at some point.  For now, mod-p modular symbols
   should be used carefully.

   Revision 1.18  2001/08/11 21:06:50  was
   nothing.

   Revision 1.17  2001/07/03 20:00:26  was
   nothing.

   Revision 1.16  2001/07/03 19:57:21  was
   Changed back to using XXXP1GeneralizedWeightAction.

   Revision 1.15  2001/06/07 01:45:55  was
   HeilbronnMerel is now in C.

   Revision 1.14  2001/06/07 01:28:09  was
   Replaced HeilbronnMerel by Allan's amazing optimized HeilbronnMerel.
   Named the old version "XXXHeilbronnMerel".

   Revision 1.13  2001/06/07 01:20:37  was
   Switched to using the C version of HeilbronnCremona, because it is much faster
   and now works.

   Revision 1.12  2001/05/30 19:17:43  was
   ?

   Revision 1.11  2001/05/29 05:35:20  was
   Added AtkinLehnerOperator as a synonym for AtkinLehner.

   Revision 1.10  2001/05/26 10:59:03  was
   ..

   Revision 1.9  2001/05/26 10:54:59  was
   Changed dual_hecke_operator thingy into a list.

   Revision 1.8  2001/05/25 11:04:11  was
   Fixed small bug in function HeckeOperatorHeilbronn(M, Heil) : it returned the wrong type of 0
   in the case when M has dimension 0.

   Revision 1.7  2001/05/25 03:05:33  was
   Changed ThetaOperator comment.

   Revision 1.6  2001/05/18 04:51:47  was
   Removed import of ValueList because it is now an intrinsic.

   Revision 1.5  2001/05/17 04:07:54  was
   removed space from comment for star involution.

   Revision 1.4  2001/05/16 21:06:05  was
   Fixed a coercion error in FastTn.

   Revision 1.3  2001/05/13 03:51:07  was
   Changed ModularForms flag to ModularSymbols.

   Revision 1.2  2001/04/20 05:06:03  was
   Added "IntegralHeckeOperator."

   Revision 1.1  2001/04/20 04:47:00  was
   Initial revision

   Revision 1.18  2001/04/14 01:42:54  was
   I coded TnSparse over finite fields.

   Revision 1.17  2001/04/13 21:37:34  was
   TODO : TnSparse -- rewrite this function when base field has characteristic p!!!!
          Need to use non-Merel definition of Hecke operator.

   Revision 1.16  2001/04/13 18:36:44  was
   I fixed a bug which sometimes occured when computing Hecke operators
   T_p on spaces of modular symbols in characteristic ell using Merel's
   description of the Hecke operators directly on Manin symbols.  Here's
   an example of the bug --
       M := ModularSymbols(5,8,GF(2)); HeckeOperator(M,2) and
       HeckeOperator(M,2) then don't commute.
   It appears that Merel's description of Hecke simply doesn't apply in
   finite characteristic, unless the finite-characteristic object is
   the direct reduction of an integral basis for the char-0 object.
   For now, I've changed so that the Hecke operators in finite characteristic
   are computed directly on modular symbols.  This is slower, but it
   must be correct.

   Revision 1.15  2001/02/12 23:29:35  was
   nothing.

   Revision 1.14  2001/02/12 20:14:01  was
   temporarily use
     intrinsic Hecke(M::ModSym, Heil::SeqEnum) -> .
   ...

   Revision 1.13  2001/02/08 01:20:06  was
   nothing

   Revision 1.12  2001/02/07 22:40:06  was
   nothing.

   Revision 1.11  2000/10/28 11:07:31  was
   Added parameter to HeckeFieldSpan

   Revision 1.10  2000/10/28 11:05:58  was
   Added a bound parameter to HeckeSpan.

   Revision 1.9  2000/09/24 15:53:35  was
   Allow atkin-lehner for quadratic character, even though W_q doesn't
   commute with Hecke!

   Revision 1.8  2000/09/09 20:59:41  was
   Removed import of Round from arith.m, because now Round is a part of Magma.

   Revision 1.7  2000/06/22 08:17:42  was
   Fixed bug in Hecke bound.Only increased bound if verbose on!!!

   Revision 1.6  2000/06/21 05:37:03  was
   Added HeckeFieldSpan

   Revision 1.5  2000/06/03 04:53:05  was
   verbose: ModularForm --> ModularForms

   Revision 1.4  2000/06/03 04:11:26  was
   Round

   Revision 1.3  2000/05/25 23:54:56  was
   fixed up HeckeBound comment.

   Revision 1.2  2000/05/03 14:49:37  was
   quick fix:   if #sparsevec eq 0 then

   Revision 1.1  2000/05/02 08:04:02  was
   Initial revision

                                                                            
 ***************************************************************************/



/* IDEA FOR OPTIMIZATION!!!!

The following trick makes it possible to efficiently compute T_p on 
Representation(M), for p large. 

   1) Precompute elements A1,...,An of the Hecke algebra such that
      the dimension of span(A1,...,An) = dim(M). 
   2) Find columns i_1,...,i_m such that 
            dimension ( col ( A1,..., An) ) = dim(M).
   3) Precompute a matrix B such that for any T in Hecke algebra 
            B * (col's i_1,...,i_m of T) = T (as a lin comb of A1...An)

*/   

import "../GrpGL2Hat/GrpGL2Hat/misc.m" :
   Conjugates,
   IsConjugate;

import "arith.m": 
   NthPrime,
   PrimePos;

import "core.m": 
   ConvFromModularSymbol,
   ConvToModularSymbol,
   CosetReduce,
   get_phi,
   lev1_ManinSymbolsGeneralizedWeightedAction,
   ManinSymbolsGeneralizedWeightedAction,
   ModularSymbolsBasis,
   P1GeneralizedWeightedAction,
   UnwindManinSymbol;

import "dims.m": 
   idxG0, 
   idxG1;

import "inner_twists.m":
   FieldAutomorphismMatrix;

import "linalg.m": 
   MakeLattice,
   Pivots,
   Restrict,
   RestrictionOfScalars;

import "multichar.m":
   MC_AtkinLehnerOperator,	    
   MC_HeckeOperator,
   MC_DualHeckeOperator,
   MC_StarInvolution; 

forward             
   ActionOnModularSymbolsBasis,
   ActionOnModularSymbolsBasisElement,
   HeckeOperatorDirectlyOnModularSymbols,
   HeckeOperatorHeilbronn,
   HeckeOperator_OnSubspace_UsingComplement,
   Heilbronn,
   TnSparse;


/*********************************************************
 *                                                       *
 *        COMPUTE HECKE OPERATORS                        *
 *                                                       *
 *********************************************************/

function XXXAllanHeilbronnMerel(n)  // it's now in C.
// Return Heilbronn matrices of determinant n, as given by Merel.
//   Here n can be composite.
 
   H := [];
   for a in [1..n] do
      // ad-bc=n so c=0 and ad=n, or b=(ad-n)/c
      // Must have ad - n >= 0, so d must be >= Ceiling(n/a).

      q := n div a;
      if q*a eq n then
         d := q;
         for b in [0..a-1] do
            Append(~H,[a,b,0,d]);
         end for;
         for c in [1..d-1] do
            Append(~H,[a,0,c,d]);
         end for;
      end if;
 
      for d in [q + 1 .. n] do
          bc := a*d - n;
 
          // Divisor c of bc must satisfy Floor(bc/c) lt a and c lt d.
          // c ge (bc div a + 1)  <=>  Floor(bc/c) lt a  (for integers)
          // c le d - 1           <=>  c lt d

          for c in [bc div a + 1 .. d - 1] do
             if IsDivisibleBy(bc, c) then
                Append(~H, [a,bc div c,c,d]);
             end if;
          end for;
      end for;
   end for;
   return H;
end function;

function XXXHeilbronnMerel(n) 
//Return Heilbronn matrices of determinant n, as given by Merel.
//   Here n can be composite.
   H := [];
   i := 0;
   for a in [1..n] do
      for d in [1..n] do;
         // ad-bc=n so c=0 and ad=n, or b=(ad-n)/c
        bc := a*d - n;
        if bc lt 0 then
           continue;
        end if;
        if bc eq 0 then
           for b in [0..a-1] do
              Append(~H,[a,b,0,d]); 
           end for;
        end if;
        if bc ne 0 then
           for c in Divisors(Abs(bc)) do
              if c lt d and Floor(bc/c) lt a then
                 Append(~H,[a,Floor(bc/c),c,d]);
              end if;
           end for;
        elif 0 lt a then
           for c in [1..d-1] do 
              Append(~H,[a,0,c,d]);
           end for;
        end if;                 
     end for;
   end for;
   return H;
end function;


// This has been put in C for a factor of 10 speed up, so is
// never called.
function XXXHeilbronnCremona(p)     
// Return the Heilbronn matrices of determinant p, as defined by Cremona.
   assert IsPrime(p); //: "Argument 1 must be prime.";
   if p eq 2 then
      return [[1,0, 0,2], [2,0, 0,1], [2,1, 0,1], [1,0, 1,2]];
   end if;
   ans := [[1,0, 0,p]];
   for r in [Ceiling(-p/2)..Floor(p/2)] do
      x1:=p; x2:=-r; y1:=0; y2:=1; a:=-p; b:=r; c:=0; x3:=0; y3:=0; q:=0;
      Append(~ans, [x1,x2, y1,y2]);
      while b ne 0 do
         q := Round(a/b);
         c := a-b*q;
         a := -b;
         b := c;
         x3 := q*x2-x1; 
         x1 := x2; x2 := x3; y3 := q*y2-y1; y1 := y2; y2 := y3;
         Append(~ans, [x1,x2, y1, y2]);
      end while;
   end for;
   return ans;
end function;

// TO DO: revise? (was this another memory management patch?)

get, set := NewEnv(["heilbronn_cremona"]);
set("heilbronn_cremona",[]);

intrinsic DeleteGlobalModularFormsData()
{Deletes globally cached data (this data speeds up computation
 of ALL spaces of modular forms/symbols)}

   set("heilbronn_cremona",[]);
end intrinsic;

function Heilbronn(M, n, Merel) 
   assert Type(M) eq ModSym;
   assert Type(n) eq RngIntElt;
   assert Type(Merel) eq BoolElt;
// {A 2-tuple.  The first entry gives the sequence of Heilbronn 
// matrices of determinant n as matrices in characteristic 0.
// The second gives the matrices in characterisic N, where N is
// the level of M.  If M has weight 2, then the second entry should be ignored.}

// T := Cputime();

// If Merel is true, then FORCE use of (one of) Merel's definitions.
   assert n ge 1;
   if not Merel then
      heilbronn_cremona := get("heilbronn_cremona");
      if exists(i) { i : i in [1..#heilbronn_cremona]
                               | heilbronn_cremona[i][1] eq n } then
         char0 := heilbronn_cremona[i][2];
         AlgZmodN := MatrixAlgebra(IntegerRing(Level(M)),2);
         charN := [AlgZmodN | h : h in char0];
         return <char0, charN>;
      end if;
   end if;
/*
   M := AmbientSpace(M);
   if not assigned M`heilbronn_cremona then
      M`heilbronn_cremona := [];
   end if;
   if not assigned M`heilbronn_merel then
      M`heilbronn_merel := [];
   end if;

   if Merel then
      if exists(i) { i : i in [1..#M`heilbronn_merel]
                               | M`heilbronn_merel[i][1] eq n } then
         return M`heilbronn_merel[i][2];
      end if;
   else
      if exists(i) { i : i in [1..#M`heilbronn_cremona]
                               | M`heilbronn_cremona[i][1] eq n } then
         return M`heilbronn_cremona[i][2];
      end if;
   end if;
*/
     
   

   if IsPrime(n) and not Merel then
// "HeilbronnCremona", n;
      // H := HeilbronnCremona(n); 
	AlgZ := MatrixAlgebra(IntegerRing(),2);
	AlgZmodN := MatrixAlgebra(IntegerRing(Level(M)),2);
	char0, charN := HeilbronnCremona(n, AlgZ, AlgZmodN);
   else
// "HeilbronnMerel", n;
        H := HeilbronnMerel(n);
	AlgZ := MatrixAlgebra(IntegerRing(),2);
	AlgZmodN := MatrixAlgebra(IntegerRing(Level(M)),2);
	char0 := [AlgZ | h : h in H];
	charN := [AlgZmodN | h : h in char0];
   end if;

   ans := <char0, charN>;

   
/*   if Merel then
      Append(~M`heilbronn_merel, <n,ans>);
   else
      Append(~M`heilbronn_cremona, <n,ans>);
   end if;
*/


   if not Merel and n le 100 then
      Append(~heilbronn_cremona,<n,ans[1]>);
      set("heilbronn_cremona",heilbronn_cremona);
   end if;

// "Heilbronn func", n, Cputime(T);
   return ans;

end function;


///////////////////////////////////////////////////////////////
//  COMPUTATION of HECKE OPERATORS                           //
///////////////////////////////////////////////////////////////

intrinsic HeckeOperator(M::ModSym, n::RngIntElt) -> AlgMatElt
{A matrix representing the nth Hecke operator
with respect to Basis(M).}
   requirege n,1;
 
   require not assigned M`al_decomp or GCD(n,Level(M)) eq 1 : 
    "Hecke operators of index not coprime to the level are not defined on Atkin-Lehner factors.";

   if not assigned M`hecke_operator then
      M`hecke_operator := [];
   end if;
   if exists(i) { i : i in [1..#M`hecke_operator]
                             | M`hecke_operator[i][1] eq n } then
      return M`hecke_operator[i][2];
   end if;
   if IsVerbose("ModularSymbols") then
      printf "Computing T_%o on %ospace of dimension %o\n",
             n, IsAmbientSpace(M) select "ambient " else "", Dimension(M);
      t := Cputime();
   end if;

   if IsMultiChar(M) then
      if IsAmbientSpace(M) then
         T := MC_HeckeOperator(M,n);
      else
         T := Restrict(HeckeOperator(AmbientSpace(M),n),VectorSpace(M));
      end if;

   elif n eq 1 then

      T := MatrixAlgebra(BaseField(M),Dimension(M))!1;

   elif IsPrime(n) then
      if IsAmbientSpace(M) then
      // Before adjusting Heilbronn to work for our case        
        if (not IsOfGammaType(M))
	  and ( ( ( not IsGammaNS(M`G) ) and ( not IsGammaNSplus(M`G) ) and
		( GCD(n, Level(M)) ne 1 ) ) or
	        ( #Domain(M`G`DetRep) lt EulerPhi(Level(M)) ) ) then
	   T := HeckeOperatorDirectlyOnModularSymbols(M,n);
        else      
           use_cremona := BaseField(M) cmpeq RationalField() and Weight(M) eq 2 
                             and IsTrivial(DirichletCharacter(M));
	   T := HeckeOperatorHeilbronn(M, Heilbronn(M, n, not use_cremona));
        end if;

/*  Using "DirectlyOn" fails in this example!!
    G<a>:=DirichletGroup(109,GF(4));M:=ModularSymbols(a,2);
    T7:=HeckeOperator(M,7);T23:=HeckeOperator(M,23);
    T7*T23-T23*T7 eq 0;
    false
*/
      else
           
         if Characteristic(BaseField(M)) eq 0 and 
                Dimension(M) lt 0.5*Dimension(AmbientSpace(M)) then
            // Uses complements which don't work well in char p, since Hecke
            // isn't semisimple in char p.   I have no idea how often
            // 0.5*dim(amb) is the right cut off. 
            T := HeckeOperator_OnSubspace_UsingComplement(M,n);
         else
            T := Restrict(HeckeOperator(AmbientSpace(M),n), VectorSpace(M));
         end if;
      end if; 

   else

      fac := Factorization(n);
      if #fac eq 1 then
         // T_{p^r} := T_p * T_{p^{r-1}} - eps(p)p^{k-1} T_{p^{r-2}}.
         p  := fac[1][1];
         r  := fac[1][2];
         eps := DirichletCharacter(M);
         if IsOfGammaType(M) then
             eps_val := Evaluate(eps,p)*p^(Weight(M)-1);
	 elif Level(M) eq 1 then
	     eps_val := p^(Weight(M)-1);
	 elif Level(M) mod p ne 0 then
	     G := LevelSubgroup(M);
	     sigma_p := p * Matrix(G`DetRep(p mod Level(M))^(-2));
	     sigma_p := ImageInLevelGL(G)!sigma_p;
	     // It might be that we don't have here p^(k-1) - check
	     eps_val := Evaluate(eps, sigma_p)*p^(Weight(M)-1);
	 else
	   G := LevelSubgroup(M);
           eps_val := 0;
	   /*
	     if IsAmbientSpace(M) then
		 T := HeckeOperatorDirectlyOnModularSymbols(M,p : 
							    Squared := true);
	     elif Characteristic(BaseField(M)) eq 0 and 
		  Dimension(M) lt 0.5*Dimension(AmbientSpace(M)) then
		 // Uses complements which don't work well in char p, since Hecke
		 // isn't semisimple in char p.   I have no idea how often
		 // 0.5*dim(amb) is the right cut off. 
		 T := HeckeOperator_OnSubspace_UsingComplement(M,p^2);
	     else
		 T := Restrict(HeckeOperator(AmbientSpace(M),p^2),
			       VectorSpace(M));	 
	     end if;
	     
	     eps_mat := HeckeOperator(M,p)^2 - T;
	     assert IsScalar(eps_mat);
	     if NumberOfRows(eps_mat) eq 0 then
		 eps_val := 1;
	     else
		 eps_val := eps_mat[1,1];
	     end if;
	   */
	 end if;
	 T  := HeckeOperator(M,p) * HeckeOperator(M,p^(r-1))
               - eps_val*HeckeOperator(M,p^(r-2));
      else  // T_m*T_r := T_{mr} and we know all T_i for i<n.
          m  := fac[1][1]^fac[1][2];
          T  := HeckeOperator(M,m)*HeckeOperator(M,n div m);
      end if;            
   end if;

   Append(~M`hecke_operator,<n,T>);

   if IsVerbose("ModularSymbols") then
      printf "\t\t(%o s)\n",Cputime(t);
   end if;

   return T;
end intrinsic;


intrinsic IntegralHeckeOperator(M::ModSym, n::RngIntElt) -> AlgMatElt
   {A matrix representating the nth Hecke operator with respect to the basis for Lattice(M).}
   // Note, not currently cached.
   T := HeckeOperator(AmbientSpace(M),n);
   L := Lattice(M);
   V := VectorSpace(AmbientSpace(M));
   A := MatrixAlgebra(IntegerRing(),Dimension(M));
   return A!&cat[Coordinates(L,L!((V!L.i)*T)) : i in [1..Dimension(L)]];
end intrinsic;

function HeckeGeneralCaseRepresentativesDoubleCoset(G,alpha,H)
  // This is not very efficient but it works 
  H := Conjugate(G meet H, alpha) meet G;
  // What we really want here is just alpha * Transversal(G,H);
  reprs := [alpha * GL(2,Rationals())!Eltseq(x) :
		       x in CosetRepresentatives(H) | x in G];
  R := [Eltseq(g) : g in reprs];
  return R;
end function;

// Here we compute H

function HeckeGeneralCaseRepresentativesDoubleCoset2(G, alpha)
  GL2Q := GL(2, Rationals());
  M2Z := MatrixAlgebra(Integers(),2);
  D := Rationals()!LCM([Denominator(x) : x in Eltseq(alpha)]);
  det := Determinant(M2Z!(ScalarMatrix(2,D) * alpha));
  N := Level(G);

  if (GCD(det,N) eq 1) then
    // apparently, creation of the PSL2Subgroups is costly,
    // because of the transversl computation.
    // So we try very hard to go around it. 
    // gamma_alpha_conj := Conjugate(G, alpha : IsExactLevel := true);
    A := M2Z!(ScalarMatrix(2,D) * alpha);
    AmodN := ModLevelGL(G)!A;
    mod_N := Conjugate(ImageInLevelGL(G), AmodN);
    snf, x, y := SmithForm(A);
    quot := snf[2,2] div snf[1,1];
    y_mod := GL(2, Integers(det))!y;
    mod_det := Conjugate(ImageInLevelGL(GammaUpper0(quot) : N := det),
			 y_mod^(-1));
    gens_N := [[Integers()!y : y in Eltseq(x)] : x in Generators(mod_N)];
    gens_det := [[Integers()!y : y in Eltseq(x)] : x in Generators(mod_det)];
    one := [1,0,0,1];
    gens_1 := [[ChineseRemainderTheorem([g[i], one[i]], [N,det])
	       : i in [1..4]] : g in gens_N];
    gens_2 := [[ChineseRemainderTheorem([one[i], g[i]], [N,det])
	       : i in [1..4]] : g in gens_det];
    gens := gens_1 cat gens_2;
    if (Type(G`BaseRing) in {Rng,RngInt,FldRat}) then 
        ModLevelGL := GL(2,quo<G`BaseRing | N*det>);
    else
        ModLevelGL := MatrixAlgebra(quo<G`BaseRing | N*det>,2);
    end if;
    H := sub<ModLevelGL | gens>;

    import "../GrpGL2Hat/GrpGL2Hat/creation.m" : get_coercion_hom;
    red_H := get_coercion_hom(H, GL(2, Integers(N)));
    H_d := Kernel(red_H);
    im_d := ImageInLevelGL(G) meet Image(red_H);
    gens_H_d := [[Integers()!y : y in Eltseq(g)] : g in Generators(H_d)];
    equalizer := [[* z, z@@red_H *] : z in Generators(im_d)];
    gens_im_d := [[[Integers()!y : y in Eltseq(g)] : g in x] : x in equalizer];
    one := [1,0,0,1];
    gens_2 := [[ChineseRemainderTheorem([one[i], g[i]], [N, N*det])
	       : i in [1..4]] : g in gens_H_d];
    gens_3 := [[ChineseRemainderTheorem([g[1][i], g[2][i]], [N, N*det])
	       : i in [1..4]] : g in gens_im_d];
    gens := gens_2 cat gens_3;
    G_meet_H := sub< ModLevelGL | gens>;

    gens_G := [[Integers()!y : y in Eltseq(g)] :
		g in Generators(ImageInLevelGL(G))];
    gens_det := [[Integers()!y : y in Eltseq(g)] :
		g in Generators(GL(2, Integers(det)))];
    gens_1 := [[ChineseRemainderTheorem([g[i], one[i]], [N, det])
	       : i in [1..4]] : g in gens_G];
    gens_2 := [[ChineseRemainderTheorem([one[i], g[i]], [N, det])
	       : i in [1..4]] : g in gens_det];
    gens := gens_1 cat gens_2;
    im_G := sub<ModLevelGL | gens>;

    U, phi := UnitGroup(Integers(N*det));
    det_hom := hom<im_G->U | [Determinant(im_G.i)@(phi^(-1)) :
			      i in [1..NumberOfGenerators(im_G)]]>;
    im_G0 := Kernel(det_hom);
    G_meet_H_0 := im_G0 meet G_meet_H;
    coset_reps := Transversal(im_G0, G_meet_H_0);
    lifts := [GL2Q!Eltseq(FindLiftToSL2(x)) : x in coset_reps];

    R :=  [alpha * x : x in lifts];
    return [Eltseq(r) : r in R];
  else
   alpha_inv := alpha^(-1);
   D := Rationals()!LCM([Denominator(x) : x in Eltseq(alpha_inv)]);
   alpha_tilde := M2Z!(ScalarMatrix(2,D) * alpha_inv);
   r , dummy , t := SmithForm(M2Z!alpha_tilde);
   gamma1_conj := GammaUpper0(r[2,2] div r[1,1]);

   gamma1_alpha_conj := Conjugate(gamma1_conj, GL2Q!t^(-1));

/*
  // verify that this is indeed the alpha*Gamma(1)*alpha^(-1) meet Gamma(1)
  gens := [GL2Q!Eltseq(g) : g in Generators(gamma1_alpha_conj)];
  assert &and[IsCoercible(M2Z,alpha^(-1)*g*alpha) : g in gens];
  assert Index(gamma1_alpha_conj) eq #gamma1_reps;
*/

   gamma_alpha_conj := Conjugate(G meet gamma1_alpha_conj, alpha);

  end if;

/*
  // verify that this is contained in alpha^(-1)*Gamma*alpha meet Gamma(1)
  // This suggests that here we don't have the full intersection
  gens := [GL2Q!Eltseq(g) : g in Generators(gamma_alpha_conj)];
  assert &and[alpha*g*alpha^(-1) in G : g in gens];
*/

  H := G meet gamma_alpha_conj;

/*
  // Check that H is contained in alpha^(-1)*Gamma*alpha
  gens := [GL2Q!Eltseq(g) : g in Generators(H)];
  assert &and[alpha*g*alpha^(-1) in G : g in gens];
*/

  // Here we want Transversal(G,H);
  coset_reps := [GL2Q!Eltseq(x) : x in CosetRepresentatives(H) | x in G];
/*
  assert &and &cat[[coset_reps[i]*coset_reps[j]^(-1) notin H : j in [1..i-1]] : i in [2..#coset_reps]];
*/

  R :=  [alpha * x : x in coset_reps];

/*
  // Check that they indeed represent different cosets
  assert &and &cat[[R[i]*R[j]^(-1) notin G : j in [1..i-1]] : i in [2..#R]];

  // This fails meaning that H is not the intersection. Where did we go wrong?
  // It is smaller (!?)
*/

  return [Eltseq(r) : r in R];
  
end function;

function HeckeNSCartanRepresentatives(G,p,plus)
  if (not IsPrime(Level(G))) or Level(G) eq p then
      error "Not implemented for composite level!";
  end if;
  // Assumes N = Level(G) is prime,  different from p
  // and p is not +-1 mod N
  u := NSCartanU(G);
  N := Level(G);

  assert (N mod p ne 0);

  for c in Parent(u) do
     is_sq, a := IsSquare(p+u*c^2);
     if is_sq then
        mod_N := SL(2,Integers(N))![a,u*c,c/p,a/p];
        break;
     end if;
  end for;

  lift := GL(2,Rationals())!FindLiftToSL2(mod_N);
  // alpha := GL(2,Rationals())![1,0,0,p] * lift;

  // Here we calculate these theoretically
  // R := HeckeGeneralCaseRepresentativesDoubleCoset(G, alpha, Gamma0(p));

  possible_mod_p := [[1,r,0,1] : r in [0..p-1]];
  Append(~possible_mod_p, [0,1,-1,0]);
  a := mod_N[1,1];
  uc := mod_N[1,2];
  mod_N := [a,p*uc,uc/(u*p^2),a/p];
  // mod_N := Eltseq(mod_N);
  d,x,y := ExtendedGreatestCommonDivisor(N,p);
  reprs := [];
  for mod_p in possible_mod_p do
     g := [Integers()!mod_N[i]*y*p + Integers()!mod_p[i]*x*N : i in [1..4]];
     Append(~reprs, Eltseq(FindLiftToSL2(SL(2,IntegerRing(N*p))!g)));
  end for;

  R_conj := [[g[1],g[2],p*g[3],p*g[4]] : g in reprs];
  R_rational := [lift^(-1)*GL(2,Rationals())!r*lift : r in R_conj];
  R := [[Integers()!y : y in Eltseq(x)] : x in R_rational];

  return R;
end function;

function HeckeFullCongruenceRepresentatives(N,p : Squared := false)
  GL2Q := GL(2, Rationals());
  if (N mod p ne 0) then
     // !!! TODO : Is this the correct global representative?
     s := Squared select 2 else 1;
     alpha := GL2Q![1,0,0,p^s];
     G := CongruenceSubgroup(N);
     return HeckeGeneralCaseRepresentativesDoubleCoset(G, alpha, Gamma0(p^s));
  end if;
  alpha_N := GL2Q![1,0,0,N];
  if Squared then
    reps := [GL2Q![1,r,0,p^2] : r in [0..p^2-1]];
    if N mod p ne 0 then
      reps := reps cat [GL2Q![p,r,0,p] : r in [0..p-1]] cat [GL2Q![p^2,0,0,1]];
    end if;
  else
    reps := [GL2Q![1,r,0,p] : r in [0..p-1]];
    if N mod p ne 0 then
      Append(~reps, GL2Q![p,0,0,1]);
    end if;
  end if;
  coset_reps := [GL2Q![1-r*N, -r^2, N^2, 1+r*N] : r in [0..N-1]];
  R := &cat[[Eltseq(alpha_N^(-1)*c*r*alpha_N) : c in coset_reps] : r in reps];
  return R;
end function;

function GetBadDoubleCosetRepresentatives(G,p)
    GL2Q := GL(2, Rationals());
    N := Level(G);
    M2Z := MatrixAlgebra(Integers(),2);
    alpha_p := GL2Q![1,0,0,p];
    // !!! TODO:  This is temporary.
    // It seems that for q-expansions any representative should do.
    // However, we cannot afford empty set of representatives
    return [alpha_p];
    eta := GL2Q![-1,0,0,1];
    H := ImageInLevel(G);
    Zp_gamma := sub<MatrixAlgebra(GF(p),2) | Generators(H)>;
    singulars := {x : x in Zp_gamma | Determinant(x) eq 0};
    Exclude(~singulars, Zp_gamma!0);
    if IsEmpty(singulars) then
	return [];
    end if;
    // This does not always work, sadly
    // alpha := FindLiftToM2Z(MatrixAlgebra(Integers(p),2)!Random(singulars) :
    //		    det := p);
    // return HeckeGeneralCaseRepresentativesDoubleCoset2(G, GL2Q!alpha);
    // The following (correct) version encounters an internal error of Magma
    // until we understand how to circumvent it, we just settle for returning
    // the double coset of some element of determinant p normalizing Gamma
    // and such that eta normalizes the double coset
    // This turns out not to work even for Gamma0. ?
    im_gamma0 := ImageInLevel(Gamma0(p) : N := N);
    conj := Conjugates(SL(2, Integers(N)), im_gamma0);
    good_conj := [c : c in conj | H subset c];
    // found := false;
    for c in good_conj do
	dummy, x := IsConjugate(SL(2,Integers(N)), c, im_gamma0);
	x_lift := GL2Q!Eltseq(FindLiftToSL2(x));
	alpha := x_lift * alpha_p;
	// This is conjugating by alpha
	// Given the choice of c, it is OK   
	p_conj := Conjugate(G,alpha);
	new_N := Maximum(Level(p_conj), N);
	is_conj, y := IsConjugate(SL(2,Integers(new_N)),
				  ImageInLevel(p_conj : N := new_N),
				  ImageInLevel(G : N := new_N));
	if is_conj then     
	    // y_lift := GL2Q!Eltseq(FindLiftToSL2(y));
	    //alpha := x_lift * alpha_p  * y_lift;
            // R := HeckeGeneralCaseRepresentativesDoubleCoset2(G, alpha);
	    return [alpha];
	    //  R_eta := HeckeGeneralCaseRepresentativesDoubleCoset2(G, alpha^eta);
	    //          return R cat R_eta;
            // found := true;
            // break;
	end if;
    end for;
     
    // Clearly wrong, but gives some Hecke operator at p
    //if (not found) then
    printf "** WARNING! The Hecke operator at %o is NOT computed correctly! **\n",p;
    return [alpha_p];
    R := HeckeGeneralCaseRepresentativesDoubleCoset2(G,alpha_p);
    // return [alpha_p];
    //end if;
    
    if exists(r){r : r in R | eta*alpha_p*eta*(GL2Q!r)^(-1) in G} then
        // return R;
	return [alpha_p];
    else
	return [alpha_p, eta*alpha_p*eta];
//	return R cat
//	       HeckeGeneralCaseRepresentativesDoubleCoset2(G,eta*alpha_p*eta);
    end if;
    
     
    // Here we compute the double coset representatives
    // for the matrices in the order generated by G with
    // Determinant p.
    // Problem : For Gamma0(p), it is not Delta0(p)!
    // On the contrary, it is the other double coset Gamma0(p)*[p,0,0,1]!
     
    // The only way I could get it to work -
    // We first look for those that have det p mod p^2
    // !!! TODO !!! Check if this is still true when N != p^e !!!
    // Then among them we choose the ones that have det p
    dummy := exists(x){x : x in Factorization(N) | x[1] eq p};
    M2Zp := MatrixAlgebra(Integers(p^x[2]),2);
    M2ZZp := MatrixAlgebra(pAdicRing(p,x[2]),2);
    H := sub<GL(2,Integers(p^x[2])) | [M2Zp!h : h in Generators(H)]>;
    //     O := sub< M2ZZp | [M2ZZp!(M2Zp!h) : h in Generators(H)]>;
    Zp_gamma := sub<M2ZZp | Generators(H)>;
    try
	singulars := {x : x in Zp_gamma | Determinant(x) eq p and x ne 0};
    catch e
	printf "WARNING! Internal Error of Magma prevented us from computing T_%o", p;
	return [];
    end try;
/*
     is	_nz := exists(x){x : x in singulars | Determinant(GL2Q!x) eq 3};
     if not is_nz then
       return [];
     end if;
*/
    // We convert H to a permutation group, because that is the only way we
    // could get magma to compute the orbits for us
    // !!! TODO - compute the orbits directly !!!
    if IsEmpty(singulars) then
        return [];
    end if;
    fpH, fp_iso := FPGroup(H);
    prmH, prm_iso := PermutationGroup(fpH);
    phi := prm_iso^(-1)*fp_iso;
    // We first find orbits for the left action
    action := map<CartesianProduct(singulars, prmH)->singulars |
		 x :-> (O!phi(x[2]^(-1)))*x[1]>;
    gset := GSet(prmH, singulars, action);
    orbs := Orbits(prmH, gset);
    // and now for the right action on orbits of the left action
    orb_sets := {Set(orb) : orb in orbs};
    orb_action := map<CartesianProduct(orb_sets, prmH)->orb_sets |
		     x :-> { y*(O!phi(x[2])) : y in x[1] }>;
    double_gset := GSet(prmH, orb_sets, orb_action);
    double_coset_orbs := Orbits(prmH, double_gset);
    // Here any element of the orbit would do, so we pick at random
    double_coset_reps := [Random(Random(x)) : x in double_coset_orbs];
    // Finally we lift to those with actual determinant p
    final_list := [FindLiftToM2Z(M2Zp!(M2Z!x) : det := p) :
		   x in double_coset_reps];
     //return &cat [HeckeGeneralCaseRepresentativesDoubleCoset2(G, GL2Q!x) :
//		  x in final_list];
    return final_list;
end function;


function HeckeGeneralCaseRepresentatives(G,p : Squared := false)
  N := Level(G);
  GL2Q := GL(2, Rationals());
  if N mod p eq 0 then
      alphas := GetBadDoubleCosetRepresentatives(G,p);
  elif N eq 1 then
      alphas := [[1,0,0,p]]; // any element of determinant p would work here
  else
      alphas := [FindLiftToM2Z(Matrix(G`DetRep(p)) : det := p)];
  end if;
  if Squared then
      alphas := [(GL2Q!Eltseq(alpha))^2 : alpha in alphas];
  end if;
  R := &cat [HeckeGeneralCaseRepresentativesDoubleCoset2(G, GL2Q!Eltseq(alpha))
							: alpha in alphas];
  return R;
end function;

// Trying to use John's idea

intrinsic HeckeAdelic(M::ModSym, w::GrpMatElt[FldRat]) -> AlgMatElt
{This function computes the Hecke operator corresponding to the element of the
    finite adeles which is trivial at all places different from p=det(w),
    and equal to w at p. At the moment we assume that p is prime}
  if (not IsAmbientSpace(M)) then
     T := HeckeAdelic(AmbientSpace(M), w);
     return Restrict(T, VectorSpace(M));
  end if;
  G := LevelSubgroup(M);
  GL2Q := GL(2, Rationals());
//  w := GL2Q!w;
  w_tilde := GL2Q!(ScalarMatrix(2, Determinant(w)) * w^(-1));
  alphas := HeckeGeneralCaseRepresentativesDoubleCoset2(G, w_tilde);
  xs := [(GL2Q!alpha)^(-1) : alpha in alphas];
  w_inv := (ModLevelGL(G)!w)^(-1);
  p := Determinant(w);
  assert IsPrime(Integers()!p);
  beta := GL2Q!Eltseq(FindLiftToSL2(w_inv * G`DetRep(p)));
  qs := [x*beta : x in xs]; 
  R := [Eltseq(q^(-1)) : q in qs];
  return &+[ActionOnModularSymbolsBasis(g,M) : g in R];
end intrinsic;

intrinsic HeckeAdelicComponents(M::ModSym, w::GrpMatElt[FldRat]) -> AlgMatElt
{This function computes the Hecke Operator on the disconnected Shimura variety
    which depends only on the level subgroup (and not on the GL2 model),
    corresponding to the element of the finite adeles which is trivial at
    all places different from p=det(w),
    and equal to w at p. At the moment we assume that p is prime}
  G := LevelSubgroup(M);
  if (not IsAmbientSpace(M)) then
     T := HeckeAdelicComponents(AmbientSpace(M), w);
     return Restrict(T, DirectSum([VectorSpace(M) : i in Domain(G`DetRep)]));
  end if;
  GL2Q := GL(2, Rationals());
//  w := GL2Q!w;
  w_tilde := GL2Q!(ScalarMatrix(2, Determinant(w)) * w^(-1));
  alphas := HeckeGeneralCaseRepresentativesDoubleCoset2(G, w_tilde);
  xs := [(GL2Q!alpha)^(-1) : alpha in alphas];
  w_inv := (ModLevelGL(G)!w)^(-1);
  p := Integers()!Determinant(w);
  assert IsPrime(p);
  transitions := [G`DetRep(i)*G`DetRep(p*i)^(-1)*G`DetRep(p^2) :
		   i in Domain(G`DetRep)];
  betas := [GL2Q!Eltseq(FindLiftToSL2(w_inv * t)) : t in transitions];
  qss := [[x*beta : x in xs] : beta in betas]; 
  Rs := [[Eltseq(q^(-1)) : q in qs] : qs in qss];
  blocks := [&+[ActionOnModularSymbolsBasis(g,M) : g in R] : R in Rs];
  Z_N_star := Set(Domain(G`DetRep));
  perm := SymmetricGroup(Z_N_star)![p*i : i in Z_N_star];
  perm_mat := PermutationMatrix(Rationals(), perm);
  mats := [[perm_mat[i,j]*blocks[i] : j in [1..#blocks]] : i in [1..#blocks]];
  return BlockMatrix(mats);
end intrinsic;

intrinsic HeckeOperator(M::ModSym , alpha::GrpMatElt[FldRat]) -> AlgMatElt
  {This function computes the Hecke operator corresponding to the double coset
      G\G*alpha*G directly. At the moment we assume p = det(alpha) is prime.}
  if (not IsAmbientSpace(M)) then
     T := HeckeOperator(AmbientSpace(M), alpha);
     return Restrict(T, VectorSpace(M));
  end if;
  p := Integers()!Determinant(alpha);
  assert IsPrime(p);
  G := LevelSubgroup(M);
  R := HeckeGeneralCaseRepresentativesDoubleCoset2(G, alpha);
  return &+[ActionOnModularSymbolsBasis(g,M) : g in R];
end intrinsic;

// For some strange reason, this does not always work

function HeckeOperatorDirectlyOnModularSymbols(M,p : Squared := false)
   assert Type(M) eq ModSym;
   assert Type(p) eq RngIntElt;
   // assert IsPrime(p);
   // We now allow also square of primes
   GL2Q := GL(2, Rationals());
   N := Level(M);
   if IsOfGammaType(M) then
      R := [[1,r,0,p] : r in [0..p-1]];
      if N mod p ne 0 then
         Append(~R,[p,0,0,1]);
      end if;
   else
       eps := DirichletCharacter(M);
       G := Parent(eps)`Gamma;
       // This is because we don't compute epsilon values on the representatives
       // at the moment
       // G := LevelSubgroup(M);
       R := HeckeGeneralCaseRepresentatives(G,p : Squared := Squared);
   end if;
   if IsEmpty(R) then
     return MatrixAlgebra(BaseField(M),Dimension(M))!0;
   end if;
   return &+[ActionOnModularSymbolsBasis(g,M) : g in R];
end function;

function ManinSymbolsAction2(defining_tuple, uv, Heil)
  G := defining_tuple[1];
  det := defining_tuple[2];
  Tquot := defining_tuple[3];
  Squot := defining_tuple[4];
  Scoef := defining_tuple[5];
  eps := defining_tuple[6];
  res := Universe(Tquot)!0;
  phi, phi_data := get_phi(G, det);
  for mat in Heil do
    uvM := Parent(mat)!Eltseq(uv) * mat;
    ind, s := phi(uvM, phi_data);
    if ind ne 0 then
      e := s@eps;
      res +:= e*Scoef[ind]*Tquot[Squot[ind]];
    end if;
  end for;
  return res;
end function;


function ManinSymbolsAction(defining_tuple, uv, w, Heil_N, Heil_0, k)
  G := defining_tuple[1];
  coset_list_size := defining_tuple[2];
  Tquot := defining_tuple[3];
  Squot := defining_tuple[4];
  Scoef := defining_tuple[5];
  eps := defining_tuple[6];
  K := BaseRing(eps);
  phi, phi_data := get_phi(G, Determinant(Heil_0[1]));
  R<X> := PolynomialRing(K);
  res := VectorSpace(K,#Tquot)!0;
  for idx in [1..#Heil_N] do
    mat := Heil_N[idx];
    uvM := Parent(mat)!Eltseq(uv) * mat;
    ind, s := phi(uvM, phi_data);
    if ind ne 0 then
      e := s@eps;
      H := Heil_0[idx];
      h := e*(R![H[1,2],H[1,1]])^w*(R![H[2,2],H[2,1]])^(k-2-w);
      for a in Eltseq(h) do
	 res[Squot[ind]] +:= a*Scoef[ind];
         ind +:= coset_list_size;
      end for;
    end if;
  end for;
  return res * RMatrixSpace(K,Degree(res),Degree(Tquot[1]))!Tquot;
end function;

procedure Get_Tquot(~quot, ~Tquot, ~CallP1Action2, ~CallP1Action)

   Tquot := quot`Tquot;

   CallP1Action2 := P1Action;
   CallP1Action := P1Action;

return;	// force special rational handling off

   V := Universe(Tquot);
   K := BaseRing(V);

   if Type(K) ne FldRat then
      return;
   end if;

   if assigned quot`Tquot_scaled then

      Tquot := quot`Tquot_scaled;
      s := quot`scalar;

   else

      // "Tquot:"; Parent(Tquot); Tquot;

      W := [];
      denom := [];
      for v in Tquot do
	 w, d := IntegralVector(v);
	 Append(~W, w);
	 Append(~denom, d);
      end for;
      lcm := LCM(denom);
      for i := 1 to #W do
	 d := denom[i];
	 if d ne lcm then
	     W[i] := (lcm div d)*W[i];
	 end if;
      end for;
      Tquot := ChangeUniverse(W, V);

      /*
      denom := [LCM([Denominator(x): x in Eltseq(v)]): v in Tquot];
      // "denom:", denom;
      lcm := LCM(denom);
      // "LCM:", LCM(denom);
      Tquot := [lcm*v: v in Tquot];
      */

      s := 1/lcm;

      quot`Tquot_scaled := Tquot;
      quot`scalar := s;
   end if;

   CallP1Action2 := func<a, b, c | s*P1Action(a, b, c)>;
   CallP1Action := func<a, b, c, d, e, f | s*P1Action(a, b, c, d, e, f)>;

end procedure;


function lev1_HeckeOperatorHeilbronn(M, Heil)
   assert Type(M) eq ModSym;
   assert Type(Heil) eq Tup;

   if Dimension(M) eq 0 then
      return Hom(Representation(M), Representation(M))!0;
   end if;

   assert Level(M) eq 1;

   if IsOfGammaType(M) then
      eps   := ValueList(DirichletCharacter(M));
   else
      eps := DirichletCharacter(M);
   end if;
   k     := Weight(M);

   quot  := M`quot;
   Sgens := quot`Sgens;

   Squot := quot`Squot;         // phi
   my_phi:= [1] cat Squot;

   Scoef := quot`Scoef;         // coeff
   my_coeff:= [0] cat Scoef;


   Tgens := quot`Tgens;
   Tquot := quot`Tquot;         // S

   coset_list := M`mlist`coset_list;
   char0Heil, modNHeil := Explode(Heil);
   det := Determinant(char0Heil[1]);

   generating_coset_list  := [];
   generating_weights := [];
   for t in Tgens do
      uv, w := UnwindManinSymbol(Sgens[t],M`mlist);
      Append(~generating_coset_list,uv);
      Append(~generating_weights,w);
   end for;

   R := PolynomialRing(BaseField(M)); x := R.1;
   if IsOfGammaType(M) then
     T := [ P1GeneralizedWeightedAction(generating_coset_list[j],
                               generating_weights[j],
                               k, coset_list, Tquot,
                               my_phi, my_coeff,
                               modNHeil, char0Heil,
                               eps,
                               R,
                               1) :
             j in [1..#generating_coset_list]
        ];
   else
     //     phiG := get_phi(LevelSubgroup(M));
     G := LevelSubgroup(M);
     T := [ lev1_ManinSymbolsGeneralizedWeightedAction(generating_coset_list[j],
                               generating_weights[j],
                               k, coset_list, Tquot,
                               my_phi, my_coeff,
                               modNHeil, char0Heil,
                               eps,
                               R,
			       1,G) :
             j in [1..#generating_coset_list]
        ];
   end if;

   return MatrixAlgebra(BaseField(M),Dimension(M))!T;
end function;



function lev1_TnSparse(M, Heil, sparsevec)
   assert Type(M) eq ModSym;
   assert Type(Heil) in {RngIntElt, Tup};
   assert Type(sparsevec) eq SeqEnum;

   if Dimension(M) eq 0 then
      return VectorSpace(M)!0;
   end if;

   assert Level(M) eq 1;

   if GetVerbose("ModularSymbols") eq 3 then
      printf "T_%o sparse... ", Type(Heil) eq RngIntElt select Heil
         else Determinant(Heil[1][1]);
      t := Cputime();
   end if;

   if Type(Heil) eq RngIntElt then
      char0Heil, modNHeil  := Explode(Heilbronn(M,Heil,false));
   else
      char0Heil, modNHeil := Explode(Heil);
   end if;

   if IsOfGammaType(M) then
      eps   := ValueList(DirichletCharacter(M));
   else
      eps := DirichletCharacter(M);
   end if;
   k     := Weight(M);

   quot  := M`quot;
   Sgens := quot`Sgens;

   Squot := quot`Squot;         // phi
   my_phi:= [1] cat Squot;

   Scoef := quot`Scoef;         // coeff
   my_coeff:= [0] cat Scoef;


   Tgens := quot`Tgens;
   Tquot := quot`Tquot;         // S

   coset_list := M`mlist`coset_list;
   det := Determinant(char0Heil[1]);

   generating_coset_list  := [];
   generating_weights := [];
   for t in Tgens do
      uv, w := UnwindManinSymbol(Sgens[t],M`mlist);
      Append(~generating_coset_list,uv);
      Append(~generating_weights,w);
   end for;

   R := PolynomialRing(BaseField(M)); x := R.1;
   if IsOfGammaType(M) then
     ans :=  &+[ m[1]* P1GeneralizedWeightedAction(generating_coset_list[m[2]],
                               generating_weights[m[2]],
                               k, coset_list, Tquot,
                               my_phi, my_coeff,
                               modNHeil, char0Heil,
                               eps,
                               R,
                               1) :
                m in sparsevec];
   else
     // phiG := get_phi(LevelSubgroup(M));
     G := LevelSubgroup(M);
     ans :=  &+[ m[1]* lev1_ManinSymbolsGeneralizedWeightedAction(
			       generating_coset_list[m[2]],
                               generating_weights[m[2]],
                               k, coset_list, Tquot,
                               my_phi, my_coeff,
                               modNHeil, char0Heil,
                               eps,
                               R,
			       1, G) :
                m in sparsevec];
   end if;

   if GetVerbose("ModularSymbols") eq 3 then
      printf " (%o s).\n", Cputime(t);
   end if;

   return ans;
end function;

function HeckeOperatorHeilbronn(M, Heil)
   if Dimension(M) eq 0 then
      return MatrixAlgebra(BaseField(M), Dimension(M))!0;
   end if;

   if Level(M) eq 1 then
      return lev1_HeckeOperatorHeilbronn(M,Heil);
   end if;

   M := AmbientSpace(M);

   if IsOfGammaType(M) then
      eps   := ValueList(DirichletCharacter(M));
   else
      eps := DirichletCharacter(M);
   end if;
   k     := Weight(M);

   quot  := M`quot;
   Sgens := quot`Sgens;

   Squot := quot`Squot;         // phi
   my_phi:= [1] cat Squot;

   Scoef := quot`Scoef;         // coeff
   my_coeff:= [0] cat Scoef;

   Tgens := quot`Tgens;         
   // Tquot := quot`Tquot;         // S

   coset_list := M`mlist`coset_list;

   char0Heil, modNHeil := Explode(Heil);
   det := Determinant(char0Heil[1]);

   generating_coset_list  := [];
   generating_weights := [];
   for t in Tgens do 
      uv, w := UnwindManinSymbol(Sgens[t],M`mlist);
      Append(~generating_coset_list,uv);
      Append(~generating_weights,w);
   end for;

   if IsOfGammaType(M) then
      Get_Tquot(~quot, ~Tquot, ~CallP1Action2, ~CallP1Action);
      defining_tuple := <coset_list, Tquot, Squot, Scoef> ;
   else
      Tquot := quot`Tquot;

      CallP1Action2 := ManinSymbolsAction2;
      CallP1Action := ManinSymbolsAction;
      G := LevelSubgroup(M);
      // find_coset := M`mlist`find_coset;
      num_cosets := #M`mlist`coset_list;
      //phi := get_phi(G);
      // defining_tuple := <phi, num_cosets, Tquot, Squot, Scoef> ;
      param :=  Weight(M) eq 2 select det else num_cosets;
      defining_tuple := <G, param, Tquot, Squot, Scoef> ;
   end if;

   Append(~defining_tuple, eps);
 
   if Weight(M) eq 2 then
	 T := [ CallP1Action2(defining_tuple, uv, modNHeil) : 
		      uv in generating_coset_list
	      ];
   else
	 T := [ CallP1Action(defining_tuple, 
			 generating_coset_list[j], generating_weights[j],
			 modNHeil, char0Heil, k) : 
		    j in [1..#generating_coset_list]
	      ];
   end if; 

   return MatrixAlgebra(BaseField(M),Dimension(M))!T;
end function;


function TnSparse(M, Heil, sparsevec)

   if #sparsevec eq 0 then
      return VectorSpace(M)!0;
   end if;

/* This now returns for the case not of Gamma type!

   In order to always use Heilbronn matrices, this is
   now commented out.  WAS, 09/15/01.
  if Weight(M) gt 2 and Characteristic(BaseField(M)) gt 0 then
*/

  if (not IsOfGammaType(M)) and
     ((not (IsGammaNS(M`G) or IsGammaNSplus(M`G))) or
      (#Domain(M`G`DetRep) lt EulerPhi(Level(M))) )  then
      if Type(Heil) eq RngIntElt then
	 n := Heil;
      else
	 n := Determinant(Heil[1][1]);
      end if;
      N := Level(M);
      // For now we always simply compute the whole Hecke operator,
      // because this seems more efficient, since it is properly cached, etc.
      if (GCD(N,n) ne 1) or (#Domain(M`G`DetRep) lt EulerPhi(Level(M))) then
        fac := Factorization(n);
        compute_direct := (#fac eq 1) and (fac[1][2] le 2);
        if not compute_direct then   // just compute the whole Hecke operator.
          Tn := HeckeOperator(M,n);
          V := VectorSpace(M);
          v := &+[s[1]*V.s[2] : s in sparsevec];      
          return v*Tn;
        else  // n is prime or a   -- this code isn't used, as it is slower.
	  p := fac[1][1];
          squared := fac[1][2] eq 2;
	  eps := DirichletCharacter(M);
	  G := Parent(eps)`Gamma;
          matrices := HeckeGeneralCaseRepresentatives(G, p : 
						      Squared := squared);
          if IsEmpty(matrices) then
	     return VectorSpace(M)!0;
          end if;
          return &+[s[1]*
   	      &+[ActionOnModularSymbolsBasisElement(g,M,s[2]) :
    	           g in matrices] : s in sparsevec];
        end if;
      end if;
   end if;    
         

   // Now consider the characteristic-zero case.
   if Level(M) eq 1 then
      return lev1_TnSparse(M,Heil,sparsevec);
   end if;

   if Dimension(M) eq 0 then
      return VectorSpace(M)!0;
   end if;

   M := AmbientSpace(M);

   if GetVerbose("ModularSymbols") eq 3 then
      printf "T_%o sparse... ", Type(Heil) eq RngIntElt select Heil 
         else Determinant(Heil[1][1]);
   end if;
   t := Cputime();

   if Type(Heil) eq RngIntElt then
      char0Heil, modNHeil := Explode(Heilbronn(M,Heil,false));
   else
      char0Heil, modNHeil := Explode(Heil);      
   end if;

   if IsOfGammaType(M) then
      eps   := ValueList(DirichletCharacter(M));
   else
      eps := DirichletCharacter(M);
   end if;
   k     := Weight(M);

   quot  := M`quot;
   Sgens := quot`Sgens;

   Squot := quot`Squot;         // phi
   // my_phi:= [1] cat Squot;

   Scoef := quot`Scoef;         // coeff
   // my_coeff := [0] cat Scoef;

   Tgens := quot`Tgens;         
   // Tquot := quot`Tquot;         // S

   coset_list := M`mlist`coset_list;
   det := Determinant(char0Heil[1]);

   generating_coset_list  := [];
   generating_weights := [];
   for t in Tgens do 
      uv, w := UnwindManinSymbol(Sgens[t],M`mlist);
      Append(~generating_coset_list,uv);
      Append(~generating_weights,w);
   end for;

   if IsOfGammaType(M) then
      Get_Tquot(~quot, ~Tquot, ~CallP1Action2, ~CallP1Action);
      defining_tuple := <coset_list, Tquot, Squot, Scoef> ;
   else
      Tquot := quot`Tquot;

      CallP1Action2 := ManinSymbolsAction2;
      CallP1Action := ManinSymbolsAction;
      G := LevelSubgroup(M);
      // find_coset := M`mlist`find_coset;
      num_cosets := #M`mlist`coset_list;
//phi := get_phi(G);
      //    defining_tuple := <phi, num_cosets, Tquot, Squot, Scoef> ;
      param :=  Weight(M) eq 2 select det else num_cosets;
      defining_tuple := <G, param, Tquot, Squot, Scoef> ;
   end if;

   Append(~defining_tuple, eps);
    
   if Weight(M) eq 2 then

	 /*
         ans := &+[ m[1]*CallP1Action2(defining_tuple, 
                                  generating_coset_list[m[2]], 
                                  modNHeil) : 
                              m in sparsevec ];
	 */

	 ans := 0;
         for m in sparsevec do
	     mat := m[1]*CallP1Action2(
		 defining_tuple, generating_coset_list[m[2]], modNHeil
	     );
	     if ans cmpeq 0 then
		ans := mat;
	     else
		ans +:= mat;
	     end if;
	 end for;
   else
	 /*
         ans := &+[ m[1]*CallP1Action(defining_tuple, 
                                  generating_coset_list[m[2]], 
                                  generating_weights[m[2]],
                                  modNHeil, 
                                  char0Heil, 
                                  k) : 
                              m in sparsevec
                  ];
	*/

	ans := 0;
        for m in sparsevec do
	     mat := m[1]*CallP1Action(
		defining_tuple, generating_coset_list[m[2]], 
		generating_weights[m[2]], modNHeil, 
		char0Heil, k
	     );
	     if ans cmpeq 0 then
		ans := mat;
	     else
		ans +:= mat;
	     end if;
	end for;
   end if; 
   vprintf ModularSymbols, 3 : " (%o s).\n", Cputime(t);
   return ans;
end function;



function GeneralizedHeilbronnOperator(M, MM, Heil : t:=1)
   if Dimension(M) eq 0 then
      return Hom(Representation(M), Representation(M))!0;
   end if;

   if IsOfGammaType(MM) then
     eps   := ValueList(DirichletCharacter(MM));
   else
     eps := DirichletCharacter(MM);
   end if;
   k     := Weight(MM);

   ambM  := AmbientSpace(M);
   ambMM := AmbientSpace(MM);

   Squot := ambMM`quot`Squot;         // phi
   my_MM_phi:= [1] cat Squot;

   Scoef := ambMM`quot`Scoef;         // coeff
   my_MM_coeff:= [0] cat Scoef;

   MM_Tquot := ambMM`quot`Tquot;         // S


   char0Heil, modNHeil := Explode(Heil);
   det := Determinant(char0Heil[1]);

   generating_coset_list  := [];
   generating_weights := [];
   Sgens := ambM`quot`Sgens;
   for t in ambM`quot`Tgens do 
      uv, w := UnwindManinSymbol(Sgens[t],ambM`mlist);
      Append(~generating_coset_list,uv);
      Append(~generating_weights,w);
   end for;

   MM_coset_list := ambMM`mlist`coset_list;

   R := PolynomialRing(BaseField(M)); x := R.1;

   if IsOfGammaType(MM) then
      T := [ P1GeneralizedWeightedAction(
                               generating_coset_list[j], 
                               generating_weights[j], 
                               k, 
                               MM_coset_list, MM_Tquot, 
                               my_MM_phi, my_MM_coeff, 
                               modNHeil, char0Heil, 
                               eps,
                               R,
                               t) :
             j in [1..#generating_coset_list]
           ];
   else
     //phiG := get_phi(LevelSubgroup(MM));
       G := LevelSubgroup(MM);
       T := [ ManinSymbolsGeneralizedWeightedAction(
                               generating_coset_list[j], 
                               generating_weights[j], 
                               k, 
                               MM_coset_list, MM_Tquot, 
                               my_MM_phi, my_MM_coeff, 
                               modNHeil, char0Heil, 
                               eps,
                               R,
                               t, G) :
             j in [1..#generating_coset_list]
           ];
   end if;

   return Hom(VectorSpace(M),VectorSpace(MM))!T;
end function;



function SparseRepresentation(v)
// Sparse representation of vector v.
   sp := [];
   v  := Eltseq(v);
   for i in [1..#v] do
      if v[i] ne 0 then
         Append(~sp, <v[i],i>);
      end if;
   end for;
   return sp;
end function;


intrinsic HeckeImages(M::ModSym, i::RngIntElt, n::RngIntElt) -> SeqEnum
{The images of the ith standard basis vector
 under the Hecke operators Tp for p<=n prime.
These are computed using sparse methods that don't
require computing the full Hecke operator.}  
   assert 1 le i and i le Dimension(M);
   if not IsAmbientSpace(M) then
      return HeckeImages(AmbientSpace(M),i,n);
   end if;
   if not assigned M`standard_images then
      M`standard_images := [[Representation(M)|] : i in [1..Dimension(M)]];
   end if;
   m := NextPrime(n);
   if #M`standard_images[i] lt PrimePos(m) then  // generate more images...
      p := NthPrime(#M`standard_images[i]+1);
      new_images := [Universe(M`standard_images[i])|]; // avoid copy inside loop
      s := SparseRepresentation(VectorSpace(M).i);  
      while p le n do 
	 Append(~new_images, TnSparse(M, p, s));
         p := NextPrime(p);
      end while;
      M`standard_images[i] := M`standard_images[i] cat new_images;
   end if;      
   return M`standard_images[i];       
end intrinsic;

intrinsic HeckeImagesSquarePrimes(M::ModSym, i::RngIntElt,
				  n::RngIntElt) -> SeqEnum
{The images of the ith standard basis vector
 under the Hecke operators Tp^2 for p^2<=n the square of a prime.
These are computed using sparse methods that don't
require computing the full Hecke operator.}  
   assert 1 le i and i le Dimension(M);
   if not IsAmbientSpace(M) then
      return HeckeImagesSquarePrimes(AmbientSpace(M),i,n);
   end if;
   if not assigned M`standard_images_squares then
      M`standard_images_squares := [
	     [Representation(M)|] : i in [1..Dimension(M)]];
   end if;
   m := NextPrime(Floor(SquareRoot(n)));
   if #M`standard_images_squares[i] lt PrimePos(m) then
      p := NthPrime(#M`standard_images_squares[i]+1);
      new_images := [Universe(M`standard_images_squares[i])|];
      s := SparseRepresentation(VectorSpace(M).i);  
      while p^2 le n do 
	 Append(~new_images, TnSparse(M, p^2, s));
         p := NextPrime(p);
      end while;
      M`standard_images_squares[i] := M`standard_images_squares[i]
	cat new_images;
   end if;      
   return M`standard_images_squares[i];       
end intrinsic;

intrinsic HeckeImagesAll(M::ModSym, i::RngIntElt, n::RngIntElt) -> SeqEnum
{The images of the ith standard basis vector
under the Hecke operators Tj for j<=n.
These are computed using sparse methods that don't
require computing the full Hecke operator.}  

   require i ge 1 and i le Dimension(M) : "Argument 2 must be between 1 and the dimension of argument 1.";
   require n ge 1 : "Argument 3 must be positive.";   

   if not IsAmbientSpace(M) then
      return HeckeImagesAll(AmbientSpace(M),i,n);
   end if;
   if not assigned M`standard_images_all then
      M`standard_images_all := [[M|] : i in [1..Dimension(M)]];
   end if;
   j0 := #M`standard_images_all[i];
   if j0 lt n then
      s := SparseRepresentation(M.i);
      new_images := [Universe(M`standard_images_all[i])|]; // avoid copy inside loop
      for j := j0 + 1 to n do
         Append(~new_images, TnSparse(M, j, s));
      end for;
      M`standard_images_all[i] := M`standard_images_all[i] cat new_images;
   end if;      
   return M`standard_images_all[i];       
end intrinsic;


intrinsic HeckeSpan(v::ModSymElt
                     : Bound := -1 ) -> Lat
{Computes the Hecke module over Z generated by a vector v.
 The result is returned as a lattice.}
   M := Parent(v);
   if v eq 0 then
      return MakeLattice([VectorSpace(M)!0]);
   end if;
   b := Bound eq -1 select HeckeBound(M) else Max(Bound,1);
   if v eq 0 then
      b := 0;
   end if;

   if IsMultiChar(M) then
      w := VectorSpace(M)!Eltseq(v);
      if w eq 0 then
         return MakeLattice([w]);
      end if;
      return MakeLattice([w*HeckeOperator(M,n)  : n in [1..b]]);
   end if;

   dense  := Representation(v);
   s := SparseRepresentation(dense);
   B := [];
   for n in [1..b] do
      if IsPrime(n) then
         Append(~B, TnSparse(M,n,s));
      else
         Append(~B, dense*HeckeOperator(M,n));
      end if;
   end for;
   return MakeLattice(B);
end intrinsic;


intrinsic HeckeFieldSpan(v::ModSymElt : 
                         Bound := -1) -> Lat
{Computes the Hecke module over the base *field* generated by a 
 vector v.  The result is returned as a subspace of the vector
 space underlying the ambient space.}
   M := Parent(v);
   b := Bound eq -1 select HeckeBound(M) else Max(Bound,1);

   if IsMultiChar(M) then
      w := VectorSpace(M)!Eltseq(v);
      return sub<VectorSpace(M) | [w*HeckeOperator(M,n)  : n in [1..b]]>;
   end if;

   dense  := Representation(v);
   s := SparseRepresentation(dense);
   B := [];
   for n in [1..b] do
      if IsPrime(n) then
         Append(~B, TnSparse(M,n,s));
      else
         Append(~B, dense*HeckeOperator(M,n));
      end if;
   end for;
   V := sub<Parent(B[1])|B>;
   return V;
end intrinsic;


intrinsic HeckeBound(M::ModSym) -> RngIntElt
{A positive integer n = (k/12)*[SL_2(Z):Gamma] 
such that the Hecke operators  T1,...,Tn acting on cusp forms
generate the Hecke algebra as a Z-module when
the character is trivial or quadratic.  Otherwise, T1,...,Tn 
generate the Hecke algebra at least as a Z[eps]-module, 
where Z[eps] is the ring generated by the values of eps.}
// This bound is due to Sturm.
   if not IsAmbientSpace(M) then
      return HeckeBound(AmbientSpace(M));
   end if;
   if not assigned M`hecke_bound then
      if IsOfGammaType(M) then
         if IsMultiChar(M) then
            M`hecke_bound := Ceiling(Weight(M) * idxG1(Level(M)) / 12);
            return M`hecke_bound;
         end if;

         b := Ceiling(Weight(M) * idxG0(Level(M)) / 12);

/*  I was really worried about the following for a while.  The counterexample I point
    out below doesn't seem to be a problem -- maybe it was the result of a different
    problem with a trick used in the decomposition algorithm?  Also KEVIN BUZZARD pointed
    out to me (William Stein) in Fall 2002 that the above bound is fine for Gamma1 with
    character, as one sees by taking a power of f.  More precisely, if f = 0 (mod p) 
    for first s coefficients, then f^r = 0 (mod p) for first s*r coefficents.   Since
    weight of f^r is r*weight(f), it follows that if s >= sturm bound for Gamma_0 at
    weight(f), then f^r has valuation large enough to be forced to be 0 at r*weight(f)
    by Sturm bound (which is valid if we choose r right).  Thus f = 0 (mod p).
    Conclusion:  For Gamma_1 with fixed character, the Sturm bound is *exactly* the same
    as for Gamma_0.    

    A key point is that we are finding Z[eps] generators for the Hecke algebra here,
    not Z-generators.  So if one wants generators for the Hecke algebra over Z, this 
    bound is wrong.
*/

/*
      if not IsTrivial(DirichletCharacter(M)) then
         vprint ModularSymbols, 1 : "HeckeBound: Using non-proven bound in computations.";
         print "HeckeBound: Using bound  of ", b, " in computations.";
// Need at least b *:= 2 here, as it fails when e = G.3^2, where G is DirChar(56),
//   and M:=MS(e,2,+1), because the bound is 16, but need more to 
//   cut out subspace dual to cuspidal subspace. 
         b *:= 2;
      end if;
*/
         M`hecke_bound := b;
      else
        G := LevelSubgroup(M);
        M`hecke_bound := Ceiling(Weight(M) * Index(G) / 12);
      end if; 
    end if;   // if not assigned M`hecke_bound   
   return M`hecke_bound;
end intrinsic;


intrinsic SetHeckeBound(M::ModSym, n::RngIntElt) 
{Many computations require a bound n such that T1,...,Tn generate
the Hecke algebra as a Z-module.  This command allows you to set
the bound that is used internally.  Setting it too low can result
in false answers.}
   if not IsAmbientSpace(M) then
      SetHeckeBound(AmbientSpace(M),n);
   else
      M`hecke_bound := n;
   end if;
end intrinsic;


/******************************************************
 * Computation of T_p on dual space.                  *
 ******************************************************/

CFastData := recformat< V, e, VEinv>;


function FastTnData(M, V) 
   // Step 1: find a set of very simple vectors e[1],...,e[n]
   // in M such that det(v[i]*e[j]) =/= 0.
   // 1. [Compute e] e = set of positions so that elements of the space 
   // spanned by the columns of V are determined by the entries in these 
   // spots.  This is accomplished by row reducing, and setting e equal to
   // the sequence of column numbers for which the columns are pivotal.


   n := #V;
   B := Basis(sub<Representation(AmbientSpace(M))|V>);
   assert #B eq n;
   // Find pivot columns.
   e := Pivots(B);

   // Step 2: Compute the matrix V*E of inner products.
   VE    := RMatrixSpace(BaseField(M),n,n)!
               [V[i][e[j]] : j in [1..n], i in [1..n]];
   VEinv := VE^(-1);
   
   return rec<CFastData| V:=V, e:=e, VEinv:=VEinv>;
end function;


function FastTn(M, V, n)
   assert IsAmbientSpace(M);

   if IsMultiChar(M) then
      Tn := DualHeckeOperator(M,n);
      return Restrict(Tn,V);
   end if;
   // Compute action of Transpose(Tn) on the Hecke-stable subspace V.
   FastData := FastTnData(M, Basis(V));
   H     := Heilbronn(M,n,false);
   F     := BaseField(M);
   V     := FastData`V;
   n     := #V;
   m     := Dimension(AmbientSpace(M));
   e     := FastData`e;
   VEinv := FastData`VEinv;
   // The next step is where all of the time is spent. 
   TE    := [TnSparse(M, H, [<1,e[i]>]) : i in [1..n]];
   Vmat  := RMatrixSpace(F, n, m) ! V;
   TEmat := RMatrixSpace(F, n, m) ! TE;
   return  MatrixAlgebra(F,n)!Eltseq(Vmat*Transpose(TEmat)*VEinv);
end function;


intrinsic DualHeckeOperator(M::ModSym, n::RngIntElt) -> AlgMatElt
{Compute a matrix representing the Hecke operator T_n on 
the dual representation of M.   This function is takes significantly 
less time to run than HeckeOperator(M,n) when the dimension of M is
small relative to the dimension of the ambient space containing M.
Note that DualHeckeOperator(M,n) is not guaranteed to equal the 
transpose of HeckeOperator(M,n).}
   require not assigned M`al_decomp or GCD(n,Level(M)) eq 1 : 
    "Hecke operators of index not coprime to the level are not defined on Atkin-Lehner factors.";

   requirege n,1;
   if IsAmbientSpace(M) then
      return Transpose(HeckeOperator(M,n));
   end if;

   if not assigned M`dual_hecke_operator then
      M`dual_hecke_operator := [ ];
   end if;
   if exists(i) { i : i in [1..#M`dual_hecke_operator]
                              | M`dual_hecke_operator[i][1] eq n } then
      return M`dual_hecke_operator[i][2];
   end if;
   vprintf ModularSymbols : "Computing T_%o on dual space of dimension %o.\n",
                          n, Dimension(M);
   if n eq 1 then

      T := MatrixAlgebra(BaseField(M),Dimension(M))!1;

   elif IsMultiChar(M) then
      
      T := Restrict(MC_DualHeckeOperator(AmbientSpace(M),n), DualVectorSpace(M));

   elif IsPrime(n) then
      T := FastTn(AmbientSpace(M),DualRepresentation(M),n);
      assert Degree(Parent(T)) eq Dimension(M);
   else
      fac := Factorization(n);
      if #fac eq 1 then
         // T_{p^r} := T_p * T_{p^{r-1}} - eps(p)p^{k-1} T_{p^{r-2}}.
         p  := fac[1][1];
         r  := fac[1][2];
         eps := DirichletCharacter(M);
         if IsOfGammaType(M) then
           eps_p := Evaluate(eps,p);
         else
	   eps_p := Evaluate(eps,
			     Parent(eps)`OriginalDomain![p,0,0,p]);
         end if;
         T  := DualHeckeOperator(M,p) * DualHeckeOperator(M,p^(r-1))
        - eps_p*p^(Weight(M)-1)*DualHeckeOperator(M,p^(r-2));
      else  // T_m*T_r := T_{mr} and we know all T_i for i<n.
         m  := fac[1][1]^fac[1][2];
         T  := DualHeckeOperator(M,m)*DualHeckeOperator(M,n div m);
      end if;            
   end if;
   Append(~M`dual_hecke_operator,<n,T>);
   return T;
end intrinsic;


function ActionOnModularSymbolsBasis(g, M)
   // 1. Compute basis of modular symbols for M.
   B  := ModularSymbolsBasis(M);
   // 2. Apply g to each basis element. 
   gB := [ModularSymbolApply(g,B[i]) : i in [1..#B]];
   // 3. Map the result back to M.
   gM := [Representation(ConvFromModularSymbol(M,gB[i])) : i in [1..#gB]];
   A :=  MatrixAlgebra(BaseField(M),Dimension(M))!gM;
   return A;
end function;

// This could be quite slow...
// This assumes that g indeed defines a map M_dom -> M_range
function ActionOnModularSymbolsBasisBetween(g, M_dom, M_range)
   // 1. Compute basis of modular symbols for M_dom.
   B  := ModularSymbolsBasis(M_dom);
   // 2. Apply g to each basis element. 
   gB := [ModularSymbolApply(g,B[i]) : i in [1..#B]];
   // 3. Map the result back to M_range.
   gM := [Representation(ConvFromModularSymbol(M_range,gB[i])) : i in [1..#gB]];
   A :=  Matrix(gM);
   return A;
end function;

function ActionOnModularSymbolsBasisElement(g, M, i)
   // 1. Compute basis of modular symbols for M.
   x  := ModularSymbolsBasis(M)[i];
   // 2. Apply g to x
   gx := ModularSymbolApply(g,x);
   // 3. Map the result back to M.
   return Representation(ConvFromModularSymbol(M,gx));
end function;

function AtkinLehnerSign(M)
   assert Type(M) eq ModSym;
   W := AtkinLehner(M,Level(M));
   assert IsScalar(W);
   return W[1,1];
end function;

intrinsic AtkinLehner(M::ModSym, q::RngIntElt) -> AlgMatElt
{The same as AtkinLehnerOperator(M,q).}
   return AtkinLehnerOperator(M,q);   
end intrinsic;

intrinsic AtkinLehnerOperator(M::ModSym, q::RngIntElt) -> AlgMatElt 

{The matrix that represents the qth Atkin-Lehner involution W_q on M,
when it is defined on modular symbols.  The involution W_q is defined
on modular symbols when M has trivial or quadratic character and even
weight (otherwise it doesn't preserve M -- use AtkinLehnerOperatorOverQ instead).  
When possible, the Atkin-Lehner operator is normalized so that it is an involution; such
normalization may not be possible when the weight k of M is >2 and the
characteristic of the base field of M divides q.}

   require IsEven(Weight(M))              : "Argument 1 must have even weight.";
   require Level(M) mod q eq 0            : "Argument 2 must divide the level of argument 1.";
   require q ne 0 and Level(M) mod q eq 0 : "Argument 2 must be nonzero and divide the level.";

   N := Level(M);
   k := Weight(M);
   repeat
      d := Gcd(Integers()!(N/q),q);
      if d eq 1 then 
         break; 
      end if;
      q *:= d;
   until false;   

   if not assigned M`atkin_lehner then
      M`atkin_lehner := [];
   end if;
   if not exists(t) { t[2] : t in M`atkin_lehner | t[1] eq q } then
       if not IsAmbientSpace(M) then
           t := Restrict(AtkinLehner(AmbientSpace(M),q), Representation(M));
       elif IsMultiChar(M) then
           t := MC_AtkinLehnerOperator(M,q);
       else
	   require IsTrivial(DirichletCharacter(M)^2)  :
	    "Argument 1 must have trivial or quadratic character.";
           // 1. Compute matrix to act by.
           d, x, y:= XGCD(q,-Integers()!(N/q));
           g := [q*x, y, N, q];
           A := ActionOnModularSymbolsBasis(g, M);
           p := Characteristic(M`F); 
           if p eq 0 or q mod p ne 0 then
	       A /:= q^(Integers()!(k/2)-1);
           end if;
           t := A;
       end if;
       Append(~M`atkin_lehner, <q,t>);
   end if;
   return t;
end intrinsic;

intrinsic AtkinLehnerOperatorOverQ(M::ModSym, q::RngIntElt) -> AlgMatElt 

{The matrix that represents the qth Atkin-Lehner involution W_q on the
restriction of scalars of M to Q.  We assume that M is defined over
a cyclotomic extension of Q generated by character values.  This W_q is
defined since the restriction of scalars is closed under conjugation
of the Dirichlet character.  We do, however, require that q be divisible by
the conductor of the Dirichlet character.}

   if IsTrivial(DirichletCharacter(M)^2) then
      return AtkinLehnerOperator(M,q);
   end if;
   require Level(M) mod q eq 0            : "Argument 2 must divide the level of argument 1.";
   require q ne 0 and Level(M) mod q eq 0 : "Argument 2 must be nonzero and divide the level.";
   require q mod Conductor(DirichletCharacter(M)) eq 0 : 
        "Argument 2 must be divisible by the conductor of the character of argument 1.";

   if Dimension(M) eq 0 then
      return MatrixAlgebra(RationalField(),0)!0;
   end if;

   N := Level(M);
   k := Weight(M);
   repeat
      d := Gcd(Integers()!(N/q),q);
      if d eq 1 then 
         break; 
      end if;
      q *:= d;
   until false;   

   if not assigned M`atkin_lehner then
      M`atkin_lehner := [];
   end if;
   if not exists(t) { t[2] : t in M`atkin_lehner | t[1] eq q } then
      if not IsAmbientSpace(M) then
         Append(~M`atkin_lehner, 
             <q,Restrict(AtkinLehnerOperatorOverQ(AmbientSpace(M),q),
                       RestrictionOfScalars(VectorSpace(M)))>);
      else
         // 1. Compute matrix to act by.
         d, x, y:= XGCD(q,-Integers()!(N/q));
         g := [q*x, y, N, q];
         A := ActionOnModularSymbolsBasis(g, M);
         p := Characteristic(M`F); 
         if p eq 0 or q mod p ne 0 then
            A /:= q^(Integers()!(k/2)-1);
         end if;
/*
   n := Nrows(A);
   F := MatrixAlgebra(BaseField(M),2*n)!0;
   for r in [1..n] do
      for c in [1..n] do
         F[r+n,c] := A[r,c];
         F[r,c+n] := ComplexConjugate(A[r,c]);
      end for;
   end for;
print "FCP(F) = ", Factorization(CharacteristicPolynomial(F));
*/
   
         phi_Q := FieldAutomorphismMatrix(AmbientSpace(M), ComplexConjugate);  
         A_Q := RestrictionOfScalars(A);
         A := phi_Q*A_Q;
//print "A = ", A;
//print "FCP(A) = ", Factorization(CharacteristicPolynomial(A));
         Append(~M`atkin_lehner, <q,A>);
      end if;
   end if;
   assert exists(t) { t[2] : t in M`atkin_lehner | t[1] eq q};
   return t;
end intrinsic;

intrinsic DualAtkinLehner(M::ModSym, q::RngIntElt) -> AlgMatElt
{The same as DualAtkinLehnerOperator(M,q).}
   return DualAtkinLehnerOperator(M,q);
end intrinsic;


intrinsic DualAtkinLehnerOperator(M::ModSym, q::RngIntElt) -> AlgMatElt
{The action of the Atkin-Lehner involution on the dual 
representation of M, when it is defined (see the documentation
for AtkinLehner.)}
   require IsEven(Weight(M)) : "Argument 1 must have even weight.";
   if not IsMultiChar(M) then
       require IsTrivial(DirichletCharacter(M)) :
      "Argument 1 must have trivial character.";
   end if;
   require Level(M) mod q eq 0 : "Argument 2 must divide the level of argument 1.";
   if not assigned M`dual_atkin_lehner then
      M`dual_atkin_lehner := [];
   end if;
   if not exists(t) { t[2] : t in M`dual_atkin_lehner | t[1] eq q } then
       if IsAmbientSpace(M) then
         Append(~M`dual_atkin_lehner, <q,Transpose(AtkinLehner(M,q))>);
      else
         Append(~M`dual_atkin_lehner, <q,Restrict(DualAtkinLehner(AmbientSpace(M),q),DualRepresentation(M))>);
      end if;
   end if;
   assert exists(t) { t[2] : t in M`dual_atkin_lehner | t[1] eq q};
   return t;
end intrinsic;


intrinsic DualStarInvolution(M::ModSym) -> AlgMatElt
{The conjugation involution * on the dual representation of M
(see the documentation for StarInvolution.)}
   if not assigned M`dual_star_involution then
      if IsAmbientSpace(M) then
         M`dual_star_involution := Transpose(StarInvolution(AmbientSpace(M)));
      else
         M`dual_star_involution := 
           Restrict(DualStarInvolution(AmbientSpace(M)),DualRepresentation(M));
      end if;
   end if;
   return M`dual_star_involution;
end intrinsic;


intrinsic StarInvolution(M::ModSym) -> AlgMatElt
{The conjugation involution * on M that sends the modular 
symbol X^iY^j\{u,v\} to (-1)^jX^iY^j \{-u,-v\}.}
   if not assigned M`star_involution then
      if IsAmbientSpace(M) then
         if IsMultiChar(M) then
            M`star_involution := MC_StarInvolution(M);
         elif Sign(M) eq 0 then
            M`star_involution := 
                Restrict(ActionOnModularSymbolsBasis([-1,0,0,1], M),
                         VectorSpace(M));
         else 
            M`star_involution := 
                MatrixAlgebra(BaseField(M),Dimension(M))!Sign(M);
         end if;
      else
         M`star_involution := 
              Restrict(StarInvolution(AmbientSpace(M)),VectorSpace(M));
      end if;
   end if;
   return M`star_involution;
end intrinsic;



/*****************************************************************

 THE THETA OPERATOR: 
   On q-expansions, the theta operator is q*d/dq.  It takes
   the q-expansion of a mod ell modular form of weight k to 
   a mod ell modular form of weight k + ell + 1. 
   On modular symbols the theta operator is simply multiplication
   by X^{ell}*Y - X*Y^{ell}.
   Proof:
      Let Q(X,Y) = X^{ell}*Y - X*Y^{ell}. 
      Then for any g in GL_2(Q), 
            Q(det(g) g^{-1}(X,Y)) = det(g) Q(X,Y)  (mod ell).
      (This congruence, of course, does not hold in 
       characteristic 0.)
      To prove the congruence simply multiply everything
      out and use the fact that elements in F_{ell} satisfy
      a^{ell} = a. 

   This construction was suggested to me by Kevin Buzzard and his girlfriend
   Tamzin at Taiwan restaurant in Berkeley.  For more details, see the 
   proof of Proposition~4.5.1, page 61, of Kevin's Ph.D. thesis.

 *****************************************************************/



intrinsic ThetaOperator(M1::ModSym, M2::ModSym) -> Map
{Multiplication by X^pY - XY^p, which is 
a possible analogue of the theta-operator.
(On mod p modular forms, the theta-operator 
is the map given by f |--> q df/dq.)
Both M_1 and M_2 must be spaces of modular symbols over a 
field of positive characteristic p; they must have the same 
level and character, and the weight of M_2 must equal 
the weight of M_1 plus p+1.}

   ell := Characteristic(BaseField(M1));
   require IsPrime(ell) : "The characteristic must be prime.";
   require ell eq Characteristic(BaseField(M2)) : 
              "The characteristics must be equal.";
   require Level(M1) eq Level(M2) : "The levels must be equal.";
   require DirichletCharacter(M1) eq DirichletCharacter(M2) : 
              "The characters must be equal.";

   function do_ThetaOperator(M1, M2, x)
      assert Type(M1) eq ModSym;
      assert Type(M2) eq ModSym;
      assert Type(x) eq ModSymElt;
   
      ell := Characteristic(BaseField(M1));
      sym := ConvToModularSymbol(M1,x);
      if #sym eq 0 then
         return M2!0;
      end if;
      P<X,Y> := Parent(sym[1][1]);
      Q      := X^ell*Y - Y^ell*X;
      for i in [1..#sym] do
         sym[i][1] *:= Q;
      end for;
      return ConvFromModularSymbol(M2,sym);
   end function;

   return hom<M1->M2 | x :->do_ThetaOperator(M1,M2,x)>;

end intrinsic;

intrinsic HeckeOperatorModSym(M::ModSym, p::RngIntElt) -> AlgMatElt
{Compute the Hecke operator T_p directly on modular symbols.}
   require not assigned M`al_decomp or GCD(p,Level(M)) eq 1 : 
    "Hecke operators of index not coprime to the level are not defined on Atkin-Lehner factors.";
   require IsPrime(p) : "p must be a prime."; 
   return HeckeOperatorDirectlyOnModularSymbols(M,p); 

end intrinsic;



function HeckeOperator_ProjectionData(M)
   assert Type(M) eq ModSym;
   if not assigned M`hecke_operator_proj_data then
      n := Dimension(M);
      K := BaseField(M);
      A := VectorSpace(AmbientSpace(M));
      V := VectorSpace(M);
      PI := ProjectionMatrix(M);
      if K cmpeq Rationals() then 
         // Do it over F_p instead (Steve added this)
         p := Floor(2^23.5);
         repeat 
           p := PreviousPrime(p);  F := GF(p); 
           can_reduce_at_p, PI_F := IsCoercible( MatrixRing(F,Dimension(A)), PI); 
         until can_reduce_at_p and Rank(PI_F) eq n;
      else
         // just use the original (WAS) procedure
         F := K;
      end if;
      E := [];
      e := 1;
      W := sub< ChangeRing(V,F) | 0 >;
      EPI := [];
      while #E lt n do
         x := A.e*PI;
         xF := ChangeRing(x, F);
         Include( ~W, xF, ~x_is_new );
         if x_is_new then
           Append(~E, e);
           Append(~EPI,x);
         end if;
         e +:= 1;
      end while;
      EPI := RMatrixSpace(K,Dimension(M),Dimension(A))!EPI;
      MM  := RMatrixSpace(K,Dimension(M),Dimension(A))!Basis(VectorSpace(M));
      X := Solution(EPI, MM);
      M`hecke_operator_proj_data := <X, E>;
   end if;
   return M`hecke_operator_proj_data;
end function;

function HeckeOperator_OnSubspace_UsingComplement(M,n)
   assert Type(M) eq ModSym;
   assert Type(n) eq RngIntElt;
   assert n ge 1;

   /* ALGORITHM:
      Let M be the matrix whose rows are Basis(M) and let T be the matrix of 
      the Hecke operator T_n on the whole space.  Let [T] be the matrix of T
      with respect to Basis(M), which is what we want.   Then [T] is the unique
      solution to the equation  [T]*M = M*T.   Computing M*T directly is difficult
      because it requires computing the relatively huge matrix T on the whole
      ambient space.   Instead, let P be the unique projection matrix from the 
      ambient space to M (in the Hecke algebra, say).   Let E be a matrix whose
      rows are such that it is relatively easy to compute E*T (e.g., the rows
      are very sparse), and such that the rows of E*P are a basis for M.  Let
      C be the unique solution to C*E*P = M, which exists by assumption on E*P.
      Using that P lies in the Hecke algebra, hence commutes with T, we have

                     [T]*M = M*T = C*E*P*T = C*E*T*P = C*(E*T)*P.

      How E*T is, by assumption, easy to compute, so we obtain [T] without
      too much work.   This is the algorithm implemented below, and it's
      one that I (William Stein, June 2003) should have figured out long 
      ago, since it speeds this up a lot!!
    */
  
   PI := ProjectionMatrix(M);
   X,E := Explode(HeckeOperator_ProjectionData(M));
   A := AmbientSpace(M);
   K := BaseField(M);
   H := Heilbronn(M,n,false);
   Mat := RMatrixSpace(K,Dimension(M),Dimension(A));
   ETPI := Mat ! [TnSparse(A, H, [<1,e>])*PI : e in E];
   MM := BasisMatrix(VectorSpace(M));
   return MatrixAlgebra(K, Dimension(M)) ! Solution(MM, X*ETPI);

end function;

