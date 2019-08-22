# SignalGeneration

## step0:

```
cmsrel CMSSW_7_6_3

cd CMSSW_7_6_3/src
cmsenv

git cms-init
git cms-addpkg Configuration/Generator

cp /afs/cern.ch/work/c/christiw/public/releases/CMSSW_7_6_3/src/Configuration/Generator/python/ppTohToSS1SS2_SS1Tobb_SS2Toveve.py Configuration/Generator/python/

scram b -j 8

voms-proxy-init --voms cms

cmsDriver.py Configuration/Generator/python/ppTohToSS1SS2_SS1Tobb_SS2Toveve.py --filein ../../unweighted_events.lhe --fileout file:test_step0.root --step GEN,SIM --conditions 76X_mcRun2_asymptotic_v12 --no_exec --eventcontent RAWSIM --datatier GEN-SIM --mc --era Run2_25ns -n 1000 --python_filename test_step0_cfg.py

cmsRun test_step0_cfg.py
```

## step1:

```
cmsrel CMSSW_8_0_21

cd CMSSW_8_0_21/src
cmsenv

git cms-init
git cms-addpkg Configuration/Generator
git cms-addpkg PhysicsTools/HepMCCandAlgos 
git cms-addpkg PhysicsTools/PatAlgos

cp /afs/cern.ch/work/c/christiw/public/releases/CMSSW_8_0_21/src/Configuration/Generator/python/ppTohToSS1SS2_SS1Tobb_SS2Toveve.py Configuration/Generator/python/

scram b -j 8

voms-proxy-init --voms cms

cmsDriver.py step1 --filein file:/afs/cern.ch/user/j/jmao/work/public/releases/cms-llp/CMSSW_7_6_3/src/test_step0.root --pileup_input "dbs:/Neutrino_E-10_gun/RunIISpring15PrePremix-PUMoriond17_80X_mcRun2_asymptotic_2016_TrancheIV_v2-v2/GEN-SIM-DIGI-RAW" --mc --eventcontent PREMIXRAW --datatier GEN-SIM-RAW --conditions 80X_mcRun2_asymptotic_2016_TrancheIV_v6 --step DIGIPREMIX_S2,DATAMIX,L1,DIGI2RAW,HLT:@frozen2016 --nThreads 1 --datamix PreMix --era Run2_2016 --python_filename test_step1_cfg.py  --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 1000

cmsRun test_step1_cfg.py
```

## step2:

```
cd CMSSW_8_0_21/src
cmsenv

voms-proxy-init --voms cms

cmsDriver.py step2 --filein file:/afs/cern.ch/user/j/jmao/work/public/releases/cms-llp/CMSSW_8_0_21/src/step1_DIGIPREMIX_S2_DATAMIX_L1_DIGI2RAW_HLT.root --fileout file:test_step2.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 80X_mcRun2_asymptotic_2016_TrancheIV_v6 --step RAW2DIGI,RECO,EI --nThreads 1 --era Run2_2016 --python_filename test_step2_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 1000

cmsRun test_step2_cfg.py
```
