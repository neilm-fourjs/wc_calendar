
IMPORT FGL fglcalendar
IMPORT FGL is_dagatal

FUNCTION cmb_init_types(cmb)
	DEFINE cmb ui.ComboBox
	CALL cmb.addItem(FGLCALENDAR_TYPE_DEFAULT, "Default")
	CALL cmb.addItem(FGLCALENDAR_TYPE_TEXT,    "Text")
	CALL cmb.addItem(FGLCALENDAR_TYPE_ICON,    "Icon")
	CALL cmb.addItem(FGLCALENDAR_TYPE_DOTS,    "Dots")
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION cmb_init_themes(cmb)
	DEFINE cmb ui.ComboBox
	CALL cmb.addItem(FGLCALENDAR_THEME_DEFAULT, "Default")
	CALL cmb.addItem(FGLCALENDAR_THEME_SAHARA,  "Sahara")
	CALL cmb.addItem(FGLCALENDAR_THEME_PACIFIC, "Pacific")
	CALL cmb.addItem(FGLCALENDAR_THEME_AMAZON,  "Amazon")
	CALL cmb.addItem(FGLCALENDAR_THEME_VIOLA,   "Viola")
	CALL cmb.addItem(FGLCALENDAR_THEME_CHILI,   "Chili")
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION cmb_init_month(cmb)
	DEFINE cmb ui.ComboBox
	DEFINE m SMALLINT
	DISPLAY "cmb_init_month"
	CALL cmb.addItem(0, "<--")
	FOR m = 1 TO 12
		CALL cmb.addItem(m, is_dagatal.manudurint(m))
	END FOR
	CALL cmb.addItem(13, "-->")
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION month_name(m)
    DEFINE m SMALLINT
    CASE m
       WHEN 1 RETURN "January"
       WHEN 2 RETURN "February"
       WHEN 3 RETURN "March"
       WHEN 4 RETURN "April"
       WHEN 5 RETURN "May"
       WHEN 6 RETURN "June"
       WHEN 7 RETURN "July"
       WHEN 8 RETURN "August"
       WHEN 9 RETURN "September"
       WHEN 10 RETURN "October"
       WHEN 11 RETURN "November"
       WHEN 12 RETURN "December"
    END CASE
    RETURN NULL
END FUNCTION