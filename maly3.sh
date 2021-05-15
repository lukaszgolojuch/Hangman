#!/bin/bash
#Author: Lukasz Golojuch
#Language: bash
#Operating system: Linux Knoppix
#App name: Hangman name

#Game gets words from words.txt
#words.txt must be in the same location
#First line of words.txt must be number of lines
#Other lines are words one word for each line

guessed=""
player_points=0
lines_number=0

actualStatus(){

	#printing in zenity actual status of hangman 
	echo "[*] Actual state of guessing word: $guessed"
	case $player_points in
	  0)
	    zenity --info --width=300 --height=200 --text "$guessed"
	    ;;
	  1)
	    zenity --info --width=300 --height=200 --text " _ \n \n $guessed"
	    ;;
	  2)
	    zenity --info --width=300 --height=200 --text "|_ \n \n $guessed"
	    ;;
	  3)
	    zenity --info --width=300 --height=200 --text " | \n |_ \n \n $guessed"
	    ;;
	  4)
	    zenity --info --width=300 --height=200 --text " | \n | \n |_ \n \n $guessed"
	    ;;
	  5)
	    zenity --info --width=300 --height=200 --text " | \n | \n | \n |_ \n \n $guessed"
	    ;;	
	  6)
	    zenity --info --width=300 --height=200 --text " | \n | \n | \n |_ \n \n $guessed"
	    ;;	
	  7)
	    zenity --info --width=300 --height=200 --text " _ \n | \n | \n | \n |_ \n \n $guessed"
	    ;;	
	  8)
	    zenity --info --width=300 --height=200 --text " __ \n | \n | \n | \n |_ \n \n $guessed"
	    ;;
	  9)
	    zenity --info --width=300 --height=200 --text " ___ \n | \n | \n | \n |_ \n \n $guessed"
	    ;;
	  10)
	    zenity --info --width=300 --height=200 --text " ___ \n |  | \n | \n | \n |_ \n \n $guessed"
	    ;;
	  *)
	    echo "[*] Error occured"
	    zenity --error --text "Error occured!"
	    ;;
	esac
}

turnOff(){
	#turn off game
	zenity --info --timeout 2 --width=300 --height=200 --text "Thank you...\nSee you soon"
	echo "[*] Game finished"
	exit
}

PlayerVsComputer(){
#Set nick
nick=$(zenity --entry --width=300 --height=200 --title "Enter your nick" --text "")
echo "[*] Nick set as $nick"
player_points=0
blank="_"
wygrana=0

number=$(( $RANDOM % $lines_number + 2))

w=p
number=${number}${w}

#put new word into word variable
word=`sed -n $number words.txt`

for (( c=1; c<=${#word}; c++ ))
do  
	guessed=${guessed}${blank};
done

while [ $wygrana -ne 1 ]
do

echo "[*]"
echo "[*] Waiting for letter input..."
letter=$(zenity --entry --title "Letter input" --text "Enter a letter")

echo "[*] New letter: $letter"
if [[ $word =~ $letter ]]; then
	
	i=0
	while [ $i -lt ${#guessed} ]; do y[$i]=${guessed:$i:1};  i=$((i+1));done
	i=0
	while [ $i -lt ${#word} ]; do z[$i]=${word:$i:1};  i=$((i+1));done

	guessed=""	
	for (( i=0; i<=${#word}; i++ ))
	do  
		letter2=${z[$i]}
		
		if [[ $letter == $letter2 ]]
		then
			y[$i]=${z[$i]}
		fi
	
		guessed=${guessed}${y[$i]};
	done
else
   player_points=`expr $player_points + 1`
   echo "[*] Number of mistakes: $player_points/10"
fi

actualStatus

if [ $player_points -eq "10" ] || [ "$word" == "$guessed" ] 
then 
	wygrana=`expr $wygrana + 1`
	echo "[*] End of the game"
fi

done

if [ $player_points -eq "10" ]
then
	echo "[*] Lose"
	zenity --warning --width=300 --height=200 --timeout 3 --text "You lose! \nCorrect word was $word \n Maybe next time..."
	turnOff
else
	echo "[*] Win"
	zenity --info --width=300 --height=200 --text "You won! \n Congratulations"
	turnOff
fi
}

zenity --question  --text "Do you wanna play?" --width=300 --height=200

echo "Logs:"

if [[ $? = 0 ]]; then
	echo "[*] Game started"	
else
	turnOff
fi

ans=$(zenity  --list  --text "Type of game" --radiolist  --column "Pick" --column "Opinion" TRUE "Player vs Computer") 

if [[ $ans == "Player vs Computer" ]]
 then
	#change of access to words.txt
	chmod 740 words.txt

	echo "[*] Chmod of words.txt set as 740"

	#getting number of lines - first line of file
	lines_number=`sed -n 1p words.txt` 
	echo "[*] Number of lines in text: $lines_number"
	echo "[*] Player Vs Computer mode"

	#starting PlayerVsComputer mode
	PlayerVsComputer 
 else
	#turn off program
	turnOff
 fi


