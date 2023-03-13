(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0|(\+)?([1-9]{1}[0-9]{0,3})|([1-5]{1}[0-9]{1,4}|[6]{1}([0-4]{1}[0-9]{3}|[5]{1}([0-4]{1}[0-9]{2}|[5]{1}([0-2]{1}[0-9]{1}|[3]{1}[0-5]{1})))))$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "5")) ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "6")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "3")) ((_ re.loop 1 1) (re.range "0" "5")))))))))) (str.to_re "\u{0a}")))))
; SystemSleuth1\x2E0versionHost\x3AArrowHost\u{3a}3Awebsearch\x2Edrsnsrch\x2EcomhostieiWonHost\u{3a}pjpoptwql\u{2f}rlnj
(assert (not (str.in_re X (str.to_re "SystemSleuth\u{13}1.0versionHost:ArrowHost:3Awebsearch.drsnsrch.com\u{13}hostieiWonHost:pjpoptwql/rlnj\u{0a}"))))
; 1?[ \.\-\+]?[(]?([0-9]{3})?[)]?[ \.\-\+]?[0-9]{3}[ \.\-\+]?[0-9]{4}
(assert (str.in_re X (re.++ (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-") (str.to_re "+"))) (re.opt (str.to_re "(")) (re.opt ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-") (str.to_re "+"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-") (str.to_re "+"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
