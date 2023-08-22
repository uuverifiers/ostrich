(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (not (str.in_re X (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}"))))
; zzzvmkituktgr\u{2f}etie\s+WindowsAttachedPalas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (not (str.in_re X (re.++ (str.to_re "zzzvmkituktgr/etie") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WindowsAttachedPalas.starware.com/dp/search?x=\u{0a}")))))
; [:;]{1}[-~+o]?[(<\[]+
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re ":") (str.to_re ";"))) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.+ (re.union (str.to_re "(") (str.to_re "<") (str.to_re "["))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
