(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{1,4}?[.]{0,1}?\d{0,3}?)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 4) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 0 3) (re.range "0" "9"))))))
; ^-?([1-8]?[0-9]\.{1}\d{1,6}$|90\.{1}0{1,6}$)
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (re.range "1" "8")) (re.range "0" "9") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (str.to_re "90") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}"))))
(check-sat)
