(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \+44\s\(0\)\s\d{2}\s\d{4}\s\d{4}
(assert (not (str.in_re X (re.++ (str.to_re "+44") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "(0)") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (\d{1,3}[\.]\d*)[, ]+-?(\d{1,3}[\.]\d*)
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re ",") (str.to_re " "))) (re.opt (str.to_re "-")) (str.to_re "\u{0a}") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")))))
; ^[1-4]\d{3}\/((0?[1-6]\/((3[0-1])|([1-2][0-9])|(0?[1-9])))|((1[0-2]|(0?[7-9]))\/(30|([1-2][0-9])|(0?[1-9]))))$
(assert (str.in_re X (re.++ (re.range "1" "4") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "6") (str.to_re "/") (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")))) (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (re.opt (str.to_re "0")) (re.range "7" "9"))) (str.to_re "/") (re.union (str.to_re "30") (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))))) (str.to_re "\u{0a}"))))
; /\.makeMeasurement\s*\u{28}[^\u{3b}]+?Array/i
(assert (not (str.in_re X (re.++ (str.to_re "/.makeMeasurement") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ";"))) (str.to_re "Array/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
