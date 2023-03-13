(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/999$/U
(assert (not (str.in_re X (str.to_re "//999/U\u{0a}"))))
; for mobile:^[0][1-9]{1}[0-9]{9}$
(assert (str.in_re X (re.++ (str.to_re "for mobile:0") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
