if __name__ == '__main__':

    from CRABAPI.RawCommand import crabCommand
    from CRABClient.ClientExceptions import ClientException
    from httplib import HTTPException

    #from CRABClient.UserUtilities import config
    #config = config()
    from WMCore.Configuration import Configuration
    config = Configuration()

    config.section_("General")
    config.General.workArea = 'crab'
    config.General.transferOutputs = True
    config.General.transferLogs = True

    config.section_("JobType")
    config.JobType.pluginName = 'PrivateMC'

    config.section_("Data")
    config.Data.inputDBS = 'global'
    config.Data.splitting = 'EventBased'
    config.Data.unitsPerJob = 1000
    config.Data.totalUnits = 100000
    config.Data.publication = True

    config.section_("Site")
    config.Site.storageSite = 'T2_US_Caltech'
    # We want to put all the CRAB project directories from the tasks we submit here into one common directory.
    # That's why we need to set this parameter (here or above in the configuration file, it does not matter, we will not overwrite it).

    def submit(config):
        try:
            crabCommand('submit', config = config)
        except HTTPException as hte:
            print "Failed submitting task: %s" % (hte.headers)
        except ClientException as cle:
            print "Failed submitting task: %s" % (cle)

    #############################################################################################
    ## From now on that's what users should modify: this is the a-la-CRAB2 configuration part. ##
    #############################################################################################
    ev = 100000 #100k events
    mchi_list = [200]
    #mchi_list = [150, 175, 200, 225, 250, 275, 300, 325, 350, 375, 400, 425, 450, 475, 500, 525, 550, 575, 600, 625, 650, 675, 700, 725, 750, 775, 800, 825, 850, 875, 900, 925, 950, 975] #GeV
    #mchi_list = [127, 150, 175, 200, 225, 250, 275, 300, 325, 350, 375, 400, 425, 450, 475, 500, 525, 550, 575, 600, 625, 650, 675, 700, 725, 750, 775, 800, 825, 850, 875, 900, 925, 950, 975] #GeV
    #pl_list = [1000]
    pl_list = ['prompt']
    mode_list = ["n3n2-n1-hbb-hbb"]
    pset_dir = "/afs/cern.ch/user/j/jmao/work/public/releases/cms-llp/aodsim/config/RunIISummer16_withISR/"
    for i in range(len(mode_list)):
	mode = mode_list[i]
	for mchi in mchi_list:
	    for pl in pl_list:
		spec = mode+"_m{}_{}_ev{}".format(mchi,pl,ev)
		
    		config.General.requestName = 'CMSSW_7_6_3_'+mode+"_mchi{}_{}_ev{}".format(mchi,pl,ev)+'_GENSIM_CaltechT2'
    		#config.General.requestName = 'CMSSW_7_6_3_'+mode+"_mchi{}_pl{}_ev{}".format(mchi,pl,ev)+'_GENSIM_CaltechT2'
		config.Data.outputPrimaryDataset = spec
		config.Data.outLFNDirBase = '/store/group/phys_exotica/jmao/aodsim/RunIISummer16/GENSIM/MSSM-1d-prod/'
		config.JobType.psetName = pset_dir + mode + "/" + spec +"_step0_cfg.py"
		#print 'config %s' %(config.JobType.psetName)
		submit(config)
