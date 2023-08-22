(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <\s*a\s[^>]*\bhref\s*=\s*
(assert (str.in_re X (re.++ (str.to_re "<") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "a") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.* (re.comp (str.to_re ">"))) (str.to_re "href") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^((\\){2})(([A-Za-z ',.;]+)(\\?)([A-Za-z ',.;]\\?)*)$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (str.to_re "\u{5c}")) (str.to_re "\u{0a}") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";"))) (re.opt (str.to_re "\u{5c}")) (re.* (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";")) (re.opt (str.to_re "\u{5c}")))))))
; search\u{2e}conduit\u{2e}com\sPARSER.*
(assert (not (str.in_re X (re.++ (str.to_re "search.conduit.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PARSER") (re.* re.allchar) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
