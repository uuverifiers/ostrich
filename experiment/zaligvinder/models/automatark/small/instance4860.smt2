(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (1 )?\d{3} \d{3}-\d{4}
(assert (str.in_re X (re.++ (re.opt (str.to_re "1 ")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[-\w`~!@#$%^&*\(\)+={}|\[\]\\:";'<>?,.\/ ]*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "-") (str.to_re "`") (str.to_re "~") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "*") (str.to_re "(") (str.to_re ")") (str.to_re "+") (str.to_re "=") (str.to_re "{") (str.to_re "}") (str.to_re "|") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ":") (str.to_re "\u{22}") (str.to_re ";") (str.to_re "'") (str.to_re "<") (str.to_re ">") (str.to_re "?") (str.to_re ",") (str.to_re ".") (str.to_re "/") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; CH\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{1}|CH\d{19}
(assert (not (str.in_re X (re.++ (str.to_re "CH") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 19 19) (re.range "0" "9")) (str.to_re "\u{0a}")))))))
; /filename=[^\n]*\u{2e}exe/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".exe/i\u{0a}")))))
(check-sat)
