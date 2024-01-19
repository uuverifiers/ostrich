(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; UI2ftpquickbrutehttp\x3A\x2F\x2Fdiscounts\x2Eshopathome\x2Ecom\x2Fframeset\x2Easp\?
(assert (not (str.in_re X (str.to_re "UI2ftpquickbrutehttp://discounts.shopathome.com/frameset.asp?\u{0a}"))))
; \x2Easpxdata\.warezclient\.comWinCrashrunningUser-Agent\x3Awowokay
(assert (str.in_re X (str.to_re ".aspxdata.warezclient.comWinCrashrunningUser-Agent:wowokay\u{0a}")))
; ^[a-zA-Z0-9][a-zA-Z0-9-_.]{2,8}[a-zA-Z0-9]$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) ((_ re.loop 2 8) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "_") (str.to_re "."))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
