#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Check if the input is a number
if [[ $1 =~ ^[0-9]+$ ]]; then
  ELEMENT=$($PSQL "
    SELECT elements.atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type 
    FROM elements 
    JOIN properties ON elements.atomic_number = properties.atomic_number 
    JOIN types ON properties.type_id = types.type_id 
    WHERE elements.atomic_number = $1")
else
  ELEMENT=$($PSQL "
    SELECT elements.atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type 
    FROM elements 
    JOIN properties ON elements.atomic_number = properties.atomic_number 
    JOIN types ON properties.type_id = types.type_id 
    WHERE symbol = '$1' OR name = '$1'")
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi
