(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; http\s+Host\x3A[^\n\r]*WinInet3Azopabora\x2Einfo\x2Fnotifier\x2FUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "http") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "WinInet3Azopabora.info/notifier/User-Agent:\u{0a}"))))
; /User\u{2d}Agent\u{3a}\u{20}[A-F\d]{32}\r\n/H
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent: ") ((_ re.loop 32 32) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "\u{0d}\u{0a}/H\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
