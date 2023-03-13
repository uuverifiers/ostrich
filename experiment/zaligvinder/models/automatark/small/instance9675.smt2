(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Ezhongsou\x2Ecom\w+FTX-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "www.zhongsou.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "FTX-Mailer:\u{13}\u{0a}"))))
; c\.goclick\.com[^\n\r]*is\s+URLBlaze
(assert (not (str.in_re X (re.++ (str.to_re "c.goclick.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlaze\u{0a}")))))
; (^([1-3]{1}[0-9]{0,}(\.[0-9]{1})?|0(\.[0-9]{1})?|[4]{1}[0-9]{0,}(\.[0]{1})?|5(\.[5]{1}))$)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "3")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (str.to_re "4")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (str.to_re "0"))))) (re.++ (str.to_re "5.") ((_ re.loop 1 1) (str.to_re "5")))) (str.to_re "\u{0a}"))))
; function.*WEBCAM-.*User-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "function") (re.* re.allchar) (str.to_re "WEBCAM-") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}"))))
(check-sat)
