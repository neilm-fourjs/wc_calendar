
IMPORT FGL fglcalendar
IMPORT FGL is_dagatal

FUNCTION cmb_init_types(cmb)
	DEFINE cmb ui.ComboBox
	CALL cmb.addItem(FGLCALENDAR_TYPE_DEFAULT, "Default")
	CALL cmb.addItem(FGLCALENDAR_TYPE_TEXT,    "Text")
	CALL cmb.addItem(FGLCALENDAR_TYPE_ICON,    "Icon")
	CALL cmb.addItem(FGLCALENDAR_TYPE_DOTS,    "Dots")
END FUNCTION

FUNCTION cmb_init_themes(cmb)
	DEFINE cmb ui.ComboBox
	CALL cmb.addItem(FGLCALENDAR_THEME_DEFAULT, "Default")
	CALL cmb.addItem(FGLCALENDAR_THEME_SAHARA,  "Sahara")
	CALL cmb.addItem(FGLCALENDAR_THEME_PACIFIC, "Pacific")
	CALL cmb.addItem(FGLCALENDAR_THEME_AMAZON,  "Amazon")
	CALL cmb.addItem(FGLCALENDAR_THEME_VIOLA,   "Viola")
	CALL cmb.addItem(FGLCALENDAR_THEME_CHILI,   "Chili")
END FUNCTION

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

FUNCTION get_aui_node(p, tagname, name)
    DEFINE p om.DomNode,
           tagname STRING,
           name STRING
    DEFINE nl om.NodeList
    IF name IS NOT NULL THEN
       LET nl = p.selectByPath(SFMT("//%1[@name=\"%2\"]",tagname,name))
    ELSE
       LET nl = p.selectByPath(SFMT("//%1",tagname))
    END IF
    IF nl.getLength() == 1 THEN
       RETURN nl.item(1)
    ELSE
       RETURN NULL
    END IF
END FUNCTION

FUNCTION add_style(pn, name)
    DEFINE pn om.DomNode,
           name STRING
    DEFINE nn om.DomNode
    LET nn = get_aui_node(pn, "Style", name)
    IF nn IS NOT NULL THEN RETURN NULL END IF
    LET nn = pn.createChild("Style")
    CALL nn.setAttribute("name", name)
    RETURN nn
END FUNCTION

FUNCTION set_style_attribute(pn, name, value)
    DEFINE pn om.DomNode,
           name STRING,
           value STRING
    DEFINE sa om.DomNode
    LET sa = get_aui_node(pn, "StyleAttribute", name)
    IF sa IS NULL THEN
       LET sa = pn.createChild("StyleAttribute")
       CALL sa.setAttribute("name", name)
    END IF
    CALL sa.setAttribute("value", value)
END FUNCTION

FUNCTION add_presentation_styles()
    DEFINE rn om.DomNode,
           sl om.DomNode,
           nn om.DomNode
    LET rn = ui.Interface.getRootNode()
    LET sl = get_aui_node(rn, "StyleList", NULL)
    --
    LET nn = add_style(sl, ".bigfont")
    IF nn IS NOT NULL THEN
       CALL set_style_attribute(nn, "fontSize", "large" )
    END IF
END FUNCTION
