if grep 'ERROR.*uninitialized' /tmp/failingdb.log
then
	echo -e "\033[32m[OK]\033[0m\t\t correct error output was found"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t correct error output was not found"
fi
TOTAL=$(( TOTAL + 10 ))
