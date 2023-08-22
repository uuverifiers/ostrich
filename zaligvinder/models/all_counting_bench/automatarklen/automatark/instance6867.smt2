(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; sql.*badurl\x2Egrandstreetinteractive\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "sql") (re.* re.allchar) (str.to_re "badurl.grandstreetinteractive.com\u{0a}"))))
; ^[0-9]{6}
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
