#!/bin/bash

read_input () {
  echo "$@" | awk -v varnum="$1" '{split($0, READIN, " "); print READIN[varnum+1]}';
}

telegram_push () {
  if [[ $@ == 2 ]]; then
    PUSHTEXT=$ANSATTACKMSG; TEXTPAM=$ANSATTACKMSGPAM
  else
    PUSHTEXT=$ANSNORMALMSG; TEXTPAM=$ANSNORMALMSGPAM
  fi
  
  curl -s -o /dev/null -X POST https://api.telegram.org/bot$ANSTGBOT/sendMessage -d chat_id=$ANSTGCHAT -d text="$PUSHTEXT" $TEXTPAM
}

replace_var () {
  TEMPTEXT="$@"
  
  TEMPTEXT=$(echo $TEMPTEXT | sed 's/\\n/%0A/g')
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGMAX/$ANSPINGMAX/g")
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGLOSS/$ANSPINGLOSS/g")
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGJIT/$ANSPINGJIT/g")
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGMIN/$ANSPINGMIN/g")
  TEMPTEXT=$(echo $TEMPTEXT | sed "s/\\\VARPINGAVG/$ANSPINGAVG/g")

  echo $TEMPTEXT
}

INNUM="1"
ANSPINGDEST="1.1.1.1"
ANSPINGCNT="4"
ANSPINGMAXTHSD="100"
ANSPINGLOSSTHSD="0"
ANSPINGJITTHSD="10"
ANSTGBOT=""
ANSTGCHAT=""
ANSATTACKMSG="Your server is under attack."
ANSNORMALMSG="The attck to your server stops."
ANSATTACKMSGPAM=""
ANSNORMALMSGPAM=""
ANSID=""

while [[ $(read_input $INNUM $@) != "" ]]
do

  if [[ $(echo $(read_input $INNUM $@) | cut -b 1) != "-" || $(read_input $((INNUM+1)) $@) == "" ]]; then
    echo "Incomplete argument. "
    exit 1;
  fi
  
  case $(read_input $INNUM $@) in

    "-pingdest")
      ANSPINGDEST=$(read_input $((INNUM+1)) $@)
      ;;

    "-pingcnt")
      ANSPINGCNT=$(read_input $((INNUM+1)) $@)
      ;;

    "-pingmax")
      ANSPINGMAXTHSD=$(read_input $((INNUM+1)) $@)
      ;;

    "-pingloss")
      ANSPINGLOSSTHSD=$(read_input $((INNUM+1)) $@)
      ;;

    "-pingjit")
      ANSPINGJITTHSD=$(read_input $((INNUM+1)) $@)
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

ANSATTACKMSG=$(replace_var $ANSATTACKMSG)
ANSNORMALMSG=$(replace_var $ANSNORMALMSG)

if [[ $(ls ~/.Under-Attack-Detector-by-Ping.sh) == "" ]]; then
  mkdir ~/.Under-Attack-Detector-by-Ping.sh
fi
  
if [[ $(echo "" | awk -v varpingmax="$ANSPINGMAX" -v varpingmaxthsd="$ANSPINGMAXTHSD" -v varpingloss="$ANSPINGLOSS" -v varpinglossthsd="$ANSPINGLOSSTHSD" -v varpingjit="$ANSPINGJIT" -v varpingjitthsd="$ANSPINGJITTHSD" '{ if (varpingmax <= varpingmaxthsd && varpingloss <= varpinglossthsd && varpingjit <= varpingjitthsd) print "1"; else print "0" }') == 1 ]]; then
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
