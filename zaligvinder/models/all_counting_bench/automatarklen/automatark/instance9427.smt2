(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3ASpyPORT-ischeck=Component
(assert (not (str.in_re X (str.to_re "User-Agent:SpyPORT-ischeck=Component\u{0a}"))))
; ^\d{3}\s?\d{3}\s?\d{3}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^.*(yourdomain.com).*$
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.* re.allchar) (str.to_re "\u{0a}yourdomain") re.allchar (str.to_re "com")))))
; /\bobj\u{0a}\u{20}*?\/Pattern\u{20}*?\u{0a}endobj\b/i
(assert (not (str.in_re X (re.++ (str.to_re "/obj\u{0a}") (re.* (str.to_re " ")) (str.to_re "/Pattern") (re.* (str.to_re " ")) (str.to_re "\u{0a}endobj/i\u{0a}")))))
; Host\x3A\s+Boss\s+media\x2Etop-banners\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Boss") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.top-banners.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
