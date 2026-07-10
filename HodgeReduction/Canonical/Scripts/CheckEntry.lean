import HodgeReduction.Canonical.MainChain

def main : IO UInt32 :=
  ChainAudit.Status.runCheck HodgeReduction.Canonical.MainChain.config
