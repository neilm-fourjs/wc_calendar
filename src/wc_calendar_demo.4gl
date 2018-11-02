
IMPORT FGL calendar
DEFINE m_selected_date DATE
MAIN
	DEFINE l_debug STRING

	OPEN FORM f1 FROM "wc_calendar_demo"
	DISPLAY FORM f1

-- Is the WC debug feature enabled?
	CALL ui.Interface.frontCall("standard","getenv",["QTWEBENGINE_REMOTE_DEBUGGING"],l_debug)
	DISPLAY "DEBUG:",l_debug

	LET m_selected_date = TODAY
	CALL calendar.init( m_selected_date, FUNCTION set_date ) -- Start
	DIALOG ATTRIBUTES(UNBUFFERED)

		INPUT BY NAME m_selected_date ATTRIBUTES(WITHOUT DEFAULTS)
		END INPUT

		SUBDIALOG calendar.calendar

		ON ACTION cancel EXIT DIALOG
		ON ACTION close EXIT DIALOG
	END DIALOG 
	CALL calendar.finish() -- Complete
END MAIN
--------------------------------------------------------------------------------
FUNCTION set_date(l_dte DATE) -- Call back function for getting selected date.
  LET m_selected_date = l_dte
END FUNCTION