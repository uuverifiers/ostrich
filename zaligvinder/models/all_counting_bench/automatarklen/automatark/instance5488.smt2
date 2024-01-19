(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ServerAgentX-Mailer\u{3a}TencentTraveler
(assert (str.in_re X (str.to_re "ServerAgentX-Mailer:\u{13}TencentTraveler\u{0a}")))
; Host\x3AHost\x3Abody=\u{25}21\u{25}21\u{25}21Optix
(assert (str.in_re X (str.to_re "Host:Host:body=%21%21%21Optix\u{13}\u{0a}")))
; ^\s*(\d{0,2})(\.?(\d*))?\s*\%?\s*$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (re.opt (str.to_re ".")) (re.* (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "%")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^[+]447\d{9}$
(assert (str.in_re X (re.++ (str.to_re "+447") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; www\.actualnames\.com.*www\.klikvipsearch\.com.*\x3C\x2Fchat\x3E
(assert (not (str.in_re X (re.++ (str.to_re "www.actualnames.com") (re.* re.allchar) (str.to_re "www.klikvipsearch.com") (re.* re.allchar) (str.to_re "</chat>\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
