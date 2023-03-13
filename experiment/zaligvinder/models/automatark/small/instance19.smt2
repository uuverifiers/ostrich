(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{4},?)+$
(assert (str.in_re X (re.++ (re.+ (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}"))))
(check-sat)
