IMPORT util
IMPORT FGL fglcalendar
IMPORT FGL is_dagatal

PUBLIC DEFINE rec record
  curr_month smallint,
  curr_year  smallint,
  calendar string
END RECORD

PUBLIC TYPE cb_set_date FUNCTION(l_dte DATE)

private define cb_sdate cb_set_date

public define selected_date date
public define dag_textar dictionary of string

private define curdate date, cid int

#
#! return date
#+ Callback function for returning the selected date
#+
#+ @code
#+ CALL return_date (function my_getdate) 
#

FUNCTION return_date(f cb_set_date)
  LET cb_sdate = f
END FUNCTION  
--------------------------------------------------------------------------------
FUNCTION setTexts(dic dictionary of string)
  CALL fglcalendar.setText(dic)
END FUNCTION  
--------------------------------------------------------------------------------
FUNCTION init(l_date DATE) -- Start

  IF l_date IS NULL THEN LET l_date = TODAY END IF

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
DIALOG calendar()

	INPUT BY NAME rec.* ATTRIBUTES(WITHOUT DEFAULTS)
		ON CHANGE curr_year 
			CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)

		ON CHANGE curr_month
			if rec.curr_month == 0 then
				LET rec.curr_year = rec.curr_year-1
				LET rec.curr_month = 12
			end if
			if rec.curr_month == 13 then
				LET rec.curr_year = rec.curr_year+1
				LET rec.curr_month = 1
			end if
			CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)
		--	CALL DIALOG.nextField("xxx")

		ON ACTION prevmonth
			DISPLAY "PrevMonth"
			if rec.curr_month == 1 then
				LET rec.curr_year = rec.curr_year-1
				LET rec.curr_month = 12
			else
				LET rec.curr_month = rec.curr_month - 1
			end if
			CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)

		ON ACTION nextmonth
			DISPLAY "NextMonth"
			if rec.curr_month == 12 then
				LET rec.curr_year = rec.curr_year+1
				LET rec.curr_month = 1
			else
				LET rec.curr_month = rec.curr_month + 1
			end if
			CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)

		ON ACTION calendar_selection
			LET selected_date = fglcalendar.getSelectedDateFromValue(cid, rec.calendar)
			DISPLAY "SELECTED_DATE=",selected_date
			if selected_date != curdate then
				CALL fglcalendar.removeSelectedDate(cid, curdate)
				LET rec.curr_month = month(selected_date)
				LET rec.curr_year = year(selected_date)
				CALL fglcalendar.addSelectedDate(cid, selected_date)
				LET curdate = selected_date
				CALL fglcalendar.display(cid, rec.curr_year, rec.curr_month)
				if cb_sdate is not null then
					CALL cb_sdate(curdate)
				end if
			end if
	END INPUT

END DIALOG
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
