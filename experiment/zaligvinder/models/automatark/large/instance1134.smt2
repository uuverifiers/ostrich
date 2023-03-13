(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([1..9])|(0[1..9])|(1\d)|(2\d)|(3[0..1])).((\d)|(0\d)|(1[0..2])).(\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re ".") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re ".") (str.to_re "1"))) (str.to_re "1") (str.to_re ".") (str.to_re "9")) re.allchar (re.union (re.range "0" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re ".") (str.to_re "2")))) re.allchar ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}tte/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tte/i\u{0a}")))))
; (^(\d{2}.\d{3}.\d{3}/\d{4}-\d{2})|(\d{14})$)|(^(\d{3}.\d{3}.\d{3}-\d{2})|(\d{11})$)
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 11 11) (re.range "0" "9"))) (str.to_re "\u{0a}")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 14 14) (re.range "0" "9"))))))
; 12/err
(assert (str.in_re X (str.to_re "12/err\u{0a}")))
; /gate\u{2e}php\u{3f}reg=[a-zA-Z]{15}/U
(assert (not (str.in_re X (re.++ (str.to_re "/gate.php?reg=") ((_ re.loop 15 15) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/U\u{0a}")))))
(check-sat)
