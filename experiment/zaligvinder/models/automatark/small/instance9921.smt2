(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; target[ ]*[=]([ ]*)(["]|['])*([_])*([A-Za-z0-9])+(["])*
(assert (not (str.in_re X (re.++ (str.to_re "target") (re.* (str.to_re " ")) (str.to_re "=") (re.* (str.to_re " ")) (re.* (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.* (str.to_re "_")) (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.* (str.to_re "\u{22}")) (str.to_re "\u{0a}")))))
; (-?(\d*\.\d{1}?\d*|\d{1,}))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (re.union (re.++ (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.+ (re.range "0" "9")))))))
; ProjectMyWebSearchSearchAssistantfast-look\x2EcomOneReporter
(assert (not (str.in_re X (str.to_re "ProjectMyWebSearchSearchAssistantfast-look.comOneReporter\u{0a}"))))
; ^([0]\d|[1][0-2])\/([0-2]\d|[3][0-1])\/([2][01]|[1][6-9])\d{2}(\s([0-1]\d|[2][0-3])(\:[0-5]\d){1,2})?$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (str.to_re "1") (re.range "6" "9"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) ((_ re.loop 1 2) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
(check-sat)
