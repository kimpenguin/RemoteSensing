# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# merge.py
# Created on: 2013-11-19 16:33:46.00000 by Kimberly Peng
# Description: Used to merge all the ftp site log files into one comprehensive
# file.
# ---------------------------------------------------------------------------

# Import necessary modules
import os
import sys
import fileinput
import re

#merges all the log files within the specified directory
dirLoc="/Users/kpeng/Desktop/ftplogs/logfiles"
files=os.listdir(dirLoc)
for f in files:
    if f.startswith("vsftpd"):
        data=open("/Users/kpeng/Desktop/ftplogs//logfiles//"+f,"r")
        #out=open("all_logs.txt", 'a')
        out=open("/Users/kpeng/Desktop/ftplogs/all_logs.txt", 'a')
        for line in data:
            out.write(line)
        data.close()
        out.close()

#replace the blank space with comma to create a csv file
with open("/Users/kpeng/Desktop/ftplogs/all_logs.csv", "wt") as fout:
    with open("/Users/kpeng/Desktop/ftplogs/all_logs.txt", "rt") as fin:
        for line in fin:
            #fout.write(line.replace(' ', ',')) #replace white space with comma
            #replaces any white space or consecutive white space with comma
            fout.write(re.sub(' +',',',line))



            
