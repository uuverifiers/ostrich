(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}jmh([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jmh") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ((079)|(078)|(077)){1}[0-9]{7}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "079") (str.to_re "078") (str.to_re "077"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; sql.*badurl\x2Egrandstreetinteractive\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "sql") (re.* re.allchar) (str.to_re "badurl.grandstreetinteractive.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
