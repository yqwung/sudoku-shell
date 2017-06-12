#!/bin/bash

# 检查一个数独是否正确
# 先从sudoku_check取出每行的9个数据放入group，
# 再循环判断1 2 3 4 5 6 7 8 9是否分别在这一行里面，
# 每列、每小块同理。

sudoku_check=(9 7 8 3 1 2 6 4 5
			  3 1 2 6 4 5 9 7 8
			  6 4 5 9 7 8 3 1 2
			  7 8 9 1 2 3 4 5 6
			  1 2 3 4 5 6 7 8 9
			  4 5 6 7 8 9 1 2 3
			  8 9 7 2 3 1 5 6 4
			  2 3 1 5 6 4 8 9 7
			  5 6 4 8 9 7 2 3 1)    # 81

group=()               # 9

count_9=0              # group里面是否有{1..9}，计数

ok_check=0             # 有多少行、列、小九宫格是对的

return_check=0         # 脚本返回，数独正确返回1，错误返回0

sudoku_check=($@)      # 接受传入的要检查的数独数组（81）


# 9行
for i in {0..8}                             # 等价于 for i in 0 1 2 3 4 5 6 7 8
do    
	# 取出一行的9个数据放入group
	for j in {0..8}                         
	do
		group[j]=${sudoku_check[$((9*i+j))]}
	done
	
	# 判断1 2 3 4 5 6 7 8 9是否在group中	
	count_9=0
	for k in {0..8}                         
	do
		if [[ "${group[@]}" =~ $((k+1)) ]]  # 判断group数组是否包含k+1元素
		then
			((count_9++))
		else
			return_check=0                  # 数独错误
			break
		fi
	done

	# 如果计数为9，说明1 2 3 4 5 6 7 8 9都在数组，即为正确
	if [ ${count_9} -eq 9 ]
	then
		((ok_check++))    # echo "line ${i} ok"
	fi
done


# 9列
for i in {0..8}                     
do
	for j in {0..8}
	do
		group[j]=${sudoku_check[$((9*j+i))]}
	done
	
	count_9=0	
	for k in {0..8}
	do
		if [[ "${group[@]}" =~ $((k+1)) ]]  
		then
			((count_9++))
		else
			return_check=0
			break
		fi
	done

	if [ ${count_9} -eq 9 ]
	then
		((ok_check++))    # echo "col ${i} ok"
	fi	
done


# 9个小九宫格
first=(0 3 6 27 30 33 54 57 60)
for i in {0..8}                   
do
	for m in 0 1 2
	do
		for n in 0 1 2
		do	
			group[$((3*m+n))]=${sudoku_check[$((${first[$i]}+9*m+n))]}
		done
	done
	
	count_9=0
	for k in {0..8}
	do
		if [[ "${group[@]}" =~ $((k+1)) ]]
		then
			((count_9++))
		else
			return_check=0
			break
		fi
	done

	if [ ${count_9} -eq 9 ]
	then
		((ok_check++))     # echo "part ${i} ok"
	fi	
done


# 9行、9列、9个小九宫格都正确，返回1
if [ ${ok_check} -eq 27 ]
then
	return_check=1
fi
