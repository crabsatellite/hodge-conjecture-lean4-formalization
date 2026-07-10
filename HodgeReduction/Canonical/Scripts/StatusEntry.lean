import HodgeReduction.Canonical.MainChain

def main : IO UInt32 :=
  ChainAudit.Status.runAudit HodgeReduction.Canonical.MainChain.config
