(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([+]?\d[ ]?[(]?\d{3}[)]?[ ]?\d{2,3}[- ]?\d{2}[- ]?\d{2})
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "+")) (re.range "0" "9") (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re " ")) ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 2 2) (re.range "0" "9"))))))
; Logger.*Host\x3A.*\x2Fcommunicatortb\u{7c}roogoo\u{7c}
(assert (str.in_re X (re.++ (str.to_re "Logger") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "/communicatortb|roogoo|\u{0a}"))))
; ^([0-9]{2})?((\([0-9]{2})\)|[0-9]{2})?([0-9]{3}|[0-9]{4})(\-)?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (re.union (re.++ (str.to_re ")(") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
