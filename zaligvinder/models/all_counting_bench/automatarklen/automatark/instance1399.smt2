(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^ -~\r\n]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}")))))
; ^(0)$|^([1-9][0-9]*)$
(assert (not (str.in_re X (re.union (str.to_re "0") (re.++ (str.to_re "\u{0a}") (re.range "1" "9") (re.* (re.range "0" "9")))))))
; (\/\/)(.+)(\/\/)
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ re.allchar) (str.to_re "//\u{0a}"))))
; e2give\.com.*Login\s+adfsgecoiwnf\u{23}\u{23}\u{23}\u{23}User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "e2give.com") (re.* re.allchar) (str.to_re "Login") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}####User-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
