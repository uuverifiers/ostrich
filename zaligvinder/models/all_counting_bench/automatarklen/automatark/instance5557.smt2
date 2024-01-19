(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; vvvjkhmbgnbbw\u{2f}qbn\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (str.in_re X (str.to_re "vvvjkhmbgnbbw/qbn\u{1b}(robert@blackcastlesoft.com)\u{0a}")))
; \r\nSTATUS\x3AUser-Agent\x3AHost\u{3a}Referer\x3A
(assert (str.in_re X (str.to_re "\u{0d}\u{0a}STATUS:User-Agent:Host:Referer:\u{0a}")))
; ^([1-9]{1}[0-9]{0,7})+((,[1-9]{1}[0-9]{0,7}){0,1})+$
(assert (not (str.in_re X (re.++ (re.+ (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 7) (re.range "0" "9")))) (re.+ (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 7) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; ^(BG){0,1}([0-9]{9}|[0-9]{10})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "BG")) (re.union ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; Host\x3A\s+User-Agent\x3A.*v\x3BApofisToolbarUser
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "v;ApofisToolbarUser\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
