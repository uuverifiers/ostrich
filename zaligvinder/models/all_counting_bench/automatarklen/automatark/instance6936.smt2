(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/cache\/pdf\x5Fefax\x5F\d{8,15}\.zip$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//cache/pdf_efax_") ((_ re.loop 8 15) (re.range "0" "9")) (str.to_re ".zip/Ui\u{0a}")))))
; (\d*)'*-*(\d*)/*(\d*)"
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.* (str.to_re "'")) (re.* (str.to_re "-")) (re.* (re.range "0" "9")) (re.* (str.to_re "/")) (re.* (re.range "0" "9")) (str.to_re "\u{22}\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
