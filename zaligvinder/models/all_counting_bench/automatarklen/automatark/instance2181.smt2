(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d{3}\-\d{2}\-\d{4})
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))))
; ^0?[0-9]?[0-9]$|^(100)$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "0")) (re.opt (re.range "0" "9")) (re.range "0" "9")) (str.to_re "100\u{0a}")))))
; (\A|\s)((\)+|\(+|\}+|\{+|\]+|\[+|\|+|\\+|/+|>+|<+|D+|[@#!OoXxZS$0])[-~+o]?[,*]?((<[:;=+])|[<:;=+])|(\)+|\(+|\}+|\{+|\]+|\[+|\|+|\\+|/+|>+|<+|D+)[-~+o]?[xX8]<?)(\Z|\s)
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.union (re.+ (str.to_re ")")) (re.+ (str.to_re "(")) (re.+ (str.to_re "}")) (re.+ (str.to_re "{")) (re.+ (str.to_re "]")) (re.+ (str.to_re "[")) (re.+ (str.to_re "|")) (re.+ (str.to_re "\u{5c}")) (re.+ (str.to_re "/")) (re.+ (str.to_re ">")) (re.+ (str.to_re "<")) (re.+ (str.to_re "D")) (str.to_re "@") (str.to_re "#") (str.to_re "!") (str.to_re "O") (str.to_re "o") (str.to_re "X") (str.to_re "x") (str.to_re "Z") (str.to_re "S") (str.to_re "$") (str.to_re "0")) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.opt (re.union (str.to_re ",") (str.to_re "*"))) (re.union (re.++ (str.to_re "<") (re.union (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "+"))) (str.to_re "<") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "+"))) (re.++ (re.union (re.+ (str.to_re ")")) (re.+ (str.to_re "(")) (re.+ (str.to_re "}")) (re.+ (str.to_re "{")) (re.+ (str.to_re "]")) (re.+ (str.to_re "[")) (re.+ (str.to_re "|")) (re.+ (str.to_re "\u{5c}")) (re.+ (str.to_re "/")) (re.+ (str.to_re ">")) (re.+ (str.to_re "<")) (re.+ (str.to_re "D"))) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.union (str.to_re "x") (str.to_re "X") (str.to_re "8")) (re.opt (str.to_re "<")))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
; Ts2\x2F\s+insertinfoSnakeUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Ts2/") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "insertinfoSnakeUser-Agent:\u{0a}")))))
; (AUX|PRN|NUL|COM\d|LPT\d)+\s*$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "AUX") (str.to_re "PRN") (str.to_re "NUL") (re.++ (str.to_re "COM") (re.range "0" "9")) (re.++ (str.to_re "LPT") (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
