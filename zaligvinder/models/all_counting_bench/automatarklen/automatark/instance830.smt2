(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d){8}$
(assert (not (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; [0-7]+
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "7")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
