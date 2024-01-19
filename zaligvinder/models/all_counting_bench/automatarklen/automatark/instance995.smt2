(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A1\-extreme\x2EbizX-Mailer\u{3a}www\x2Ewebcruiser\x2Ecc
(assert (not (str.in_re X (str.to_re "Host:1-extreme.bizX-Mailer:\u{13}www.webcruiser.cc\u{0a}"))))
; User-Agent\u{3a}User-Agent\x3A
(assert (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}")))
; (^(4|5)\d{3}-?\d{4}-?\d{4}-?\d{4}|(4|5)\d{15})|(^(6011)-?\d{4}-?\d{4}-?\d{4}|(6011)-?\d{12})|(^((3\d{3}))-\d{6}-\d{5}|^((3\d{14})))
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "-") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "3") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "3") ((_ re.loop 14 14) (re.range "0" "9")))) (str.to_re "\u{0a}")) (re.++ (re.union (str.to_re "4") (str.to_re "5")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (str.to_re "4") (str.to_re "5")) ((_ re.loop 15 15) (re.range "0" "9"))) (re.++ (str.to_re "6011") (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "6011") (re.opt (str.to_re "-")) ((_ re.loop 12 12) (re.range "0" "9"))))))
; \{[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}\}
(assert (not (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "}\u{0a}")))))
; Handyst=ClassStopperHost\x3ASpamBlockerUtility
(assert (str.in_re X (str.to_re "Handyst=ClassStopperHost:SpamBlockerUtility\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
