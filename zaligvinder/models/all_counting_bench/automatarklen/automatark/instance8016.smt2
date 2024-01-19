(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/AES\d{9}O\d{4,5}\u{2e}jsp/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//AES") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "O") ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re ".jsp/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
