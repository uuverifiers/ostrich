(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1][0-9]|[0-9])[1-9]{2}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "9")) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "\u{0a}"))))
; \{CHBLOCK\:(.*?\})
(assert (not (str.in_re X (re.++ (str.to_re "{CHBLOCK:\u{0a}") (re.* re.allchar) (str.to_re "}")))))
; ^(\+65)?\d{8}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+65")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (\A|\s)((\)+|\(+|\}+|\{+|\]+|\[+|\|+|\\+|/+|>+|<+|D+|[@#!OoXxZS$0])[-~+o]?[,*]?((<[:;=+])|[<:;=+])|(\)+|\(+|\}+|\{+|\]+|\[+|\|+|\\+|/+|>+|<+|D+)[-~+o]?[xX8]<?)(\Z|\s)
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.union (re.+ (str.to_re ")")) (re.+ (str.to_re "(")) (re.+ (str.to_re "}")) (re.+ (str.to_re "{")) (re.+ (str.to_re "]")) (re.+ (str.to_re "[")) (re.+ (str.to_re "|")) (re.+ (str.to_re "\u{5c}")) (re.+ (str.to_re "/")) (re.+ (str.to_re ">")) (re.+ (str.to_re "<")) (re.+ (str.to_re "D")) (str.to_re "@") (str.to_re "#") (str.to_re "!") (str.to_re "O") (str.to_re "o") (str.to_re "X") (str.to_re "x") (str.to_re "Z") (str.to_re "S") (str.to_re "$") (str.to_re "0")) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.opt (re.union (str.to_re ",") (str.to_re "*"))) (re.union (re.++ (str.to_re "<") (re.union (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "+"))) (str.to_re "<") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "+"))) (re.++ (re.union (re.+ (str.to_re ")")) (re.+ (str.to_re "(")) (re.+ (str.to_re "}")) (re.+ (str.to_re "{")) (re.+ (str.to_re "]")) (re.+ (str.to_re "[")) (re.+ (str.to_re "|")) (re.+ (str.to_re "\u{5c}")) (re.+ (str.to_re "/")) (re.+ (str.to_re ">")) (re.+ (str.to_re "<")) (re.+ (str.to_re "D"))) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.union (str.to_re "x") (str.to_re "X") (str.to_re "8")) (re.opt (str.to_re "<")))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
(check-sat)
