(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (".+"\s)?<?[a-z\._0-9]+[^\._]@([a-z0-9]+\.)+[a-z0-9]{2,6}>?;?
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "\u{22}") (re.+ re.allchar) (str.to_re "\u{22}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.opt (str.to_re "<")) (re.+ (re.union (re.range "a" "z") (str.to_re ".") (str.to_re "_") (re.range "0" "9"))) (re.union (str.to_re ".") (str.to_re "_")) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "."))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.opt (str.to_re ">")) (re.opt (str.to_re ";")) (str.to_re "\u{0a}"))))
(check-sat)
