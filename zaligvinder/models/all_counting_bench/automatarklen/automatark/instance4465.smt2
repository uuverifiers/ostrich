(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-f0-9]{8}\/[a-f0-9]{7,8}\/$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 7 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "//U\u{0a}"))))
; e2give\.com\s+adfsgecoiwnf\u{23}\u{23}\u{23}\u{23}User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "e2give.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}####User-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
