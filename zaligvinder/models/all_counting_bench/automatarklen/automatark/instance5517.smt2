(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}\s+ServerToolbar
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ServerToolbar\u{0a}")))))
; zzzvmkituktgr\u{2f}etie\s+WindowsAttachedPalas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (str.in_re X (re.++ (str.to_re "zzzvmkituktgr/etie") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WindowsAttachedPalas.starware.com/dp/search?x=\u{0a}"))))
; ^R(\d){8}
(assert (not (str.in_re X (re.++ (str.to_re "R") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
