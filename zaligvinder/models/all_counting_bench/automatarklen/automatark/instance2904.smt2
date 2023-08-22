(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]*\-?\ ?\/?[0-9]*)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) (re.opt (str.to_re "/")) (re.* (re.range "0" "9")))))
; ^(\+|-)?(\d\.\d{1,6}|[1-9]\d\.\d{1,6}|1[1-7]\d\.\d{1,6}|180\.0{1,6})$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.++ (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.range "1" "7") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (str.to_re "180.") ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}"))))
; [^!~/><\|/#%():;{}`_-]
(assert (not (str.in_re X (re.++ (re.union (str.to_re "!") (str.to_re "~") (str.to_re "/") (str.to_re ">") (str.to_re "<") (str.to_re "|") (str.to_re "#") (str.to_re "%") (str.to_re "(") (str.to_re ")") (str.to_re ":") (str.to_re ";") (str.to_re "{") (str.to_re "}") (str.to_re "`") (str.to_re "_") (str.to_re "-")) (str.to_re "\u{0a}")))))
; ^[1-9]{1}[0-9]{3} ?[A-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
