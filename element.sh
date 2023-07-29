#!/bin/bash

PSQL="psql -A -U freecodecamp -d periodic_table -t -c"

PROMPT_ELEMENT () {
  echo "$1" | while IFS="|" read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
}

PROMPT_NOT_FOUND () {
  echo "I could not find that element in the database."
}

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]*$ ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM properties LEFT JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1")
    
    if [[ -z $ELEMENT ]]
    then
      PROMPT_NOT_FOUND
    else
      PROMPT_ELEMENT $ELEMENT
    fi
  else
    ELEMENT=$($PSQL "SELECT * FROM properties LEFT JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")

    if [[ -z $ELEMENT ]]
    then
      PROMPT_NOT_FOUND
    else
      PROMPT_ELEMENT $ELEMENT
    fi
  fi
else
  echo "Please provide an element as an argument."
fi
