(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}plf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".plf/i\u{0a}")))))
; (^([1-9]|[1][0-2]):([0-5][0-9])(\s{0,1})(AM|PM|am|pm|aM|Am|pM|Pm{2,2})$)|(^([0-9]|[1][0-9]|[2][0-3]):([0-5][0-9])$)|(^([1-9]|[1][0-2])(\s{0,1})(AM|PM|am|pm|aM|Am|pM|Pm{2,2})$)|(^([0-9]|[1][0-9]|[2][0-3])$)
(assert (not (str.in_re X (re.union (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "AM") (str.to_re "PM") (str.to_re "am") (str.to_re "pm") (str.to_re "aM") (str.to_re "Am") (str.to_re "pM") (re.++ (str.to_re "P") ((_ re.loop 2 2) (str.to_re "m")))) (re.range "0" "5") (re.range "0" "9")) (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9")) (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "AM") (str.to_re "PM") (str.to_re "am") (str.to_re "pm") (str.to_re "aM") (str.to_re "Am") (str.to_re "pM") (re.++ (str.to_re "P") ((_ re.loop 2 2) (str.to_re "m"))))) (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "\u{0a}"))))))
; ^(GIR|[A-Z]\d[A-Z\d]??|[A-Z]{2}\d[A-Z\d]??)[ ]??(\d[A-Z]{2})$
(assert (str.in_re X (re.++ (re.union (str.to_re "GIR") (re.++ (re.range "A" "Z") (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (str.to_re " ")) (str.to_re "\u{0a}") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")))))
; (< *balise[ *>|:(.|\n)*>| (.|\n)*>](.|\n)*</balise *>)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}<") (re.* (str.to_re " ")) (str.to_re "balise") (re.union (str.to_re " ") (str.to_re "*") (str.to_re ">") (str.to_re "|") (str.to_re ":") (str.to_re "(") (str.to_re ".") (str.to_re "\u{0a}") (str.to_re ")")) (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "</balise") (re.* (str.to_re " ")) (str.to_re ">")))))
; Travel.*www\x2Etopadwarereviews\x2Ecom\s+v2\x2E0www\.raxsearch\.com
(assert (not (str.in_re X (re.++ (str.to_re "Travel") (re.* re.allchar) (str.to_re "www.topadwarereviews.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "v2.0www.raxsearch.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
