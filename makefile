
FGLRESOURCEPATH=../etc

all: bin/wc_calendar_demo.42r

bin/wc_calendar_demo.42r: src/wc_calendar_demo.4gl src/wc_calendar_demo.per src/wc_calendar.4gl src/wc_calendar_lib.4gl src/wc_calendar.per src/wc_fglsvgcalendar.4gl
	gsmake wc_calendar.4pw

run: bin/wc_calendar_demo.42r
	cd bin && fglrun wc_calendar_demo.42r

