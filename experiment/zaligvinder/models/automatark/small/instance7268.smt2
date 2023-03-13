(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mka/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mka/i\u{0a}"))))
; Host\x3A\d+Black\s+daosearch\x2EcomMyPostwww\.raxsearch\.com
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Black") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "daosearch.comMyPostwww.raxsearch.com\u{0a}")))))
; ^((([1]\d{2})|(22[0-3])|([1-9]\d)|(2[01]\d)|[1-9]).(([1]\d{2})|(2[0-4]\d)|(25[0-5])|([1-9]\d)|\d).(([1]\d{2})|(2[0-4]\d)|(25[0-5])|([1-9]\d)|\d).(([1]\d{2})|(2[0-4]\d)|(25[0-5])|([1-9]\d)|\d))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "22") (re.range "0" "3")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.range "1" "9")) re.allchar (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) re.allchar (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) re.allchar (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")))))
; [-+]((0[0-9]|1[0-3]):([03]0|45)|14:00)
(assert (str.in_re X (re.++ (re.union (str.to_re "-") (str.to_re "+")) (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "3"))) (str.to_re ":") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "3")) (str.to_re "0")) (str.to_re "45"))) (str.to_re "14:00")) (str.to_re "\u{0a}"))))
; ^[+-]?[0-9]*\.?([0-9]?)*
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.opt (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
