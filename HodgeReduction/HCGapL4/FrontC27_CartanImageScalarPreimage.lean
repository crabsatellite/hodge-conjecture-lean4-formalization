/-
# HC Gap L4 -- Front C27: Cartan image exactness as scalar preimages (R568).

R566/R567 left three genuine EVII geometric equalities.  The third one,

  `Submodule.map j_q trivialModuleGK_H8 = trivialModulePart`,

is the Cartan-image exactness statement.  This file turns that submodule
equality into the element-level problem a next agent can attack:

  every class in the cuspidal trivial-module part is `j_q (r * h^4)`.

The containment direction is already formal once the Matsushima
compact-dual carrier is identified with Cartan's H8 line: compact-dual
classes map into target invariants, and R554 identifies target invariants
with the trivial-module part.  Thus the remaining content of the Cartan
image equality is exactly scalar surjectivity onto the trivial-module
part.

No concrete EVII instance, axiom, or stronger bundled premise is added.
-/

import HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC27_CartanImageScalarPreimage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC25_CartanLineBoundaryExactness

section ExactImageToScalarPreimage

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [CuspidalCohomologyData B]

/-- **R568 substantive theorem (1/4)**: exact Cartan-image equality gives
an element-level scalar preimage: every trivial-module class is the
Matsushima image of some scalar multiple of `h^4`. -/
theorem exists_scalar_h_pow_four_preimage_of_cartan_image
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B))
    {beta : B}
    (hbeta : beta ∈ CuspidalCohomologyData.trivialModulePart (A := B)) :
    ∃ r : Rat,
      MatsushimaData.j_q (A := A) (B := B)
        (r • ((KaehlerClass.h : A) ^ 4)) = beta := by
  have hbeta_image :
      beta ∈
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
    rw [hcartan_image]
    exact hbeta
  obtain ⟨alpha, halpha_cartan, halpha_beta⟩ := hbeta_image
  have halpha_H8 : alpha ∈ CompactDualData.H8 (A := A) := by
    rw [<- CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
    exact halpha_cartan
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)] at halpha_H8
  rw [Submodule.mem_span_singleton] at halpha_H8
  obtain ⟨r, hr⟩ := halpha_H8
  refine ⟨r, ?_⟩
  rw [hr]
  exact halpha_beta

end ExactImageToScalarPreimage

section CartanImageContainment

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R568 substantive theorem (2/4)**: once the Matsushima compact-dual
carrier is Cartan's H8 line, the Cartan image is contained in the
cuspidal trivial-module part.  The reverse containment is the real gap. -/
theorem cartan_image_le_trivialModulePart_of_compactDual_eq_cartan
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      ≤ CuspidalCohomologyData.trivialModulePart (A := B) := by
  intro beta hbeta
  obtain ⟨alpha, halpha_cartan, halpha_beta⟩ := hbeta
  have halpha_compact :
      alpha ∈ MatsushimaCompactDualData.compactDual (A := A) (B := B) := by
    rw [hcompact_cartan]
    exact halpha_cartan
  have htarget :
      MatsushimaData.j_q (A := A) (B := B) alpha ∈
        MatsushimaData.target_invariants (A := A) (B := B) :=
    MatsushimaCompactDualData.j_q_compactDual_in_target_invariants
      (A := A) (B := B) halpha_compact
  rw [<- halpha_beta]
  rw [<- target_invariants_eq_trivialModulePart (A := A) (B := B)]
  exact htarget

/-- **R568 substantive theorem (3/4)**: after the compact-dual carrier is
identified with Cartan's H8 line, exact Cartan-image equality is
equivalent to scalar surjectivity from the single generator `h^4`. -/
theorem cartan_image_eq_trivialModulePart_iff_scalar_preimage
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B)
    ↔
    ∀ beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
        ∃ r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta := by
  constructor
  · intro hcartan_image beta hbeta
    exact exists_scalar_h_pow_four_preimage_of_cartan_image
      (A := A) (B := B) hcartan_image hbeta
  · intro hscalar
    apply le_antisymm
    · exact cartan_image_le_trivialModulePart_of_compactDual_eq_cartan
        (A := A) (B := B) hcompact_cartan
    · intro beta hbeta
      obtain ⟨r, hr⟩ := hscalar beta hbeta
      refine ⟨r • ((KaehlerClass.h : A) ^ 4), ?_, hr⟩
      have hh4_H8 :
          ((KaehlerClass.h : A) ^ 4) ∈ CompactDualData.H8 (A := A) := by
        rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
        exact Submodule.subset_span (by simp)
      have hh4_cartan :
          ((KaehlerClass.h : A) ^ 4) ∈
            CartanCompactDualIso.trivialModuleGK_H8 (A := A) := by
        rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
        exact hh4_H8
      exact Submodule.smul_mem _ r hh4_cartan

end CartanImageContainment

section BoundaryFromScalarPreimage

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R568 substantive theorem (4/4)**: the FrontC boundary package can
consume scalar preimage surjectivity instead of the raw Cartan-image
submodule equality.  The two other Cartan-line exactness statements remain
explicit geometric inputs. -/
def matsushimaV56BoundaryData_of_cartan_scalar_preimage
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_cartan :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hscalar :
      ∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_cartan_line_exactness
    (A := A) (B := B)
    hsource_cartan
    hcompact_cartan
    ((cartan_image_eq_trivialModulePart_iff_scalar_preimage
      (A := A) (B := B) hcompact_cartan).2 hscalar)

def R568_substantiveTheoremCount : Nat := 4

end BoundaryFromScalarPreimage

end FrontC27_CartanImageScalarPreimage
end HCGapL4
end HodgeReduction
