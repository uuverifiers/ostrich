(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\<!--\s*.*?((--\>)|$))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}<!--") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar) (str.to_re "-->")))))
; ^((\\){2})(([A-Za-z ',.;]+)(\\?)([A-Za-z ',.;]\\?)*)$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (str.to_re "\u{5c}")) (str.to_re "\u{0a}") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";"))) (re.opt (str.to_re "\u{5c}")) (re.* (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";")) (re.opt (str.to_re "\u{5c}"))))))))
(assert (> (str.len X) 10))
(check-sat)
