(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/ZES\d+O\d+\.jsp\?[a-z0-9=\u{2b}\u{2f}]{20}/iU
(assert (str.in_re X (re.++ (str.to_re "//ZES") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iU\u{0a}"))))
; ^[1-9]+\d*\.\d{2}$
(assert (not (str.in_re X (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\/cache\/pdf\x5Fefax\x5F\d{8,15}\.zip$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//cache/pdf_efax_") ((_ re.loop 8 15) (re.range "0" "9")) (str.to_re ".zip/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
