read_input () {
  echo "$@" | awk -v varnum="$1" '{split($0, READIN, " "); print READIN[varnum+1]}';
}

telegram_push () {
  if [[ $@ == 2 ]]; then
    PUSHTEXT=$ANSATTACKMSG;
  else
    PUSHTEXT=$ANSNORMALMSG;
  fi
  
  curl -s -o /dev/null -X POST https://api.telegram.org/bot$ANSTGBOT/sendMessage -d chat_id=$ANSTGCHAT -d text="$PUSHTEXT" -d parse_mode=MarkdownV2
}

INNUM="1"
ANSPINGDEST="1.1.1.1"
ANSPINGCNT="4"
ANSPINGMAXTHSD="100"
ANSPINGLOSSTHSD="0"
ANSTGBOT=""
ANSTGCHAT=""
ANSATTACKMSG="Your server is under attack. "
ANSNORMALMSG="The attck to your server stops. "

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

    "-tgbot")
      ANSTGBOT=$(read_input $((INNUM+1)) $@)
      ;;

    "-tgchat")
      ANSTGCHAT=$(read_input $((INNUM+1)) $@)
      ;;

    "-attackmsg" | "-normalmsg")
      INNUM2=2
      TEMPMSG=$(read_input $((INNUM+1)) $@)

      while [[ $(echo $(read_input $((INNUM+INNUM2)) ${*@Q}) | head -c 2) != "'-" && $(echo $(read_input $((INNUM+INNUM2)) $@)) != "" ]]
      do
        TEMPMSG="$TEMPMSG $(read_input $((INNUM+INNUM2)) $@)"
        INNUM2=$((INNUM2+1))
      done
      
      if [[ $(read_input $INNUM $@) == "-attackmsg" ]]; then
        ANSATTACKMSG=$TEMPMSG
      else
        ANSNORMALMSG=$TEMPMSG
      fi
      
      INNUM=$((INNUM+INNUM2-2))
      ;;

    esac

    INNUM=$((INNUM+2))
    
done

ANSATTACKMSG=$(echo $ANSATTACKMSG | sed 's/[][\~`!@#$%^&*()=+{}|;:'"'"'",<>/?-]/\\&/g')
ANSNORMALMSG=$(echo $ANSNORMALMSG | sed 's/[][\~`!@#$%^&*()=+{}|;:'"'"'",<>/?-]/\\&/g')

if [[ $ANSTGBOT == "" || $ANSTGCHAT == "" ]]; then
  echo 'Argument -tgbot or -tgchat not specified. '
  exit 1;
fi

ANSPING=$(ping -c 4 $ANSPINGDEST -q)
ANSPINGMAX=$(echo $ANSPING | awk '{split($26, PINGNUM, "/"); print PINGNUM[3]}')
ANSPINGLOSS=$(echo $ANSPING | awk '{split($18, LOSSNUM, "%"); print LOSSNUM[1]}')

if [[ $(ls ~/.Under-Attack-Detector-by-Ping.sh) == "" ]]; then
  mkdir ~/.Under-Attack-Detector-by-Ping.sh
fi
  
if [[ $(echo "" | awk -v varpingmax="$ANSPINGMAX" -v varpingmaxthsd="$ANSPINGMAXTHSD" -v varpingloss="$ANSPINGLOSS" -v varpinglossthsd="$ANSPINGLOSSTHSD" '{ if (varpingmax <= varpingmaxthsd && varpingloss <= varpinglossthsd) print "1"; else print "0" }') == 1 ]]; then
  if [[ $(cat ~/.Under-Attack-Detector-by-Ping.sh/Under-Attack-Detector-by-Ping.sh.status) == 2 ]]; then
    telegram_push 1
  fi
  echo "1" > ~/.Under-Attack-Detector-by-Ping.sh/Under-Attack-Detector-by-Ping.sh.status
else
  if [[ $(cat ~/.Under-Attack-Detector-by-Ping.sh/Under-Attack-Detector-by-Ping.sh.status) == 1 || $(ls ~/.Under-Attack-Detector-by-Ping.sh | grep "Under-Attack-Detector-by-Ping.sh.status") == "" ]]; then
    telegram_push 2
  fi
  echo "2" > ~/.Under-Attack-Detector-by-Ping.sh/Under-Attack-Detector-by-Ping.sh.status
fi
