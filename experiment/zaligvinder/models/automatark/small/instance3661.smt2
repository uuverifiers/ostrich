(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+ulmxct\u{2f}mqoycWinSession\x2Fclient\x2F\x2APORT1\x2A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ulmxct/mqoycWinSession/client/*PORT1*\u{0a}"))))
; \x2Fta\x2FNEWS\x2Fpassword\x3B1\x3BOptix
(assert (not (str.in_re X (str.to_re "/ta/NEWS/password;1;Optix\u{0a}"))))
; ^([1-9]|(0|1|2)[0-9]|30)(/|-)([1-9]|1[0-2]|0[1-9])(/|-)(14[0-9]{2})$
(assert (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (str.to_re "30")) (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (str.to_re "\u{0a}14") ((_ re.loop 2 2) (re.range "0" "9")))))
(check-sat)
