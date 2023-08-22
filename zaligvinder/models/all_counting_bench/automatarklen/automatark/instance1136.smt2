(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^GET\s\/[a-z]{5}\.php\?id=[A-Z0-9]{18}\sHTTP\/1\.[0-1]\r\n/
(assert (str.in_re X (re.++ (str.to_re "/GET") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/") ((_ re.loop 5 5) (re.range "a" "z")) (str.to_re ".php?id=") ((_ re.loop 18 18) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "HTTP/1.") (re.range "0" "1") (str.to_re "\u{0d}\u{0a}/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
