(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b(0?[1-9]|1[0-2])(\-)(0?[1-9]|1[0-9]|2[0-9]|3[0-1])(\-)(0[0-8])\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "-") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "-\u{0a}0") (re.range "0" "8")))))
; Host\x3A\s+ulmxct\u{2f}mqoycWinSession\x2Fclient\x2F\x2APORT1\x2A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ulmxct/mqoycWinSession/client/*PORT1*\u{0a}"))))
; ^(\+?36)?[ -]?(\d{1,2}|(\(\d{1,2}\)))/?([ -]?\d){6,7}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (str.to_re "36"))) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "(") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ")"))) (re.opt (str.to_re "/")) ((_ re.loop 6 7) (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
