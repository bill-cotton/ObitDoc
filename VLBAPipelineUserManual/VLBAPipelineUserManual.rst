=========================
VLBA Pipeline User Manual
=========================

:Author: Jared Crossley <jcrossle@nrao.edu>
:Date: January 2012

+
| QUESTIONS:
| Can the pipeline be run using the NRAO system install?
| Can the pipeline be run using the binary installation?
| Does the check parameter still work?
+

------------
Introduction
------------

The VLBA data reduction pipeline is a software pipeline developed as an
extension of the Obit algorithmic development system.  The goal of the pipeline
is to automate editing, calibration, and imaging of raw VLBA data products.  
Currently, the pipeline works only on continuum data.

-------------------------
Download and Installation
-------------------------

The VLBA pipeline runs within Obit.  See the Obit home page for Obit
installation instructions, http://www.cv.nrao.edu/~bcotton/Obit.html. The
pipeline works with Obit svn revision 400, and may work with earlier revisions.
When the Obit installation is complete and you have sourced the Obit setup
script (and AIPS setup script, if necessary) you will be able to start
``ObitTalk`` from the command line.  Now you are ready install and run the VLBA
pipeline.

The pipeline is stored in a subversion repository.  To checkout a copy
run the following subversion command::

    $ svn co https://svn.cv.nrao.edu/svn/VLBApipeline

Before running the pipeline:

1. The directory containing the pipeline code must be added to the ObitTalk
   Python path. 
2. Environment variable FITSDIR must be defined as the directory where the
   pipeline will acquire its input FITS data.

Both of these can be accomplished using the template bash setup script,
``setup.sh.default``.  Copy this file to ``setup.sh``, modify the paths as
appropriate for your system and source the script::  

    $ cp setup.sh.default setup.sh
    $ # open setup.sh in editor and set appropriate paths...
    $ source setup.sh 

If you are running a shell other than bash, you will need to translate the bash
script to the language of your shell.

-----------
Quick Start
-----------

The quickest way to use the pipeline is through the continuum pipeline wrapper,
``VLBAContPipeWrap.py``.  The wrapper queries the archive, downloads archive
data, sets up the pipeline input files and starts the pipeline script.  

By default, the wrapper requires an AIPS setup script be present in the local
directory.  Copy the ``AIPSSetup.py`` script from the Obit ``scripts``
directory [1] and change the content to conform to your system and directory
structure. Some of the things that you should pay attention to are:

* Setting the AIPS data and FITS directories using variables ``adirs`` and
  ``fdirs``.  Remove any directories you are not using.
* Set the AIPS user number with variable ``user``.
* Set ``AIPS_ROOT``, ``AIPS_VERSION``, and ``DA00`` as appropriate for your
  AIPS installation.
* Set ``nThreads`` to the number of threads Obit tasks are allowed to spawn.
* Specify the AIPS data directory that should be used by setting variable
  ``disk`` to an index of ``adirs``.
 
An explanation of the wrapper command line arguments and options can be found
using the ``-h`` option::

    $ ObitTalk VLBAContPipeWrap.py -h
    Using DADEVS.SH
    Obit: info    20120125T094943 ObitPython Begins, svn ver. 400
    Obit: info    20120125T094943 Date/Time: 2012-01-25  09:49:43
    Usage: VLBAContPipeWrap.py [options] StartDate [StopDate]
           dates as yyyy-mmm-dd, eg. 2005-jan-01
    
    Options:
      -h, --help            show this help message and exit
      -P PROJECT, --project=PROJECT
                            project code
      -q, --query           query and summary only
      -a, --all             Automatically process all files in archive response
      -m, --metadata        Display all metadata in archive response
      -i, --ignoreidi       Ignore all FITS IDI files in archive response
      --multiidi            Download and fill multiple old-correlator FITS IDI
                            files
      -F, --finish          Finish only, skip download and process

The required command line arguments are the archive query start and stop
dates::

    $ ObitTalk VLBAContPipeWrap.py 2010-jan-01 2010-jan-31

This will cause the wrapper to query the NRAO archive for VLBA observations from
January of 2010.  The wrapper will write a table of the archive response and
ask the user to select rows from the table for sequential pipeline processing.

NOTE: The wrapper currently does not work when old-correlator FITS-IDI files
are selected directly.  To load data from old-correlator FITS-IDI files, use
the ``--multiidi`` option and *select the corresponding FITS-AIPS files*.  Use
``-i`` to ignore all FITS-IDI files when printing the archive query response.

[#] The location of the ``scripts`` directory depends on which Obit
    installation you are using:
    * If you installed Obit from source, the path from the ``ObitInstall``
      directory is::
          ./ObitSystem/Obit/share/scripts
    * If you installed Obit as a binary package, the path from the top-level 
      Obit installation directory is::
          ./share/obit/scripts
    * If you are using the NRAO system installation of Obit, ``scripts`` can
      be found here::
          /usr/share/obit/scripts

---------------------------------------------
The Pipeline Wrapper: ``VLBAContPipeWrap.py``
---------------------------------------------

The continuum pipeline wrapper simplifies the job of starting the pipeline by
providing a simple interface to the NRAO VLBA Archive, automatically
downloading data to a directory on the NRAO AOC network, setting up the input
parameters for the pipeline script, executing the pipeline script, and copying
the data to a storage directory when finished.

The VLBA Archive currently contains data from two correlators.  The old
correlator output one or more FITS-IDI files for each observing session.  These
files require special handling for reduction in Obit (or AIPS).  For this
reason, the raw IDI files were processed (by a different pipeline) to produce a
single FITS-AIPS file for each observing session.  The new DiFX correlator
outputs single FITS-IDI files for each observing session.

The pipeline is designed to process one data file at a time.  For
old-correlator data, this means processing FITS-AIPS files; for new-correlator
data, this means processing FITS-IDI files.  However, experience has shown that
some of the old-correlator FITS-AIPS files contain errors that can be avoided
by using the FITS-IDI files directly.  The wrapper has therefore been enhanced
with a ``--multiidi`` option to allow for automated retrieval, concatenation,
and processing of multiple IDI files.  

----------------------------------------
The Pipeline Script: ``VLBAContPipe.py``
----------------------------------------

The continuum pipeline can be run manually by invoking ``VLBAContPipe.py`` as
an ObitTalk script.  This method requires specifying two input parameter files
on the command line::

    $ ObitTalk VLBAContPipe.py AIPSSetup.py PipelineParms.py

The first argument is the AIPS setup Python script.  This file
defines the AIPS data and FITS directories and initializes important Obit
variables.  An example setup file is included in the Obit installation in file
``AIPSSetup.py`` in the Obit ``scripts`` directory [1].  Make a local copy of
``AIPSSetup.py`` and modify it to suit your system.  Some of the things that
you should pay attention to are:

* Setting the AIPS data and FITS directories using variables ``adirs`` and
  ``fdirs``.  Remove any directories you are not using.
* Set the AIPS user number with variable ``user``.
* Set ``AIPS_ROOT``, ``AIPS_VERSION``, and ``DA00`` as appropriate for your
  AIPS installation.
* Set ``nThreads`` to the number of threads Obit tasks are allowed to spawn.
* Specify the AIPS data directory that should be used by setting variable
  ``disk`` to an index of ``adirs``.

The second command line argument to ``VLBAContPipe.py`` is the pipeline
parameters file.  A template of the parameters file is distributed with the
pipeline source code in ``VLBAContTemplateParm.py``.  Make a local copy of the
parameters template and replace all the substitution keys with values
appropriate for your data set.  Each substitution key is explained at the top
of the template file along with a data type where it is not obvious from the
context. At the bottom of the parameters file are the pipeline control
parameters.  These parameters allow the user to:

* turn on script checking [does this work?] which executes much of the pipeline
  code without calling the routines that actually process the data.
* turn on debug mode which prints the Obit and AIPS task input parameters 
  prior to task execution and leaves Obit task input files in the /tmp
  directory for debugging.
* Specify the type of data file to load: UVFITS (also known as FITS-AIPS) or
  FITS-IDI.
* Turn on or off various steps in the pipeline process.

The ability to turn pipeline steps off allows you to restart the pipeline at
any point if there is an error or if you want to rerun a subset of the
pipeline.

--------------
Python Modules
--------------

The pipeline currently consists of several Python modules, described below.  
``VLBACal.py`` and ``PipeUtil.py`` serve as a pipeline API.

VLBACal.py
    A collection of functions that perform various steps in the reduction 
    process.  Typical functions setup and invoke Obit or AIPS tasks to
    accomplish the data reduction. 

VLBAContPipe.py
    The VLBA continuum pipeline.  A function that calls the appropriate
    functions in VLBACal, in the appropriate order, to reduce VLBA continuum
    data.  This file can be invoked as an ObitTalk script.

VLBAContPipeWrap.py
    A wrapper that automates archive access and writes setup files for the 
    continuum pipeline.  This file can be invoked as an ObitTalk script.

VLBAContTemplateParm.py
    A template Python file used as input to VLBAContPipe.py.  The wrapper
    inserts appropriate values in this template for each execution of the 
    continuum pipeline.

VLBALinePipe.py
    The VLBA spectral line pipeline.  Not yet functional.

PipeUtil.py
    A collection of functions that perform various pipeline-related tasks.

IDIFix.py
    A function that fixes old-correlator (pre-2010) FITS-IDI files.

-------------
Data Products
-------------

The pipeline generates metadata and data files that fall into one of two 
catagories: multi-source data and single-source data.  A complete table of 
file data and metadata products can be found here: 
https://archive.nrao.edu/VLBAPipeProducts/metadata.html.  Some of the most
useful data products are listed below.

HTML Report (ex: ``BL0149_BN_2cm.report.html``)
    A human-readable report on all metadata and file data products generated in 
    HTML.

Pipeline log (ex: ``BL0149_BN_2cm.log``)
    The VLBA pipeline log file.  This is the place to go for diagnosing
    problems and reviewing pipeline performance.

Clean image, total intensity (ex: ``BL0149_BN_2cm_0010+405.IClean.fits``)
    The self-calibrated clean image.  The extension ``IClean`` signifies that
    this is the total intensity clean image.

Contour plot (ex: ``BL0149_BN_2cm_0010+405.cntr.ps``)
    A contour plot produced from the total intensity clean image.  A version of
    this plot is generated in PostScript and JPEG formats.

Diagnostic visibility plots (ex: ``BL0149_BN_2cm_0010+405.amp.jpg``)
    Diagnostic plots are generated to show:
    * Amplitude versus uv-distance
    * uv-coverage (u versus v)
    * Visibilities in the complex plane (real versus imaginary)
    The diagnostic plots are generated in JPEG format.

Calibrated and averaged uv data (ex: ``BL0149_BN_2cm.CalAvg.uvtab``)
    The calibrated and averaged visibility data.

Calibrated AIPS tables (ex: ``BL0149_BN_2cm.CalTab.uvtab``)
    The calibrated AIPS tables without visibility data.

---------------
Troubleshooting
---------------

* PROBLEM: One of the AIPS tables contains an error that crashes the pipeline
  or produces erroneous results.

  SOLUTION: If you loaded data from an old-correlator (observed before ??)
  pipeline generated FITS-AIPS file, first try downloading the original
  FITS-IDI files, and running the pipeline on those files directly.  In some
  cases errors that appear in the FITS-AIPS files are not present in the
  original FITS-IDI files.

  If this does not resolve the problem, or if the error is present in FITS-IDI
  data produced by the DiFX correlator (?? or later) there is no easy fix. Your
  best bet in this case is to correct the error manually and run the pipeline
  on the corrected data or give up. Remember that you can turn various parts of
  the pipeline on or off by editing the ``AIPSSetup.py`` script.
 
  A list of archived VLBA data files that cannot be processed using the VLBA
  pipeline or require special handling is maintained here:
  BadData.txt.  
  If you find a file that you belive should be added to this 
  list please email the authors.

* PROBLEM: The flag (FG) table is missing.

  SOLUTION: Generate an FG table using...

---------
Wish List
---------

Here I record feature enhancements I'd like to see.

* Load old-correlator IDI files automatically. (No need to use FITS-AIPS files.)
* Spawn multiple processes automatically.
* Load data and prep pipeline only.  Do not actually start the pipeline.  This
  will allow the user to tweak the pipeline input parameters before the pipeline
  is started.
* Produce warning if pipeline starts with AIPS catalog not empty.
* Add no-clean-up and no-copy-over option to wrapper.


