(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; from\x3AHost\u{3a}www\.thecommunicator\.net
(assert (str.in_re X (str.to_re "from:Host:www.thecommunicator.net\u{0a}")))
; ^([a-zA-z\s]{2,})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "z") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.range "a" "z") (re.range "A" "z") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
; ^([0][1-9]|[1][0-2]):[0-5][0-9] {1}(AM|PM|am|pm)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") ((_ re.loop 1 1) (str.to_re " ")) (re.union (str.to_re "AM") (str.to_re "PM") (str.to_re "am") (str.to_re "pm")) (str.to_re "\u{0a}")))))
; ProxyDownCurrentUser-Agent\x3AHost\x3Acom\x2Findex\.php\?tpid=
(assert (not (str.in_re X (str.to_re "ProxyDownCurrentUser-Agent:Host:com/index.php?tpid=\u{0a}"))))
; ^(www\.regxlib\.com)$
(assert (str.in_re X (str.to_re "www.regxlib.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
