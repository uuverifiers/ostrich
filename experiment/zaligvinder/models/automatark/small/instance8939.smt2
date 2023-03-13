(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; HXLogOnlyanHost\x3AspasHost\x3A
(assert (str.in_re X (str.to_re "HXLogOnlyanHost:spasHost:\u{0a}")))
; logs\d+X-Mailer\u{3a}\d+url=enews\x2Eearthlink\x2Enet
(assert (str.in_re X (re.++ (str.to_re "logs") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer:\u{13}") (re.+ (re.range "0" "9")) (str.to_re "url=enews.earthlink.net\u{0a}"))))
; Host\x3A\s+twfofrfzlugq\u{2f}eve\.qd\s+\x2Ftoolbar\x2Fsupremetb
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "twfofrfzlugq/eve.qd") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/supremetb\u{0a}")))))
; ^#?(([a-fA-F0-9]{3}){1,2})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "#")) ((_ re.loop 1 2) ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}pls/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pls/i\u{0a}")))))
(check-sat)
