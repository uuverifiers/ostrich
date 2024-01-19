(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}jpm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpm/i\u{0a}"))))
; /filename=[^\n]*\u{2e}dbp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dbp/i\u{0a}"))))
; ^([7-9]{1})([0-9]{9})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "7" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
