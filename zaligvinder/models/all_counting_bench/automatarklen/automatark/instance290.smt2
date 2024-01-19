(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(action|setup)=[a-z]{1,4}/Ri
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "action") (str.to_re "setup")) (str.to_re "=") ((_ re.loop 1 4) (re.range "a" "z")) (str.to_re "/Ri\u{0a}")))))
; \x2FcommunicatortbHost\u{3a}
(assert (str.in_re X (str.to_re "/communicatortbHost:\u{0a}")))
; /filename=[^\n]*\u{2e}met/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".met/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
