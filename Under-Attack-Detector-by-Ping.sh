#!/bin/bash

read_input () {
  echo "$@" | awk -v varnum="$1" '{split($0, READIN, " "); print READIN[varnum+1]}';
}

telegram_push () {
  if [[ $@ == "2" ]]; then
    PUSHTEXT=$ANSATTACKMSG; TEXTPAM=$ANSATTACKMSGPAM
  else
    PUSHTEXT=$ANSNORMALMSG; TEXTPAM=$ANSNORMALMSGPAM
  fi
  
  curl -s -o /dev/null -X POST https://api.telegram.org/bot$ANSTGBOT/sendMessage -d chat_id=$ANSTGCHAT -d text="$PUSHTEXT" $TEXTPAM $TGNOTIFICATION
}

check_number_only () {
  if [[ $(echo $2 | grep '[^0-9.]') != "" || $2 == "" ]]; then
    echo "Argument $1 should only contain numbers. "
    exit 1;
  fi
}

check_ip () {
  if [[ $(echo $@ | grep '[^0-9|\..]') != "" || $(echo $@ | awk '{ split($0, SECT, "."); for (i = 1; i <= 4; i++) { if (SECT[i] > 255 || SECT[i] < 0 || SECT[i] == "") { print "1"; break; } } }') == "1" || $@ == "" ]]; then
    echo "Argument -pingdest should be a valid IP. "
    exit 1;
  fi
}

replace_var () {
  if [[ $@ == "2" ]]; then
    TEMPTEXT=$ANSATTACKMSG
    TEMPTEXTPAM=$ANSATTACKMSGPAM
  else
    TEMPTEXT=$ANSNORMALMSG
    TEMPTEXTPAM=$ANSNORMALMSGPAM
  fi

  if [[ TEMPTEXTPAM == "-d parse_mode=MarkdownV2" ]]; then 
    TEMPPINGMAX=$(echo $ANSPINGMAX | sed 's/\./\\\./g')
    TEMPPINGAVG=$(echo $ANSPINGAVG | sed 's/\./\\\./g')
    TEMPPINGMIN=$(echo $ANSPINGMIN | sed 's/\./\\\./g')
    TEMPPINGJIT=$(echo $ANSPINGJIT | sed 's/\./\\\./g')
    TEMPPINGLOSS=$(echo $ANSPINGLOSS | sed 's/\./\\\./g')
  else
    TEMPPINGMAX=$ANSPINGMAX
    TEMPPINGAVG=$ANSPINGAVG
    TEMPPINGMIN=$ANSPINGMIN
    TEMPPINGJIT=$ANSPINGJIT
    TEMPPINGLOSS=$ANSPINGLOSS
  fi
  
  TEMPTEXT=$(echo $TEMPTEXT | sed 's/\\n/%0A/g')
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGMAX/$TEMPPINGMAX/g")
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGLOSS/$TEMPPINGLOSS/g")
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGJIT/$TEMPPINGJIT/g")
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGMIN/$TEMPPINGMIN/g")
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGAVG/$TEMPPINGAVG/g")

  echo $TEMPTEXT
}

INNUM="1"
ANSPINGDEST="1.1.1.1"
ANSPINGCNT="4"
ANSPINGMAXTHSD="100"
ANSPINGLOSSTHSD="0"
ANSPINGJITTHSD="30"
ANSPINGAVGTHSD="50"
ANSPINGMINTHSD="20"
ANSTGBOT=""
ANSTGCHAT=""
ANSATTACKMSG="Your server is under attack."
ANSNORMALMSG="The attck to your server stops."
ANSATTACKMSGPAM=""
ANSNORMALMSGPAM=""
ANSID=""
TGNOTIFICATION=""

while [[ $(read_input $INNUM $@) != "" ]]
do

  if [[ $(echo $(read_input $INNUM $@) | cut -b 1) != "-" ]]; then
    echo "Incomplete argument. "
    exit 1;
  fi
  
  case $(read_input $INNUM $@) in

    "-pingdest")
      ANSPINGDEST=$(read_input $((INNUM+1)) $@)
      check_ip $ANSPINGDEST
      ;;

    "-pingcnt")
      ANSPINGCNT=$(read_input $((INNUM+1)) $@)
      check_number_only "-pingcnt" $ANSPINGCNT
      ;;

    "-pingmax")
      ANSPINGMAXTHSD=$(read_input $((INNUM+1)) $@)
      check_number_only "-pingmax" $ANSPINGMAXTHSD
      ;;

    "-pingloss")
      ANSPINGLOSSTHSD=$(read_input $((INNUM+1)) $@)
      check_number_only "-pingloss" $ANSPINGLOSSTHSD
      ;;

    "-pingjit")
      ANSPINGJITTHSD=$(read_input $((INNUM+1)) $@)
      check_number_only "-pingjit" $ANSPINGJITTHSD
      ;;

    "-pingavg")
      ANSPINGAVGTHSD=$(read_input $((INNUM+1)) $@)
      check_number_only "-pingavg" $ANSPINGAVGTHSD
      ;;

    "-pingmin")
      ANSPINGMINTHSD=$(read_input $((INNUM+1)) $@)
      check_number_only "-pingmin" $ANSPINGMINTHSD
      ;;

    "-tgbot")
      ANSTGBOT=$(read_input $((INNUM+1)) $@)
      ;;

    "-tgchat")
      ANSTGCHAT=$(read_input $((INNUM+1)) $@)
      ;;

    "-id")
      ANSID=".$(read_input $((INNUM+1)) $@)"
      ;;

    "-tg-no-notification")
      TGNOTIFICATION='-d disable_notification=true'
      INNUM=$((INNUM-1))
      ;;

    "-attackmsg" | "-normalmsg" | "-attackmsg-md" | "-normalmsg-md" | "-attackmsg-html" | "-normalmsg-html")
      INNUM2=2
      TEMPMSG=$(read_input $((INNUM+1)) $@)

      while [[ $(echo $(read_input $((INNUM+INNUM2)) ${*@Q}) | head -c 2) != "'-" && $(echo $(read_input $((INNUM+INNUM2)) $@)) != "" ]]
      do
        TEMPMSG="$TEMPMSG $(read_input $((INNUM+INNUM2)) $@)"
        INNUM2=$((INNUM2+1))
      done

      case $(echo $(read_input $INNUM $@) | head -c 10) in
      "-attackmsg")
        ANSATTACKMSG=$TEMPMSG
        case $(echo $(read_input $INNUM $@) | awk '{ split($0, ARG, "-"); print ARG[3]; }') in
          "md") ANSATTACKMSGPAM="-d parse_mode=MarkdownV2" ;;
          "html") ANSATTACKMSGPAM="-d parse_mode=HTML" ;;
        esac
        ;;
      "-normalmsg")
        ANSNORMALMSG=$TEMPMSG
        case $(echo $(read_input $INNUM $@) | awk '{ split($0, ARG, "-"); print ARG[3]; }') in
          "md") ANSNORMALMSGPAM="-d parse_mode=MarkdownV2" ;;
          "html") ANSNORMALMSGPAM="-d parse_mode=HTML" ;;
        esac
        ;;
      esac
      
      INNUM=$((INNUM+INNUM2-2))
      ;;

    esac

    INNUM=$((INNUM+2))
    
done

if [[ $ANSTGBOT == "" || $ANSTGCHAT == "" ]]; then
  echo 'Argument -tgbot or -tgchat not specified. '
  exit 1;
fi

ANSPING=$(ping $ANSPINGDEST -c $ANSPINGCNT -q)
ANSPINGMIN=$(echo $ANSPING | awk '{split($26, PINGNUM, "/"); print PINGNUM[1]}')
ANSPINGAVG=$(echo $ANSPING | awk '{split($26, PINGNUM, "/"); print PINGNUM[2]}')
ANSPINGMAX=$(echo $ANSPING | awk '{split($26, PINGNUM, "/"); print PINGNUM[3]}')
ANSPINGJIT=$(echo $ANSPING | awk '{split($26, PINGNUM, "/"); print PINGNUM[4]}')
ANSPINGLOSS=$(echo $ANSPING | awk '{split($18, LOSSNUM, "%"); print LOSSNUM[1]}')

ANSATTACKMSG=$(replace_var 2)
ANSNORMALMSG=$(replace_var 1)

if [[ $(ls ~/.Under-Attack-Detector-by-Ping.sh) == "" ]]; then
  mkdir ~/.Under-Attack-Detector-by-Ping.sh
fi
  
if [[ $(echo "" | awk -v varpingmax="$ANSPINGMAX" -v varpingmaxthsd="$ANSPINGMAXTHSD" -v varpingloss="$ANSPINGLOSS" -v varpinglossthsd="$ANSPINGLOSSTHSD" -v varpingjit="$ANSPINGJIT" -v varpingjitthsd="$ANSPINGJITTHSD" -v varpingavg="$ANSPINGAVG" -v varpingavgthsd="$ANSPINGAVGTHSD" -v varpingmin="$ANSPINGMIN" -v varpingminthsd="$ANSPINGMINTHSD" '{ if (varpingmax <= varpingmaxthsd && varpingloss <= varpinglossthsd && varpingjit <= varpingjitthsd && varpingavg <= varpingavgthsd && varpingmin <= varpingminthsd) print "1"; else print "0" }') == 1 ]]; then
  if [[ $(cat ~/.Under-Attack-Detector-by-Ping.sh/Under-Attack-Detector-by-Ping.sh${ANSID}.status) == 2 ]]; then
    telegram_push 1
  fi
  echo "1" > ~/.Under-Attack-Detector-by-Ping.sh/Under-Attack-Detector-by-Ping.sh${ANSID}.status
else
  if [[ $(cat ~/.Under-Attack-Detector-by-Ping.sh/Under-Attack-Detector-by-Ping.sh${ANSID}.status) == 1 || $(ls ~/.Under-Attack-Detector-by-Ping.sh | grep "Under-Attack-Detector-by-Ping.sh${ANSID}.status") == "" ]]; then
    telegram_push 2
  fi
  echo "2" > ~/.Under-Attack-Detector-by-Ping.sh/Under-Attack-Detector-by-Ping.sh${ANSID}.status
fi
