(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; kl\x2Esearch\x2Eneed2find\x2Ecom\ssource%3Dultrasearch136%26campaign%3Dsnap
(assert (str.in_re X (re.++ (str.to_re "kl.search.need2find.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "source%3Dultrasearch136%26campaign%3Dsnap\u{0a}"))))
; User-Agent\x3A\s+Robert
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Robert\u{0a}"))))
; /^\/[\w-]{48}$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/U\u{0a}"))))
(check-sat)
