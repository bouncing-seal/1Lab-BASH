#!/bin/bash

#Практическая работа 1
#Курапов Иван, гр.R3335

#Ввод названия необходимой директории
#read dirname #Ввод названия необходимой директории

dirname="./СПО/IOT-OPEN"
#Создание таблицы с результатами
echo -e "Путь \tИмя \t Расширение \t Дата изменения \t Размер (МБ) \t Продолжительность" > Table.xls
IFS=$'\n'	#Для чтения файлов с пробелами в названии
dir=$dirname
function  fun {
	for f in "$dir"/*
	do
		if [[ -d "$f" ]]
		then
			dir=$f
			fun
		else
			local file="${f##*/}"	#Имя файла С его расширением
			local name="${file%.*}"	#Имя файла БЕЗ его расширения
			local ext="${file:${#name} + 1}" #Расширение
			local lastch=$(ls -Rl "$f" | awk '{print $6, $7}') #Дата изменения
			local size=$(du -BM "$f" | awk '{print $1}') #Размер в МБ
			#Продолжительность, если файл - аудио/видео
			if [[ "$f" = *.MOV || "$f" = *.mp3 || "$f" = *.mp4 || "$f" = *.avi ]]
			then
				local dur=$(ffprobe -i "$f" -show_entries format=duration -v quiet -of csv="p=0" -sexagesimal);
			else
				local dur=$(echo No);
			fi
			echo -e "$f \t$name \t$ext \t$lastch \t$size \t$dur " >> Table.xls #Вывод в таблицу
			echo -e "$f $name $ext $lastch $size $dur"
			dir=$dirname
		fi
	done
		}
#Вызов функции
fun
