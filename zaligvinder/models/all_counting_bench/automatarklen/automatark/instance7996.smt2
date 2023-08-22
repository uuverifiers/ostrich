(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [\\""=:;,](([\w][\w\-\.]*)\.)?([\w][\w\-]+)(\.([\w][\w\.]*))?\\sql\d{1,3}[\\""=:;,]
(assert (str.in_re X (re.++ (re.union (str.to_re "\u{5c}") (str.to_re "\u{22}") (str.to_re "=") (str.to_re ":") (str.to_re ";") (str.to_re ",")) (re.opt (re.++ (str.to_re ".") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.opt (re.++ (str.to_re ".") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{5c}sql") ((_ re.loop 1 3) (re.range "0" "9")) (re.union (str.to_re "\u{5c}") (str.to_re "\u{22}") (str.to_re "=") (str.to_re ":") (str.to_re ";") (str.to_re ",")) (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
(assert (> (str.len X) 10))
(check-sat)
