(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((FI|HU|LU|MT|SI)-?)?[0-9]{8}
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "FI") (str.to_re "HU") (str.to_re "LU") (str.to_re "MT") (str.to_re "SI")) (re.opt (str.to_re "-")))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (^\d{1,2}\.\d{1,2}\.\d{4})|(^\d{1,2}\.\d{1,2})|(^\d{1,2})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
