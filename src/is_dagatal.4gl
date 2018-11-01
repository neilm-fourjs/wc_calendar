
public define DES_24_FRI boolean
public define DES_31_FRI boolean
private define easter date
################################################################################
# Skilar texta til að displaya ( vikud. og frídagstexta ef þarf.) 
# Skilar 2 parametrum, (frídagur (T/F), texti string)
################################################################################

public function dag_texti(date_in, syna_vikud)
  
 define fri, syna_vikud,m,d,y    smallint,
        date_in, l_easter  date,
        d_txt string 

 if DES_24_FRI is null then let DES_24_FRI = true end if
 if DES_31_FRI is null then let DES_31_FRI = true end if

 let m = month(date_in)
 let d = day(date_in)
 let y = year(date_in)

 if y = year(easter) then 
  let l_easter = easter
 else
  let l_easter = calc_easter(y)
 end if
 
 let d_txt = " " 
 let fri = false

 case
  when date_in = (l_easter - 3)
   let fri = true
   let d_txt = "Skírdagur"
  when date_in = (l_easter - 2)
   let fri = true
   let d_txt = "Fös. langi"
  when date_in = l_easter
   let fri = true
   let d_txt = "Páskadagur"
  when date_in = (l_easter + 1)
   let fri = true
   let d_txt = "Páskar"
  when date_in = (l_easter + 39)
   let fri = true
   let d_txt = "Uppstigningardagur"
  when date_in = (l_easter + 49)
   let fri = true
   let d_txt = "Hvítasunna"
  when date_in = (l_easter + 50)
   let fri = true
   let d_txt = "Hvítasunna"
  when m = 4 and weekday(date_in) = 4 and d > 18 and d <= 25
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
   if weekday(date_in) = 1 and d <= 7 then
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
  let d_txt = "(",vikud(date_in),") ", d_txt
 end if

 if d_txt = " " then let d_txt = null end if
 return fri, d_txt

end function

################################################################################
# Reiknar páskadag 1900 - 2099 (bæði ár meðtalin)
################################################################################

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

end function

################################################################################
# Function skilar vikudegi
################################################################################

private function vikud(d)
define d date

case weekday(d)
 when 0 return "Sun"
 when 1 return "Mán"
 when 2 return "Þri"
 when 3 return "Mið"
 when 4 return "Fim"
 when 5 return "Fös"
 when 6 return "Lau"
end case
end function

################################################################################
# skilar true ef frídagur
################################################################################

function fridagur(indag)
define indag date,
 fri smallint,
 tx  string

if indag is null then return null end if
call dag_texti(indag,false) returning fri, tx
return fri
end function

################################################################################
# skilar true ef helgi (lau eða sun)
################################################################################

function helgi(indag)
define indag date
return weekday(indag) = 0 or weekday(indag) = 6
end function

################################################################################
# Function skilar heiti mánaðar frá dags (skammstafað, 3 stafir)
################################################################################
public function manint(i int) returns string
  return man(mdy(i,1,year(today)))
end function

public function man(d date) returns string
define i int
let i = month(d)
if i is null then return null end if
case i
 when  1 return "jan"
 when  2 return "feb"
 when  3 return "mar"
 when  4 return "apr"
 when  5 return "maí"
 when  6 return "jún"
 when  7 return "júl"
 when  8 return "ágú"
 when  9 return "sep"
 when 10 return "okt"
 when 11 return "nóv"
 when 12 return "des"
 otherwise return "***"
end case
end function

################################################################################
# Function skilar heiti mánaðar frá dags 
################################################################################

public function manudurint(i int) returns string
  return manudur(mdy(i,1,year(today)))
end function

public function manudur(d date) returns string
define i int
let i = month(d)
if i is null then return null end if
case i
 when  1 return "janúar"
 when  2 return "febrúar"
 when  3 return "mars"
 when  4 return "apríl"
 when  5 return "maí"
 when  6 return "júní"
 when  7 return "júlí"
 when  8 return "ágúst"
 when  9 return "september"
 when 10 return "október"
 when 11 return "nóvember"
 when 12 return "desember"
 otherwise return "***"
end case
end function