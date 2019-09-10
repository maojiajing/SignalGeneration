#!/bin/bash

#directory def
work_dir=/afs/cern.ch/user/j/jmao/work/public/releases/cms-llp/ 
step0_dir=/afs/cern.ch/user/j/jmao/work/public/releases/cms-llp/CMSSW_7_6_3/src/
step1_dir=/afs/cern.ch/user/j/jmao/work/public/releases/cms-llp/CMSSW_8_0_21/src/
step2_dir=/afs/cern.ch/user/j/jmao/work/public/releases/cms-llp/CMSSW_8_0_21/src/

#Format: bash lhe_to_aod_test.sh [step] [mchi] [nev] [mode]
STEP=$1
MCHI=$2
RUN=run_m${MCHI}_ev${N_EV}
PL=$3
N_EV=$4
mode=$5
#root_file_step0=root://cms-xrd-global.cern.ch//store//user/christiw/ppTohToSS1SS2_SS1Tobb_SS2Toveve_MC_prod/ppTohToSS1SS2_SS1Tobb_SS2Toveve_run_m50_w0p001_pl_10_step0/crab_CMSSW_7_6_3_ppTohToSS1SS2_SS1Tobb_SS2Toveve_run_m50_w0p001_pl_10_GENSIM_CaltechT2/190108_064437/0000/ppTohToSS1SS2_SS1Tobb_SS2Toveve_run_m50_w0p001_pl_10_step0_1.root
OUTPUT_FILE=${mode}
lhe_file=root://cmsxrootd.fnal.gov//store/group/phys_exotica/jmao/aodsim/RunIISummer16/LHE/MSSM-1d-prod/n3n2-n1-hbb-hbb/pl_${PL}/m${MCHI}_pl${PL}_evt100k.lhe
LHE_OUTPUT=${OUTPUT_FILE}_mh${MCHI}_pl${PL}_ev${N_EV}
#lhe_file=root://cmsxrootd.fnal.gov//store/group/phys_exotica/jmao/aodsim/RunIISummer16/LHE/MSSM-1d-prod/n3n2-n1-hbb-hbb/${PL}/m${MCHI}_${PL}_evt100k.lhe
#LHE_OUTPUT=${OUTPUT_FILE}_m${MCHI}_${PL}_ev${N_EV}
#lhe_file=root://cms-xrd-global.cern.ch//store/group/phys_exotica/jmao/aodsim/RunIISummer16/LHE/MSSM-1d-prod/n3n2-n1-hbb-hbb/m${MCHI}_pl${PL}.lhe
OUTPUT_DIR=/afs/cern.ch/user/j/jmao/work/public/releases/cms-llp/aodsim/config/RunIISummer16_withISR/${OUTPUT_FILE}/
mkdir -p ${OUTPUT_DIR}
if [ $STEP -eq 0 ] 
then
cd ${step0_dir}
eval `scramv1 runtime -sh`
cmsDriver.py Configuration/Generator/python/ppTohToSS1SS2_SS1Tobb_SS2Toveve.py --filein ${lhe_file} --fileout file:${OUTPUT_FILE}_step0.root --step GEN,SIM --conditions 76X_mcRun2_asymptotic_v12 --no_exec --eventcontent RAWSIM --datatier GEN-SIM --mc --era Run2_25ns -n ${N_EV}  --python_filename ${OUTPUT_DIR}${LHE_OUTPUT}_step0_cfg.py
#sed -i "s/t.outputCommands/t.outputCommands + ['keep *_genParticles_xyz0_*', 'keep *_genParticles_t0_*',]/g" ${OUTPUT_DIR}${LHE_OUTPUT}_step0_cfg.py
#cmsRun ${OUTPUT_DIR}${LHE_OUTPUT}_step0_cfg.py
cd ${wor_dir}
echo "step 0 completed"

#step 1, from GENSIm to DIGI-RECO
elif [ $STEP -eq 1 ] 
then
cd ${step1_dir}
eval `scramv1 runtime -sh`
cmsDriver.py step1 --filein file:${OUTPUT_DIR}${OUTPUT_FILE}_step0.root --fileout file:${OUTPUT_FILE}_step1.root  --pileup_input "dbs:/Neutrino_E-10_gun/RunIISpring15PrePremix-PUMoriond17_80X_mcRun2_asymptotic_2016_TrancheIV_v2-v2/GEN-SIM-DIGI-RAW" --mc --eventcontent PREMIXRAW --datatier GEN-SIM-RAW --conditions 80X_mcRun2_asymptotic_2016_TrancheIV_v6 --step DIGIPREMIX_S2,DATAMIX,L1,DIGI2RAW,HLT:@frozen2016 --nThreads 1 --datamix PreMix --era Run2_2016 --python_filename ${OUTPUT_DIR}${OUTPUT_FILE}_step1_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n ${N_EV}
#sed -i "s/t.outputCommands/t.outputCommands + ['keep *_genParticles_xyz0_*', 'keep *_genParticles_t0_*',]/g" ${OUTPUT_DIR}${OUTPUT_FILE}_step1_cfg.py
#cmsRun ${OUTPUT_DIR}${OUTPUT_FILE}_step1_cfg.py
cd ${wor_dir}
echo "step 1 completed"

#====== step 2, from DR to AODSIM
elif [ $STEP -eq 2 ]
then
cd ${step2_dir}
eval `scramv1 runtime -sh`
cmsDriver.py step2 --filein file:${OUTPUT_DIR}${OUTPUT_FILE}_step1.root --fileout file:${OUTPUT_FILE}_step2.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 80X_mcRun2_asymptotic_2016_TrancheIV_v6 --step RAW2DIGI,RECO,EI --nThreads 1 --era Run2_2016 --python_filename ${OUTPUT_DIR}${OUTPUT_FILE}_step2_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n ${N_EV}
#sed -i "s/t.outputCommands/t.outputCommands + ['keep *_genParticles_xyz0_*', 'keep *_genParticles_t0_*',]/g" ${OUTPUT_DIR}${OUTPUT_FILE}_step2_cfg.py
#cmsRun ${OUTPUT_DIR}${OUTPUT_FILE}_step2_cfg.py
cd ${wor_dir}
echo "step 2 completed"
fi
