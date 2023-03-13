(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; show\x2Eroogoo\x2Ecom\s+report\<\x2Ftitle\>Host\u{3a}\.fcgi
(assert (str.in_re X (re.++ (str.to_re "show.roogoo.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "report</title>Host:.fcgi\u{0a}"))))
; /^connect\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/connect|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; (""|[^"])*
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "\u{22}\u{22}") (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{0a}")))))
(check-sat)
