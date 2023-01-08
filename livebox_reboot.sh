LIVEBOX_IP="192.168.1.1"
USERNAME="admin"
PASSWORD="ENTER_YOUR_PASSWORD" # To be replaced
COOKIE_SAVE_PATH="/tmp/"


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

LOGIN_RESPONSE=`curl 'http://'"${LIVEBOX_IP}"'/ws' -s -X POST -H 'User-Agent: \
Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:96.0) Gecko/20100101 Firefox/96.0' \
-H 'Accept: */*' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H \
'Accept-Encoding: gzip, deflate' -H 'Authorization: X-Sah-Login' -H 'Content-T\
ype: application/x-sah-ws-4-call+json' -H 'Origin: http://'"${LIVEBOX_IP}" -H 'DNT\
: 1' -H 'Connection: keep-alive' -H 'Referer: http://'"${LIVEBOX_IP}"'/' -H 'C\
ookie: 3e673c0f/accept-language=fr,fr-FR; UILang=fr' --data-raw '{"service":"sa\
h.Device.Information","method":"createContext","parameters":{"applicationName":\
"webui","username":"'"${USERNAME}"'","password":"'"${PASSWORD}"'"}}' -c "${COOK\
IE_SAVE_PATH}"'.cookie_livebox'`

regex_pattern='contextID\"\:\"([^\"]+)'

[[ $LOGIN_RESPONSE =~ $regex_pattern ]]

CONTEXT_ID=${BASH_REMATCH[1]}

REBOOT_RESPONSE=`curl 'http://'"${LIVEBOX_IP}"'/ws' -s -X POST -H 'User-Agent: \
Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:96.0) Gecko/20100101 Firefox/96.0' -\
H 'Accept: */*' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H 'A\
ccept-Encoding: gzip, deflate' -H 'Content-Type: application/x-sah-ws-4-call+js\
on' -H 'Authorization: X-Sah '"${CONTEXT_ID}"'' -H 'X-Context: '"${CONTEXT_ID}"\
'' -H 'Origin: http://'"${LIVEBOX_IP}" -H 'DNT: 1' -H 'Connection: keep-alive' -H '\
Referer: http://'"${LIVEBOX_IP}"'/' -b "${COOKIE_SAVE_PATH}"'.cookie_livebox' -\
-data-raw '{"service":"NMC","method":"reboot","parameters":{"reason":"GUI_Reboo\
t"}}'`

if [[ $REBOOT_RESPONSE == *"true"* ]]; then
    echo "Rebooting..."
else
    echo " !!! Reboot failed !!!"
fi

rm "${COOKIE_SAVE_PATH}"'.cookie_livebox'
