#!/bin/sh

expday=`date -d"yesterday" "+%Y%m%d"`

export LC_ALL='en_US.UTF-8'

attachement="/tmp/_verification_${expday}.csv"
result_html="/tmp/_verification_${expday}.html"

sudo -u postgres psql -d xxxx_db -q -f '/tmp/_verify.sql'>$result_html
cat /tmp/tmp_01.csv > $attachement
echo "" >> $attachement
cat /tmp/tmp_02.csv >> $attachement
echo "" >> $attachement
cat /tmp/tmp_03.csv >> $attachement


# -- user params ---
MAILFROM="noreply@wolaidai.com"
MAILTO="test@test.com;test1@test1.com"
SUBJECT="易联验密日报[${expday}]"
BODY_FILE="${result_html}"
ATT_FILE="${attachement}"
ATT_AS_FILE="`basename ${attachement}`"

# --- generated values ---
BOUNDARY="unique-boundary-$RANDOM"
BODY_MIMETYPE=$(file -ib $BODY_FILE | cut -d";" -f1)   # detect mime type
ATT_MIMETYPE=$(file -ib $ATT_FILE | cut -d";" -f1)     # detect mime type
ATT_ENCODED=$(base64 < $ATT_FILE)  # encode attachment

# --- generate MIME message and pipe to sendmail ---
cat <<EOF | /usr/sbin/sendmail "$MAILTO"
MIME-Version: 1.0
From: $MAILFROM
To: $MAILTO
Subject: $SUBJECT
Content-Type: multipart/mixed; boundary="$BOUNDARY"

--$BOUNDARY
Content-Type: $BODY_MIMETYPE
Content-Disposition: inline

$(cat $BODY_FILE)
--$BOUNDARY
Content-Type: $ATT_MIMETYPE; name="$ATT_AS_FILE"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="$ATT_AS_FILE"

$ATT_ENCODED
--$BOUNDARY
EOF
