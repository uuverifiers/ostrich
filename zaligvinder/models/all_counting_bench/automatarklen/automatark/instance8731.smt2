(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/AES\d{9}O\d{4,5}\u{2e}jsp/Ui
(assert (str.in_re X (re.++ (str.to_re "//AES") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "O") ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re ".jsp/Ui\u{0a}"))))
; \d{0,7}([\.|\,]\d{0,2})?
(assert (not (str.in_re X (re.++ ((_ re.loop 0 7) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re "|") (str.to_re ",")) ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; HBand,\sHost\x3A[^\n\r]*lnzzlnbk\u{2f}pkrm\.fin
(assert (not (str.in_re X (re.++ (str.to_re "HBand,") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
