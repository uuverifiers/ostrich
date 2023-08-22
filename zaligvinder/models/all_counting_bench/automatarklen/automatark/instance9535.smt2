(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Easpxdata\.warezclient\.comWinCrashrunningUser-Agent\x3Awowokay
(assert (str.in_re X (str.to_re ".aspxdata.warezclient.comWinCrashrunningUser-Agent:wowokay\u{0a}")))
; ^.{2,}$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) re.allchar) (re.* re.allchar)))))
; /filename=[^\n]*\u{2e}s3m/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".s3m/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
