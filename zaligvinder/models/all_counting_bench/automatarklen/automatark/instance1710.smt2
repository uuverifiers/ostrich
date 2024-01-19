(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[-+]?((\d*|((\d{1,3})?,(\d{3},)*(\d{3})))?)(\.\d*)?([eE][-+]\d+)?$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.union (re.* (re.range "0" "9")) (re.++ (re.opt ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.opt (re.++ (str.to_re ".") (re.* (re.range "0" "9")))) (re.opt (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.union (str.to_re "-") (str.to_re "+")) (re.+ (re.range "0" "9")))) (str.to_re "/\u{0a}"))))
; search\u{2e}conduit\u{2e}com\sPARSER.*
(assert (str.in_re X (re.++ (str.to_re "search.conduit.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PARSER") (re.* re.allchar) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
