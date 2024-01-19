(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\d+\/\d\.zip$/U
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re "/") (re.range "0" "9") (str.to_re ".zip/U\u{0a}"))))
; ^(([0-9])|([0-2][0-9])|(3[0-1]))\/(([1-9])|(0[1-9])|(1[0-2]))\/(([0-9][0-9])|([1-2][0,9][0-9][0-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "9")) (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^[ \w]{3,}([A-Za-z]\.)?([ \w]*\#\d+)?(\r\n| )[ \w]{3,},\u{20}[A-Za-z]{2}\u{20}\d{5}(-\d{4})?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (str.to_re "."))) (re.opt (re.++ (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "#") (re.+ (re.range "0" "9")))) (re.union (str.to_re "\u{0d}\u{0a}") (str.to_re " ")) (str.to_re ", ") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re " ") ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 3 3) (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; Toolbar\dcount\x2Eyok\x2EcomweatherHost\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.range "0" "9") (str.to_re "count.yok.comweatherHost:User-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
