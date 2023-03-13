(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z0-9\\-\\&-]{5,12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "\u{5c}" "\u{5c}") (str.to_re "&") (str.to_re "-"))) (str.to_re "\u{0a}")))))
; X-OSSproxy\u{3a}FTPSubject\u{3a}ServerMicrosoft\x2APORT3\x2APro
(assert (str.in_re X (str.to_re "X-OSSproxy:FTPSubject:ServerMicrosoft*PORT3*Pro\u{0a}")))
; search\u{2e}imesh\u{2e}com\s+WatchDogupwww\.klikvipsearch\.com
(assert (not (str.in_re X (re.++ (str.to_re "search.imesh.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDogupwww.klikvipsearch.com\u{0a}")))))
(check-sat)
