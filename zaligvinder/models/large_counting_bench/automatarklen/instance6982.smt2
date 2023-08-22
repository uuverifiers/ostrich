(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[a-z\d\u{2b}\u{2f}\u{3d}]{48,256}$/iP
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 48 256) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/") (str.to_re "="))) (str.to_re "/iP\u{0a}"))))
; \x2Ehtml\s+IDENTIFY\s+\x2Fbar_pl\x2Ffav\.fcgiwwwUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re ".html") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "IDENTIFY") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/bar_pl/fav.fcgiwwwUser-Agent:\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
