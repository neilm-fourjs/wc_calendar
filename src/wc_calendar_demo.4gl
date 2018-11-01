IMPORT util

IMPORT FGL fglcalendar
IMPORT FGL is_dagatal
IMPORT FGL calendar
IMPORT FGL lib

DEFINE m_selected_date DATE

MAIN
	DEFINE l_debug STRING

	OPEN FORM f1 FROM "wc_calendar_demo"
	DISPLAY FORM f1

	CALL ui.Interface.frontCall("standard","getenv",["QTWEBENGINE_REMOTE_DEBUGGING"],l_debug)
	DISPLAY "DEBUG:",l_debug

	CALL lib.add_presentation_styles()

	LET m_selected_date = TODAY
	CALL calendar.return_date(FUNCTION set_date)
	CALL calendar.hefja( m_selected_date ) -- Start
	DIALOG ATTRIBUTES(UNBUFFERED)

		INPUT BY NAME m_selected_date ATTRIBUTES(WITHOUT DEFAULTS)
		END INPUT

		SUBDIALOG calendar.calendar

		ON ACTION cancel EXIT DIALOG
		ON ACTION close EXIT DIALOG
	END DIALOG 
	CALL calendar.ljuka() -- Complete

END MAIN
--------------------------------------------------------------------------------
FUNCTION set_date(l_dte DATE)
  LET m_selected_date = l_dte
END FUNCTION