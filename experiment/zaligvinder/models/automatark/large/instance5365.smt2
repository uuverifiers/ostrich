(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}ppt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppt/i\u{0a}"))))
; ^[+]?\d*$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; SbAts[^\n\r]*Subject\u{3a}\d+dcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "SbAts") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Subject:") (re.+ (re.range "0" "9")) (str.to_re "dcww.dmcast.com\u{0a}")))))
; comUser-Agent\x3Asi=PORT\x3D\x2Fpagead\x2Fads\?Host\u{3a}\x2Fdesktop\x2F
(assert (str.in_re X (str.to_re "comUser-Agent:si=PORT=/pagead/ads?Host:/desktop/\u{0a}")))
; /[a-z\d\u{2f}\u{2b}\u{3d}]{100}/AGPi
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 100 100) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "/") (str.to_re "+") (str.to_re "="))) (str.to_re "/AGPi\u{0a}"))))
(check-sat)
