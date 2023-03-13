(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\w]+[-\.\w]*@[-\w]+\.[a-z]{2,6}(\.[a-z]{2,6})?$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 6) (re.range "a" "z")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 6) (re.range "a" "z")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}avi/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".avi/i\u{0a}")))))
; /User\u{2d}Agent\u{3a}\u{20}[A-F\d]{32}\r\n/H
(assert (str.in_re X (re.++ (str.to_re "/User-Agent: ") ((_ re.loop 32 32) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "\u{0d}\u{0a}/H\u{0a}"))))
; ^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$
(assert (not (str.in_re X (re.union (re.++ (re.union (str.to_re "+92") (str.to_re "0092")) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))) ((_ re.loop 11 11) (re.range "0" "9")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
