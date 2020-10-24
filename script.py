#!/usr/bin/python3

print("content-type: text/html");
print();

import subprocess as sp
import cgi


mydata = cgi.FieldStorage()
var = mydata.getvalue('x')

nvar = str(var).replace("_"," ")

data = sp.getstatusoutput("sudo " + nvar)

scode = data[0]
body = data[1]

l = {"status": scode, "output": body}

import json

returnval = json.dumps(l)
print(returnval)