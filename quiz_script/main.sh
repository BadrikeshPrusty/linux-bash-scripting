#! /bin/bash

<<comment
Author Name	: Badrikesh Prusty
Date		: 29/02/2020
Description	: 
Input		:
Output		:
comment

BOLD="\033[0;1m"
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"
clear
echo -e "$BOLD    #########################################################################################################################################"
echo -e "$BOLD$BLUE					             		     Welcome					 		"
echo -e "$BOLD    #########################################################################################################################################"

echo
echo "    Please select an option:"
echo -e "$NORMAL    1. Sign Up"
echo "    2. Sign In"
echo "    3. Exit"
echo -e "$BOLD" 
read -p "    Enter Selection: " select
echo
arr_usr=(`cat user.csv | tr "," " "`)
arr_passwd=(`cat password.csv | tr "," " "`)
case $select in
    1)
	echo -e "$BOLD$CYAN    Sign Up:$NORMAL"
	i=1
	while [ $i -le 3 ]
	do
	    count=0
	    read -p "    Enter new Username: " user
	    for j in `seq 0 $((${#arr_usr[@]}-1))`
	    do
		if [[ $user == ${arr_usr[$j]} ]]
		then
		    echo -e "$BOLD$RED    Entered username already exists."
		    count=$(($count+1))
		fi
	    done
	    if [ $count -eq 0 ]
	    then
	        read -p "    Enter Password: " -s pass
	        echo
	        if [ ${#pass} -ge 8 ]
	        then
	            read -p "    Re-enter Password: " -s pass1
	            echo
	            if [ $pass == $pass1 ]
	            then
		        echo -e "$BOLD$YELLOW    Congratulations! Your account has been created."
			echo -e "    Now you can Sign In with your username and password and give the test.$NORMAL"
			echo $user>>user.csv
			echo $pass>>password.csv
		        break
	            else
		        echo -e "$BOLD$RED    Re-entered password and entered password is different."
	            fi
	        else
	            echo -e "$BOLD$RED    Entered password has less than 8 characters."
		fi
	    fi   
	    i=$(($i+1))
	    echo
	    if [ $i -ge 1 -a $i -le 3 ]
	    then
	        echo -e "$BOLD$YELLOW    Try Again."
	        echo -e "    Chances left: $((4-$i)).$NORMAL"
	        echo
	    elif [ $i -gt 3 ]
	    then
	        echo -e "$BOLD$YELLOW    You have entered incorrect information three times."
	        echo -e "    Please enter the information carefully and correctly next time you execute the program.$NORMAL" 
	    fi
	    echo
	done
	;;
    2)
	echo -e "$BOLD$CYAN    Sign In:$NORMAL"
	i=1
	while [ $i -le 3 ]
	do
	    count=0
	    read -p "    Enter Username: " user
	    for j in `seq 0 $((${#arr_usr[@]}-1))`
	    do
	        if [[ $user == ${arr_usr[$j]} ]]
	        then
		    count=$(($count+1))
		    break
		fi
	    done
	    if [ $count -eq 1 ]
	    then
		read -p "    Enter password: " -s pass
		echo
		if [[ $pass == ${arr_passwd[$j]} ]]
		then
		    echo
		    echo -e "$BOLD$GREEN    Login Successful."
		    login=success
		    break
		else
		    echo
		    echo -e "$BOLD$RED    Wrong Password."
		fi
	    else
		echo -e "$BOLD$RED    $user doesn't exist."
	    fi
	    i=$(($i+1))
	    echo
	    if [ $i -ge 1 -a $i -le 3 ]
	    then
	        echo -e "$BOLD$YELLOW    Try Again."
	        echo -e "    Chances left: $((4-$i)).$NORMAL"
	        echo
	    elif [ $i -gt 3 ]
	    then
	        echo -e "$BOLD$YELLOW    You have entered incorrect information three times."
	        echo -e "    Please enter the information carefully and correctly next time you execute the program.$NORMAL" 
	    fi
	done
	if [[ $login == success ]]
	then
	    echo -e "$BOLD"
	    read -p "    Do you want to give the test? (yes/no): " ans
	    if [[ $ans == yes ]]
	    then
		clear
		echo -e "$BOLD    #########################################################################################################################################"
		echo -e "$BOLD$BLUE							       Welcome to the test.$NORMAL"
		echo -e "$BOLD    #########################################################################################################################################$NORMAL"
		echo
		echo -e "$BOLD$YELLOW							Your test will begin shortly....."
		echo "			   Please press only one key amongst a, b, c, d for giving answers and wait for next question"
		echo
		echo -e "$BOLD$GREEN							        ALL THE VERY BEST$NORMAL"
		sleep 5
		lines=6
		rm -rf "$user"_ans.txt
		while [ $lines -le 78 ]
		do
		    clear
		    i=10
		    while [ $i != 0 ]
		    do
			clear
			cat question_bank.txt | head -$lines | tail -6
			echo
			echo -n "Select an option before $i sec: "
			echo -n -e "$BOLD$YELLOW"
			read -n1 -t 1 answer
			echo -n -e "$NORMAL"
			if [[ -n $answer ]]
			then
			    sleep 1
			    echo "$answer">>"$user"_ans.txt
			    break
			elif [[ -z $answer && $i -le 1 ]]
			then
			    echo -e ""$BOLD$RED"TIMEOUT!!!$NORMAL"
			    sleep 1
			    echo "timeout">>"$user"_ans.txt
			fi
			i=$(($i-1))
		    done
		    lines=$(($lines+8))
		    i=$(($i-1))
		    echo
		done
		clear
		echo -e "$BOLD$GREEN							 You have successfully completed the test"
		echo -e "$BOLD$YELLOW								 Preparing your results..."
		sleep 2
		echo
		echo -e "$BOLD$CYAN								     Results Prepared$NORMAL"
		sleep 1
		clear
		rm -rf "$user"_results.txt
		arr_org_ans=(`cat org_ans.txt`)
		arr_usr_ans=(`cat "$user"_ans.txt`)
		strt=1
		en=6
		for i in `seq 0 $((${#arr_org_ans[@]}-1))`
		do
		    sed -n "$strt,$en"p question_bank.txt>>"$user"_results.txt
		    echo>>"$user"_results.txt
		    if [ ${arr_org_ans[$i]} == ${arr_usr_ans[$i]} ]
		    then
			echo -e ""$GREEN"correct"$NORMAL"">>"$user"_results.txt
		    elif [ ${arr_usr_ans[$i]} == timeout ]
		    then
			echo -e ""$RED"timeout"$NORMAL"">>"$user"_results.txt
		    else
			echo -e ""$RED"incorrect"$NORMAL"">>"$user"_results.txt
		    fi
		    echo>>"$user"_results.txt
		    strt=$(($strt+8))
		    en=$(($en+8))
		done
		less -R "$user"_results.txt
	    elif [[ $ans == no ]]
	    then
		echo "    bye."
	    else
		echo -e "$BOLD$RED    Invalid Entry. Enter either yes or no."
	    fi
	fi
	;;
    3)
	echo -e "$BOLD$YELLOW Exiting the script.$NORMAL"
	;;
    *)
	echo -e "$BOLD$RED Invalid Selection. Please re-run the program and follow the instruction. $NORMAL"
esac
