(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ShadowNetMyAgentServerconfigINTERNAL\.iniKeylogger-Prosearchreslt
(assert (str.in_re X (str.to_re "ShadowNetMyAgentServerconfigINTERNAL.iniKeylogger-Prosearchreslt\u{0a}")))
; ^((\d{1,3}(,\d{3})*)|(\d{1,3}))$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^(1[0-2]|0?[1-9]):([0-5]?[0-9])( AM| PM)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (str.to_re ":\u{0a}") (re.opt (re.range "0" "5")) (re.range "0" "9") (str.to_re " ") (re.union (str.to_re "AM") (str.to_re "PM"))))))
; /filename=[^\n]*\u{2e}met/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".met/i\u{0a}")))))
; style="[^"]*"|'[^']*'
(assert (str.in_re X (re.union (re.++ (str.to_re "style=\u{22}") (re.* (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}")) (re.++ (str.to_re "'") (re.* (re.comp (str.to_re "'"))) (str.to_re "'\u{0a}")))))
(check-sat)
