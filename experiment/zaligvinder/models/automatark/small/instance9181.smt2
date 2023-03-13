(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[0-9]{8}\.html$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re ".html/U\u{0a}")))))
(check-sat)
