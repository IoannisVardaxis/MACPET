#' @importFrom stats p.adjust.methods
#' @importFrom methods is
#' @importFrom ShortRead countLines
#' @importFrom futile.logger flog.appender flog.layout layout.format appender.tee flog.info flog.warn
#------------------------------------
# input check for MACPETUlt.R
#------------------------------------
# main function for checking the inputs:
InputCheckMACPETUlt = function(InArg) {
    LogFile = list()  #for the log file.
    LogFile[1] = "|%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|"
    LogFile[2] = "|-------------MACPET analysis input checking------------|"
    LogFile[3] = "|%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|"
    #------------------------------------
    # all stages input:
    #------------------------------------
    Input_check_SA_fun(InArg = InArg)
    LogFile[4] = "Common stage inputs...OK"
    LogFile[5] = paste("Stages to run: ", paste((InArg$SA_stages), collapse = "-"),
        sep = "")
    # write in log and print:
    for (lf in seq_len(5)) futile.logger::flog.info(LogFile[[lf]], name = "SA_LogFile",
        capture = FALSE)
    #------------------------------------
    # 0 stage input:
    #------------------------------------
    if (c(0) %in% InArg$SA_stages) {
        InArg = Input_check_S0_fun(InArg)
    }
    #------------------------------------
    # 1 stage input:
    #------------------------------------
    if (c(1) %in% InArg$SA_stages) {
        InArg = Input_check_S1_fun(InArg)
    }
    #------------------------------------
    # 2 stage input:
    #------------------------------------
    if (c(2) %in% InArg$SA_stages) {
        InArg = Input_check_S2_fun(InArg)
    }
    #------------------------------------
    # 3 stage input:
    #------------------------------------
    if (c(3) %in% InArg$SA_stages) {
        InArg = Input_check_S3_fun(InArg)
    }
    #------------------------------------
    # 4 stage input:
    #------------------------------------
    if (c(4) %in% InArg$SA_stages) {
        InArg = Input_check_S4_fun(InArg)
    }
    #--------------------------
    # Break output:
    #--------------------------
    InArg = Break_output_fun(InArg = InArg)
    #--------------------------
    # Finallize
    #--------------------------
    futile.logger::flog.info("All inputs correct! Starting MACPET analysis...", name = "SA_LogFile",
        capture = FALSE)
    return(InArg)
}
# Done
#---------------------
#---------------------
# function for checking inputs for stage SA
Input_check_SA_fun = function(InArg) {
    #------------
    # check directory:
    #------------
    if (!methods::is(InArg$SA_AnalysisDir, "character")) {
        stop("SA_AnalysisDir:", InArg$SA_AnalysisDir, " is not a directory!", call. = FALSE)
    } else if (!dir.exists(InArg$SA_AnalysisDir)) {
        stop("SA_AnalysisDir:", InArg$SA_AnalysisDir, " directory does not exist!",
            call. = FALSE)
    }
    #------------
    # check stages:
    #------------
    if (!methods::is(InArg$SA_stages, "numeric")) {
        stop("SA_stages: ", InArg$SA_stages, " variable has to be a numeric or numeric vector!",
            call. = FALSE)
    } else if (any(!InArg$SA_stages %in% c(0, 1, 2, 3, 4))) {
        stop("SA_stages: ", InArg$SA_stages, " variable has to be a numeric or numeric vector with values c(0,1,2,3,4)!",
            call. = FALSE)
    } else {
        stageseq = seq(from = min(InArg$SA_stages), to = max(InArg$SA_stages))
        if (any(!stageseq %in% InArg$SA_stages)) {
            stop("SA_stages: ", InArg$SA_stages, " cannot have skipped intermediate stages!",
                call. = FALSE)
        }
    }
    #------------
    # check prefix:
    #------------
    if (!methods::is(InArg$SA_prefix, "character")) {
        stop("SA_prefix: ", InArg$SA_prefix, " variable has to be a string!", call. = FALSE)
    } else if (nchar(InArg$SA_prefix) == 0) {
        stop("SA_prefix: ", InArg$SA_prefix, " variable has to be a non-empty string!",
            call. = FALSE)
    }
    #------------
    # create log file
    #------------
    SA_LogFile.dir = file.path(InArg$SA_AnalysisDir, paste(InArg$SA_prefix, "_analysis.log",
        sep = ""))
    if (file.exists(SA_LogFile.dir))
        unlink(SA_LogFile.dir, recursive = TRUE, force = TRUE)
    # create the log file:
    futile.logger::flog.appender(futile.logger::appender.tee(SA_LogFile.dir), "SA_LogFile")
    futile.logger::flog.layout(futile.logger::layout.format("~m"), name = "SA_LogFile")
}
# done
#---------------------
#---------------------
# function for checking inputs for stage S0- fastq split
Input_check_S0_fun = function(InArg) {
    futile.logger::flog.info("|---- Checking Stage 0 inputs ----|", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # check fastq files:
    #------------
    # 1:
    if (!methods::is(InArg$S0_fastq1, "character")) {
        stop("S0_fastq1: ", InArg$S0_fastq1, " variable has to be a file directory!",
            call. = FALSE)
    } else if (!file.exists(InArg$S0_fastq1)) {
        stop("S0_fastq1: ", InArg$S0_fastq1, " file does not exist!", call. = FALSE)
    } else {
        fastq1 = basename(InArg$S0_fastq1)
        if (!grepl(".fastq.gz", fastq1) & !grepl(".fastq", fastq1)) {
            stop("S0_fastq1: ", InArg$S0_fastq1, " file is probably not fastq or fastq.gz format!",
                call. = FALSE)
        }
    }
    # 2:
    if (!methods::is(InArg$S0_fastq2, "character")) {
        stop("S0_fastq2: ", InArg$S0_fastq2, " variable has to be a file directory!",
            call. = FALSE)
    } else if (!file.exists(InArg$S0_fastq2)) {
        stop("S0_fastq2: ", InArg$S0_fastq2, " file does not exist!", call. = FALSE)
    } else {
        fastq2 = basename(InArg$S0_fastq2)
        if (!grepl(".fastq.gz", fastq2) & !grepl(".fastq", fastq2)) {
            stop("S0_fastq2: ", InArg$S0_fastq2, " file is probably not fastq or fastq.gz format!",
                call. = FALSE)
        }
    }
    #----------------
    # preliminary fastq check:
    #----------------
    cat("Preliminary fastq checking...")
    # count fast1 lines:
    Lines_fastq = ShortRead::countLines(dirPath = c(InArg$S0_fastq1, InArg$S0_fastq2))
    if (Lines_fastq[[1]] != Lines_fastq[[2]]) {
        stop("S0_fastq1: ", InArg$S0_fastq1, " and S0_fastq2: ", InArg$S0_fastq2,
            " files are not of same length.", call. = FALSE)
    }
    cat("OK\n")
    S0_Totfastqreads = Lines_fastq[[1]]/4  #four lines per entry
    # new variable to use in stage 0:
    InArg$S0_Totfastqreads = S0_Totfastqreads
    #----------------
    # check linkers
    #----------------
    if (!methods::is(InArg$S0_LinkerA, "character")) {
        stop("S0_LinkerA: ", InArg$S0_LinkerA, " has to be a string!", call. = FALSE)
    } else if (nchar(InArg$S0_LinkerA) == 0) {
        stop("S0_LinkerA: ", InArg$S0_LinkerA, " has to be a non-empty string!",
            call. = FALSE)
    }
    futile.logger::flog.info(paste("Linker A sequence chosen:", InArg$S0_LinkerA),
        name = "SA_LogFile", capture = FALSE)
    if (!methods::is(InArg$S0_LinkerB, "character")) {
        stop("S0_LinkerB: ", InArg$S0_LinkerB, " has to be a string!", call. = FALSE)
    } else if (nchar(InArg$S0_LinkerB) == 0) {
        stop("S0_LinkerB: ", InArg$S0_LinkerB, " has to be a non-empty string!",
            call. = FALSE)
    }
    futile.logger::flog.info(paste("Linker B sequence chosen:", InArg$S0_LinkerB),
        name = "SA_LogFile", capture = FALSE)
    # linker match:
    if (nchar(InArg$S0_LinkerA) != nchar(InArg$S0_LinkerB)) {
        LogFile = paste("WARNING: S0_LinkerA:", InArg$S0_LinkerA, "and S0_LinkerB:",
            InArg$S0_LinkerB, " lengths do not match.")
        futile.logger::flog.warn(LogFile, name = "SA_LogFile", capture = FALSE)
    }
    #----------------
    # check S0_LinkerOccurence:
    #----------------
    if (!methods::is(InArg$S0_LinkerOccurence, "numeric")) {
        stop("S0_LinkerOccurence: ", InArg$S0_LinkerOccurence, " has to be an integer!",
            call. = FALSE)
    } else if (!InArg$S0_LinkerOccurence %in% c(0, 1, 2, 3, 4)) {
        stop("S0_LinkerOccurence: ", InArg$S0_LinkerOccurence, " has to be one of 0, 1, 2, 3, 4!",
            call. = FALSE)
    }
    if (InArg$S0_LinkerOccurence == 0) {
        LogFile = paste("Linker mode chosen:", InArg$S0_LinkerOccurence, "\n ==> PETs with any read with no linker will be moved to ambiguous class.")
    } else if (InArg$S0_LinkerOccurence == 1) {
        LogFile = paste("Linker mode chosen:", InArg$S0_LinkerOccurence, "\n ==> PETs with left read with no linker, but right read with linker, will be moved to usable class.")
    } else if (InArg$S0_LinkerOccurence == 2) {
        LogFile = paste("Linker mode chosen:", InArg$S0_LinkerOccurence, "\n ==> PETs with right read with no linker, but left read with linker,  will be moved to usable class.")
    } else if (InArg$S0_LinkerOccurence == 3) {
        LogFile = paste("Linker mode chosen:", InArg$S0_LinkerOccurence, "\n ==> PETs with any or both reads without linkers, will be moved to usable class.")
    } else if (InArg$S0_LinkerOccurence == 4) {
        LogFile = paste("Linker mode chosen:", InArg$S0_LinkerOccurence, "\n ==> PETs with both reads without linkers, will be moved to usable class.")
    }
    futile.logger::flog.info(LogFile, name = "SA_LogFile", capture = FALSE)
    #----------------
    # check lengths
    #----------------
    if (!methods::is(InArg$S0_MinReadLength, "numeric")) {
        stop("S0_MinReadLength: ", InArg$S0_MinReadLength, " has to be an integer!",
            call. = FALSE)
    } else if (InArg$S0_MinReadLength < 0) {
        stop("S0_MinReadLength: ", InArg$S0_MinReadLength, " has to be >=0!", call. = FALSE)
    } else {
        InArg$S0_MinReadLength = ceiling(InArg$S0_MinReadLength)
    }
    if (!methods::is(InArg$S0_MaxReadLength, "numeric")) {
        stop("S0_MaxReadLength: ", InArg$S0_MaxReadLength, " has to be an integer!",
            call. = FALSE)
    } else if (InArg$S0_MaxReadLength < 0) {
        stop("S0_MaxReadLength: ", InArg$S0_MaxReadLength, " has to be >=0!", call. = FALSE)
    } else {
        InArg$S0_MaxReadLength = ceiling(InArg$S0_MaxReadLength)
    }
    if (InArg$S0_MinReadLength >= InArg$S0_MaxReadLength) {
        stop("S0_MinReadLength: ", InArg$S0_MinReadLength, " has to be < S0_MaxReadLength: ",
            InArg$S0_MaxReadLength, " !", call. = FALSE)
    }
    futile.logger::flog.info(paste("Maximum read length after linker trimming:",
        InArg$S0_MaxReadLength), name = "SA_LogFile", capture = FALSE)
    futile.logger::flog.info(paste("Minimum read length after linker trimming:",
        InArg$S0_MinReadLength), name = "SA_LogFile", capture = FALSE)
    #----------------
    # checkimage and fastqStream:
    #----------------
    if (!methods::is(InArg$S0_image, "logical")) {
        stop("S0_image ", InArg$S0_image, " has to be logical!", call. = FALSE)
    } else if (InArg$S0_image) {
        if (!requireNamespace("ggplot2", quietly = TRUE)) {
            stop("ggplot2 is needed if S0_image==TRUE. Please install it.", call. = FALSE)
        }
    }
    if (!methods::is(InArg$S0_fastqStream, "numeric")) {
        stop("S0_fastqStream: ", InArg$S0_fastqStream, " has to be a numeric!", call. = FALSE)
    } else if (InArg$S0_fastqStream <= 0) {
        stop("S0_fastqStream: ", InArg$S0_fastqStream, " has to be a positive numeric!",
            call. = FALSE)
    } else {
        InArg$S0_fastqStream = ceiling(InArg$S0_fastqStream)
    }
    futile.logger::flog.info("Correct Stage 0 inputs given.", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # create savedir for stage 0:
    #------------
    # new variable for stage 0:
    InArg$S0_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S0_results")
    return(InArg)
}
# done
#---------------------
#---------------------
# function for checking inputs for stage S1- mapping and paired-end bam creation
Input_check_S1_fun = function(InArg) {
    futile.logger::flog.info("|---- Checking Stage 1 inputs ----|", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # check the logical:
    #------------
    if (!methods::is(InArg$S1_image, "logical")) {
        stop("S1_image: ", InArg$S1_image, " has to be logical!", call. = FALSE)
    } else if (InArg$S1_image) {
        if (!requireNamespace("ggplot2", quietly = TRUE)) {
            stop("ggplot2 is needed if S1_image==TRUE. Please install it.", call. = FALSE)
        }
    }
    if (!methods::is(InArg$S1_RbowtieIndexBuild, "logical")) {
        stop("S1_RbowtieIndexBuild: ", InArg$S1_RbowtieIndexBuild, " has to be logical!",
            call. = FALSE)
    }
    futile.logger::flog.info(paste("Building bowtie index?", InArg$S1_RbowtieIndexBuild),
        name = "SA_LogFile", capture = FALSE)
    if (!methods::is(InArg$S1_makeSam, "logical")) {
        stop("S1_makeSam: ", InArg$S1_makeSam, " has to be logical!", call. = FALSE)
    }
    #------------
    # check S1_BAMStream:
    #------------
    if (!methods::is(InArg$S1_BAMStream, "numeric")) {
        stop("S1_BAMStream: ", InArg$S1_BAMStream, " has to be a numeric!", call. = FALSE)
    } else if (InArg$S1_BAMStream <= 0) {
        stop("S1_BAMStream: ", InArg$S1_BAMStream, " has to be a positive numeric!",
            call. = FALSE)
    } else {
        InArg$S1_BAMStream = ceiling(InArg$S1_BAMStream)
    }
    #------------
    # check S1_genome:
    #------------
    if (!methods::is(InArg$S1_genome, "character")) {
        stop("S1_genome: ", InArg$S1_genome, " has to be a character!", call. = FALSE)
    } else if (!InArg$S1_genome %in% names(sysdata)) {
        LogFile = paste("WARNING: S1_genome: ", InArg$S1_genome, ", is not a part of ",
            paste(names(sysdata), collapse = "/"), ". If S2_BlackList==TRUE, then no black-listed regions will be removed from the data.",
            sep = "")
        futile.logger::flog.warn(LogFile, name = "SA_LogFile", capture = FALSE)
    }
    futile.logger::flog.info(paste("Genome chosen:", InArg$S1_genome), name = "SA_LogFile",
        capture = FALSE)
    #------------
    # check S1_RbowtieIndexPrefix:
    #------------
    if (!methods::is(InArg$S1_RbowtieIndexPrefix, "character")) {
        stop("S1_RbowtieIndexPrefix: ", InArg$S1_RbowtieIndexPrefix, " has to be a string!",
            call. = FALSE)
    } else if (nchar(InArg$S1_RbowtieIndexPrefix) == 0) {
        stop("S1_RbowtieIndexPrefix: ", InArg$S1_RbowtieIndexPrefix, " has to be a non-empty string!",
            call. = FALSE)
    }
    #------------
    # check S1_RbowtieIndexDir:
    #------------
    if (!InArg$S1_RbowtieIndexBuild) {
        # if the bowtie index is built already:
        if (!methods::is(InArg$S1_RbowtieIndexDir, "character")) {
            stop("S1_RbowtieIndexDir: ", InArg$S1_RbowtieIndexDir, " variable has to be a directory!",
                call. = FALSE)
        } else if (!dir.exists(InArg$S1_RbowtieIndexDir)) {
            stop("S1_RbowtieIndexDir: ", InArg$S1_RbowtieIndexDir, " directory does not exist!",
                call. = FALSE)
        }
        # check the directory files:
        BowtieIndexes = file.path(InArg$S1_RbowtieIndexDir, InArg$S1_RbowtieIndexPrefix)
        BowtieIndexes = paste(BowtieIndexes, c(".1.ebwt", ".1.ebwtl", ".2.ebwt",
            ".2.ebwtl", ".3.ebwt", ".3.ebwtl", ".4.ebwt", ".4.ebwtl", ".rev.1.ebwt",
            ".rev.1.ebwtl", ".rev.2.ebwt", ".rev.2.ebwtl"), sep = "")
        for (i in seq_len(length(BowtieIndexes)/2)) {
            if (!file.exists(BowtieIndexes[i]) && !file.exists(BowtieIndexes[i +
                1])) {
                stop(basename(BowtieIndexes[i]), " or ", basename(BowtieIndexes[i +
                  1]), " files are missing from S1_RbowtieIndexDir or the S1_RbowtieIndexPrefix is wrong!",
                  call. = FALSE)
            }
        }
    } else {
        # you will build the index, check the fasta files
        #------------
        # check S1_RbowtieRefDir:
        #------------
        if (!methods::is(InArg$S1_RbowtieRefDir, "character")) {
            stop("S1_RbowtieRefDir: ", InArg$S1_RbowtieRefDir, " has to be a character vector with the paths of the .fa files for building the bowtie index!",
                call. = FALSE)
        } else if (any(!file.exists(InArg$S1_RbowtieRefDir))) {
            Famissing = which(!file.exists(InArg$S1_RbowtieRefDir))
            Famissing = InArg$S1_RbowtieRefDir[Famissing]
            Famissing = paste(basename(Famissing), collapse = "/")
            stop("S1_RbowtieRefDir contains the following missing .fa files: ", Famissing,
                call. = FALSE)
        }
        # give the S1_RbowtieIndexDir, where to save the index:
        InArg$S1_RbowtieIndexDir = file.path(InArg$SA_AnalysisDir, "S1_results",
            "BowtieIndex")
    }
    #------------
    # check S1_fastq1_usable_dir and S1_fastq2_usable_dir:
    #------------
    if (!c(0) %in% InArg$SA_stages) {
        # then the fastq files are given as input so they have to be checked: 1:
        if (!methods::is(InArg$S1_fastq1_usable_dir, "character")) {
            stop("S1_fastq1_usable_dir: ", InArg$S1_fastq1_usable_dir, " variable has to be a file directory!",
                call. = FALSE)
        } else if (!file.exists(InArg$S1_fastq1_usable_dir)) {
            stop("S1_fastq1_usable_dir: ", InArg$S1_fastq1_usable_dir, " file does not exist!",
                call. = FALSE)
        } else {
            fastq1 = basename(InArg$S1_fastq1_usable_dir)
            if (all(!grepl("fastq.gz", fastq1) || !grepl("fastq", fastq1))) {
                stop("S1_fastq1_usable_dir: ", InArg$S1_fastq1_usable_dir, " file is probably not fastq or fastq.gz format!",
                  call. = FALSE)
            }
        }
        # 2:
        if (!methods::is(InArg$S1_fastq2_usable_dir, "character")) {
            stop("S1_fastq2_usable_dir: ", InArg$S1_fastq2_usable_dir, " variable has to be a file directory!",
                call. = FALSE)
        } else if (!file.exists(InArg$S1_fastq2_usable_dir)) {
            stop("S1_fastq2_usable_dir: ", InArg$S1_fastq2_usable_dir, " file does not exist!",
                call. = FALSE)
        } else {
            fastq2 = basename(InArg$S1_fastq2_usable_dir)
            if (all(!grepl("fastq.gz", fastq2) || !grepl("fastq", fastq2))) {
                stop("S1_fastq2_usable_dir: ", InArg$S1_fastq2_usable_dir, " file is probably not fastq or fastq.gz format!",
                  call. = FALSE)
            }
        }
        #----------------
        # preliminary fastq check:
        #----------------
        cat("Preliminary fastq checking...")
        # count fast1 lines:
        Lines_fastq = ShortRead::countLines(dirPath = c(InArg$S1_fastq1_usable_dir,
            InArg$S1_fastq2_usable_dir))
        if (Lines_fastq[[1]] != Lines_fastq[[2]]) {
            stop("S1_fastq1_usable_dir: ", InArg$S1_fastq1_usable_dir, " and S1_fastq2_usable_dir: ",
                InArg$S1_fastq2_usable_dir, " files are not of same length.", call. = FALSE)
        }
        cat("OK\n")
        Totfastqreads = Lines_fastq[[1]]/4  #four lines per entry
    } else {
        # then the fastq files will be found in stage 0, so return their names
        S0_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S0_results")
        S1_fastq1_usable_dir = paste(InArg$SA_prefix, "_usable_1.fastq.gz", sep = "")
        InArg$S1_fastq1_usable_dir = file.path(S0_AnalysisDir, S1_fastq1_usable_dir)
        S1_fastq2_usable_dir = paste(InArg$SA_prefix, "_usable_2.fastq.gz", sep = "")
        InArg$S1_fastq2_usable_dir = file.path(S0_AnalysisDir, S1_fastq2_usable_dir)
    }
    futile.logger::flog.info("Correct Stage 1 inputs given.", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # create savedir for stage 1:
    #------------
    # new variable for stage 1:
    InArg$S1_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S1_results")
    return(InArg)
}
# done
#---------------------
#---------------------
# function for checking inputs for stage S2- pet classification
Input_check_S2_fun = function(InArg) {
    futile.logger::flog.info("|---- Checking Stage 2 inputs ----|", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # check the S2_image:
    #------------
    if (!methods::is(InArg$S2_image, "logical")) {
        stop("S2_image: ", InArg$S2_image, " has to be logical!", call. = FALSE)
    } else if (InArg$S2_image) {
        if (!requireNamespace("ggplot2", quietly = TRUE)) {
            stop("ggplot2 is needed if S2_image==TRUE. Please install it.", call. = FALSE)
        }
    }
    #------------
    # check the S2_BlackList:
    #------------
    if (!methods::is(InArg$S2_BlackList, "logical") && !methods::is(InArg$S2_BlackList,
        "GRanges")) {
        stop("S2_BlackList: has to be logical or a GRanges object!", call. = FALSE)
    }
    #------------
    # give name to savedir for stage 2:
    #------------
    InArg$S2_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S2_results")
    #------------
    # check S2_PairedEndBAMpath:
    #------------
    if (!c(1) %in% InArg$SA_stages) {
        # then S2_PairedEndBAMpath is given as input and it has to be the paired end bam
        # file it can be both bam and sam format:
        if (!methods::is(InArg$S2_PairedEndBAMpath, "character")) {
            stop("S2_PairedEndBAMpath: ", InArg$S2_PairedEndBAMpath, " variable has to be a file directory!",
                call. = FALSE)
        } else if (!file.exists(InArg$S2_PairedEndBAMpath)) {
            stop("S2_PairedEndBAMpath: ", InArg$S2_PairedEndBAMpath, " file does not exist!",
                call. = FALSE)
        }
        # check format:
        PairedDataName = basename(InArg$S2_PairedEndBAMpath)
        PairedDataName = strsplit(PairedDataName, ".", fixed = TRUE)
        PairedDataName = unlist(PairedDataName)
        Format = PairedDataName[length(PairedDataName)]
        if (all(!c("bam", "sam") %in% Format)) {
            stop("S2_PairedEndBAMpath: ", InArg$S2_PairedEndBAMpath, " has to be of .bam or .sam format!",
                call. = FALSE)
        }
        # else load the data now:, note SA_AnalysisDir is needed in case BAM is SAM and
        # needs to be saved there
        S2_PairedData = LoadBAM_FromInputChecks_fun(SA_AnalysisDir = InArg$SA_AnalysisDir,
            S2_AnalysisDir = InArg$S2_AnalysisDir, SA_prefix = InArg$SA_prefix, S2_PairedEndBAMpath = InArg$S2_PairedEndBAMpath,
            Format = Format, S2_BlackList = InArg$S2_BlackList, S2_image = InArg$S2_image)
        # save:
        InArg$S2_PairedData = S2_PairedData
        InArg$S2_PairedEndBAMpath = NULL
        InArg$S2_BlackList = NULL
    } else {
        # it will be created with the following directory:
        S1_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S1_results")
        PairedEndBAMfile = paste(InArg$SA_prefix, "_Paired_end.bam", sep = "")
        PairedEndBAMpath = file.path(S1_AnalysisDir, PairedEndBAMfile)
        InArg$S2_PairedEndBAMpath = PairedEndBAMpath
    }
    futile.logger::flog.info("Correct Stage 2 inputs given.", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # return:
    #------------
    return(InArg)
}
# done
#---------------------
#---------------------
# function for checking inputs for stage S3
Input_check_S3_fun = function(InArg) {
    futile.logger::flog.info("|---- Checking Stage 3 inputs ----|", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # check the S3_image:
    #------------
    if (!methods::is(InArg$S3_image, "logical")) {
        stop("S3_image: ", InArg$S3_image, " has to be logical!", call. = FALSE)
    } else if (InArg$S3_image) {
        if (!requireNamespace("ggplot2", quietly = TRUE)) {
            stop("ggplot2 is needed if S3_image==TRUE. Please install it.", call. = FALSE)
        }
    }
    #------------
    # check the S3_method:
    #------------
    if (!InArg$S3_method %in% stats::p.adjust.methods) {
        stop("S3_method: ", InArg$S3_method, " is wrong! See ??stats::p.adjust.methods.",
            call. = FALSE)
    }
    #------------
    # check the S3_fileSelfDir:
    #------------
    if (!c(2) %in% InArg$SA_stages) {
        # means the data is given as it is, so load it and check class check if directory
        # exists:
        if (!methods::is(InArg$S3_fileSelfDir, "character")) {
            stop("S3_fileSelfDir: ", InArg$S3_fileSelfDir, " variable has to be a file directory!",
                call. = FALSE)
        } else if (!file.exists(InArg$S3_fileSelfDir)) {
            stop("S3_fileSelfDir: ", InArg$S3_fileSelfDir, " file does not exist!",
                call. = FALSE)
        }
        # load data:
        load(InArg$S3_fileSelfDir)
        if (!exists(paste(InArg$SA_prefix, "_pselfData", sep = ""))) {
            stop("If S3_fileSelfDir is used to load PSelf class data, the object loaded should be named: ",
                paste(InArg$SA_prefix, "_pselfData", sep = ""), call. = FALSE)
        }
        S3_Selfobject = get(paste(InArg$SA_prefix, "_pselfData", sep = ""))
        # check class:
        if (!methods::is(S3_Selfobject, "PSelf")) {
            stop("The file loaded from S3_fileSelfDir: ", InArg$S3_fileSelfDir, " is not of PSelf class!",
                call. = FALSE)
        }
        InArg$S3_Selfobject = S3_Selfobject
        InArg$S3_fileSelfDir = NULL
    } else {
        # give the path directory where it will be saved:
        S2_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S2_results")
        fileSelDir = paste(InArg$SA_prefix, "_pselfData", sep = "")
        fileSelDir = file.path(S2_AnalysisDir, fileSelDir)
        InArg$S3_fileSelfDir = fileSelDir
    }
    futile.logger::flog.info("Correct Stage 3 inputs given.", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # create savedir for stage 3:
    #------------
    InArg$S3_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S3_results")
    return(InArg)
}
# done
#---------------------
#---------------------
# function for checking inputs for stage S4
Input_check_S4_fun = function(InArg) {
    futile.logger::flog.info("|---- Checking Stage 4 inputs ----|", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # check the S4_image:
    #------------
    if (!methods::is(InArg$S4_image, "logical")) {
        stop("S4_image: ", InArg$S4_image, " has to be logical!", call. = FALSE)
    } else if (InArg$S4_image) {
        if ((!requireNamespace("ggplot2", quietly = TRUE))|(!requireNamespace("reshape2", quietly = TRUE))) {
            stop("ggplot2 and reshape2 packages are needed if S4_image==TRUE. Please install it.", call. = FALSE)
        }
    }
    #------------
    # check the S4_PeakExt:
    #------------
    if (!methods::is(InArg$S4_PeakExt, "numeric")) {
        stop("S4_PeakExt: ", InArg$S4_PeakExt, " has to be a numeric!", call. = FALSE)
    } else if (InArg$S4_PeakExt < 0) {
        stop("S4_PeakExt: ", InArg$S4_PeakExt, " should be positive!", call. = FALSE)
    } else {
        # round it:
        InArg$S4_PeakExt = round(InArg$S4_PeakExt)
    }
    #------------
    # check the S4_minPETs:
    #------------
    if (!methods::is(InArg$S4_minPETs, "numeric")) {
        stop("S4_minPETs: ", InArg$S4_minPETs, " has to be a numeric!", call. = FALSE)
    } else if (InArg$S4_minPETs < 1) {
        stop("S4_minPETs: ", InArg$S4_minPETs, " has to be at least = 1!", call. = FALSE)
    } else {
        # round it:
        InArg$S4_minPETs = round(InArg$S4_minPETs)
    }
    #------------
    # check the S4_FDR_peak:
    #------------
    if (!methods::is(InArg$S4_FDR_peak, "numeric")) {
        stop("S4_FDR_peak: ", InArg$S4_FDR_peak, " has to be a numeric!", call. = FALSE)
    } else if (InArg$S4_FDR_peak > 1) {
        stop("S4_FDR_peak: ", InArg$S4_FDR_peak, " has to be a numeric smaller than 1!",
            call. = FALSE)
    } else if (InArg$S4_FDR_peak < 0) {
        stop("S4_FDR_peak: ", InArg$S4_FDR_peak, " has to be a positive numeric!",
            call. = FALSE)
    }
    #------------
    # check the S4_method:
    #------------
    if (!InArg$S4_method %in% stats::p.adjust.methods) {
        stop("S4_method: ", InArg$S4_method, " is wrong! See ??stats::p.adjust.methods.",
            call. = FALSE)
    }
    #------------
    # check the S4_filePSFitDir:
    #------------
    if (!c(3) %in% InArg$SA_stages) {
        # means the data is given as it is, so load it and check class check if directory
        # exists:
        if (!methods::is(InArg$S4_filePSFitDir, "character")) {
            stop("S4_filePSFitDir: ", InArg$S4_filePSFitDir, " variable has to be a file directory!",
                call. = FALSE)
        } else if (!file.exists(InArg$S4_filePSFitDir)) {
            stop("S4_filePSFitDir: ", InArg$S4_filePSFitDir, " file does not exist!",
                call. = FALSE)
        }
        # load data:
        load(InArg$S4_filePSFitDir)
        if (!exists(paste(InArg$SA_prefix, "_psfitData", sep = ""))) {
            stop("If S4_filePSFitDir is used to load PSFit class data, the object loaded should be named: ",
                paste(InArg$SA_prefix, "_psfitData", sep = ""), call. = FALSE)
        }
        S4_FitObject = get(paste(InArg$SA_prefix, "_psfitData", sep = ""))
        # check class:
        if (!methods::is(S4_FitObject, "PSFit")) {
            stop("The file loaded from S4_filePSFitDir: ", InArg$S4_filePSFitDir,
                " is not of PSFit class!", call. = FALSE)
        }
        InArg$S4_FitObject = S4_FitObject
        InArg$S4_filePSFitDir = NULL
    } else {
        # give the path directory where it will be saved:
        S3_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S3_results")
        filefitDir = paste(InArg$SA_prefix, "_psfitData", sep = "")
        filefitDir = file.path(S3_AnalysisDir, filefitDir)
        InArg$S4_filePSFitDir = filefitDir
    }
    #------------
    # check the S4_filePIntraDir:
    #------------
    if (!c(2) %in% InArg$SA_stages) {
        # means the data is given as it is, so load it and check class check if directory
        # exists:
        if(!is.null(InArg$S4_filePIntraDir)){
            if (!methods::is(InArg$S4_filePIntraDir, "character")) {
                stop("S4_filePIntraDir: ", InArg$S4_filePIntraDir, " variable has to be a file directory!",
                     call. = FALSE)
            } else if (!file.exists(InArg$S4_filePIntraDir)) {
                stop("S4_filePIntraDir: ", InArg$S4_filePIntraDir, " file does not exist!",
                     call. = FALSE)
            }
            # load data:
            load(InArg$S4_filePIntraDir)
            if (!exists(paste(InArg$SA_prefix, "_pintraData", sep = ""))) {
                stop("If S4_filePIntraDir is used to load PIntra class data, the object loaded should be named: ",
                     paste(InArg$SA_prefix, "_pintraData", sep = ""), call. = FALSE)
            }
            S4_IntraObject = get(paste(InArg$SA_prefix, "_pintraData", sep = ""))
            # check class:
            if (!methods::is(S4_IntraObject, "PIntra")) {
                stop("The file loaded from S4_filePIntraDir: ", InArg$S4_filePIntraDir,
                     " is not of PIntra class!", call. = FALSE)
            }
            InArg$S4_IntraObject = S4_IntraObject
        }else{# else it is null
            InArg$S4_IntraObject = NULL
        }
        InArg$S4_filePIntraDir = NULL #for both null and not
    } else {
        # give the path directory where it will be saved:
        S2_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S2_results")
        fileIntraDir = paste(InArg$SA_prefix, "_pintraData", sep = "")
        fileIntraDir = file.path(S2_AnalysisDir, fileIntraDir)
        InArg$S4_filePIntraDir = fileIntraDir
    }
    #------------
    # check the S4_filePInterDir:
    #------------
    if (!c(2) %in% InArg$SA_stages) {
        # means the data is given as it is, so load it and check class check if directory
        # exists:
        if(!is.null(InArg$S4_filePInterDir)){
            if (!methods::is(InArg$S4_filePInterDir, "character")) {
                stop("S4_filePInterDir: ", InArg$S4_filePInterDir, " variable has to be a file directory!",
                     call. = FALSE)
            } else if (!file.exists(InArg$S4_filePInterDir)) {
                stop("S4_filePInterDir: ", InArg$S4_filePInterDir, " file does not exist!",
                     call. = FALSE)
            }
            # load data:
            load(InArg$S4_filePInterDir)
            if (!exists(paste(InArg$SA_prefix, "_pinterData", sep = ""))) {
                stop("If S4_filePInterDir is used to load PInter class data, the object loaded should be named: ",
                     paste(InArg$SA_prefix, "_pinterData", sep = ""), call. = FALSE)
            }
            S4_InterObject = get(paste(InArg$SA_prefix, "_pinterData", sep = ""))
            # check class:
            if (!methods::is(S4_InterObject, "PInter")) {
                stop("The file loaded from S4_filePInterDir: ", InArg$S4_filePInterDir,
                     " is not of PInter class!", call. = FALSE)
            }
            InArg$S4_InterObject = S4_InterObject
        }else{# else it is null
            InArg$S4_InterObject = NULL
        }
        InArg$S4_filePInterDir = NULL #common for both null and not null
    } else {
        # give the path directory where it will be saved:
        S2_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S2_results")
        fileInterDir = paste(InArg$SA_prefix, "_pinterData", sep = "")
        fileInterDir = file.path(S2_AnalysisDir, fileInterDir)
        InArg$S4_filePInterDir = fileInterDir
    }
    #------------
    # check if the S4_IntraObject/S4_InterObject are NULL in case they are given as input:
    #------------
    if (is.null(InArg$S4_IntraObject) & is.null(InArg$S4_InterObject) &
        (!c(2) %in% InArg$SA_stages)) {
        stop("No Intra/Inter-ligated data is found (both NULL)!", call. = FALSE)
    }
    futile.logger::flog.info("Correct Stage 4 inputs given.", name = "SA_LogFile",
        capture = FALSE)
    #------------
    # create savedir for stage 4:
    #------------
    InArg$S4_AnalysisDir = file.path(InArg$SA_AnalysisDir, "S4_results")
    return(InArg)
}
# done
#---------------------
#---------------------
# function for breaking the output:
Break_output_fun = function(InArg) {
    #--------------
    # Stage 0 output:
    #--------------
    S0names = c("S0_AnalysisDir", "SA_prefix", "S0_fastq1", "S0_fastq2", "S0_LinkerA",
        "S0_LinkerB", "S0_MinReadLength", "S0_MaxReadLength", "S0_LinkerOccurence",
        "S0_image", "S0_fastqStream", "S0_Totfastqreads")
    InArgS0 = InArg[which(names(InArg) %in% S0names)]
    #--------------
    # Stage 1 output:
    #--------------
    S1names = c("S1_AnalysisDir", "SA_prefix", "S1_fastq1_usable_dir", "S1_fastq2_usable_dir",
        "S1_image", "S1_makeSam", "S1_genome", "S1_RbowtieIndexBuild", "S1_RbowtieIndexDir",
        "S1_RbowtieIndexPrefix", "S1_RbowtieRefDir", "S1_BAMStream")
    InArgS1 = InArg[which(names(InArg) %in% S1names)]
    #--------------
    # Stage 2 output:
    #--------------
    S2names = c("S2_AnalysisDir", "S2_PairedEndBAMpath", "S2_image", "S2_BlackList",
        "S2_PairedData", "SA_prefix")
    InArgS2 = InArg[which(names(InArg) %in% S2names)]
    #--------------
    # Stage 3 output:
    #--------------
    S3names = c("S3_AnalysisDir", "S3_fileSelfDir", "S3_method", "S3_Selfobject",
        "SA_prefix", "S3_image")
    InArgS3 = InArg[which(names(InArg) %in% S3names)]
    #--------------
    # Stage 4 output:
    #--------------
    S4names = c("S4_AnalysisDir", "S4_filePSFitDir", "S4_filePIntraDir", "S4_filePInterDir",
        "S4_FDR_peak", "S4_method", "S4_FitObject", "S4_IntraObject", "S4_InterObject",
        "SA_prefix", "S4_image", "S4_minPETs", "S4_PeakExt")
    InArgS4 = InArg[which(names(InArg) %in% S4names)]
    return(list(InArgS0 = InArgS0, InArgS1 = InArgS1, InArgS2 = InArgS2, InArgS3 = InArgS3,
        InArgS4 = InArgS4))
}
# done
