#!/bin/bash

echo "Setup ssmtp"

CONF=/etc/ssmtp/ssmtp.conf
rm $CONF
SSMTP_ENABLED=false

for E in $(env)
do
  if [ "$(echo $E | sed -e '/^SSMTP_/!d' )" ]
  then
    echo $E | sed -e 's/^SSMTP_//' >> $CONF
    SSMTP_ENABLED=false
  fi
done

if [ $SSMTP_ENABLED ]; then
  echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini
fi 

exec "$@"
