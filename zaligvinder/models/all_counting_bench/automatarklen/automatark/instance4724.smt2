(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <!--.*?-->
(assert (not (str.in_re X (re.++ (str.to_re "<!--") (re.* re.allchar) (str.to_re "-->\u{0a}")))))
; isSAH\*Agentwww\.raxsearch\.comHost\x3A-~-\u{22}The
(assert (not (str.in_re X (str.to_re "isSAH*Agentwww.raxsearch.comHost:-~-\u{22}The\u{0a}"))))
; ad\x2Esearchsquire\x2Ecom[^\n\r]*User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "ad.searchsquire.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}")))))
; ^((0?[2])/(0?[1-9]|[1-2][0-9])|(0?[469]|11)/(0?[1-9]|[1-2][0-9]|30)|(0?[13578]|1[02])/(0?[1-9]|[1-2][0-9]|3[0-1]))/([1][9][0-9]{2}|[2-9][0-9]{3}) (00|0?[1-9]|1[0-9]|2[0-3])\:([0-5][0-9])\:([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (str.to_re "30"))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))))) (str.to_re "/") (re.union (re.++ (str.to_re "19") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re " ") (re.union (str.to_re "00") (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)
