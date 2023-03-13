(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; AgentanswerHost\x3Atool\x2Eworld2\x2EcnTCwhenu\x2Ecom
(assert (not (str.in_re X (str.to_re "AgentanswerHost:tool.world2.cn\u{13}TCwhenu.com\u{13}\u{0a}"))))
; ^07[789]-\d{7}$
(assert (str.in_re X (re.++ (str.to_re "07") (re.union (str.to_re "7") (str.to_re "8") (str.to_re "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ((\+351|00351|351)?)(2\d{1}|(9(3|6|2|1)))\d{7}
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+351") (str.to_re "00351") (str.to_re "351"))) (re.union (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "9") (re.union (str.to_re "3") (str.to_re "6") (str.to_re "2") (str.to_re "1")))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\x3A\s+ulmxct\u{2f}mqoyc\s+securityOmFkbWluADROARad\x2Emokead\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ulmxct/mqoyc") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "securityOmFkbWluADROARad.mokead.com\u{0a}"))))
; \d+\s*[.'-]\s*\d+\s*[\d+.m\"]*
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re ".") (str.to_re "'") (str.to_re "-")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.range "0" "9") (str.to_re "+") (str.to_re ".") (str.to_re "m") (str.to_re "\u{22}"))) (str.to_re "\u{0a}")))))
(check-sat)
