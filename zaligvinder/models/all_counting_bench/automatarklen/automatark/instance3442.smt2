(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; .*(\.[Jj][Pp][Gg]|\.[Gg][Ii][Ff]|\.[Jj][Pp][Ee][Gg]|\.[Pp][Nn][Gg])
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}.") (re.union (re.++ (re.union (str.to_re "J") (str.to_re "j")) (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "G") (str.to_re "g"))) (re.++ (re.union (str.to_re "G") (str.to_re "g")) (re.union (str.to_re "I") (str.to_re "i")) (re.union (str.to_re "F") (str.to_re "f"))) (re.++ (re.union (str.to_re "J") (str.to_re "j")) (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "E") (str.to_re "e")) (re.union (str.to_re "G") (str.to_re "g"))) (re.++ (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "N") (str.to_re "n")) (re.union (str.to_re "G") (str.to_re "g")))))))
; ^\s*(([\w-]+\.)+[\w-]+|([a-zA-Z]{1}|[\w-]{2,}))@(\w+\.)+[A-Za-z]{2,5}$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "."))) (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "."))) ((_ re.loop 2 5) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; ^([0-9]{3,4})$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
