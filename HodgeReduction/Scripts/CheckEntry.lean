import HodgeReduction.MainChain

def main : IO UInt32 :=
  ChainAudit.Status.runCheck HodgeReduction.MainChain.config
