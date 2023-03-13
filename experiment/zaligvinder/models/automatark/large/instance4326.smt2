(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}ram?([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.ra") (re.opt (str.to_re "m")) (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; Host\x3A\s+Host\x3A.*c=MicrosoftStartupStarLoggerServerX-Mailer\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "c=MicrosoftStartupStarLoggerServerX-Mailer:\u{13}\u{0a}"))))
; ^[0-9]{10}GBR[0-9]{7}[U,M,F]{1}[0-9]{9}$
(assert (not (str.in_re X (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "GBR") ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "U") (str.to_re ",") (str.to_re "M") (str.to_re "F"))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ShadowNet\s+AID\x2FUser-Agent\x3AFen\u{ea}treEye\x2Fdss\x2Fcc\.2_0_0\.
(assert (not (str.in_re X (re.++ (str.to_re "ShadowNet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AID/User-Agent:Fen\u{ea}treEye/dss/cc.2_0_0.\u{0a}")))))
; /[1-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}/H
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "1" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/H\u{0a}"))))
(check-sat)
