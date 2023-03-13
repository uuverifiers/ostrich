(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[\w-]{48}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/U\u{0a}")))))
; Server\.exeHWPEServer\u{3a}Host\x3A
(assert (str.in_re X (str.to_re "Server.exeHWPEServer:Host:\u{0a}")))
; e2give\.com.*Login\s+adfsgecoiwnf\u{23}\u{23}\u{23}\u{23}User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "e2give.com") (re.* re.allchar) (str.to_re "Login") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}####User-Agent:\u{0a}")))))
; config\x2E180solutions\x2Ecom\dStableWeb-MailUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "config.180solutions.com") (re.range "0" "9") (str.to_re "StableWeb-MailUser-Agent:\u{0a}"))))
; ^.+@[^\.].*\.[a-z]{2,}$
(assert (not (str.in_re X (re.++ (re.+ re.allchar) (str.to_re "@") (re.comp (str.to_re ".")) (re.* re.allchar) (str.to_re ".\u{0a}") ((_ re.loop 2 2) (re.range "a" "z")) (re.* (re.range "a" "z"))))))
(check-sat)
