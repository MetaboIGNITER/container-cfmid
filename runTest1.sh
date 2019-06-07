#!/bin/bash

# install required packages
apt-get update -y && apt-get install -y --no-install-recommends wget ca-certificates

# prepare test input files
mkdir /tmp/testfiles
wget -O /tmp/testfiles/2500_47.4328704_175.0237_.txt https://github.com/phnmnl/container-cfmid/raw/develop/testfiles/2500_47.4328704_175.0237_.txt
wget -O /tmp/testfiles/hmdb_2017-07-23.csv https://github.com/phnmnl/container-cfmid/raw/develop/testfiles/hmdb_2017-07-23.csv


# perform test
/usr/local/bin/cfmid.r input=/tmp/testfiles/2500_47.4328704_175.0237_.txt candidate_file=/tmp/testfiles/hmdb_2017-07-23.csv output=/tmp/testfiles/output.txt candidate_id=Identifier candidate_inchi_smiles=SMILES candidate_mass=MonoisotopicMass databaseNameColumn=Name databaseInChIColumn="InChI" realName<-"2500_47.4328704_175.0237_.txt"


# check output
if [ ! -f /tmp/testfiles/output.txt ]; then 
   echo "Error: Output file /tmp/testfiles/output.txt not found"
   exit 1 
fi
