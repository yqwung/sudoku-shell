#!/bin/bash

# �ն�������Ϸ����Ϸ��8���ȼ���ͨ���������Ҽ��ƶ���꣬���ּ����룬������ɰ���f����֤������q���˳���Ϸ


clear                      # ����

COLOR_BLACK="\033[30m"     # ��ɫ
COLOR_RED="\033[31m"       # ��ɫ
COLOR_GREEN="\033[32m"     # ��ɫ
COLOR_YELLOW="\033[33m"    # ��ɫ
COLOR_BLUE="\033[34m"      # ��ɫ
COLOR_MAGENTA="\033[35m"   # Ʒ��ɫ
COLOR_CYAN="\033[36m"      # ����ɫ
COLOR_DEFAULT="\033[37m"   # ��ɫ��Ĭ��ɫ

LINE_GRREEN="${COLOR_GREEN}|${COLOR_DEFAULT}"   # ��ɫ��
CROSS_GRREEN="${COLOR_GREEN}+${COLOR_DEFAULT}"  # ��ɫ������

LAST_LINE=`tput lines`          # tput lines�����ȡ�ն�����
LAST_COL=`tput cols`            # tput cols�����ȡ�ն�����
#echo "${LAST_LINE}"
#echo "${LAST_COL}"

CURSOR_X=0   # ������
CURSOR_Y=0   # ������

KEY=()       # ��������

# �ű�����ѡ����Ϸ�ȼ�(1-8)
if [ ! -n "$1" ]       # û�д�������Ĭ�ϵȼ�1
then
	LEVEL=1
else
	if [ $1 -lt 1 ]    # ����������͵ȼ�1
	then
		LEVEL=1
	elif [ $1 -gt 8 ]  # ����������ߵȼ�8
	then
		LEVEL=8
	else
		LEVEL=$1
	fi
fi

# 

sudoku=()	

source ./generate.sh ${LEVEL}   # ִ���������ɽű�generate.sh
sudoku=(${sudoku_generate[*]})	# sudoku_generateΪ�ű�generate.sh���ɵ��������� 

sudoku_buf=(${sudoku[*]})	    # ��һ�����鸳����һ�����飬������������ʱ��Ŵ𰸣��Թ���֤��

	
# 1 ������
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

echo -ne "\033[$((${LAST_LINE}));1H"                              # ����ƶ������һ�У���һ��
echo -ne "\033[0m"
echo -ne "\033[7mPress f for finish or q to quit!\033[0m" 


# 2 ��д��Ŀ����
echo -ne "\033[3;9H"        # ����ƶ�����3�У���9�У�������ʼ����
echo -ne "${COLOR_RED}"
for i in {0..8}             # �ȼ��� for i in 0 1 2 3 4 5 6 7 8
do
	for j in {0..8}
	do
	    echo -ne "\033[$[ $i * 2 + 3 ];$[ $j * 4 + 9 ]H"   # ����ƶ�����i*2+3�У���j*4+9�� 	
		if [ ${sudoku[$[ $i * 9 + $j ]]} -ne 0 ]           # ������ݲ�����0����д��
		then
			echo -n "${sudoku[$[ $i * 9 + $j ]]}"
		fi								
	done
done
echo -ne "${COLOR_DEFAULT}"
echo -ne "\033[3;9H"        # ����ƶ�����3�У���9�У�������ʼ����


start=$(date "+%s")  # ��ʱ��


# 3 ��ȡ�û���������
while :                    
do			
    #read -s -t 1 -n 1 KEY    # ��ȡ�������룬��ʱ�˳�
	read -s -n 1 KEY    # ��ȡ�������룬�����������KEY
	case ${KEY[0]} in		   
		"A")            # �������
			CURSOR_X=`expr ${CURSOR_X} - 1`   # �ȼ���  CURSOR_X=$[ CURSOR_X - 1 ]
			if [ ${CURSOR_X} -lt 0 ]
			then
				CURSOR_X=8
				echo -ne "\033[16B"   # ���ƹ��16��
			else
				echo -ne "\033[2A"    # ���ƹ��2��
			fi
			;;
		"B")	         # �������	
			CURSOR_X=`expr ${CURSOR_X} + 1`  	
			if [ ${CURSOR_X} -gt 8 ]
			then
				CURSOR_X=0
				echo -ne "\033[16A"   # ���ƹ��16��
			else
				echo -ne "\033[2B"    # ���ƹ��2��
			fi
			;;
		"C")             # �������
			CURSOR_Y=`expr ${CURSOR_Y} + 1`   
			if [ ${CURSOR_Y} -gt 8 ]
			then
				CURSOR_Y=0
				echo -ne "\033[32D"   # ���ƹ��32��
			else
				echo -ne "\033[4C"    # ���ƹ��4��
			fi
			;;
		"D")             # �������
			CURSOR_Y=`expr ${CURSOR_Y} - 1`   
			if [ ${CURSOR_Y} -lt 0 ]
			then
				CURSOR_Y=8
				echo -ne "\033[32C"   # ���ƹ��32��
			else
				echo -ne "\033[4D"    # ���ƹ��4��
			fi
			;;
		[0-9])           # �ȼ��� "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9")
			if [ ${sudoku[$[ ${CURSOR_X} * 9 + ${CURSOR_Y} ]]} -eq 0 ]   # �ж��Ƿ�����Ŀ����
			then
				sudoku_buf[$[ ${CURSOR_X} * 9 + ${CURSOR_Y} ]]=${KEY[0]} # ����������ݷ��뻺���������Թ������жϴ�
				if [ ${KEY[0]} -eq 0 ]
				then
					echo -n " "
				else
					echo -n "${KEY[0]}"
				fi				
				echo -ne "\033[1D"
			fi
			;;
		"f")             # ���������Ϸ�������ȷ��		
		    source ./check.sh ${sudoku_buf[*]}   #  ִ���������ű�check.sh��������sudoku_buf����
			if [[ $return_check -eq 0 ]]  # �ж�sudoku_buf�����Ƿ����0Ԫ�أ�return_checkΪcheck.sh��ִ�н��
			then
				tput sc      # ������λ��
				echo -ne "\033[19;54H"        # ����Ƶ�19�е�62��
				echo -ne "                "   # �������	
				echo -ne "\033[19;54H"        # ����Ƶ�19�е�62��
				echo -ne "${COLOR_RED}    Error${COLOR_DEFAULT}"
				tput rc      # �ָ���굽�ϴα����λ��	
			else
				tput sc      # ������λ��
				echo -ne "\033[19;54H"        # ����Ƶ�19�е�62��
				echo -ne "                "   # �������	
				echo -ne "\033[19;54H"        # ����Ƶ�19�е�62��
				echo -ne "${COLOR_BLUE}Congratulations${COLOR_DEFAULT}"
				tput rc      # �ָ���굽�ϴα����λ��				
			fi
			;;
		"q")             # �˳�			    
			echo -ne "\033[${LAST_LINE};1H" # ����Ƶ����һ�е�һ��
			echo -ne "\033[K"	            # �����ǰ��굽��β������	
			clear
			break
			;;
		*)            
			continue
			;;
	esac
	
	
	# ��ʱ��
    now=$(date "+%s")
	time=$((now-start))

	minute=$((time/60))
	second=$((time-minute*60))

	tput sc      # ������λ��  
	#tput civis  # ���ع��
	echo -ne "\033[15;62H" # ����Ƶ�15�е�62��
	echo -ne "        "    # �����ʱ����	
	echo -ne "\033[15;62H" # ����Ƶ�15�е�62��
	echo -ne "${COLOR_DEFAULT}${minute}'${second}s${COLOR_DEFAULT}" 
	tput rc      # �ָ���굽�ϴα����λ��	
	
done