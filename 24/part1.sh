#!/bin/bash

# set -x

input_file="input.txt"
rm out*.log

declare -A connectors
declare -A paths
declare -A operators=([AND]="&&" [OR]="||" [XOR]="^")

get_max_z()
{
	for i in $(seq 00 "$max_z"); do
		counter=$(printf "%02d" "$i")
		key="z$counter"
		echo "$key: ${connectors["$key"]}"
		if [ "${connectors["$key"]}" -eq 3 ]; then
			return 1
		fi
	done
	return 0
}

max_z=$(grep "-" "${input_file}" | awk -F" " '{print $NF}' | grep "z" | tr -d 'z' | sort | tail -n1)
echo "max_z: $max_z"

for i in $(seq 00 "$max_z"); do
	counter=$(printf "%02d" "$i")
	key="z$counter"
	connectors["$key"]=3
done


while IFS=": " read -r con val; do
    connectors["$con"]="$val"
done < <(grep ":" "${input_file}")

#for i in "${!connectors[@]}"; do echo "${i}: ${connectors[$i]}"; done


while IFS="-" read -r op val; do
    val=$(tr -d "> " <<< "$val")

    if ! [ "${paths[$op]}" == "" ]; then
	paths["$val AND $val"]=${paths[$op]}
    fi
    paths["$op"]="$val"
done < <(grep "-" "${input_file}")

# for i in "${!paths[@]}"; do echo "${i}: ${paths[$i]}" >> out_init.txt; done

# initialize blank keys
for i in "${!paths[@]}"; do 
	first=$(awk -F" " '{print $1}' <<< "$i")
	operator=$(awk -F" " '{print $2}' <<< "$i")
	second=$(awk -F" " '{print $3}' <<< "$i")
	assign=${paths[$i]}
	#echo "${paths[$i]}"
	#echo "$assign"
	#echo "${i}: ${paths[$i]}"; 

	fir="${connectors[$first]}"
	se="${connectors[$second]}"
	as="${connectors[$assign]}"
	op="${operators[$operator]}"
	#echo "$first, $second, $operator, $assign"
	#echo "$fir, $se, $op, $as"

	if [ "$fir" == "" ]; then
		connectors["$first"]=3	
	fi

	if [ "$se" == "" ]; then
		connectors["$second"]=3	
	fi

	if [ "$as" == "" ]; then
		connectors["$assign"]=3	
	fi
done

get_max_z
weiter="$?"
for j in {1..50}; do
	echo "$j"
	if [ "$weiter" -eq 0 ]; then
		echo "weiter: $j, $weiter"
		break
	fi
	for i in "${!paths[@]}"; do 
		assign=${paths[$i]}
		as="${connectors[${paths[$i]}]}"

		if ! [ "$as" = 3 ]; then
			continue
		fi

		first=$(awk -F" " '{print $1}' <<< "$i")
		fir="${connectors[$first]}"

		operator=$(awk -F" " '{print $2}' <<< "$i")
		op="${operators[$operator]}"

		second=$(awk -F" " '{print $3}' <<< "$i")
		se="${connectors[$second]}"
		#echo "$assign"
		#echo "${i}: ${paths[$i]}"; 
	
		#echo "$first, $second, $operator, $assign"
		#echo "$fir, $se, $op, $as"


		if [ "$fir" = 3 ] || [ "$se" = 3 ]; then
		#	echo "$first, $second, $operator, $assign"
		#	echo "$fir, $se, $op, $as"
			continue
		fi
		# echo "$first, $second, $operator, $assign"
		# echo "$fir, $se, $op, $as"

		# echo "$assign: $as"
		# echo "$first, $second, $operator, $assign"
		#echo "$fir, $se, $op, $as"
		res=$(( "$fir$op$se" ))
		#echo "$res"
		#echo "$assign = $res"
		connectors["$assign"]=$res
#		fi="${connectors[$first]}"
#		se="${connectors[$second]}"
#		as="${connectors[${paths[$i]}]}"
#		op="${operators[$operator]}"
		#echo "$first, $second, $operator, $assign"
		#echo "$fir, $se, $op, $as"
	done


	# for i in "${!connectors[@]}"; do 
	# 	if [ "${connectors[$i]}" = 3 ]; then
	# 		echo "${i}: ${connectors[$i]}";
	# 	fi
	# done

	get_max_z
	weiter="$?"
	echo "weiter: $weiter"
done
for i in "${!paths[@]}"; do echo "${i}: ${paths[$i]}" >> out1.log; done
for i in "${!connectors[@]}"; do echo "${i}: ${connectors[$i]}" >> out2.log; done
for i in "${!paths[@]}"; do 
       first=$(awk -F" " '{print $1}' <<< "$i")
       operator=$(awk -F" " '{print $2}' <<< "$i")
       second=$(awk -F" " '{print $3}' <<< "$i")
       assign=${paths[$i]}
       #echo "$assign"
       #echo "${i}: ${paths[$i]}"; 

       fir="${connectors[$first]}"
       se="${connectors[$second]}"
       as="${connectors[${paths[$i]}]}"
       op="${operators[$operator]}"
       #echo "$first, $second, $operator, $assign" >> out3.txt
       #echo "$fir, $se, $op, $as" >> out3.txt
done
num=""
for i in $(seq 00 "$max_z"); do
	counter=$(printf "%02d" "$i")
	key="z$counter"
#	echo "$counter"
#	echo "$key"
	num="${connectors["$key"]}$num"
done
echo "$((2#$num))"

