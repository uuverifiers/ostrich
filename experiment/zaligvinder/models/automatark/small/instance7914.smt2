(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\A|\s)(((>[:;=+])|[>:;=+])[,*]?[-~+o]?(\)+|\(+|\}+|\{+|\]+|\[+|\|+|\\+|/+|>+|<+|D+|[@#!OoPpXxZS$03])|>?[xX8][-~+o]?(\)+|\(+|\}+|\{+|\]+|\[+|\|+|\\+|/+|>+|<+|D+))(\Z|\s)
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.union (re.++ (str.to_re ">") (re.union (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "+"))) (str.to_re ">") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "+")) (re.opt (re.union (str.to_re ",") (str.to_re "*"))) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.union (re.+ (str.to_re ")")) (re.+ (str.to_re "(")) (re.+ (str.to_re "}")) (re.+ (str.to_re "{")) (re.+ (str.to_re "]")) (re.+ (str.to_re "[")) (re.+ (str.to_re "|")) (re.+ (str.to_re "\u{5c}")) (re.+ (str.to_re "/")) (re.+ (str.to_re ">")) (re.+ (str.to_re "<")) (re.+ (str.to_re "D")) (str.to_re "@") (str.to_re "#") (str.to_re "!") (str.to_re "O") (str.to_re "o") (str.to_re "P") (str.to_re "p") (str.to_re "X") (str.to_re "x") (str.to_re "Z") (str.to_re "S") (str.to_re "$") (str.to_re "0") (str.to_re "3"))) (re.++ (re.opt (str.to_re ">")) (re.union (str.to_re "x") (str.to_re "X") (str.to_re "8")) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.union (re.+ (str.to_re ")")) (re.+ (str.to_re "(")) (re.+ (str.to_re "}")) (re.+ (str.to_re "{")) (re.+ (str.to_re "]")) (re.+ (str.to_re "[")) (re.+ (str.to_re "|")) (re.+ (str.to_re "\u{5c}")) (re.+ (str.to_re "/")) (re.+ (str.to_re ">")) (re.+ (str.to_re "<")) (re.+ (str.to_re "D"))))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
; User-Agent\x3ABetaWordixqshv\u{2f}qzccsServer\u{00}
(assert (not (str.in_re X (str.to_re "User-Agent:BetaWordixqshv/qzccsServer\u{00}\u{0a}"))))
; (^3[47])((\d{11}$)|(\d{13}$))
(assert (str.in_re X (re.++ (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 13) (re.range "0" "9"))) (str.to_re "\u{0a}3") (re.union (str.to_re "4") (str.to_re "7")))))
(check-sat)