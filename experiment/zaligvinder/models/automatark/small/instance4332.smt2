(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{1}(\.\d{3})-\d{3}(\.\d{1})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}.") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9"))))))
; searchnugget.*Referer\x3A\s+User-Agent\x3AHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "searchnugget\u{13}") (re.* re.allchar) (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:Host:\u{0a}")))))
(check-sat)
