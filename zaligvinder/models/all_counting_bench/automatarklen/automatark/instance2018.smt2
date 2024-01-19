(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(.*?)([^/\\]*?)(\.[^/\\.]*)?$
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.* (re.union (str.to_re "/") (str.to_re "\u{5c}"))) (re.opt (re.++ (str.to_re ".") (re.* (re.union (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "."))))) (str.to_re "\u{0a}")))))
; /GET \/[a-z]{8,12}\?[a-z] HTTP\/1.1/i
(assert (not (str.in_re X (re.++ (str.to_re "/GET /") ((_ re.loop 8 12) (re.range "a" "z")) (str.to_re "?") (re.range "a" "z") (str.to_re " HTTP/1") re.allchar (str.to_re "1/i\u{0a}")))))
; User-Agent\u{3a}\sRequestwww\x2Ealtnet\x2EcomSubject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Requestwww.altnet.com\u{1b}Subject:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
