# checking for PV with persistentVolumeReclaimPolicy set to Delete
if kubectl get pv exam2-task4-pv -o yaml | grep 'persistentVolumeReclaimPolicy: Delete' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t found the pv exam2-task4-pv with persistentVolumeReclaimPolicy: Delete"
	SCORE=$(( SCORE + 4 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t didn't find the pv exam2-task4-pv with persistentVolumeReclaimPolicy: Delete"
fi
TOTAL=$(( TOTAL + 4 ))

# checking for StorageClass with allowVolumeExpension: true
if kubectl get storageclass -o yaml | grep 'allowVolumeExpansion: true' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t found a storageClass with allowVolumeExpansion set to true"
        SCORE=$(( SCORE + 4 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t didn't find a storageClass with allowVolumeExpansion set to true"
fi
TOTAL=$(( TOTAL + 4 ))

# checking bound status between PVC and PV
if kubectl get pvc exam2-task4-pvc | grep 'Bound' | grep 'exam2-task4-pv' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t found the pvc correctly bound to the pv"
        SCORE=$(( SCORE + 4 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t didn't find a correct binding between the pvc and the pv"
fi
TOTAL=$(( TOTAL + 4 ))

# checking size in the PVC
if kubectl get pvc exam2-task4-pvc -o yaml | grep -A 1 requests | grep 'storage: 200Mi' &>/dev/null 
then
        echo -e "\033[32m[OK]\033[0m\t\t found correct resized size request on the PVC"
        SCORE=$(( SCORE + 4 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t didn't find correct resized size request on the PVC"
fi
TOTAL=$(( TOTAL + 4 ))

# checking mountPath for the PVC in Pod
if kubectl get pods storage -o yaml | grep 'claimName: exam2-task4-pvc' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t correct PVC mount found in Pod"
        SCORE=$(( SCORE + 4 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t correct PV mount not found in Pod"
fi
TOTAL=$(( TOTAL + 4 ))

