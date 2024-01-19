(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(9\d{2})([ \-]?)([7]\d|8[0-8])([ \-]?)(\d{4})$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.union (re.++ (str.to_re "7") (re.range "0" "9")) (re.++ (str.to_re "8") (re.range "0" "8"))) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}9") ((_ re.loop 2 2) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
