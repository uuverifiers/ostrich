(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; http\s+Host\x3A[^\n\r]*WinInet3Azopabora\x2Einfo\x2Fnotifier\x2FUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "http") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "WinInet3Azopabora.info/notifier/User-Agent:\u{0a}"))))
; ^[A][Z](.?)[0-9]{4}$
(assert (str.in_re X (re.++ (str.to_re "AZ") (re.opt re.allchar) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
