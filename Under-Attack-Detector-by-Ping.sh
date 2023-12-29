read_input () {
  echo "$@" | awk -v varnum="$1" '{split($0, READIN, " "); print READIN[varnum+1]}';
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

while [$(read_input "$INNUM") != ""]
do
  case $(read_input "$INNUM") in

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

    "-attackmsg")
      ANSATTACKMSG=$(read_input $((INNUM+1)) $@)
      ;;

    "-normalmsg")
      ANSNORMALMSG=$(read_input $((INNUM+1)) $@)
      ;;

    esac

    INNUM=$((INNUM+2))
    
done

if [[ $ANSTGBOT == "" || $ANSTGCHAT == "" ]]; then
  echo 'Argument -tgbot or -tgchat not specified. '
  # exit 1;
fi

ANSPING=$(ping -c 4 $ANSPINGDEST -q)
ANSPINGMAX=$(echo $ANSPING | awk '{split($26, PINGNUM, "/"); print PINGNUM[3]}')
ANSPINGLOSS=$(echo $ANSPING | awk '{split($18, LOSSNUM, "%"); print LOSSNUM[1]}')

if [[ $ANSPINGMAX > $ANSPINGMAXTHSD && $ANSPINGLOSS > $ANSPINGLOSSTHSD ]]; then
  echo "Under Attack"
else
  echo "Not under attack"
fi
