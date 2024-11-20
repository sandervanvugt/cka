if true &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t this task cannot be automatically graded so you just get the points"
        SCORE=$(( SCORE + 10 ))
fi
TOTAL=$(( TOTAL + 10 ))
