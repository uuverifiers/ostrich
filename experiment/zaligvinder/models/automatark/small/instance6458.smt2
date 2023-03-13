(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}lzh/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".lzh/i\u{0a}"))))
; (\+1|\+|1)|([^0-9])
(assert (str.in_re X (re.union (re.++ (re.range "0" "9") (str.to_re "\u{0a}")) (str.to_re "+1") (str.to_re "+") (str.to_re "1"))))
; <\?xml.*</note>
(assert (str.in_re X (re.++ (str.to_re "<?xml") (re.* re.allchar) (str.to_re "</note>\u{0a}"))))
; ^(([1-9])|(0[1-9])|(1[0-2]))\/(([0-9])|([0-2][0-9])|(3[0-1]))\/(([0-9][0-9])|([1-2][0,9][0-9][0-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.range "0" "9") (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "9")) (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^((((0?[13578])|(1[02]))[\/|\-]?((0?[1-9]|[0-2][0-9])|(3[01])))|(((0?[469])|(11))[\/|\-]?((0?[1-9]|[0-2][0-9])|(30)))|(0?[2][\/\-]?(0?[1-9]|[0-2][0-9])))[\/\-]?\d{2,4}$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (re.opt (re.union (str.to_re "/") (str.to_re "|") (str.to_re "-"))) (re.union (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (re.opt (re.union (str.to_re "/") (str.to_re "|") (str.to_re "-"))) (re.union (str.to_re "30") (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (re.opt (str.to_re "0")) (str.to_re "2") (re.opt (re.union (str.to_re "/") (str.to_re "-"))) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "0" "2") (re.range "0" "9"))))) (re.opt (re.union (str.to_re "/") (str.to_re "-"))) ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
