(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-2]\d|3[0-1]|[1-9])\/(0\d|1[0-2]|[1-9])\/(\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1")) (re.range "1" "9")) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; [\w!#$%&&apos;*+./=?`{|}~^-]+@[\d.A-Za-z-]+
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "!") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "&") (str.to_re "a") (str.to_re "p") (str.to_re "o") (str.to_re "s") (str.to_re ";") (str.to_re "*") (str.to_re "+") (str.to_re ".") (str.to_re "/") (str.to_re "=") (str.to_re "?") (str.to_re "`") (str.to_re "{") (str.to_re "|") (str.to_re "}") (str.to_re "~") (str.to_re "^") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (str.to_re ".") (re.range "A" "Z") (re.range "a" "z") (str.to_re "-"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
