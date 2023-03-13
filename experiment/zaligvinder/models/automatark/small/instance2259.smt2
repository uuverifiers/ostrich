(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.jpg\u{20}HTTP\/1\.[01]\r\nUser\u{2d}Agent\u{3a}\u{20}[a-z]+\r\nHost\u{3a}\u{20}[a-z0-9\u{2d}\u{2e}]+\.com\.br\r\n\r\n$/
(assert (not (str.in_re X (re.++ (str.to_re "/.jpg HTTP/1.") (re.union (str.to_re "0") (str.to_re "1")) (str.to_re "\u{0d}\u{0a}User-Agent: ") (re.+ (re.range "a" "z")) (str.to_re "\u{0d}\u{0a}Host: ") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".com.br\u{0d}\u{0a}\u{0d}\u{0a}/\u{0a}")))))
; ^(([0-9]{3})[ \-\/]?([0-9]{3})[ \-\/]?([0-9]{3}))|([0-9]{9})|([\+]?([0-9]{3})[ \-\/]?([0-9]{2})[ \-\/]?([0-9]{3})[ \-\/]?([0-9]{3}))$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 9 9) (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "+")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))) ((_ re.loop 3 3) (re.range "0" "9"))))))
(check-sat)
