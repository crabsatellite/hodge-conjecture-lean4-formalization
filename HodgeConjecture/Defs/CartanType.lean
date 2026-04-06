/-
  HodgeConjecture/Defs/CartanType.lean

  Killing--Cartan classification of simple Lie algebras over ℚ.
  The nine types: A_n, B_m, C_n, D_m, E_6, E_7, E_8, F_4, G_2.
-/
import Mathlib.Data.Finset.Basic
import Mathlib.Tactic

namespace HodgeConjecture

/-- Simple Lie algebra types in the Killing-Cartan classification. -/
inductive CartanType where
  | A (n : ℕ) (hn : n ≥ 1) -- unitary: SU(n+1), rank n
  | B (m : ℕ) (hm : m ≥ 2) -- odd orthogonal: SO(2m+1), rank m
  | C (n : ℕ) (hn : n ≥ 3) -- symplectic: Sp(2n), rank n
  | D (m : ℕ) (hm : m ≥ 4) -- even orthogonal: SO(2m), rank m
  | E6
  | E7
  | E8
  | F4
  | G2
  deriving DecidableEq

/-- The rank of a simple Lie algebra. -/
def CartanType.rank : CartanType → ℕ
  | .A n _ => n
  | .B m _ => m
  | .C n _ => n
  | .D m _ => m
  | .E6 => 6
  | .E7 => 7
  | .E8 => 8
  | .F4 => 4
  | .G2 => 2

/-- Whether the type is classical (A, B, C, D) or exceptional (E, F, G). -/
def CartanType.isClassical : CartanType → Bool
  | .A _ _ => true
  | .B _ _ => true
  | .C _ _ => true
  | .D _ _ => true
  | _ => false

def CartanType.isExceptional : CartanType → Bool
  | .E6 => true
  | .E7 => true
  | .E8 => true
  | .F4 => true
  | .G2 => true
  | _ => false

end HodgeConjecture
