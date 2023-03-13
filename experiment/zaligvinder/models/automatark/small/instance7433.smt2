(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^ *(([\.\-\+\w]{2,}[a-z0-9])@([\.\-\w]+[a-z0-9])\.([a-z]{2,3})) *(; *(([\.\-\+\w]{2,}[a-z0-9])@([\.\-\w]+[a-z0-9])\.([a-z]{2,3})) *)* *$
(assert (not (str.in_re X (re.++ (re.* (str.to_re " ")) (re.* (str.to_re " ")) (re.* (re.++ (str.to_re ";") (re.* (str.to_re " ")) (re.* (str.to_re " ")) (str.to_re "@.") ((_ re.loop 2 3) (re.range "a" "z")) (re.union (re.range "a" "z") (re.range "0" "9")) ((_ re.loop 2 2) (re.union (str.to_re ".") (str.to_re "-") (str.to_re "+") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re ".") (str.to_re "-") (str.to_re "+") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (re.range "a" "z") (re.range "0" "9")))) (re.* (str.to_re " ")) (str.to_re "\u{0a}@.") ((_ re.loop 2 3) (re.range "a" "z")) (re.union (re.range "a" "z") (re.range "0" "9")) ((_ re.loop 2 2) (re.union (str.to_re ".") (str.to_re "-") (str.to_re "+") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re ".") (str.to_re "-") (str.to_re "+") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (re.range "a" "z") (re.range "0" "9"))))))
; (^\d{5}$)|(^\d{5}-\d{4}$)
(assert (str.in_re X (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))))
; [AaEeIiOoUuYy]
(assert (str.in_re X (re.++ (re.union (str.to_re "A") (str.to_re "a") (str.to_re "E") (str.to_re "e") (str.to_re "I") (str.to_re "i") (str.to_re "O") (str.to_re "o") (str.to_re "U") (str.to_re "u") (str.to_re "Y") (str.to_re "y")) (str.to_re "\u{0a}"))))
; ^([0-9]{2})(00[1-9]|0[1-9][0-9]|[1-2][0-9][0-9]|3[0-5][0-9]|36[0-6])$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "00") (re.range "1" "9")) (re.++ (str.to_re "0") (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "36") (re.range "0" "6"))) (str.to_re "\u{0a}"))))
; Referer\x3A.*User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Referer:") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}")))))
(check-sat)
