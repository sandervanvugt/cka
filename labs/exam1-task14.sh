if docker images | grep myapp | grep '1.0' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t container image myapp:1.0 was found"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t container image myapp:1.0 was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if [ -f /tmp/myapp.tar ]
then
        echo -e "\033[32m[OK]\033[0m\t\t tar archive /tmp/myapp.tar was found"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t tar archive /tmp/myapp.tar was not found"
fi
TOTAL=$(( TOTAL + 10 ))

