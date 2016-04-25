import smtplib
from datetime import datetime
import asyncore
from smtpd import SMTPServer

class EmlServer(SMTPServer):
    no = 0
    def process_message(self, peer, mailfrom, rcpttos, data):
        gmail_user = 'followthetask@gmail.com'  
        gmail_password = 'follow_pass'

        data = data.replace('\\n', '\n')

        print 'Sending email...'
        try:  
            server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
            server.ehlo()
            server.login(gmail_user, gmail_password)
            server.sendmail(mailfrom, rcpttos, data)
            server.quit()
            print 'Email sent...'
        except:
            print 'Something went wrong...'


def run():
    foo = EmlServer(('localhost', 25), None)
    try:
        asyncore.loop()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    run()