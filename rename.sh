#!/bin/bash

echo "Create output directory"
mkdir -p output

declare -A branch=( ["AA"]="粉嶺" ["AB"]="馬鞍山" ["AC"]="荃灣" ["AD"]="上水" ["AE"]="九龍灣")

# remove space in file name
find ./input/ -name "* *" -type f | rename 's/ /_/g'

for file in ./input/*.pdf
do 
    echo "Processing file $file"
    branchCode=$(java -jar tabula-1.0.2-jar-with-dependencies.jar -a 30,190,50,202 -i $file)
    branchCode=${branchCode//[$'\t\r\n']}
    echo "Detected branch code $branchCode"
    cp $file input/$branchCode.pdf
    pdfseparate -f 1 input/${branchCode}.pdf input/${branchCode}_p%d.pdf
    for file in ./input/${branchCode}_p*.pdf
    do
        supplierName=$(java -jar tabula-1.0.2-jar-with-dependencies.jar -a 60,50,80,1000 -i $file)
        supplierName=${supplierName//\"/}
        supplierName=${supplierName//[$'\t\r\n']}
        supplierName=${supplierName// /_}
        mkdir -p output/$supplierName
        cp $file output/$supplierName/$supplierName.${branch[$branchCode]}.pdf
    done
done

find ./input/ -name "* *" -type f | rename 's/ /_/g'

# for branchCode in "${!branch[@]}";
# do
#     pdfseparate -f 1 input/*${branchCode}.pdf input/${branchCode}_p%d.pdf
#     for file in ./input/${branchCode}_p*.pdf
#     do
#         supplierName=$(java -jar tabula-1.0.2-jar-with-dependencies.jar -a 60,50,80,1000 -i $file)
#         supplierName=${supplierName//\"/}
#         supplierName=${supplierName//[$'\t\r\n']}
#         supplierName=${supplierName// /_}
#         mkdir -p output/$supplierName
#         cp $file output/$supplierName/$supplierName.${branch[$branchCode]}.pdf
#     done
# done
