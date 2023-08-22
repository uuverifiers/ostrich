(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ToolbarServerserver\x7D\x7BSysuptime\x3A
(assert (not (str.in_re X (str.to_re "ToolbarServerserver}{Sysuptime:\u{0a}"))))
; /\/[a-z]{4}\.html\?h\=\d{6,7}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".html?h=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; \.([A-Za-z0-9]{2,5}($|\b\?))
(assert (not (str.in_re X (re.++ (str.to_re ".\u{0a}") ((_ re.loop 2 5) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "?")))))
; /\x3F[0-9a-z]{32}D/U
(assert (not (str.in_re X (re.++ (str.to_re "/?") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "D/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
