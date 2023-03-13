(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]{2}[0-9]{3})|([A-Z]{2}[\ ][0-9]{3})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")))))))
; \[DRIVE\w+updates[^\n\r]*\u{22}StarLogger\u{22}User-Agent\x3AJMailUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "[DRIVE") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "updates") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}StarLogger\u{22}User-Agent:JMailUser-Agent:\u{0a}")))))
; ^([0-1][0-9]|2[0-3]){1}:([0-5][0-9]){1}:([0-5][0-9]){1},([0-9][0-9][0-9]){1} --> ([0-1][0-9]|2[0-3]){1}:([0-5][0-9]){1}:([0-5][0-9]){1},([0-9][0-9][0-9]){1}(.*)$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 1 1) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re " --> ") ((_ re.loop 1 1) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 1 1) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (re.* re.allchar) (str.to_re "\u{0a}"))))
(check-sat)
