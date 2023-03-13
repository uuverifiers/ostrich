(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0[1-9]|1[0-9]|2[0-4])[0-59]\\d{7}(00[1-9]|[0-9][1-9][0-9]|[1-9][0-9][0-9]))|((0[1-9]|1[0-9]|2[0-4])6\\d{6}(000[1-9]|[0-9][0-9][1-9][0-9]|[0-9][1-9][0-9][0-9]|[1-9][0-9][0-9][0-9]))$
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) (re.union (re.range "0" "5") (str.to_re "9")) (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d")) (re.union (re.++ (str.to_re "00") (re.range "1" "9")) (re.++ (re.range "0" "9") (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) (str.to_re "6\u{5c}") ((_ re.loop 6 6) (str.to_re "d")) (re.union (re.++ (str.to_re "000") (re.range "1" "9")) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "1" "9") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9")))))))
; ^(\+86)(13[0-9]|145|147|15[0-3,5-9]|18[0,2,5-9])(\d{8})$
(assert (not (str.in_re X (re.++ (str.to_re "+86") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}1") (re.union (re.++ (str.to_re "3") (re.range "0" "9")) (str.to_re "45") (str.to_re "47") (re.++ (str.to_re "5") (re.union (re.range "0" "3") (str.to_re ",") (re.range "5" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "2") (re.range "5" "9"))))))))
; Host\u{3a}[^\n\r]*A-311\s+lnzzlnbk\u{2f}pkrm\.finSubject\u{3a}Basic
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "A-311") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.finSubject:Basic\u{0a}"))))
; /\u{2e}mka([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.mka") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
