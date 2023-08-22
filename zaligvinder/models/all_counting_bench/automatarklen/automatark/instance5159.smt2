(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z1-9]*)\.(((a|A)(s|S)(p|P)(x|X))|((h|H)(T|t)(m|M)(l|L))|((h|H)(t|T)(M|m))|((a|A)(s|S)(p|P)))
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "1" "9"))) (str.to_re ".") (re.union (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "x") (str.to_re "X"))) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.union (str.to_re "T") (str.to_re "t")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "l") (str.to_re "L"))) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.union (str.to_re "t") (str.to_re "T")) (re.union (str.to_re "M") (str.to_re "m"))) (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "p") (str.to_re "P")))) (str.to_re "\u{0a}")))))
; ^([\w\._-]){3,}\@([\w\-_.]){3,}\.(\w){2,4}$
(assert (str.in_re X (re.++ (str.to_re "@.") ((_ re.loop 2 4) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (str.to_re ".") (str.to_re "_") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re ".") (str.to_re "_") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 3 3) (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; Monitor\s+SupervisorPalUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Monitor") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SupervisorPalUser-Agent:\u{0a}")))))
; ^(s-|S-){0,1}[0-9]{3}\s?[0-9]{2}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "s-") (str.to_re "S-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
