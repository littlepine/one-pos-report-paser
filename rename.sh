#!/bin/bash

echo "Create output directory"
mkdir -p output

declare -A branch=( ["AA"]="粉嶺" ["AB"]="馬鞍山" ["AC"]="荃灣" ["AD"]="上水" ["AE"]="九龍灣")

for branchCode in "${!branch[@]}";
do
    for file in ./$branchCode/p*.pdf
    do
        supplierName=$(java -jar tabula-1.0.2-jar-with-dependencies.jar -a 60,70,80,1000 -i $file)
        supplierName=${supplierName//\"/}
        supplierName=${supplierName//[$'\t\r\n']}
        supplierName=${supplierName// /_}
        mkdir -p output/$supplierName
        cp $file output/$supplierName/$supplierName.fl.pdf
    done
done