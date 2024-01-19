(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SystemSleuth1\x2E0versionHost\x3AArrowHost\u{3a}3Awebsearch\x2Edrsnsrch\x2EcomhostieiWonHost\u{3a}pjpoptwql\u{2f}rlnj
(assert (str.in_re X (str.to_re "SystemSleuth\u{13}1.0versionHost:ArrowHost:3Awebsearch.drsnsrch.com\u{13}hostieiWonHost:pjpoptwql/rlnj\u{0a}")))
; ^((\+[1-9]{1}[0-9]{0,3})?\s?(\([1-9]{1}[0-9]{0,3}\)))?\s?(\b\d{1,9}\b)$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (re.++ (str.to_re "+") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 3) (re.range "0" "9")))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re ")"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2f}[a-z0-9]+\.php\?php\u{3d}receipt$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".php?php=receipt/Ui\u{0a}"))))
; /(\u{17}\u{00}|\u{00}\x5C)\u{00}e\u{00}l\u{00}s\u{00}e\u{00}x\u{00}t\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{17}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}e\u{00}l\u{00}s\u{00}e\u{00}x\u{00}t\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
