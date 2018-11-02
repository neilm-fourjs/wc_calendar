
IMPORT FGL calendar_lib

public define DES_24_FRI boolean
public define DES_31_FRI boolean
private define easter date
################################################################################
# Skilar texta til að displaya ( vikud. og frídagstexta ef þarf.) 
# Skilar 2 parametrum, (frídagur (T/F), texti string)
################################################################################

public function dag_texti(l_date_in DATE, syna_vikud SMALLINT)
	define fri, m,d,y    smallint,
        l_easter  date,
        d_txt string 

 if DES_24_FRI is null then let DES_24_FRI = true end if
 if DES_31_FRI is null then let DES_31_FRI = true end if

 let m = month(l_date_in)
 let d = day(l_date_in)
 let y = year(l_date_in)

 if y = year(easter) then 
  let l_easter = easter
 else
  let l_easter = calc_easter(y)
 end if
 
 let d_txt = " " 
 let fri = false

 case
  when l_date_in = (l_easter - 3)
   let fri = true
   let d_txt = "Skírdagur"
  when l_date_in = (l_easter - 2)
   let fri = true
   let d_txt = "Fös. langi"
  when l_date_in = l_easter
   let fri = true
   let d_txt = "Páskadagur"
  when l_date_in = (l_easter + 1)
   let fri = true
   let d_txt = "Páskar"
  when l_date_in = (l_easter + 39)
   let fri = true
   let d_txt = "Uppstigningardagur"
  when l_date_in = (l_easter + 49)
   let fri = true
   let d_txt = "Hvítasunna"
  when l_date_in = (l_easter + 50)
   let fri = true
   let d_txt = "Hvítasunna"
  when m = 4 and weekday(l_date_in) = 4 and d > 18 and d <= 25
   let fri = true
   let d_txt = "Sumard. fyrsti"
  when m = 1 and d = 1
   let fri = true
   let d_txt = "Nýársdagur"
  when m = 5 and d = 1
   let fri = true
   let d_txt = "Verkalýðsdagurinn"
  when m = 6 and d = 17
   let fri = true
   let d_txt = "Þjóðhátíð"
  when m = 8
   if weekday(l_date_in) = 1 and d <= 7 then
    let fri = true
    let d_txt = "Fríd. verslunarmanna"
   end if
  when m = 12 and d = 24
   let fri = DES_24_FRI
   let d_txt = "Aðfangadagur"
  when m = 12 and d = 25
   let fri = true
   let d_txt = "Jóladagur"
  when m = 12 and d = 26
   let fri = true
   let d_txt = "Annar í jólum"
  when m = 12 and d = 31
   let fri = DES_31_FRI
   let d_txt = "Gamlársdagur"
 end case

 if syna_vikud then 
  let d_txt = "(", calendar_lib.day_fullName(l_date_in),") ", d_txt
 end if

 if d_txt = " " then let d_txt = null end if
 return fri, d_txt

END FUNCTION
--------------------------------------------------------------------------------
-- Weekend Calculates Easter Day
private function calc_easter(y)
	define y,a,b,c,d,e,f,g smallint

	let a = y - 1900
	let b = a mod 19
	let c = (7 * b + 1) / 19
	let d = (11 * b+ 4 - c) mod 29
	let e = a / 4
	let f = (a + e + 31 - d) mod 7
	let g = 25 - d - f   

	if g > 0 then
		return mdy(4,g,y)
	else
		return mdy(3,g+31,y)
	end if

END FUNCTION
--------------------------------------------------------------------------------
--
FUNCTION holidays(l_date DATE) RETURNS STRING
	DEFINE
		fri smallint,
		tx  string

	IF l_date IS NULL THEN RETURN NULL END IF
	CALL dag_texti(l_date,false) returning fri, tx
	RETURN fri
END FUNCTION