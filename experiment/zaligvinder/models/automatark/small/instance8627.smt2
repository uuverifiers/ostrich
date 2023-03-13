(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Easpxdata\.warezclient\.comWinCrashrunningUser-Agent\x3Awowokay
(assert (str.in_re X (str.to_re ".aspxdata.warezclient.comWinCrashrunningUser-Agent:wowokay\u{0a}")))
; body=wordHost\x3ASpediartaddrEverywareHost\x3AHost\x3A
(assert (str.in_re X (str.to_re "body=wordHost:SpediartaddrEverywareHost:Host:\u{0a}")))
; ^01[0-2]{1}[0-9]{8}
(assert (not (str.in_re X (re.++ (str.to_re "01") ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
