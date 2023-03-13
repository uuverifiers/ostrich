(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Ready\s+Toolbar\d+ServerLiteToolbar
(assert (not (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "ServerLiteToolbar\u{0a}")))))
; ^((19|20)\d\d)[- /.](([1-9]|[0][1-9]|1[012]))[- /.](([1-9]|[0][1-9]|1[012])|([12][0-9]|3[01]))$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "-") (str.to_re " ") (str.to_re "/") (str.to_re ".")) (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "/") (str.to_re ".")) (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2"))) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "\u{0a}") (re.union (str.to_re "19") (str.to_re "20")) (re.range "0" "9") (re.range "0" "9")))))
; &#\d{2,5};
(assert (str.in_re X (re.++ (str.to_re "&#") ((_ re.loop 2 5) (re.range "0" "9")) (str.to_re ";\u{0a}"))))
(check-sat)
