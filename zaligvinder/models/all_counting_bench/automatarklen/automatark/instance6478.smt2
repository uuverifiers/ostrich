(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((([0]?[1-9]|1[0-2])(:|\.)(00|15|30|45)?( )?(AM|am|aM|Am|PM|pm|pM|Pm))|(([0]?[0-9]|1[0-9]|2[0-3])(:|\.)(00|15|30|45)?))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re ":") (str.to_re ".")) (re.opt (re.union (str.to_re "00") (str.to_re "15") (str.to_re "30") (str.to_re "45"))) (re.opt (str.to_re " ")) (re.union (str.to_re "AM") (str.to_re "am") (str.to_re "aM") (str.to_re "Am") (str.to_re "PM") (str.to_re "pm") (str.to_re "pM") (str.to_re "Pm"))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.union (str.to_re ":") (str.to_re ".")) (re.opt (re.union (str.to_re "00") (str.to_re "15") (str.to_re "30") (str.to_re "45"))))) (str.to_re "\u{0a}"))))
; /\.php\?b=[A-F0-9]+&v=1\./U
(assert (not (str.in_re X (re.++ (str.to_re "/.php?b=") (re.+ (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "&v=1./U\u{0a}")))))
; Toolbar\w+www\x2Etopadwarereviews\x2Ecommedia\x2Etop-banners\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www.topadwarereviews.commedia.top-banners.com\u{0a}")))))
; [A-Za-z]{2}[0-9]{1,6}|[0-9]{1,8}
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ ((_ re.loop 1 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
