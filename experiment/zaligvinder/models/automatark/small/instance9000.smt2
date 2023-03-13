(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [+]346[0-9]{8}
(assert (not (str.in_re X (re.++ (str.to_re "+346") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; richfind\x2Ecomdcww\x2Edmcast\x2Ecom
(assert (str.in_re X (str.to_re "richfind.comdcww.dmcast.com\u{0a}")))
; Port\s+AgentHost\x3Ainsertkeys\x3Ckeys\u{40}hotpop
(assert (str.in_re X (re.++ (str.to_re "Port") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AgentHost:insertkeys<keys@hotpop\u{0a}"))))
; (\/\*(\s*|.*?)*\*\/)|(--.*)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/*") (re.* (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar))) (str.to_re "*/")) (re.++ (str.to_re "\u{0a}--") (re.* re.allchar))))))
(check-sat)
