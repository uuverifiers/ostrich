(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ad\x2Esearchsquire\x2Ecom[^\n\r]*User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "ad.searchsquire.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}"))))
; ^([\s\S]){1,20}([\s\.])
(assert (not (str.in_re X (re.++ ((_ re.loop 1 20) (re.union (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}")))))
; ((http(s)?:\/\/)?[a-z0-9-]{3,}(\.[a-z0-9-]{2,})+(:[0-9]+)?((\/[^\/\s.]+\.[^\/\s.,!]+)|(\/[^\/\s.,!]*))*)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://"))) (re.+ (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.* (re.union (re.++ (str.to_re "/") (re.+ (re.union (str.to_re "/") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".") (re.+ (re.union (str.to_re "/") (str.to_re ".") (str.to_re ",") (str.to_re "!") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.++ (str.to_re "/") (re.* (re.union (str.to_re "/") (str.to_re ".") (str.to_re ",") (str.to_re "!") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-")))))))
; [-]?[1-9]\d{0,16}\.?\d{0,2}|[-]?[0]?\.[1-9]{1,2}|[-]?[0]?\.[0-9][1-9]
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) (re.range "1" "9") ((_ re.loop 0 16) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "0")) (str.to_re ".") ((_ re.loop 1 2) (re.range "1" "9"))) (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "0")) (str.to_re ".") (re.range "0" "9") (re.range "1" "9") (str.to_re "\u{0a}"))))))
; /[a-z]=[a-f0-9]{98}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 98 98) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/P\u{0a}")))))
(check-sat)
