#!/usr/bin/python
# -*- coding: utf-8 -*-
from email.mime.text import MIMEText
from email.header import Header
from smtplib import SMTP_SSL
import sys
sent_smtp = 'smtp.163.com'
sent_user = 'sdayfic'
pwd = ''
sent_mail = 'sdayfic@163.com'
rece_mail =sys.argv[1]
mail_title = sys.argv[2]
mail_content = sys.argv[3]
smtp = SMTP_SSL(sent_smtp)
smtp.set_debuglevel(0)
smtp.ehlo(sent_smtp)
smtp.login(sent_user , pwd)
msg = MIMEText(mail_content , "plain" , 'utf-8')
msg ["Subject"] = Header(mail_title , 'utf-8')
msg ["From"] = sent_mail
msg ["To"] = rece_mail
smtp.sendmail(sent_mail , rece_mail , msg.as_string())
smtp.quit()
