(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+twfofrfzlugq\u{2f}eve\.qd\s+\x2Ftoolbar\x2Fsupremetb
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "twfofrfzlugq/eve.qd") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/supremetb\u{0a}"))))
; ^[a-zA-Z]{1,3}\[([0-9]{1,3})\]
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "[") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "]\u{0a}"))))
; onAlertMGS-Internal-Web-Manager
(assert (not (str.in_re X (str.to_re "onAlertMGS-Internal-Web-Manager\u{0a}"))))
(check-sat)
