(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/blog\/images\/3521\.jpg\?v\d{2}=\d{2}\u{26}tq=/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//blog/images/3521.jpg?v") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "=") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "&tq=/Ui\u{0a}")))))
; ^[A][Z](.?)[0-9]{4}$
(assert (not (str.in_re X (re.++ (str.to_re "AZ") (re.opt re.allchar) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^\$[+-]?([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(\.[0-9]{1,2})?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^\+\d{1,3}\s\d{3}\s\d{3}\s\d{4}
(assert (not (str.in_re X (re.++ (str.to_re "+") ((_ re.loop 1 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}jif/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jif/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
