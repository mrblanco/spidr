#!/bin/bash
clusterfile=$1
echo "Working on Cluster file: $clusterfile"

#Filtering clusters for condition based on first barcode:
awk 'BEGIN { FS = "." } ; $6 ~ /CNTRL/ {print $0}' $clusterfile > $clusterfile".cntrl.clusters"

awk 'BEGIN { FS = "." } ; $6 ~ /TORIN/ {print $0 }' $clusterfile > $clusterfile".torin.clusters"

#Read and Bead Counts:
python /groups/guttman/projects/spidr/scripts/plot_assignment_distribution_RPM.py -c $clusterfile".cntrl.clusters"  --min_oligos 1 --proportion 0.8 --max_size 100 --outprefix $clusterfile".cntrldistribution_1_0.8_100"

python /groups/guttman/projects/spidr/scripts/plot_assignment_distribution_RPM.py -c $clusterfile".torin.clusters"  --min_oligos 1 --proportion 0.8 --max_size 100 --outprefix $clusterfile".torindistribution_1_0.8_100"

grep -v Cluster $clusterfile".cntrldistribution_1_0.8_100.counts" | sort -k1,1  > $clusterfile".controldistribution_1_0.8_100.sorted.counts"

grep -v Cluster $clusterfile".torindistribution_1_0.8_100.counts" | sort -k1,1  > $clustefile".torindistribution_1_0.8_100.sorted.counts"

join -j 1 $clusterfile".controldistribution_1_0.8_100.sorted.counts" $clusterfile".torindistribution_1_0.8_100.sorted.counts" > $clusterfile".joined.distribution.control.torin.sorted.counts"

