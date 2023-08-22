(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\[[abiu][^\[\]]*\])([^\[\]]+)(\[/?[abiu]\])
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "[") (str.to_re "]"))) (str.to_re "\u{0a}[") (re.union (str.to_re "a") (str.to_re "b") (str.to_re "i") (str.to_re "u")) (re.* (re.union (str.to_re "[") (str.to_re "]"))) (str.to_re "][") (re.opt (str.to_re "/")) (re.union (str.to_re "a") (str.to_re "b") (str.to_re "i") (str.to_re "u")) (str.to_re "]")))))
; /\/[a-z0-9]{9}\.jnlp$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 9 9) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jnlp/U\u{0a}"))))
; too[^\n\r]*User-Agent\x3A\sHost\x3A.*IP-WindowsAttachedPalas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (str.in_re X (re.++ (str.to_re "too") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "IP-WindowsAttachedPalas.starware.com/dp/search?x=\u{0a}"))))
; couponbar\.coupons\.com\dOwner\x3AX-Sender\x3A
(assert (str.in_re X (re.++ (str.to_re "couponbar.coupons.com") (re.range "0" "9") (str.to_re "Owner:X-Sender:\u{13}\u{0a}"))))
; /filename=[^\n]*\u{2e}asx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asx/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
