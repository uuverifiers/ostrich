(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Ready\s+Eye.*http\x3A\x2F\x2Fsupremetoolbar
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Eye") (re.* re.allchar) (str.to_re "http://supremetoolbar\u{0a}"))))
; (.|[\r\n]){1,5}
(assert (str.in_re X (re.++ ((_ re.loop 1 5) (re.union re.allchar (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
