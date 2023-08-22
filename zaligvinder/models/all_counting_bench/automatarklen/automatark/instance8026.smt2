(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SbAts\d+dcww\x2Edmcast\x2EcomdistID=
(assert (not (str.in_re X (re.++ (str.to_re "SbAts") (re.+ (re.range "0" "9")) (str.to_re "dcww.dmcast.comdistID=\u{0a}")))))
; ^\{(.+)|^\\(.+)|(\}*)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "{") (re.+ re.allchar)) (re.++ (str.to_re "\u{5c}") (re.+ re.allchar)) (re.++ (re.* (str.to_re "}")) (str.to_re "\u{0a}"))))))
; ^[-|\+]?[0-9]{1,3}(\,[0-9]{3})*$|^[-|\+]?[0-9]+$
(assert (str.in_re X (re.union (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+"))) ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Subject\u{3a}\d+zmnjgmomgbdz\u{2f}zzmw\.gzt
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.range "0" "9")) (str.to_re "zmnjgmomgbdz/zzmw.gzt\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
