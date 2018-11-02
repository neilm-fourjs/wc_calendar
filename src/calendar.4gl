IMPORT util
IMPORT FGL fglcalendar

PUBLIC DEFINE rec record
  curr_month smallint,
  curr_year  smallint,
  calendar string
END RECORD

PUBLIC TYPE cb_set_date FUNCTION(l_dte DATE)

PRIVATE DEFINE cb_sdate cb_set_date
PRIVATE DEFINE curdate DATE, cid INTEGER

PUBLIC DEFINE selected_date DATE
PUBLIC DEFINE dag_textar DICTIONARY OF STRING

--------------------------------------------------------------------------------
#+ Callback function for returning the selected date
#+
#+ @code
#+ CALL return_date (function my_getdate) 
#+
#+ @param l_date The start date
#+ @param l_setDateCallBack Function for the callback
FUNCTION init(l_date DATE, l_setDateCallBack cb_set_date) -- Start

  IF l_date IS NULL THEN LET l_date = TODAY END IF

  LET cb_sdate = l_setDateCallBack
  CALL fglcalendar.initialize()
  LET cid = fglcalendar.create("formonly.calendar")
  CALL set_type(cid, FGLCALENDAR_TYPE_DEFAULT)
  CALL fglcalendar.setColorTheme(cid, FGLCALENDAR_THEME_DEFAULT)
  CALL fglcalendar.showDayNames(cid, true)
  CALL fglcalendar.showDayNumbers(cid, true)
  CALL fglcalendar.showweekNumbers(cid, false)
  LET rec.curr_year = YEAR(l_date)
  LET rec.curr_month = MONTH(l_date)
  LET selected_date = l_date
  LET curdate = l_date
  CALL ui.Interface.Refresh()
  CALL fglcalendar.addSelectedDate(cid, l_date)
  CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)

END FUNCTION
--------------------------------------------------------------------------------
#+ The calendar subdialog input.
DIALOG calendar()

	INPUT BY NAME rec.* ATTRIBUTES(WITHOUT DEFAULTS)
		ON CHANGE curr_year 
			CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)

		ON CHANGE curr_month
			IF rec.curr_month < 1 THEN
				LET rec.curr_year = rec.curr_year - 1
				LET rec.curr_month = 12
			END IF
			if rec.curr_month > 12 THEN
				LET rec.curr_year = rec.curr_year + 1
				LET rec.curr_month = 1
			END IF
			CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)
		--	CALL DIALOG.nextField("xxx")

		ON ACTION prevmonth
			DISPLAY "PrevMonth"
			IF rec.curr_month = 1 THEN
				LET rec.curr_year = rec.curr_year-1
				LET rec.curr_month = 12
			ELSE
				LET rec.curr_month = rec.curr_month - 1
			END IF
			CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)

		ON ACTION nextmonth
			DISPLAY "NextMonth"
			IF rec.curr_month = 12 THEN
				LET rec.curr_year = rec.curr_year+1
				LET rec.curr_month = 1
			ELSE
				LET rec.curr_month = rec.curr_month + 1
			END IF
			CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)

		ON ACTION calendar_selection
			LET selected_date = fglcalendar.getSelectedDateFromValue(cid, rec.calendar)
			DISPLAY "SELECTED_DATE=",selected_date
			IF selected_date != curdate THEN
				CALL fglcalendar.removeSelectedDate(cid, curdate)
				LET rec.curr_month = MONTH(selected_date)
				LET rec.curr_year = YEAR(selected_date)
				CALL fglcalendar.addSelectedDate(cid, selected_date)
				LET curdate = selected_date
				CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)
				IF cb_sdate IS NOT NULL THEN CALL cb_sdate(curdate) END IF
			END IF
	END INPUT

END DIALOG
--------------------------------------------------------------------------------
FUNCTION setTexts(dic dictionary of string)
  CALL fglcalendar.setText(dic)
END FUNCTION  
--------------------------------------------------------------------------------
FUNCTION finish()
	CALL fglcalendar.destroy(cid)
	CALL fglcalendar.finalize()
END FUNCTION  
--------------------------------------------------------------------------------
PRIVATE FUNCTION set_type(c_id SMALLINT, type SMALLINT)
	CALL fglcalendar.setViewType(c_id, type)
{	IF  type = FGLCALENDAR_TYPE_DEFAULT THEN
		CALL fglcalendar.setDayNames(cid, "Mán|Þri|Mið|Fim|Fös|Lau|Sun")
	ELSE
		CALL fglcalendar.setDayNames(cid, "M|Þ|M|F|F|L|S")
	END IF}
END FUNCTION