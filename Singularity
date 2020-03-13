Bootstrap: docker
From: ubuntu:trusty
%files
scripts/*.r /usr/local/bin/
runTest1.sh /usr/local/bin/runTest1.sh
%labels
MAINTAINER PhenoMeNal-H2020 Project (phenomenal-h2020-users@googlegroups.com)
software="CFM-ID"
software.version="v2.0.0"
version="v2.0.0"
Description="CFM-ID provides a method for accurately and efficiently identifying metabolites in spectra generated by electrospray tandem mass spectrometry (ESI-MS/MS)."
website="http://cfmid.wishartlab.com/"
documentation="https://github.com/phnmnl/container-cfmid/blob/master/README.md"
tags="Metabolomics"
%post




# Set RDKit version
RDKIT_VERSION=Release_2016_03_3

# Set home directory
#ENV HOME /root
mkdir /engine
cd /engine

# Download dependencies
sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
apt-get update && \
apt-get -y upgrade && \
apt-get install -y build-essential software-properties-common && \
apt-get install -y byobu curl git htop man unzip vim wget && \
apt-get install -y cmake flex bison python-numpy python-dev sqlite3 libsqlite3-dev libboost-dev libboost-system-dev libboost-thread-dev libboost-serialization-dev libboost-python-dev libboost-regex-dev && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# Compile rdkit
curl https://github.com/rdkit/rdkit/archive/$RDKIT_VERSION.tar.gz -o /engine//$RDKIT_VERSION.tar.gz
tar xzvf $RDKIT_VERSION.tar.gz && \
rm $RDKIT_VERSION.tar.gz

cd /engine/rdkit-$RDKIT_VERSION/External/INCHI-API && \
./download-inchi.sh

mkdir /engine/rdkit-$RDKIT_VERSION/build && \
cd /engine/rdkit-$RDKIT_VERSION/build && \
cmake -DRDK_BUILD_INCHI_SUPPORT=ON .. && \
make && \
make install

# Set environmental variables
RDBASE=/engine/rdkit-$RDKIT_VERSION
LD_LIBRARY_PATH=$RDBASE/lib
PYTHONPATH=$PYTHONPATH:$RDBASE


#ENV HOME /root
cd /engine

# Download dependencies
apt-get update && \
apt-get -y upgrade && \
apt-get install -y subversion libboost-filesystem-dev git && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# Add sources
curl http://downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.0/lp_solve_5.5.2.0_source.tar.gz -o /engine//lp_solve_5.5.2.0_source.tar.gz
tar xzvf lp_solve_5.5.2.0_source.tar.gz && \
rm lp_solve_5.5.2.0_source.tar.gz

# Compile LPSolve
chmod +x /engine/lp_solve_5.5/lpsolve55/ccc
cd /engine/lp_solve_5.5/lpsolve55 && \
./ccc

# Compile CFM-ID
mkdir cfm-id-code
apt-get update
cd cfm-id-code && git clone https://github.com/PayamEmami/CFM-ID.git && mv CFM-ID cfm

ls -l /engine/lp_solve_5.5/lpsolve55/bin/ux64 && \
mkdir /engine/cfm-id-code/cfm/build && \
cd /engine/cfm-id-code/cfm/build && \
cmake .. -DLPSOLVE_INCLUDE_DIR=/engine/lp_solve_5.5 -DLPSOLVE_LIBRARY_DIR=/engine/lp_solve_5.5/lpsolve55/bin/ux64 && \
make install

# Set environmental variables
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$RDBASE/lib:/engine/lp_solve_5.5/lpsolve55/bin/ux64
PATH=$PATH:/engine/cfm-id-code/cfm/bin

cd /engine/cfm-id-code/cfm/supplementary_material/trained_models/esi_msms_models/negative_metab_se_cfm/ && unzip negative_se_params.zip
cd /engine/cfm-id-code/cfm/supplementary_material/trained_models/esi_msms_models/metab_se_cfm/ && unzip params_metab_se_cfm.zip

software_version="3.4.4-1trusty0"

# Add cran R backport


echo "deb http://cloud.r-project.org/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# Install r-base and remove not needed stuff
apt-get -y update && apt-get -y --no-install-recommends --force-yes install apt-transport-https r-base=${software_version} r-base-dev=${software_version} && \
apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

R -e 'source("https://bioconductor.org/biocLite.R");biocLite("tools")'

chmod +x /usr/local/bin/*.r

chmod +x /usr/local/bin/runTest1.sh
%environment
export RDKIT_VERSION=Release_2016_03_3
export RDBASE=/engine/rdkit-$RDKIT_VERSION
export LD_LIBRARY_PATH=$RDBASE/lib
export PYTHONPATH=$PYTHONPATH:$RDBASE
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$RDBASE/lib:/engine/lp_solve_5.5/lpsolve55/bin/ux64
export PATH=$PATH:/engine/cfm-id-code/cfm/bin
export software_version="3.4.4-1trusty0"
%runscript
cd /engine
exec /bin/bash "$@"
%startscript
cd /engine
exec /bin/bash "$@"
