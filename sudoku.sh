#!/bin/bash

# 终端数独游戏，游戏有8个等级，通过上下左右键移动光标，数字键输入，数独完成按‘f’验证，按‘q’退出游戏


clear                      # 清屏

COLOR_BLACK="\033[30m"     # 黑色
COLOR_RED="\033[31m"       # 红色
COLOR_GREEN="\033[32m"     # 绿色
COLOR_YELLOW="\033[33m"    # 黄色
COLOR_BLUE="\033[34m"      # 蓝色
COLOR_MAGENTA="\033[35m"   # 品红色
COLOR_CYAN="\033[36m"      # 蓝绿色
COLOR_DEFAULT="\033[37m"   # 白色、默认色

LINE_GRREEN="${COLOR_GREEN}|${COLOR_DEFAULT}"   # 绿色线
CROSS_GRREEN="${COLOR_GREEN}+${COLOR_DEFAULT}"  # 绿色交叉线

LAST_LINE=`tput lines`          # tput lines命令获取终端行数
LAST_COL=`tput cols`            # tput cols命令获取终端列数
#echo "${LAST_LINE}"
#echo "${LAST_COL}"

CURSOR_X=0   # 数独行
CURSOR_Y=0   # 数独列

KEY=()       # 键盘输入

# 脚本参数选择游戏等级(1-8)
if [ ! -n "$1" ]       # 没有传参数，默认等级1
then
	LEVEL=1
else
	if [ $1 -lt 1 ]    # 参数低于最低等级1
	then
		LEVEL=1
	elif [ $1 -gt 8 ]  # 参数超出最高等级8
	then
		LEVEL=8
	else
		LEVEL=$1
	fi
fi

# 

sudoku=()	

source ./generate.sh ${LEVEL}   # 执行数独生成脚本generate.sh
sudoku=(${sudoku_generate[*]})	# sudoku_generate为脚本generate.sh生成的数独数组 

sudoku_buf=(${sudoku[*]})	    # 把一个数组赋给另一个数组，次数组用于临时存放答案，以供验证答案

	
# 1 数独框
echo -e "   ********************************************************************"
echo -e "   *  ${COLOR_DEFAULT}-------------------------------------                           *"              
echo -e "   *  ${COLOR_DEFAULT}|   |   |   ${LINE_GRREEN}   |   |   ${LINE_GRREEN}   |   |   |                           *"              
echo -e "   *  ${COLOR_DEFAULT}|---+---+---${CROSS_GRREEN}---+---+---${CROSS_GRREEN}---+---+---|                           *"              
echo -e "   *  ${COLOR_DEFAULT}|   |   |   ${LINE_GRREEN}   |   |   ${LINE_GRREEN}   |   |   |                           *"             
echo -e "   *  ${COLOR_DEFAULT}|---+---+---${CROSS_GRREEN}---+---+---${CROSS_GRREEN}---+---+---|                           *"            
echo -e "   *  ${COLOR_DEFAULT}|   |   |   ${LINE_GRREEN}   |   |   ${LINE_GRREEN}   |   |   |                           *"             
echo -e "   *  |${COLOR_GREEN}---+---+---+---+---+---+---+---+---${COLOR_DEFAULT}|                           *"              
echo -e "   *  ${COLOR_DEFAULT}|   |   |   ${LINE_GRREEN}   |   |   ${LINE_GRREEN}   |   |   |       * * * * * * * * * * *"              
echo -e "   *  ${COLOR_DEFAULT}|---+---+---${CROSS_GRREEN}---+---+---${CROSS_GRREEN}---+---+---|       *                   *"              
echo -e "   *  ${COLOR_DEFAULT}|   |   |   ${LINE_GRREEN}   |   |   ${LINE_GRREEN}   |   |   |       * Level:    ${LEVEL}/8     *"              
echo -e "   *  ${COLOR_DEFAULT}|---+---+---${CROSS_GRREEN}---+---+---${CROSS_GRREEN}---+---+---|       *                   *"             
echo -e "   *  ${COLOR_DEFAULT}|   |   |   ${LINE_GRREEN}   |   |   ${LINE_GRREEN}   |   |   |       * * * * * * * * * * *"              
echo -e "   *  |${COLOR_GREEN}---+---+---+---+---+---+---+---+---${COLOR_DEFAULT}|       *                   *"              
echo -e "   *  ${COLOR_DEFAULT}|   |   |   ${LINE_GRREEN}   |   |   ${LINE_GRREEN}   |   |   |       * Timer:            *"            
echo -e "   *  ${COLOR_DEFAULT}|---+---+---${CROSS_GRREEN}---+---+---${CROSS_GRREEN}---+---+---|       *                   *"             
echo -e "   *  ${COLOR_DEFAULT}|   |   |   ${LINE_GRREEN}   |   |   ${LINE_GRREEN}   |   |   |       * * * * * * * * * * *"             
echo -e "   *  ${COLOR_DEFAULT}|---+---+---${CROSS_GRREEN}---+---+---${CROSS_GRREEN}---+---+---|       *                   *"            
echo -e "   *  ${COLOR_DEFAULT}|   |   |   ${LINE_GRREEN}   |   |   ${LINE_GRREEN}   |   |   |       *                   *"           
echo -e "   *  ${COLOR_DEFAULT}-------------------------------------       *                   *"
echo -e "   ********************************************************************"

echo -ne "\033[$((${LAST_LINE}));1H"                              # 光标移动到最后一行，第一列
echo -ne "\033[0m"
echo -ne "\033[7mPress f for finish or q to quit!\033[0m" 


# 2 填写题目数据
echo -ne "\033[3;9H"        # 光标移动到第3行，第9列，数独起始行列
echo -ne "${COLOR_RED}"
for i in {0..8}             # 等价于 for i in 0 1 2 3 4 5 6 7 8
do
	for j in {0..8}
	do
	    echo -ne "\033[$[ $i * 2 + 3 ];$[ $j * 4 + 9 ]H"   # 光标移动到第i*2+3行，第j*4+9列 	
		if [ ${sudoku[$[ $i * 9 + $j ]]} -ne 0 ]           # 如果数据不等于0，就写入
		then
			echo -n "${sudoku[$[ $i * 9 + $j ]]}"
		fi								
	done
done
echo -ne "${COLOR_DEFAULT}"
echo -ne "\033[3;9H"        # 光标移动到第3行，第9列，数独起始行列


start=$(date "+%s")  # 计时器


# 3 获取用户键盘输入
while :                    
do			
    #read -s -t 1 -n 1 KEY    # 获取键盘输入，超时退出
	read -s -n 1 KEY    # 获取键盘输入，存入变量数组KEY
	case ${KEY[0]} in		   
		"A")            # 光标上移
			CURSOR_X=`expr ${CURSOR_X} - 1`   # 等价于  CURSOR_X=$[ CURSOR_X - 1 ]
			if [ ${CURSOR_X} -lt 0 ]
			then
				CURSOR_X=8
				echo -ne "\033[16B"   # 下移光标16行
			else
				echo -ne "\033[2A"    # 上移光标2行
			fi
			;;
		"B")	         # 光标下移	
			CURSOR_X=`expr ${CURSOR_X} + 1`  	
			if [ ${CURSOR_X} -gt 8 ]
			then
				CURSOR_X=0
				echo -ne "\033[16A"   # 上移光标16行
			else
				echo -ne "\033[2B"    # 下移光标2行
			fi
			;;
		"C")             # 光标右移
			CURSOR_Y=`expr ${CURSOR_Y} + 1`   
			if [ ${CURSOR_Y} -gt 8 ]
			then
				CURSOR_Y=0
				echo -ne "\033[32D"   # 左移光标32列
			else
				echo -ne "\033[4C"    # 右移光标4列
			fi
			;;
		"D")             # 光标左移
			CURSOR_Y=`expr ${CURSOR_Y} - 1`   
			if [ ${CURSOR_Y} -lt 0 ]
			then
				CURSOR_Y=8
				echo -ne "\033[32C"   # 右移光标32列
			else
				echo -ne "\033[4D"    # 左移光标4列
			fi
			;;
		[0-9])           # 等价于 "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9")
			if [ ${sudoku[$[ ${CURSOR_X} * 9 + ${CURSOR_Y} ]]} -eq 0 ]   # 判断是否是题目数据
			then
				sudoku_buf[$[ ${CURSOR_X} * 9 + ${CURSOR_Y} ]]=${KEY[0]} # 将输入的数据放入缓冲数独，以供后面判断答案
				if [ ${KEY[0]} -eq 0 ]
				then
					echo -n " "
				else
					echo -n "${KEY[0]}"
				fi				
				echo -ne "\033[1D"
			fi
			;;
		"f")             # 完成数独游戏，检查正确性		
		    source ./check.sh ${sudoku_buf[*]}   #  执行数独检查脚本check.sh，并传入sudoku_buf数组
			if [[ $return_check -eq 0 ]]  # 判断sudoku_buf数组是否包含0元素，return_check为check.sh的执行结果
			then
				tput sc      # 保存光标位置
				echo -ne "\033[19;54H"        # 光标移到19行第62列
				echo -ne "                "   # 清除内容	
				echo -ne "\033[19;54H"        # 光标移到19行第62列
				echo -ne "${COLOR_RED}    Error${COLOR_DEFAULT}"
				tput rc      # 恢复光标到上次保存的位置	
			else
				tput sc      # 保存光标位置
				echo -ne "\033[19;54H"        # 光标移到19行第62列
				echo -ne "                "   # 清除内容	
				echo -ne "\033[19;54H"        # 光标移到19行第62列
				echo -ne "${COLOR_BLUE}Congratulations${COLOR_DEFAULT}"
				tput rc      # 恢复光标到上次保存的位置				
			fi
			;;
		"q")             # 退出			    
			echo -ne "\033[${LAST_LINE};1H" # 光标移到最后一行第一列
			echo -ne "\033[K"	            # 清除当前光标到行尾的内容	
			clear
			break
			;;
		*)            
			continue
			;;
	esac
	
	
	# 计时器
    now=$(date "+%s")
	time=$((now-start))

	minute=$((time/60))
	second=$((time-minute*60))

	tput sc      # 保存光标位置  
	#tput civis  # 隐藏光标
	echo -ne "\033[15;62H" # 光标移到15行第62列
	echo -ne "        "    # 清除计时内容	
	echo -ne "\033[15;62H" # 光标移到15行第62列
	echo -ne "${COLOR_DEFAULT}${minute}'${second}s${COLOR_DEFAULT}" 
	tput rc      # 恢复光标到上次保存的位置	
	
done