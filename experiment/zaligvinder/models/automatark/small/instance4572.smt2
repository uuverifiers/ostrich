(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ProAgentHost\x3ALOGSeconds\-
(assert (str.in_re X (str.to_re "ProAgentHost:LOGSeconds-\u{0a}")))
; ShadowNetMyAgentServerconfigINTERNAL\.iniKeylogger-Prosearchreslt
(assert (str.in_re X (str.to_re "ShadowNetMyAgentServerconfigINTERNAL.iniKeylogger-Prosearchreslt\u{0a}")))
; <asp:requiredfieldvalidator(\s*\w+\s*=\s*\"?\s*\w+\s*\"?\s*)+\s*>\s*<\/asp:requiredfieldvalidator>
(assert (not (str.in_re X (re.++ (str.to_re "<asp:requiredfieldvalidator") (re.+ (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "\u{22}")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "\u{22}")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ">") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "</asp:requiredfieldvalidator>\u{0a}")))))
; c\.goclick\.com[^\n\r]*is\s+URLBlaze
(assert (not (str.in_re X (re.++ (str.to_re "c.goclick.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlaze\u{0a}")))))
; \d{1,2}d \d{1,2}h
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "d ") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h\u{0a}")))))
(check-sat)
