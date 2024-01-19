(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0][^0]|([^0]{1}(.){1})|[^0]*
(assert (str.in_re X (re.union (re.++ (str.to_re "0") (re.comp (str.to_re "0"))) (re.++ ((_ re.loop 1 1) (re.comp (str.to_re "0"))) ((_ re.loop 1 1) re.allchar)) (re.++ (re.* (re.comp (str.to_re "0"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
