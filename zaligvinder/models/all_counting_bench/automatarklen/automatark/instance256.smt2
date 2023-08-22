(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{1,2}d \d{1,2}h
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "d ") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h\u{0a}"))))
; /filename=[^\n]*\u{2e}svg/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".svg/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
