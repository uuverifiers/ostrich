(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\.actualnames\.com.*www\.klikvipsearch\.com.*\x3C\x2Fchat\x3E
(assert (not (str.in_re X (re.++ (str.to_re "www.actualnames.com") (re.* re.allchar) (str.to_re "www.klikvipsearch.com") (re.* re.allchar) (str.to_re "</chat>\u{0a}")))))
; \x2Fxml\x2Ftoolbar\x2F
(assert (not (str.in_re X (str.to_re "/xml/toolbar/\u{0a}"))))
; ^([1-9]|(0|1|2)[0-9]|30)(/|-)([1-9]|1[0-2]|0[1-9])(/|-)(14[0-9]{2})$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (str.to_re "30")) (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (str.to_re "\u{0a}14") ((_ re.loop 2 2) (re.range "0" "9"))))))
(check-sat)
