(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}wma/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wma/i\u{0a}")))))
; ^[A-Z0-9a-z'&()/]{0,1}[A-Z0-9a-z'&()/]{0,1}(([A-Z0-9a-z'&()/_-])|(\\s)){0,47}[A-Z0-9a-z'&()/]{1}$
(assert (str.in_re X (re.++ (re.opt (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) (re.opt (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) ((_ re.loop 0 47) (re.union (str.to_re "\u{5c}s") (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/") (str.to_re "_") (str.to_re "-"))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) (str.to_re "\u{0a}"))))
; ([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}|(\d{1,3}\.){3}\d{1,3}
(assert (str.in_re X (re.union (re.++ ((_ re.loop 7 7) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re ":"))) ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f")))) (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /(A|B|AB|O)[+-]/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "AB") (str.to_re "O")) (re.union (str.to_re "+") (str.to_re "-")) (str.to_re "/\u{0a}")))))
(check-sat)
