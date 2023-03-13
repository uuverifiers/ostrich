(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; configINTERNAL\.ini.*SecureNet\s+User-Agent\x3Aregister\.asp
(assert (not (str.in_re X (re.++ (str.to_re "configINTERNAL.ini") (re.* re.allchar) (str.to_re "SecureNet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:register.asp\u{0a}")))))
; on\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "on") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}"))))
; /\u{2e}asx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.asx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; for mobile:^[0][1-9]{1}[0-9]{9}$
(assert (str.in_re X (re.++ (str.to_re "for mobile:0") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
