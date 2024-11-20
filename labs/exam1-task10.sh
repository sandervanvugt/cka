if test -x $(which helm) &>/dev/null
then    
        echo -e "\033[32m[OK]\033[0m\t\t the helm binary has been installed"
        SCORE=$(( SCORE + 10 ))
else    
        echo -e "\033[31m[FAIL]\033[0m\t\t the helm binary has not been installed"
fi
TOTAL=$(( TOTAL + 10 ))

if helm list | grep mysql &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t you have successfully installed the bitnami mysql chart"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t bitnami mysql chart not found"
fi
TOTAL=$(( TOTAL + 10 ))
