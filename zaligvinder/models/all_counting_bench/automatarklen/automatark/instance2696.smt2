(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A[^\n\r]*cache\x2Eeverer\x2Ecom\s+from\.myway\.comToolbar
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "cache.everer.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "from.myway.com\u{1b}Toolbar\u{0a}"))))
; (^(5[0678])\d{11,18}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 11 18) (re.range "0" "9")) (str.to_re "5") (re.union (str.to_re "0") (str.to_re "6") (str.to_re "7") (str.to_re "8"))))))
; /^GET\u{20}\/plus\u{2e}asp\?[^\r\n]*?query=[a-z0-9+\/]{2,40}@{0,2}/i
(assert (str.in_re X (re.++ (str.to_re "/GET /plus.asp?") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "query=") ((_ re.loop 2 40) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) ((_ re.loop 0 2) (str.to_re "@")) (str.to_re "/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
