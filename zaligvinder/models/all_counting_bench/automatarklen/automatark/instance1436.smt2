(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b([0]?[1-9]|[1,2]\d|3[0,1])[-/]([0]?[1-9]|[1][0,1,2])[-/](\d{1,2}|[1][9]\d\d|[2][0]\d\d)\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re ",") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "1")))) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "1") (str.to_re "2")))) (re.union (str.to_re "-") (str.to_re "/")) (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "20") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; welcomeforToolbarHost\x3A
(assert (not (str.in_re X (str.to_re "welcomeforToolbarHost:\u{0a}"))))
; /filename=[^\n]*\u{2e}ppt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppt/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
