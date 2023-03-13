(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 3) (str.to_re "d")) (str.to_re "\u{5c}") re.allchar (str.to_re "\u{5c}") ((_ re.loop 1 3) (str.to_re "d")) (str.to_re "\u{5c}") re.allchar (str.to_re "\u{5c}") ((_ re.loop 1 3) (str.to_re "d")) (str.to_re "\u{5c}") re.allchar (str.to_re "\u{5c}") ((_ re.loop 1 3) (str.to_re "d")) (str.to_re "\u{0a}")))))
; %[\-\+0\s\#]{0,1}(\d+){0,1}(\.\d+){0,1}[hlI]{0,1}[cCdiouxXeEfgGnpsS]{1}
(assert (str.in_re X (re.++ (str.to_re "%") (re.opt (re.union (str.to_re "-") (str.to_re "+") (str.to_re "0") (str.to_re "#") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (re.opt (re.union (str.to_re "h") (str.to_re "l") (str.to_re "I"))) ((_ re.loop 1 1) (re.union (str.to_re "c") (str.to_re "C") (str.to_re "d") (str.to_re "i") (str.to_re "o") (str.to_re "u") (str.to_re "x") (str.to_re "X") (str.to_re "e") (str.to_re "E") (str.to_re "f") (str.to_re "g") (str.to_re "G") (str.to_re "n") (str.to_re "p") (str.to_re "s") (str.to_re "S"))) (str.to_re "\u{0a}"))))
(check-sat)
