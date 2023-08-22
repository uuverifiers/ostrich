(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \(([0-9]{2}|0{1}((x|[0-9]){2}[0-9]{2}))\)\s*[0-9]{3,4}[- ]*[0-9]{4}
(assert (not (str.in_re X (re.++ (str.to_re "(") (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 2 2) (re.union (str.to_re "x") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re ")") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 4) (re.range "0" "9")) (re.* (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; [cC]{1}[0-9]{0,7}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "c") (str.to_re "C"))) ((_ re.loop 0 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[^<>`~!/@\#}$%:;)(_^{&*=|'+]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "<") (str.to_re ">") (str.to_re "`") (str.to_re "~") (str.to_re "!") (str.to_re "/") (str.to_re "@") (str.to_re "#") (str.to_re "}") (str.to_re "$") (str.to_re "%") (str.to_re ":") (str.to_re ";") (str.to_re ")") (str.to_re "(") (str.to_re "_") (str.to_re "^") (str.to_re "{") (str.to_re "&") (str.to_re "*") (str.to_re "=") (str.to_re "|") (str.to_re "'") (str.to_re "+"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
