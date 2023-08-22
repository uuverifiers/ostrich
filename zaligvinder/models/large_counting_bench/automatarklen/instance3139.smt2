(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}pub/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pub/i\u{0a}"))))
; /^\u{2f}[a-z\u{2d}\u{5f}]{90,97}\.php$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 90 97) (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "_"))) (str.to_re ".php/U\u{0a}"))))
; ^([a-zA-Z.\s']{1,50})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 50) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re ".") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; ^([0]?[1-9]|[1][0-2])[./-]([0]?[1-9]|[1|2][0-9]|[3][0|1])[./-]([0-9]{4}|[0-9]{2})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "1")))) (re.union (str.to_re ".") (str.to_re "/") (str.to_re "-")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
