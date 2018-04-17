#!/usr/bin/env python

from twilio.rest import client

account_sid = "AC183aead33eee0218a5be86c2a0d4f3a7"
auth_token = "99f0fe55c30d81240f12683e764ef35b"
from_number = "+16477928621"
to_number = "4166253512"

client = Client(account_sid, auth_token)

message = client.messages.create(
   to="to_number",
   from="from_number",
   body="Hello from oss")

print(message.sid)
   
