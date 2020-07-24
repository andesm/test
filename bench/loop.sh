a=0
i=0
while (( i <= 100000000 ))
do
    a=$(( a + i ))
    i=$(( i + 1 ))
done
echo $a
