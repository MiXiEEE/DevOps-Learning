#!/bin/bash
echo "Variable-test"
echo "-------------"
name="MiXiEEE"
echo "Hello, $name!"
echo " "


echo "If statement-basic"
echo "-------------"
number=10
if [ $number -gt 5 ]; then
	echo "number greater than 5"
 else
 	echo "number less than or equal to 5"
fi
echo " "


echo "Loop for/while"
echo "-------------"
for i in {1..3}; do
	echo "Loop number $i"
done

count=1
while [ $count -le 3 ]; do
	echo "Count is $count"
	((count++))
done
echo " "


echo "functions"
echo "-------------"
greet() {
	echo "Hello, $1! Second argument $2"
}
greet "Mika" "arg2"

print_args() {
	echo "total arguments: $#"
	echo "Arguments as list: $@"
	echo "Arguments as string: $*"
}
print_args "one" "two" "three"

