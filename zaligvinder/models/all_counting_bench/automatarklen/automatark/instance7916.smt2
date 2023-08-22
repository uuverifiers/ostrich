(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((([1]?\d)?\d|2[0-4]\d|25[0-5])\.){3}(([1]?\d)?\d|2[0-4]\d|25[0-5]))|([\da-fA-F]{1,4}(\:[\da-fA-F]{1,4}){7})|(([\da-fA-F]{1,4}:){0,5}::([\da-fA-F]{1,4}:){0,5}[\da-fA-F]{1,4})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "1")) (re.range "0" "9"))) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "."))) (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "1")) (re.range "0" "9"))) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")))) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 7 7) (re.++ (str.to_re ":") ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")))))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 0 5) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re ":"))) (str.to_re "::") ((_ re.loop 0 5) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re ":"))) ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))))))
; /\u{2f}x\u{2f}[0-9a-z]{8,10}\u{2f}[0-9a-f]{32}\u{2f}AA\u{2f}0$/U
(assert (str.in_re X (re.++ (str.to_re "//x/") ((_ re.loop 8 10) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/AA/0/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
