(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\"http:\/\/www\.youtube\.com\/v\/\w{11}\&rel\=1\")
(assert (str.in_re X (re.++ (str.to_re "\u{0a}\u{22}http://www.youtube.com/v/") ((_ re.loop 11 11) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "&rel=1\u{22}"))))
; \bhttp(s?)\:\/\/[a-zA-Z0-9\/\?\-\.\&\(\)_=#]*
(assert (not (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "/") (str.to_re "?") (str.to_re "-") (str.to_re ".") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "_") (str.to_re "=") (str.to_re "#"))) (str.to_re "\u{0a}")))))
; <!--[\w\W]*?-->
(assert (str.in_re X (re.++ (str.to_re "<!--") (re.* (re.union (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "-->\u{0a}"))))
; [0-9]{4}-[0-9]{3}
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
