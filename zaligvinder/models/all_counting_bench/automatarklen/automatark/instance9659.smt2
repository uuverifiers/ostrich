(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Esogou\x2Ecomix=WebsiteHost\u{3a}Web-Mail
(assert (not (str.in_re X (str.to_re "www.sogou.comix=WebsiteHost:Web-Mail\u{0a}"))))
; (^(\d{3}.\d{3}.\d{3}-\d{2})|(\d{11})$)
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 11 11) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^[\d]{5}[-\s]{1}[\d]{2}[-\s]{1}[\d]{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
