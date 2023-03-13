(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/index\d{9}\.asp/i
(assert (not (str.in_re X (re.++ (str.to_re "//index") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re ".asp/i\u{0a}")))))
(check-sat)
