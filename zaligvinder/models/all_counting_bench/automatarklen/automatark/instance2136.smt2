(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}asx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asx/i\u{0a}")))))
; ([0-0]{1}[1-9]{1}[0-9]{9})|[1-9]{1}[0-9]{9}
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "0")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
