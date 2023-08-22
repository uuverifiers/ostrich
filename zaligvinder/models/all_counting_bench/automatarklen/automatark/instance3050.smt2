(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(LV-)[0-9]{4}$
(assert (not (str.in_re X (re.++ (str.to_re "LV-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^5[1-5][0-9]{14}$
(assert (str.in_re X (re.++ (str.to_re "5") (re.range "1" "5") ((_ re.loop 14 14) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}wk4/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wk4/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
