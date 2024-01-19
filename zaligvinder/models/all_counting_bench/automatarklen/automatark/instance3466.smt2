(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]*\/{1}[1-9]{1}[0-9]*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "/")) ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \({1}[0-9]{3}\){1}\-{1}[0-9]{3}\-{1}[0-9]{4}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ")")) ((_ re.loop 1 1) (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
