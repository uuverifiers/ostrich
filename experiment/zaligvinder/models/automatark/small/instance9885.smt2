(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Ericercadoppia\x2Ecom\w+TPSystem\s+User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "www.ricercadoppia.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "TPSystem") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}"))))
; Handyst=ClassStopperHost\x3ASpamBlockerUtility
(assert (not (str.in_re X (str.to_re "Handyst=ClassStopperHost:SpamBlockerUtility\u{0a}"))))
; User-Agent\u{3a}\s+Host\x3AnamediepluginHost\x3AX-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:namediepluginHost:X-Mailer:\u{13}\u{0a}")))))
; to=\x2Fezsb\s\x3Ahirmvtg\u{2f}ggqh\.kqhSPYzzzvmkituktgr\u{2f}etie
(assert (str.in_re X (re.++ (str.to_re "to=/ezsb") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re ":hirmvtg/ggqh.kqh\u{1b}SPYzzzvmkituktgr/etie\u{0a}"))))
; /^\/f(\/[^\u{2f}]+)?\/14\d{8}(\/\d{9,10})?(\/\d)+(\/x[a-f0-9]+(\u{3b}\d)+?)?$/U
(assert (not (str.in_re X (re.++ (str.to_re "//f") (re.opt (re.++ (str.to_re "/") (re.+ (re.comp (str.to_re "/"))))) (str.to_re "/14") ((_ re.loop 8 8) (re.range "0" "9")) (re.opt (re.++ (str.to_re "/") ((_ re.loop 9 10) (re.range "0" "9")))) (re.+ (re.++ (str.to_re "/") (re.range "0" "9"))) (re.opt (re.++ (str.to_re "/x") (re.+ (re.union (re.range "a" "f") (re.range "0" "9"))) (re.+ (re.++ (str.to_re ";") (re.range "0" "9"))))) (str.to_re "/U\u{0a}")))))
(check-sat)
