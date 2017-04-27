all: ins2nt makedata objreq scrview sprconv sprconv2 truncate

ins2nt: ins2nt.c endian.c endian.h goattrk.h
	gcc ins2nt.c endian.c -o ins2nt

objreq: objreq.c
	gcc objreq.c -o objreq

scrview: scrview.c
	gcc scrview.c -o scrview

sprconv: sprconv.c endian.c endian.h
	gcc sprconv.c endian.c -o sprconv

sprconv2: sprconv2.c endian.c endian.h
	gcc sprconv2.c endian.c -o sprconv2

truncate: truncate.c
	gcc truncate.c -o truncate
