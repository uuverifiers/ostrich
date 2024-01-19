(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AX-Mailer\u{3a}Host\x3Adcww\x2Edmcast\x2Ecom
(assert (str.in_re X (str.to_re "User-Agent:X-Mailer:\u{13}Host:dcww.dmcast.com\u{0a}")))
; ^\d{1,2}\/\d{2,4}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
