(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; horoscope2YAHOOwww\u{2e}2-seek\u{2e}com\u{2f}searchHost\x3A
(assert (not (str.in_re X (str.to_re "horoscope2YAHOOwww.2-seek.com/searchHost:\u{0a}"))))
; ^\(0[1-9]{1}\)[0-9]{8}$
(assert (not (str.in_re X (re.++ (str.to_re "(0") ((_ re.loop 1 1) (re.range "1" "9")) (str.to_re ")") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
