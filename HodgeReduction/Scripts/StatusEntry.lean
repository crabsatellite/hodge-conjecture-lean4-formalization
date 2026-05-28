import HodgeReduction.MainChain

def main : IO UInt32 :=
  ChainAudit.Status.runAudit HodgeReduction.MainChain.config
