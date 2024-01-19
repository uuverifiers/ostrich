(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; MyPostsearch\u{2e}conduit\u{2e}comUser-Agent\x3AAcmeSubject\x3Aready\.\r\n
(assert (str.in_re X (str.to_re "MyPostsearch.conduit.comUser-Agent:AcmeSubject:ready.\u{0d}\u{0a}\u{0a}")))
; ([a-zA-Z]{2}[0-9]{1,2}\s{0,1}[0-9]{1,2}[a-zA-Z]{2})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))))
(assert (> (str.len X) 10))
(check-sat)
