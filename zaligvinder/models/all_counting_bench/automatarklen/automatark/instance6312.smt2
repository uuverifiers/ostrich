(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /Libs\/Starter(CmdExec|NetUtils|Rec|ScreenShots|Settings)\.py/
(assert (str.in_re X (re.++ (str.to_re "/Libs/Starter") (re.union (str.to_re "CmdExec") (str.to_re "NetUtils") (str.to_re "Rec") (str.to_re "ScreenShots") (str.to_re "Settings")) (str.to_re ".py/\u{0a}"))))
; ^[ a - z, 0 - 9 , ?   -   ?   ,?   -   ? , ?    -  ?   ,?   -  ? , . ]
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "a") (re.range " " " ") (str.to_re "z") (str.to_re ",") (str.to_re "0") (str.to_re "9") (str.to_re "?") (str.to_re ".")) (str.to_re "\u{0a}")))))
; ^((((0[13578])|(1[02]))[\/]?(([0-2][0-9])|(3[01])))|(((0[469])|(11))[\/]?(([0-2][0-9])|(30)))|(02[\/]?[0-2][0-9]))[\/]?\d{4}$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (re.opt (str.to_re "/")) (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))))) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (re.opt (str.to_re "/")) (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (str.to_re "30"))) (re.++ (str.to_re "02") (re.opt (str.to_re "/")) (re.range "0" "2") (re.range "0" "9"))) (re.opt (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(b|B)(f|F)(p|P)(o|O)(\s*||\s*C(/|)O\s*)[0-9]{1,4}
(assert (not (str.in_re X (re.++ (re.union (str.to_re "b") (str.to_re "B")) (re.union (str.to_re "f") (str.to_re "F")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "o") (str.to_re "O")) (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "C/O") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(\d{1,3},)?(\d{3},)+\d{3}(\.\d*)?$|^(\d*)(\.\d*)?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ","))) (re.+ (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.* (re.range "0" "9"))))) (re.++ (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.* (re.range "0" "9")))) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
