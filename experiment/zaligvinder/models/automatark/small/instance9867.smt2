(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d(\u{20})\d{2}(\u{20})\d{2}(\u{20})\d{2}(\u{20})\d{3}(\u{20})\d{3}((\u{20})\d{2}|))|(\d\d{2}\d{2}\d{2}\d{3}\d{3}(\d{2}|)))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "0" "9") (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; (01*0|1)*
(assert (not (str.in_re X (re.++ (re.* (re.union (re.++ (str.to_re "0") (re.* (str.to_re "1")) (str.to_re "0")) (str.to_re "1"))) (str.to_re "\u{0a}")))))
; url=http\x3A\s+jsp[^\n\r]*serverHOST\x3ASubject\x3Ai\-femdom\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "url=http:\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "jsp") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "serverHOST:Subject:i-femdom.com\u{0a}")))))
; ^([1-9]|[1-9]\d|[1-2]\d{2}|3[0-6][0-6])$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "6") (re.range "0" "6"))) (str.to_re "\u{0a}")))))
(check-sat)
