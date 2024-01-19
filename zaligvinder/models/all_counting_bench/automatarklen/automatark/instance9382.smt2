(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ".*?"|".*$|'.*?'|'.*$
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{22}") (re.* re.allchar) (str.to_re "\u{22}")) (re.++ (str.to_re "\u{22}") (re.* re.allchar)) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "'")) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "\u{0a}")))))
; ^([0-9]{0,2})-([0-9]{0,2})-([0-9]{0,4})$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 0 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
