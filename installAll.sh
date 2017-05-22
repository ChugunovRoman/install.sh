#!/bin/bash

SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

if [[ $EUID -ne 0 ]]; then
	echo "Скрипт нужно запускать от root! Панятна??)";
	echo "Выход";
	exit 1;
fi

declare -a arProg=( 

	# boot
	isolinux
	gfxboot
	extlinux
	pxelinux
	syslinux-themes-ubuntu
	syslinux-utils

	# systems
	dialog
	synaptic
	gnome-tweak-tool
	screenfetch
	gksu
	mc
	dconf-editor
	nvidia-prime
	ubuntu-restricted-extras
	libavcodec-extra
	hddtemp
	psensor
	tlp
	tlp-rdw
	gcc
	texinfo
	autoconf
	y-ppa-manager
	tasksel
	prelink
	preload
	gparted
	libunity-tools
	gddrescue
	libc-ares2
	libcrypto++9v5
	libssl1.0.2
	libchm1
	libwebkitgtk-1.0-0
	ffmpeg
	compiz
	compiz-plugins-extra 
	compizconfig-settings-manager
	aqemu
	kvmtool
	libsdl2-2.0-0
	xterm
	gnome-terminal
	konsole
	zenity
	fonts-liberation
	inxi
	samba

	# browsers
	#chromium-browser
	google-chrome-stable
	pepperflashplugin-nonfree
	adobe-flashplugin

	# indicators
	indicator-cpufreq
	indicator-multiload
	indicator-netspeed

	# apps
	camera-app
	docky
	skype
	qbittorrent
	#deluge
	audacious
	gimp
	inkscape
	wallch
	#notepadqq
	#filezilla
	screenlets
	screenlets-pack-all
	lm-sensors
	#brackets
	playonlinux
	handbrake
	#avidemux*
	gtk-redshift
	audacity
	nautilus-admin
	nautilus-columns
	nautilus-hide
	nautilus-terminal
	gimp-plugin-registry
	gimp-dds
	diodon
	bleachbit
	djview4
	simplescreenrecorder
	simplescreenrecorder-lib:i386
	#obs-studio
	byzanz
	imagemagick
	virtualbox
	virtualbox-ext-pack
	git
	git-all
	software-properties-common
	synaptic
	apt-xapian-index
	gdebi
	caffeine
	qupzilla
	haguichi

	# python
	python
	python-all
	python-rsvg
	python-scour
	python-gnome2
	python-dbus
	python-wnck
	python-gnome2-desktop
	python-gnome2-desktop-dev
	python-gst0.10
	python-gst-1.0
	python-xdg
	python-gconf
	python-beautifulsoup
	python3-openssl
	python-software-properties

	# themes
	adwaita-os-x-gtk3
	vold-theme-gtk3
	stylish-dark-gtk3
	sable-icons
	sable-theme-gtk3
	dorian-theme-gtk3
	delorean-dark-gtk3
	azure-theme-gtk3
	animus-gtk3
	ambiance

	# server
	apache2
	libapache2-mod-php5.6
	php5.6
	php5.6-cgi
	php5.6-bz2
	php5.6-curl
	php5.6-mbstring
	php5.6-mcrypt
	php5.6-mysql
	php5.6-odbc
	php5.6-xml
	php5.6-zip
	mysql-client
	mysql-server
	mysql-utilities
);

declare -a arRepositories=(
	ppa:indicator-multiload/stable-daily
	ppa:nilarimogard/webupd8
	ppa:qbittorrent-team/qbittorrent-stable
	ppa:notepadqq-team/notepadqq
	ppa:djcj/screenfetch
	ppa:linrunner/tlp
	ppa:webupd8team/y-ppa-manager
	ppa:ondrej/php
	ppa:webupd8team/brackets
	ppa:appgrid/stable
	ppa:rebuntu16/avidemux+unofficial
	ppa:maarten-baert/simplescreenrecorder
	ppa:webupd8team/haguichi

);

declare -a arProgNotInstall;

lsb_distr=`lsb_release -i`;
lsb_distr=${lsb_distr:16};

# перебираем агрументы скрипта
if [[ $# -ne "0" ]]; then
	argv=$@;

	if [[ `expr index "$argv" y` -ne 0 ]]; then
		y="-y";
		echo "Всем да :)";
	fi
	
	if [[ "$argv" == *--repository* || "$argv" == *-r* || "$argv" == *r* ]]; then

		echo -e "Добавляем репы...";
		bash -c "apt-get update";
		apt-get install software-properties-common -y
		apt-get install python-software-properties -y

		if [ "$lsb_distr" == "elementary" ]; then
			arRepositories+=( 
				ppa:varlesh-l/loki
				ppa:mpstark/elementary-tweaks-daily
			 );
		fi

		# Добавление репозиториев
		for rep in "${arRepositories[@]}"; do
			bash -c "add-apt-repository $rep $y";
			if [ $? -eq 0 ]; then
			    $SETCOLOR_SUCCESS
			    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
			    $SETCOLOR_NORMAL
			    echo
			else
			    $SETCOLOR_FAILURE
			    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"   
			    $SETCOLOR_NORMAL
			    echo
			fi
		done

		echo "Обновляем базу";
		bash -c "apt-get update";

		if [ $? -eq 0 ]; then
		    $SETCOLOR_SUCCESS
		    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
		    $SETCOLOR_NORMAL
		    echo
		else
		    $SETCOLOR_FAILURE
		    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
		    $SETCOLOR_NORMAL
		    echo
		fi
	fi

	if [[ "$argv" == *--install* || "$argv" == *-i* || "$argv" == *i* ]]; then

		echo "Устанавливаем все проги...";

		if [ "$lsb_distr" == "elementary" ]; then
			arProg+=( 
				elementary-tweaks
			);
		fi
		if [ "$lsb_distr" == "Ubuntu" ]; then
			arProg+=( 
				unity-tweak-tool
			);
		fi
		if [ "$lsb_distr" == "antiX" ]; then
			arProg+=( 
				gedit
				nautilus
			);
		fi

		bash -c "wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -"
		sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

		bash -c "cd /etc/xdg/autostart/";
		bash -c "sudo sed --in-place 's/NoDisplay=true/NoDisplay=false/g' *.desktop ";

		for value in "${arProg[@]}"; do

			bash -c "apt-get install $y $value";

			if [ $? -eq 0 ]; then
			    $SETCOLOR_SUCCESS
			    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
			    $SETCOLOR_NORMAL
			    echo
			else
			    $SETCOLOR_FAILURE
			    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
			    $SETCOLOR_NORMAL
			    echo
			fi

			if [ "`dpkg -s $value | grep Package`" != "Package: $value" ]; then
				arProgNotInstall+="$value ";		
			fi
		done

		if [ "${#arProgNotInstall[*]}" -ne "0" ]; then
			echo "

			!!! Пакеты, которые не установились: "${arProgNotInstall[@]};
		fi

		echo "Идет настройка системы..."

		#bash -c "tlp start"
		bash -c "gtk-redshift -l 56.315685:44.058699 -t 5500:3400 &"
		bash -c "update-pepperflashplugin-nonfree --install"
		bash -c "prelink -amfR"
		bash -c "preload"

		# Настройка сервера apache2
		bash -c "cp -r /media/ruut/MyDisk/Linux_sh/hosts /etc/hosts"
		bash -c "cp -r '/media/ruut/MyDisk/Linux_sh/apache2/apache2.conf' '/etc/apache2/apache2.conf'"
		bash -c "cp -r '/media/ruut/MyDisk/Linux_sh/apache2/interface.conf' '/etc/apache2/sites-available/interface.conf'"
		bash -c "cp -r '/media/ruut/MyDisk/Linux_sh/apache2/test.conf' '/etc/apache2/sites-available/test.conf'"
		bash -c "a2ensite interface test"
		bash -c "chmod 777 /media/ruut"
		bash -c "chmod 777 /media/ruut/MyDisk"
		bash -c "chmod 777 /media/ruut/MyDisk/Soft"
		bash -c "chmod 777 /media/ruut/MyDisk/Soft/Programming"
		bash -c "chmod 777 -R /media/ruut/MyDisk/Soft/Programming/site"
		bash -c "a2ensite interface test"

		# Добавление лакали
		bash -c "cp -r '/media/ruut/MyDisk/Linux_sh/ru' '/var/lib/locales/supported.d/ru'"
		bash -c "locale-gen"

		# копирование настроек
		#bash -c "cp -Ra '/media/ruut/MyDisk/Linux_sh/.config' '/home/ruut/.config'"
		#bash -c "cron"
		#bash -c "crontab '/media/ruut/MyDisk/Linux_sh/cron_cpfilessh'"

		if [ "$lsb_distr" == "antiX" ]; then
			bash -c "alsaconf"
		fi
		
	fi

	if [[ "$argv" == *--dpkg* || "$argv" == *-d* || "$argv" == *d* ]]; then
		echo "Ставим локальные пакеты...";

		# Установка пакетов с диска
		dpkg -i '/media/ruut/MyDisk/Soft/Other/python-support_1.0.14ubuntu2_all.deb'
		dpkg -i '/media/ruut/MyDisk/Soft/Other/screenlets_0.1.6-0ubuntu3_all.deb' '/media/ruut/MyDisk/Soft/Other/screenlets-pack-all_0.1.6-0ubuntu1_all.deb'
		dpkg -i '/media/ruut/MyDisk/Soft/Other/screenlets-pack-all_0.1.6-0ubuntu1_all.deb'
		dpkg -i '/media/ruut/MyDisk/Soft/Internet/yandex-disk_latest_amd64.deb'
		dpkg -i '/media/ruut/MyDisk/Soft/Internet/megasync-xUbuntu_16.04_amd64.deb'
		dpkg -i '/media/ruut/MyDisk/Soft/Internet/nautilus-megasync-xUbuntu_16.04_amd64.deb'
		#dpkg -i '/media/ruut/MyDisk/Soft/Office/chmsee_1.3.1.1-1-getdeb3-vivid_amd64.deb'
		dpkg -i '/media/ruut/MyDisk/GameZ/steam_latest.deb'

		if [ $? -eq 0 ]; then
		    $SETCOLOR_SUCCESS
		    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
		    $SETCOLOR_NORMAL
		    echo
		else
		    $SETCOLOR_FAILURE
		    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
		    $SETCOLOR_NORMAL
		    echo
		fi
	fi

	if [[ "$argv" == *warsow* || "$argv" == *-w* || "$argv" == *w*  ]]; then
		echo "Cтавим варсу)))";

		# Установка WarSow
		apt-get install libsdl2-2.0-0
		mkdir '/usr/local/games/warsow'
		tar -xvf '/media/ruut/MyDisk/GameZ/warsow_21_unified.tar.gz' -C '/usr/local/games/warsow'
		cp -r '/media/ruut/MyDisk/Linux_sh/warsow' '/usr/local/games/warsow/warsow'

		for TARGET in warsow wsw_server wswtv_server; do 
			sudo ln -s /usr/local/games/warsow/$TARGET /usr/local/bin/$TARGET; 
		done

		chown -R root:root '/usr/local/bin/' '/usr/local/games/warsow/'
		chmod -R 0755 '/usr/local/bin/' '/usr/local/games/warsow/'
		mkdir '/home/ruut/.local/share/warsow-2.1'
		mkdir '/home/ruut/.local/share/warsow-2.1/basewsw'
		chown ruut '/home/ruut/.local/share/warsow-2.1'
		chown ruut '/home/ruut/.local/share/warsow-2.1/basewsw'
		cp -r '/media/ruut/MyDisk/Linux_sh/config.cfg' '/home/ruut/.local/share/warsow-2.1/basewsw/config.cfg'
		chown ruut -R '/home/ruut/.local/share/warsow-2.1'
	fi

	if [[ "$argv" == *--upgrade* || "$argv" == *-u* || "$argv" == *u* ]]; then
		bash -c "apt-get dist-upgrade";
	fi
else
	echo "
Скрипт для автоматической установки программ.

Использование: install.sh [riuyw] [-r -i -u -y -w] [--repository --install --upgrade --warsow]
	-r --repository 	добавить репозитории, указанные в скрипте.
	-i --install 		установить программы и утилиты, указанные в скрипте.
	-u --upgrade 		выполнить apt-get dist-upgrade. Выпоняется в самом конце скрипта.
	-y 			по умолчанию отвечать 'Да'
	-w --warsow 		установить игруху warsow";
	exit 0;
fi

