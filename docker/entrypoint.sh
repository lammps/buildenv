#!/bin/bash
source /etc/profile
module load mpi

/bin/bash -c "$@"
