(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=\u{22}\d+\u{22}\r\n/P
(assert (not (str.in_re X (re.++ (str.to_re "/filename=\u{22}") (re.+ (re.range "0" "9")) (str.to_re "\u{22}\u{0d}\u{0a}/P\u{0a}")))))
; (0?[1-9]|[12][0-9]|3[01])-(0?[1-9]|1[012])-((19|20)\\d\\d)
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "-") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re "-\u{0a}") (re.union (str.to_re "19") (str.to_re "20")) (str.to_re "\u{5c}d\u{5c}d")))))
; ^[^iIoOqQ'-]{10,17}$
(assert (not (str.in_re X (re.++ ((_ re.loop 10 17) (re.union (str.to_re "i") (str.to_re "I") (str.to_re "o") (str.to_re "O") (str.to_re "q") (str.to_re "Q") (str.to_re "'") (str.to_re "-"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}hpj/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".hpj/i\u{0a}"))))
(check-sat)
