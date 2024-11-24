if kubectl get pv lab154 -o yaml | grep 'path.*/lab154' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t a PersistentVolume with the name lab155 was found and it uses the right path"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t PersistentVolume with the name lab155 using the right path was not found"
fi
TOTAL=$(( TOTAL + 10 ))
