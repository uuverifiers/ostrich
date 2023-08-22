(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[a-z\d]{1,8}\.exe$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 8) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".exe/Ui\u{0a}")))))
; /new (java|org)/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/new ") (re.union (str.to_re "java") (str.to_re "org")) (str.to_re "/Ui\u{0a}")))))
; /\/pdfx\.html$/U
(assert (not (str.in_re X (str.to_re "//pdfx.html/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
