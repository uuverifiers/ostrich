(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d+)?-?(\d+)-(\d+)
(assert (not (str.in_re X (re.++ (re.opt (re.+ (re.range "0" "9"))) (re.opt (str.to_re "-")) (re.+ (re.range "0" "9")) (str.to_re "-") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^([0-9]{12},)+[0-9]{12}$|^([0-9]{12})$
(assert (not (str.in_re X (re.union (re.++ (re.+ (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
