(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9]+\d*\.\d{2}$
(assert (str.in_re X (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
