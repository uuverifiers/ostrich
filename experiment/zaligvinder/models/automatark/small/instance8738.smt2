(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; source%3Dultrasearch136%26campaign%3DsnapuplogWinInet3Azopabora\x2Einfo
(assert (not (str.in_re X (str.to_re "source%3Dultrasearch136%26campaign%3DsnapuplogWinInet3Azopabora.info\u{0a}"))))
; ^(\(\d{3}\)|\d{3})[\s.-]?\d{3}[\s.-]?\d{4}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \x7D\x7BPort\x3AHost\x3Amqnqgijmng\u{2f}ojNavhelperUser-Agent\x3A
(assert (str.in_re X (str.to_re "}{Port:Host:mqnqgijmng/ojNavhelperUser-Agent:\u{0a}")))
(check-sat)
